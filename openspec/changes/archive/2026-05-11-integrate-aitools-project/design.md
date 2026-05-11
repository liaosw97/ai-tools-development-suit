# Design: integrate-aitools-project

> 技术设计 — 描述实现方案和技术决策

## 技术方案

### 方案概述

将 AiTools 根目录初始化为 Git 主仓库，三个子项目各自转为 Git Submodule。包装层仅提供：
1. 根级配置文件（`.gitmodules`、`package.json`、`.gitignore`）
2. Bash 同步脚本（`scripts/sync-upstream.sh`）
3. 版本锁定文件（`versions.lock`）
4. README 文档

子项目之间零代码依赖，各自保持独立的构建系统和版本号。

### 目标文件结构

```
AiTools/                          ← 主仓库 (git init)
├── .git/
├── .gitmodules                   ← submodule 配置
├── .gitignore                    ← 全局忽略规则
├── .claude/                      ← 主仓库直接管理
│   ├── settings.json
│   └── commands/
├── CLAUDE.md                     ← 更新项目结构描述
├── README.md                     ← 项目说明
├── package.json                  ← 包装层元信息 + workspaces
├── versions.lock                 ← 子项目版本快照
├── openspec/                     ← 本地变更目录（主仓库管理）
│   ├── config.yaml
│   ├── specs/
│   └── changes/
├── scripts/
│   └── sync-upstream.sh          ← 上游同步脚本
├── ai-tools/                     ← submodule 父目录
│   ├── OpenSpec/                 ← git submodule (liaosw97/OpenSpec)
│   └── superpowers/              ← git submodule (liaosw97/superpowers)
└── ai-tools-bridge/              ← git submodule (liaosw97/ai-tools-bridge)
```

### 模块关系

```
                    ┌─────────────────────┐
                    │   AiTools 主仓库     │
                    │  (包装层 / 管理层)   │
                    └─────────┬───────────┘
                              │
           ┌──────────────────┼──────────────────┐
           │                  │                  │
           ▼                  ▼                  ▼
   ┌───────────────┐ ┌───────────────┐ ┌──────────────────┐
   │   OpenSpec    │ │  Superpowers  │ │  ai-tools-bridge  │
   │  (Submodule)  │ │  (Submodule)  │ │   (Submodule)     │
   │  TypeScript   │ │  Markdown     │ │  Markdown+Vitest  │
   │  pnpm         │ │  无构建系统   │ │  pnpm (dev)       │
   └───────────────┘ └───────────────┘ └──────────────────┘

   子项目之间：零依赖（松耦合）
   主仓库 → 子项目：仅 Git Submodule 引用
```

### 同步脚本流程

```
sync-upstream.sh
│
├── 1. 备份 versions.lock → versions.lock.bak
│
├── 2. 遍历子项目（支持 --only <name> 指定单个）
│   │
│   ├── git fetch --tags
│   ├── 识别最新 release tag（semver 排序，排除 pre-release）
│   ├── 对比当前指向 → 相同则跳过
│   ├── git checkout <tag>
│   ├── 运行测试（如有 test 命令）
│   │   ├── 通过 → 更新 versions.lock
│   │   └── 失败 → 回滚到 versions.lock.bak 中的 hash
│   └── 输出结果
│
├── 3. 汇总报告
│
└── 4. 退出码：0=全部成功, 1=部分失败, 2=全部失败
```

## 决策追溯

- 选择 [Git Submodule] 而非 [Git Subtree/脚本拉取]：版本同步是核心需求（见 brainstorm.md §决策 1: 上游同步机制）
- 选择 [松耦合包装层] 而非 [深度融合]：子项目各自有独立上游，深度融合阻碍同步（见 brainstorm.md §决策 2: 子项目集成程度）
- 选择 [独立版本号] 而非 [统一版本号]：保留与上游的版本语义一致（见 brainstorm.md §决策 3: 版本策略）
- 选择 [Bash] 而非 [Node.js]：同步操作是 git 命令组合，无需运行时依赖（见 brainstorm.md §决策 7: 同步脚本语言）
- 选择 [release tag] 而非 [main 最新 commit]：稳定版本优先（见 brainstorm.md §决策 9: 上游同步的"成功"定义）
- 选择 [versions.lock 回滚] 而非 [git reflog]：显式快照利于协作（见 brainstorm.md §决策 10: 上游同步回滚策略）

## 数据模型

### versions.lock 格式

```
# versions.lock — AiTools 子项目版本快照
# Updated: <ISO 8601 时间戳>

openspec=<commit-hash> <tag-name>
superpowers=<commit-hash> <tag-name>
ai-tools-bridge=<commit-hash> <tag-name>
```

- 每行一个子项目，格式：`<名称>=<commit-hash> <tag-name>`
- `#` 开头为注释行
- tag-name 如不存在则为 `untagged`
- shell 脚本通过 `grep` + `awk` 解析

### .gitmodules 格式

```ini
[submodule "ai-tools/OpenSpec"]
    path = ai-tools/OpenSpec
    url = https://github.com/liaosw97/OpenSpec.git
[submodule "ai-tools/superpowers"]
    path = ai-tools/superpowers
    url = https://github.com/liaosw97/superpowers.git
[submodule "ai-tools-bridge"]
    path = ai-tools-bridge
    url = https://github.com/liaosw97/ai-tools-bridge.git
```

### .gitignore 规则

```gitignore
# 子项目构建产物
node_modules/
dist/
*.tsbuildinfo

# 临时文件
*.stackdump
log/

# 系统文件
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# 版本锁备份（同步过程中临时产生）
versions.lock.bak
```

## 接口设计

### 新增接口：sync-upstream.sh

**签名：**
```bash
bash scripts/sync-upstream.sh [--only <submodule-name>]
```

**参数：**
- `--only <name>`：（可选）仅同步指定子项目。name 可选值：`openspec`、`superpowers`、`ai-tools-bridge`
- 无参数时同步所有子项目

**退出码：**
| 码 | 含义 |
|----|------|
| 0 | 所有同步成功 |
| 1 | 部分子项目同步失败（有回滚） |
| 2 | 全部失败 |

**输出格式：**
```
[openspec] v1.3.0 → v1.4.0 ✅
[superpowers] v5.1.0 (已是最新) ⏭️
[ai-tools-bridge] v0.2.0 → v0.3.0 ❌ 测试失败，已回滚到 v0.2.0
---
汇总: 1 成功, 1 跳过, 1 失败
```

## 文件变更预估

| 文件 | 操作 | 说明 |
|------|------|------|
| `.gitmodules` | Create | 三个子项目的 submodule 配置 |
| `.gitignore` | Create | 全局忽略规则 |
| `package.json` | Create | 包装层元信息 + workspaces 声明 |
| `README.md` | Create | 项目说明、安装步骤、submodule 指南 |
| `versions.lock` | Create | 子项目版本快照 |
| `scripts/sync-upstream.sh` | Create | 上游同步脚本 |
| `CLAUDE.md` | Modify | 更新项目结构描述，反映 submodule 模式 |
| `ai-tools/OpenSpec/` | Convert | 普通目录 → Git Submodule |
| `ai-tools/superpowers/` | Convert | 普通目录 → Git Submodule |
| `ai-tools-bridge/` | Convert | 普通目录 → Git Submodule |
| `bash.exe.stackdump` | Delete | 临时文件清理 |
| `log/` | Delete | 临时目录清理 |

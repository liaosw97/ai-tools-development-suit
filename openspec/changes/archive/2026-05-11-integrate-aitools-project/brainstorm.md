# Brainstorm: integrate-aitools-project

> 深度探索记录 — 记录需求探索过程和关键决策

## 需求描述

将 `D:\Code\AiTools` 从一个松散的文件集合转变为一个**统一的开源项目**，整合以下三个子项目：

| 子项目 | 来源 | 当前版本 | 语言 |
|--------|------|---------|------|
| `ai-tools/OpenSpec/` | https://github.com/liaosw97/OpenSpec.git | v1.3.0 | TypeScript (pnpm) |
| `ai-tools/superpowers/` | https://github.com/liaosw97/superpowers.git | v5.1.0 | Markdown skills |
| `ai-tools-bridge/` | https://github.com/liaosw97/ai-tools-bridge.git | v0.2.0 | Markdown + Vitest |

**核心动机：**
- 三个子项目各自独立拉取，缺乏统一管理
- 需要从上游 GitHub 仓库持续同步更新
- 计划作为开源项目发布

**核心约束：**
- 必须保留与上游仓库的同步能力
- 子项目之间保持松耦合（包装层模式）
- 各子项目独立版本号

## 方案探索

### 方案 A: Git Submodule 包装层

将三个子项目各自作为 Git Submodule 引入，AiTools 根目录作为包装层项目。

**项目结构：**
```
AiTools/                      ← 主仓库（新 git init）
├── .gitmodules
├── package.json              ← 包装层 package.json（workspaces）
├── CLAUDE.md
├── openspec/                 ← OpenSpec 变更目录（本地）
├── scripts/
│   └── sync-upstream.sh      ← 上游同步脚本
├── ai-tools/                 ← submodule 父目录
│   ├── OpenSpec/             ← git submodule (liaosw97/OpenSpec)
│   └── superpowers/          ← git submodule (liaosw97/superpowers)
└── ai-tools-bridge/          ← git submodule (liaosw97/ai-tools-bridge)
```

- **优点：**
  - Git 原生机制，成熟可靠
  - 每个子项目完整保留 git 历史
  - `git submodule update --remote` 即可同步上游
  - 子项目可锁定到特定 commit/tag
  - 清晰的版本边界
- **缺点：**
  - clone 时需要 `--recursive` 或额外步骤
  - 对不熟悉 submodule 的开发者有学习成本
  - 子项目之间的跨项目修改工作流稍复杂

### 方案 B: Git Subtree 包装层

使用 Git Subtree 将上游代码合并到主仓库中。

- **优点：**
  - clone 即用，无需额外步骤
  - 代码在主仓库内，操作简单
- **缺点：**
  - 同步上游时的 merge 冲突处理复杂
  - 子项目历史混入主仓库
  - 大型仓库会显著增加主仓库体积
  - 多个 subtree 的版本追踪不直观

### 方案 C: npm/yarn workspace + 脚本拉取

不使用 git 原生机制，通过脚本定期下载上游 release tarball。

- **优点：**
  - 不依赖 git submodule 机制
  - 操作简单直观
- **缺点：**
  - 无法跟踪具体的 commit
  - 丢失完整的 git 历史
  - 难以处理 patch/定制

### 方案比较

| 维度 | Submodule | Subtree | 脚本拉取 |
|------|-----------|---------|---------|
| 上游同步 | 优秀 | 中等 | 差 |
| 版本锁定 | 优秀 | 中等 | 差 |
| Clone 体验 | 需 --recursive | 优秀 | 优秀 |
| 历史保留 | 完整 | 合并 | 无 |
| 冲突处理 | 简单 | 复杂 | N/A |

**结论：选择方案 A（Git Submodule）** — 上游同步是核心需求，Submodule 在这方面最可靠。

## 关键决策

### 决策 1: 上游同步机制
- **选择:** Git Submodule
- **理由:** 核心需求是版本同步与更新，Submodule 是唯一能同时提供精确版本锁定和便捷上游同步的方案
- **被否决的替代:** Git Subtree（merge 冲突复杂）、脚本拉取（丢失历史）

### 决策 2: 子项目集成程度
- **选择:** 包装层（松耦合）
- **理由:** 三个子项目各有独立的上游和发布节奏，深度融合会导致同步困难。包装层模式允许各自独立演进
- **被否决的替代:** 中度集成（增加同步成本）、深度融合（严重阻碍上游同步）

### 决策 3: 版本策略
- **选择:** 独立版本号
- **理由:** 子项目各自有上游版本号（OpenSpec v1.3.0、Superpowers v5.1.0），统一版本号会导致与上游脱节。AiTools 包装层有自己的版本号，记录兼容的子项目版本范围
- **被否决的替代:** 统一版本号（与上游版本语义冲突）

### 决策 4: ai-tools-bridge 的归属
- **选择:** ai-tools-bridge 作为 Git Submodule（有独立上游仓库）
- **理由:** ai-tools-bridge 有自己的 GitHub 上游仓库，与其他两个子项目保持一致的 submodule 模式
- **被否决的替代:** 本地目录（无法与上游同步）

### 决策 5: 管理工具范围
- **选择:** Bash 同步脚本
- **理由:** 当前阶段聚焦核心需求（版本同步），不引入过多基础设施。Bash 脚本在 Git Bash/WSL 环境下均可运行
- **被否决的替代:** Node.js 脚本（引入不必要的运行时依赖）、一次性搭建完整 CI/CD（过度工程化）

### 决策 6: 发布形式
- **选择:** 纯 Git 仓库
- **理由:** 当前阶段以源码形式提供即可，用户通过 git clone 获取。不引入 npm 发布流程的复杂性
- **被否决的替代:** npm 包（维护成本高）、GitHub Release（需额外构建流程）

### 决策 7: 同步脚本语言
- **选择:** Bash
- **理由:** 同步操作本质是 git 命令的组合，Bash 最直接。Windows 下通过 Git Bash 或 WSL 运行
- **被否决的替代:** Node.js（引入不必要的运行时依赖）

### 决策 8: .claude/ 配置目录归属
- **选择:** `.claude/` 由主仓库直接管理
- **理由:** `.claude/` 包含的是本项目（AiTools 整体）的 Claude Code 配置，不是任何子项目的一部分。其中的命令和技能引用子项目路径，但配置本身属于包装层
- **被否决的替代:** 放入某个子项目中（概念上不属于任何一个）

### 决策 9: 上游同步的"成功"定义
- **选择:** submodule 指向各上游仓库的最新 release tag（非 main 分支最新 commit）
- **理由:** release tag 代表稳定版本，适合集成。同步后运行子项目的测试套件验证兼容性
- **被否决的替代:** 指向 main 最新 commit（不稳定，可能引入未发布的功能）

### 决策 10: 上游同步回滚策略
- **选择:** 同步前自动记录当前 submodule commit hash 到 `versions.lock` 文件，失败时从 lock 文件恢复
- **理由:** 简单可靠，无需复杂机制。`versions.lock` 也用于记录当前集成的版本快照
- **被否决的替代:** 依赖 git reflog（不够显式，不利于团队协作）

## 验收标准引导

> 后续 tasks.md 中应为每个决策定义可验证的验收条件。以下为建议方向：

| 决策 | 建议验收条件 |
|------|-------------|
| 决策 1 (Submodule) | `git submodule status` 返回三个有效 commit hash |
| 决策 2 (松耦合) | 修改一个子项目不影响其他子项目的构建/测试 |
| 决策 3 (独立版本) | 各子项目 `package.json` 版本号互不依赖 |
| 决策 4 (bridge submodule) | bridge 子项目与其他子项目使用相同的 submodule 配置方式 |
| 决策 5 (Bash 脚本) | 运行 `sync-upstream.sh` 后 submodule 指向目标版本，且子项目测试通过 |
| 决策 6 (纯 Git) | `git clone --recursive` 后项目可正常使用 |
| 决策 7 (Bash) | 脚本在 Git Bash 和 WSL 环境下均可运行 |

## 约束识别

### 技术约束
- 子项目各自有独立的包管理器（OpenSpec 用 pnpm，superpowers 无构建系统）
- OpenSpec 有全局 CLI（`openspec`），需要考虑与包装层的安装关系
- Superpowers 是纯 Markdown 仓库，无构建依赖
- ai-tools-bridge 依赖 Vitest 进行模板/schema 测试

### 团队约束
- 面向开源社区发布，需要清晰的 README 和贡献指南
- Git Submodule 对新贡献者有学习成本，文档需要覆盖

### 清理约束
- 开源发布前需清理 `bash.exe.stackdump`、`log/` 等临时文件
- 主仓库 `.gitignore` 需覆盖所有子项目的忽略规则（`node_modules/`、`dist/`、`.stackdump` 等）

### 上游约束
- 三个上游仓库的发布节奏不受控
- 需要定义"兼容版本范围"策略，避免上游 breaking change 导致集成失败

## 需要产出的制品

1. **主仓库初始化** — `git init`、`.gitmodules`、根 `package.json`、`.gitignore`
2. **同步脚本** — `scripts/sync-upstream.sh`（Bash），自动化上游同步流程，含回滚机制
3. **版本锁定文件** — `versions.lock`，记录各子项目当前锁定的 commit/tag
4. **README** — 项目说明、安装步骤、子项目介绍、submodule 克隆指南

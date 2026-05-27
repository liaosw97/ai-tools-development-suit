# Design: 添加 gstack 并提取角色系统

> 技术设计 — 实现方案和技术决策

## 技术方案

### 方案概述

本次变更分为两个独立但相关的部分：

1. **gstack 集成**：使用 Git Submodule 将 gstack 仓库添加到 `ai-tools/gstack/`
2. **角色系统**：在 ai-tools-bridge 中实现角色定义、加载、绑定和切换

角色系统借鉴 gstack 的角色设计理念，但完全重写为 SDD 原生实现，不依赖 gstack 运行时。

### 架构图

```
用户请求
    │
    ▼
┌─────────────────────────────────────────────────┐
│ SDD Action (sdd-brainstorm, sdd-review-code...) │
└─────────────────────────────────────────────────┘
    │
    ▼ 前置逻辑: 加载角色
┌─────────────────────────────────────────────────┐
│ 角色加载器                                      │
│ 1. 检查 --role 参数                             │
│ 2. 检查会话级角色 (/sdd-role 设置)              │
│ 3. 使用默认角色                                 │
│ 4. 按优先级合并角色定义                         │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 角色定义源（优先级：内置 < 项目 < 用户）         │
│                                                 │
│ ~/.claude/roles/     ← 用户级（优先级最高）      │
│ openspec/roles/      ← 项目级                   │
│ ai-tools-bridge/roles/ ← 内置（优先级最低）      │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 角色应用                                        │
│ - 注入专业视角                                   │
│ - 执行强制问题                                   │
│ - 格式化输出                                     │
└─────────────────────────────────────────────────┘
```

## 决策追溯

- 选择 [分类目录结构] 而非 [扁平目录]：清晰且可扩展，便于按阶段组织角色（见 brainstorm.md §角色目录结构比较）
- 选择 [三层优先级] 而非 [单一配置源]：用户级优先级最高（可覆盖项目级和内置），项目级次之（可覆盖内置），团队协作时项目级配置可生效（见 brainstorm.md §决策 4：角色优先级）
- 选择 [Markdown 角色定义] 而非 [YAML/JSON]：与 SDD 技能定义格式一致，便于 AI 直接读取
- 选择 [参数 + 命令双入口] 而非 [单一入口]：覆盖不同场景，参数用于一次性切换，命令用于会话级持久切换（见 brainstorm.md §角色切换交互方式比较）

## 数据模型

### 角色定义结构

```yaml
# YAML frontmatter
name: string          # 角色标识符（小写，用于命令和参数）
trigger: string[]     # 可用的 SDD action 列表（可选）
```

```markdown
# 角色
[角色身份描述]

# 专业视角
[该角色关注的核心维度列表]

# 强制问题
1. [问题1]
2. [问题2]
...

# 输出格式
## [输出节1]
## [输出节2]
```

### 角色加载状态

```typescript
interface RoleState {
  currentRole: string;        // 当前角色名称
  roleSource: 'builtin' | 'project' | 'user';  // 角色来源
  sessionOverride: string | null;  // 会话级覆盖（/sdd-role 设置）
}
```

## 接口设计

### 新增接口

#### `/sdd-role` 命令

| 命令 | 参数 | 说明 |
|------|------|------|
| `/sdd-role` | 无 | 显示当前角色 |
| `/sdd-role <name>` | 角色名 | 切换当前会话角色 |
| `/sdd-role --list` | 无 | 列出所有可用角色 |

#### `--role` 参数

| 使用方式 | 说明 |
|----------|------|
| `/sdd-action --role <name>` | 一次性切换，仅影响当前 action |

### 优先级规则

```
--role 参数 > /sdd-role 会话级 > 默认角色
```

## 文件变更预估

| 文件 | 操作 | 说明 |
|------|------|------|
| `ai-tools/gstack/` | Create | Git Submodule |
| `.gitmodules` | Modify | 新增 gstack 条目 |
| `versions.lock` | Modify | 记录 gstack 版本 |
| `ai-tools-bridge/roles/planning/*.md` | Create | 4 个角色定义 |
| `ai-tools-bridge/roles/execution/*.md` | Create | 1 个角色定义 |
| `ai-tools-bridge/roles/review/*.md` | Create | 3 个角色定义 |
| `ai-tools-bridge/roles/release/*.md` | Create | 2 个角色定义 |
| `ai-tools-bridge/skills/sdd-*/SKILL.md` | Modify | 添加角色加载逻辑 |
| `.claude/commands/sdd-role.md` | Create | 角色切换命令 |
| `CLAUDE.md` | Modify | 补充角色使用说明 |

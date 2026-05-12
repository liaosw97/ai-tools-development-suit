# Brainstorm: add-skills-plugin

> 深度探索记录 — 记录需求探索过程和关键决策

## 需求描述

在 `ai-tools/` 目录中新增 `skills` 子模块（https://github.com/liaosw97/skills.git），作为独立的 AI 编码代理技能工具集引入。

**背景：**
- `ai-tools/` 已有 `OpenSpec/`（规格管理框架）和 `superpowers/`（SDD 纪律层技能）两个子模块
- liaosw97/skills 是 mattpocock/skills 的 fork，包含 18 个面向 AI 编码代理的工程实践技能
- 技能分为三大类：Engineering（10 个）、Productivity（4 个）、Misc（4 个）

**动机：**
- 扩展可用的 AI 编码技能库，为日常开发提供更多工具选择
- 保留完整的技能源码以便离线参考和定制

## 方案探索

### 方案 A: Git Submodule 引入（推荐）

将 liaosw97/skills 作为 Git Submodule 添加到 `ai-tools/skills/`，与现有 OpenSpec/superpowers 管理方式一致。

- **优点：**
  - 与现有子模块管理模式一致（统一的版本锁定、同步机制）
  - 保留完整 Git 历史，可追溯上游更新
  - `sync-upstream.sh` 已有子模块同步框架，新增 skills 只需在 SUBMODULES 数组中添加一行配置
  - 主仓库通过 commit hash 锁定版本
- **缺点：**
  - 子模块增加 clone/init 复杂度
  - skills 仓库如果频繁更新，需要手动同步

### 方案 B: Git Subtree 引入

使用 `git subtree add` 将 skills 仓库内容合并到 `ai-tools/skills/`。

- **优点：**
  - 不需要 submodule 初始化步骤
  - 代码直接存在于主仓库中
- **缺点：**
  - 与 OpenSpec/superpowers 的管理方式不一致
  - 更新上游需要 subtree pull，操作更复杂
  - 增加主仓库体积

### 方案比较

选择方案 A（Git Submodule）。与已有子项目采用统一的管理方式，降低认知负担；`sync-upstream.sh` 同步框架已就绪，仅需在 SUBMODULES 数组新增一行即可复用。

## 关键决策

### 决策 1: 定位为独立工具集
- **选择:** skills 作为独立工具集与 superpowers 平行存在，不修改 SDD 编排逻辑
- **理由:** superpowers 是 SDD 工作流的核心依赖，已被 ai-tools-bridge 深度集成。mattpocock/skills 提供的工程实践技能（grill-me, diagnose, improve-codebase-architecture 等）覆盖不同场景，两者互补而非替代
- **被否决的替代:** 将部分 mattpocock skills 集成到 SDD 编排中（过度复杂化，且与 SDD 的"委托 Superpowers"模式冲突）

### 决策 2: 全量引入全部技能
- **选择:** 引入仓库的全部 18 个技能，不做筛选
- **理由:** 作为独立工具集，保留完整技能库让用户按需选择。部分技能（如 prototype, scaffold-exercises）可能当前不需要，但存储成本极低（纯 Markdown）
- **被否决的替代:** 选择性引入部分技能（需要维护筛选列表，且增加后续补充的复杂度）

### 决策 3: 技能安装方式
- **选择:** 仅作为 Git Submodule 引入，不运行 `npx skills@latest add` installer
- **理由:** skills.sh installer 会将技能复制到 `.claude/commands/`，但本项目已有 SDD 的斜杠命令体系。直接以 submodule 形式保留源码，用户需要时可手动安装特定技能
- **被否决的替代:** 运行 installer 自动安装到 `.claude/commands/`（可能与 SDD 命令冲突，且增加自动化复杂度）

### 决策 4: 技能重叠处理
- **选择:** 不处理重叠，两套技能系统独立运行
- **理由:** superpowers 的 TDD/brainstorming 被 SDD 编排器专用；mattpocock 的 tdd/grill-me 可用于非 SDD 场景。用户根据上下文选择使用哪套
- **被否决的替代:** 统一两套技能的重叠部分（改动范围大，且会破坏 SDD 编排逻辑）

**功能重叠对照表：**

| mattpocock/skills | superpowers | 说明 |
|---|---|---|
| `tdd` | `test-driven-development` | superpowers 版本被 SDD 编排器 (`sdd-code`) 专用 |
| `grill-me` / `grill-with-docs` | `brainstorming` | superpowers 版本被 SDD 编排器 (`sdd-brainstorm`) 专用 |
| `diagnose` | `systematic-debugging` | superpowers 版本被 SDD 编排器专用 |
| `write-a-skill` | `writing-skills` | 两者都用于创建新技能，superpowers 版本更偏向 SDD 技能体系 |
| `prototype` | — | 无重叠，mattpocock 独有 |
| `improve-codebase-architecture` | — | 无重叠，mattpocock 独有 |
| `caveman` | — | 无重叠，mattpocock 独有 |

## 约束识别

### 技术约束
- 子模块 URL 指向 GitHub，需要网络访问才能 clone
- `.gitmodules` 文件将被修改，`git submodule add` 需在主仓库根目录执行
- liaosw97/skills 是 mattpocock/skills 的 fork，上游同步需要额外处理
- 技能文件为纯 Markdown，无构建依赖

### 团队约束
- 需要更新 CLAUDE.md 项目文档（至少：项目概述表格新增一行、架构关系图补充 skills 定位）
- `scripts/sync-upstream.sh` 的 SUBMODULES 数组需新增 skills 条目
- `versions.lock` 需要记录新子模块的版本快照

## 未解决的问题

（无 — 所有关键决策已明确）

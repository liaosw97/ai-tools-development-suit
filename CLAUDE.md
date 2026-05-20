# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **语言规则**: 所有对话输入及输出始终使用中文（简体）。

## 项目概述

这是一个 AI 工具开发工作区，多个子项目以 Git Submodule 方式管理：

| 目录 | 内容 | 语言 | 管理方式 |
|------|------|------|----------|
| `ai-tools/OpenSpec/` | OpenSpec CLI — 规格管理框架 (v1.3.0) | TypeScript (pnpm) | Git Submodule |
| `ai-tools/superpowers/` | Superpowers — AI 编码代理技能系统 (v5.1.0) | Markdown skills | Git Submodule |
| `ai-tools-bridge/` | SDD 工作流编排器 — 串联 OpenSpec + Superpowers (v0.3.0) | Markdown + Vitest | Git Submodule |
| `ai-tools/skills/` | Skills — AI 编码代理工程实践技能集 | Markdown skills | Git Submodule |
| `.claude/` | 本地 Claude Code 配置（设置、命令、技能） | JSON/Markdown | — |
| `openspec/` | 当前项目的 OpenSpec 变更目录 | YAML/Markdown | — |
| `log/` | 会话记录导出目录 | — | — |

## 常用命令

### Submodule 管理

```bash
git submodule status                        # 查看子模块状态
git submodule update --init --recursive     # 初始化/更新子模块
bash scripts/sync-upstream.sh              # 同步所有子项目到最新 release tag
bash scripts/sync-upstream.sh --only openspec  # 仅同步指定子项目
```

### OpenSpec (ai-tools/OpenSpec/)

```bash
cd ai-tools/OpenSpec
pnpm install          # 安装依赖
pnpm run build        # 构建 (node build.js)
pnpm test             # 运行测试 (vitest run)
pnpm run test:watch   # 监听模式
pnpm run lint         # ESLint 检查
pnpm run dev          # TypeScript watch 模式
```

运行单个测试：`pnpm vitest run path/to/test.test.ts`

### ai-tools-bridge

```bash
cd ai-tools-bridge
pnpm test             # 运行测试 (vitest run)
```

注意：ai-tools-bridge 核心是纯 Markdown 技能定义，测试仅验证 schema 和模板。

### Superpowers

纯 Markdown 技能仓库，无构建系统。测试通过 `tests/` 目录下的服务器驱动评估。

### OpenSpec CLI (全局)

```bash
openspec init         # 在项目中初始化 OpenSpec
openspec update       # 刷新 AI 指令和斜杠命令
openspec config profile  # 选择工作流 profile
```

## 架构

### 子项目关系

子项目以 Git Submodule 集成到主仓库。子项目保持独立版本历史，主仓库通过 commit hash 锁定版本（`versions.lock` 记录快照）。

```
用户需求
    ↓
ai-tools-bridge (SDD 编排)
    ├── 委托 → OpenSpec: 规格层 (proposal, specs, tasks, design)
    └── 委托 → Superpowers: 纪律层 (brainstorming, TDD, code review, debugging)

ai-tools/skills/ — 独立工具集，不参与 SDD 编排，与 Superpowers 互补
```

SDD 的 13 个 action 各自独立，通过文件系统传递状态（`openspec/changes/<name>/`）。每个 action 遵循三层模式：前置逻辑（定位/校验）→ 核心执行（委托底层 skill）→ 后置逻辑（审查/验证）。

### 关键斜杠命令

**SDD 工作流** (`ai-tools-bridge` 提供)：
- `/sdd-doctor` — 环境诊断 + 复杂度评估
- 完整流程：`/sdd-brainstorm` → `/sdd-propose` → `/sdd-ff` → `/sdd-review-spec` → `/sdd-plan` → `/sdd-code` → `/sdd-review-code` → `/sdd-test-code` → `/sdd-verify` → `/sdd-ship`
- 快速路径：`/sdd-quick`（简单需求一站式）
- 辅助：`/sdd-continue`（逐步补充 artifact）

**OpenSpec 工作流** (`.claude/commands/opsx/` 提供)：
- `/opsx:propose` → `/opsx:apply` → `/opsx:archive`

### 制品依赖链

```
brainstorm.md (可选) → proposal.md (必需) → specs/ (必需)
                                                  → design.md (可选)
                                                      → tasks.md (必需) → plan.md (可选)
```

所有制品存储在 `openspec/changes/<name>/`，action 间可安全 `/clear`。

## 开发约定

- **规格场景**：GIVEN/WHEN/THEN 格式，附带 ADDED/MODIFIED/REMOVED 增量标记
- **决策追溯**：`选择 [X] 而非 [Y]：[原因]（见 brainstorm.md §<标题>）`
- **任务-规格链接**：`[spec:domain#scenario]`
- **Token 卫生**：每个 action 后执行 `/clear`，最小化上下文加载
- **模板占位符**：HTML 注释 `<!-- ... -->`

## 会话管理

- 导出对话记录：保存到 `log/history/`
- 保存当前对话（完整内容）：保存到 `log/plan/`
- **log 目录保护**：`log/` 中的文件不可删除，只能通过 `.gitignore` 过滤不纳入版本控制

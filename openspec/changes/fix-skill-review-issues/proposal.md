# Proposal: 修复审查命令无法自动修复文档问题

## Why

当前 `/sdd-review-spec` 和 `/sdd-review-code` 命令只报告问题，不提供修复能力。用户需要手动执行修复命令或编辑文件，增加了上下文切换成本。

**问题来源**：`openspec/changes/archive/2026-06-13-fix-opsx-flow-bleed/reviews/code-quality-r3.md` 发现的文档问题（sdd-quick 流程指引未区分场景、sdd-verify 缺少选项等）无法通过命令自动修复。

## What Changes

- **增强 `/sdd-review-code` 命令**：添加 Phase 3 交互式修复阶段
- **增强 `/sdd-review-spec` 命令**：添加交互式修复阶段
- **新增交互式修复模板**：在 `skills/_shared/` 中添加修复流程模板

## Capabilities

### New Capabilities

- `interactive-fix`: 审查命令的交互式修复功能，支持逐个问题询问是否修复

### Modified Capabilities

- `sdd-review-code`: 添加 Phase 3 交互式修复阶段
- `sdd-review-spec`: 添加交互式修复阶段

## Impact

**受影响的文件**：
- `ai-tools-bridge/skills/sdd-review-code/SKILL.md`
- `ai-tools-bridge/skills/sdd-review-spec/SKILL.md`
- `ai-tools-bridge/skills/_shared/review-loop.md`（可选，添加修复模板）

**无外部依赖影响**：不修改任何外部工具或插件。

## 决策追溯

- **选择 [方案 A: 增强 review 命令] 而非 [方案 B: 独立命令]**：修复应该在发现问题的地方进行，减少上下文切换（见 brainstorm.md §方案选择）
- **选择 [交互式修复] 而非 [自动修复]**：保留用户对修复的控制权，避免意外修改（见 brainstorm.md §设计方案）

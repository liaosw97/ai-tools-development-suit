# Proposal: SDD 流程指引 include 机制修复

## Why

在 fix-opsx-flow-bleed 变更的代码审查中发现，6 个 SDD action 的流程指引部分使用"直接复制"方式而非"include 引用"方式，导致维护成本高。如果模板格式需要修改，需要同步修改 6 个 SKILL.md 文件。

**来源**: `openspec/changes/archive/2026-06-13-fix-opsx-flow-bleed/reviews/code-quality-r3.md` (Minor #5)

## What Changes

### 方案选择

经过技术调研，发现 Claude Code 的 include 机制不支持条件参数（仅简单文本插入）。由于 SDD 流程指引每个 action 的内容不同，无法使用 include 引用整个块。

**选择 [方案 C: 保持现状 + 明确文档说明] 而非 [方案 B: include 框架 + 本地内容]**：
- include 机制不支持条件渲染，无法实现方案 A 和 D
- 方案 C 实现成本最低（仅更新文档说明）
- 当前"直接复制"方式已经可以工作
- 6 个 SKILL.md 的流程指引格式已经统一（Round 4 修复后），一致性风险已降低

### 变更内容

1. **更新 `skills/_shared/sdd-flow-guidance.md` 的使用说明**
   - 明确"直接复制"是推荐方式
   - 说明原因：每个 action 的流程指引内容不同，include 机制不支持条件渲染
   - 提供复制指南：如何从模板中复制对应 action 的内容

2. **添加一致性检查指南**
   - 在模板文件中添加"一致性检查"节
   - 说明如何验证 6 个 SKILL.md 的流程指引格式是否一致
   - 提供检查命令或脚本

**不涉及的变更**：
- 不修改现有 SKILL.md 的流程指引内容（Round 4 已修复）
- 不修改 include 机制（投入产出比不高）

## Capabilities

### Modified Capabilities

- `sdd-flow-guidance`: 更新使用说明，明确"直接复制"是推荐方式，添加一致性检查指南

## Impact

**受影响的文件**：
- `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

**不涉及的文件**：
- 6 个 SKILL.md 文件（保持现状）
- include 机制（不修改）

**无外部依赖影响**：不修改任何外部工具或插件。

## 决策追溯

- **选择 [方案 C] 而非 [方案 B]**：include 机制不支持条件渲染，方案 C 实现成本最低（见 brainstorm.md §决策 1）
- **选择 [不修改 include 机制]**：投入产出比不高，当前"骨架模板"模式已足够灵活（见 brainstorm.md §决策 2）

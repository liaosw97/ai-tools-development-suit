# Spec: SDD 流程指引文档

## Purpose

为 SDD action 提供统一的流程指引格式规范和使用说明。

TBD - 详细描述待补充。

---

## Requirements

### Requirement: sdd-flow-guidance.md 使用说明明确"直接复制"是推荐方式

`sdd-flow-guidance.md` 的使用说明 SHALL 明确指出"直接复制"是推荐的使用方式，并解释原因。

#### Scenario: 用户阅读使用说明了解推荐方式

- **GIVEN** 用户打开 `skills/_shared/sdd-flow-guidance.md`
- **WHEN** 查看"使用方式"节
- **THEN** 文档明确说明"直接复制"是推荐方式
- **AND** 文档解释原因：每个 action 的流程指引内容不同，include 机制不支持条件渲染
- **AND** 文档提供复制指南：如何从模板中复制对应 action 的内容

### Requirement: sdd-flow-guidance.md 包含一致性检查指南

`sdd-flow-guidance.md` SHALL 包含一致性检查指南，帮助开发者验证 6 个 SKILL.md 的流程指引格式是否一致。

#### Scenario: 用户使用一致性检查指南验证格式

- **GIVEN** 用户修改了某个 SKILL.md 的流程指引
- **WHEN** 用户需要验证 6 个 SKILL.md 的格式一致性
- **THEN** 文档提供"一致性检查"节
- **AND** 文档说明如何验证格式一致性
- **AND** 文档提供检查命令或脚本示例

### Requirement: sdd-flow-guidance.md 包含格式规范

`sdd-flow-guidance.md` SHALL 包含完整的格式规范，作为"直接复制"的参考来源。

#### Scenario: 用户从模板复制流程指引

- **GIVEN** 用户需要为某个 SDD action 添加流程指引
- **WHEN** 用户打开 `sdd-flow-guidance.md`
- **THEN** 文档包含所有 6 个 action 的流程指引模板
- **AND** 每个模板包含完整的格式（分隔线、标题、推荐下一步）
- **AND** 用户可以直接复制对应 action 的内容到 SKILL.md

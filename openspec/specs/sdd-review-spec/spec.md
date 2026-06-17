## MODIFIED Requirements

### Requirement: Spec 审查流程

sdd-review-spec SHALL 包含 spec 审查和交互式修复两个阶段。

> **跨 spec 引用**: 交互式修复阶段的详细行为定义见 `specs/interactive-fix/spec.md`。

#### Scenario: 完整审查流程

- **WHEN** 用户执行 `/sdd-review-spec`
- **THEN** 执行 spec 审查
- **AND** 执行交互式修复（条件执行）

#### Scenario: 交互式修复触发条件

- **WHEN** spec 审查发现 Important 或 Minor issues
- **THEN** 进入交互式修复
- **AND** 询问用户是否修复

#### Scenario: 交互式修复跳过条件

- **WHEN** spec 审查未发现问题
- **OR** 用户选择跳过修复
- **THEN** 跳过交互式修复
- **AND** 输出完成引导

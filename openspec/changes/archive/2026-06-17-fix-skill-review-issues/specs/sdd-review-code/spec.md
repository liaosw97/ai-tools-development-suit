## MODIFIED Requirements

### Requirement: 代码审查流程

sdd-review-code SHALL 包含三个审查阶段和一个交互式修复阶段。

> **跨 spec 引用**: 交互式修复阶段的详细行为定义见 `specs/interactive-fix/spec.md`。

#### Scenario: 完整审查流程

- **WHEN** 用户执行 `/sdd-review-code`
- **THEN** 执行 Phase 1: Spec 合规审查
- **AND** 执行 Phase 1.5: 规范扫描（条件执行）
- **AND** 执行 Phase 2: 代码质量审查
- **AND** 执行 Phase 3: 交互式修复（条件执行）

#### Scenario: Phase 1.5 触发条件

- **GIVEN** Phase 1 已完成
- **WHEN** 变更包含 SKILL.md 文件修改
- **OR** 变更涉及流程指引相关内容
- **THEN** 执行 Phase 1.5 规范扫描

#### Scenario: Phase 1.5 跳过条件

- **GIVEN** Phase 1 已完成
- **WHEN** 变更不包含 SKILL.md 文件修改
- **AND** 变更不涉及流程指引相关内容
- **THEN** 跳过 Phase 1.5
- **AND** 直接进入 Phase 2

#### Scenario: Phase 3 触发条件

- **WHEN** Phase 2 发现 Important 或 Minor issues
- **THEN** 进入 Phase 3 交互式修复
- **AND** 询问用户是否修复

#### Scenario: Phase 3 跳过条件

- **WHEN** Phase 2 未发现问题
- **OR** 用户选择跳过修复
- **THEN** 跳过 Phase 3
- **AND** 输出完成引导

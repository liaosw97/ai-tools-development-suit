## ADDED Requirements

### Requirement: Skill 文件模块化拆分

系统 SHALL 将大型 skill 文件拆分为独立模块，支持按需加载。

#### Scenario: sdd-brainstorm 拆分
- **GIVEN** sdd-brainstorm skill 文件为单体结构（~472行）
- **WHEN** 执行 sdd-brainstorm action
- **THEN** 系统加载核心流程模块（~150行），角色系统和拆分模式模块按需加载

#### Scenario: 其他大型 skill 拆分
- **GIVEN** sdd-plan、sdd-code 等 skill 文件为单体结构（>200行）
- **WHEN** 执行对应 action
- **THEN** 系统加载核心流程模块，可选功能模块按需加载

#### Scenario: 模块加载失败降级
- **GIVEN** skill 模块文件不存在（路径不存在或文件为空）
- **WHEN** 执行 skill 加载
- **THEN** 系统降级到完整加载（使用原始 skill 文件），记录错误日志，继续执行不阻断流程

### Requirement: Guidelines 按需加载

系统 SHALL 根据 action 类型按需加载 guidelines 文件，而非一次性全部加载。

#### Scenario: token-optimization.md 加载
- **GIVEN** SDD 工作流尚未初始化
- **WHEN** 初始化 SDD 工作流
- **THEN** 系统在初始化阶段加载 token-optimization.md，后续 action 执行时不再重复加载（可通过加载计数器验证）

#### Scenario: quality-checkpoints.md 加载
- **GIVEN** 当前 action 为 sdd-ff、sdd-plan、sdd-code 或 sdd-verify（这些 action 包含质量门检查点）
- **WHEN** 执行质量门检查
- **THEN** 系统仅加载对应 action 的检查点部分（而非完整文件）

#### Scenario: decision-strategy.md 加载
- **GIVEN** 当前 action 为 sdd-brainstorm 或 sdd-propose（这些 action 包含方案选择决策点）
- **WHEN** 执行到方案选择步骤
- **THEN** 系统加载 decision-strategy.md

### Requirement: Reviewer Prompt 延迟加载

系统 SHALL 仅在进入 review 循环时加载对应的 reviewer prompt。

#### Scenario: brainstorm review
- **GIVEN** sdd-brainstorm 已完成，进入 review 循环
- **WHEN** 进入 brainstorm review 循环
- **THEN** 系统加载 brainstorm-reviewer-prompt.md（~60行）

#### Scenario: plan review
- **GIVEN** sdd-plan 已完成，进入 review 循环
- **WHEN** 进入 plan review 循环
- **THEN** 系统加载 plan-reviewer-prompt.md（~62行）

#### Scenario: code review
- **GIVEN** sdd-code 已完成，进入 review 循环
- **WHEN** 进入 code review 循环
- **THEN** 系统加载对应的 reviewer prompt（spec-compliance、scan、code-quality）

### Requirement: token-optimization.md 指南更新

系统 SHALL 更新 token-optimization.md 指南，包含懒加载优化策略。

#### Scenario: 指南内容更新
- **GIVEN** token-optimization.md 指南已存在
- **WHEN** 完成懒加载机制实现
- **THEN** 系统更新指南，包含以下内容：
  - 懒加载策略说明（模块化拆分、按需加载、延迟加载）
  - 各 action 的加载优化规则
  - 异常降级处理说明

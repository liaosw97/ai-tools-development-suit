## ADDED Requirements

### Requirement: Artifact 摘要传递

系统 SHALL 使用摘要代替完整 artifact 内容传递给 subagent。

#### Scenario: spec 场景列表传递
- **GIVEN** spec 文件包含多个 GIVEN/WHEN/THEN 场景
- **WHEN** 传递 spec 给 subagent
- **THEN** 系统传递 spec 场景列表（场景名称 + 关键字段），而非完整 spec 文件

#### Scenario: task 摘要传递
- **GIVEN** tasks.md 包含多个任务项
- **WHEN** 传递 tasks 给 subagent
- **THEN** 系统传递 task 摘要（任务编号 + 描述 + spec 链接），而非完整 tasks.md

#### Scenario: 关键字段保留
- **GIVEN** artifact 包含关键字段
- **WHEN** 生成 artifact 摘要
- **THEN** 系统强制保留以下关键字段，关键信息覆盖率 ≥95%：
  - **spec 场景**: 场景名称 + 完整的 GIVEN/WHEN/THEN 三元组
  - **task 链接**: task 编号 + spec 引用（`[spec:domain#scenario]` 格式）
  - **决策结论**: 决策选项 + 选择理由 + 被否决替代方案
  - 覆盖率计算公式: `保留的关键字段数 / 原文关键字段总数 × 100%`

#### Scenario: 摘要信息丢失降级
- **GIVEN** 摘要算法丢失关键信息（关键信息覆盖率 <95%）
- **WHEN** 检测到摘要质量问题
- **THEN** 系统降级到完整 artifact 传递，记录摘要质量问题

### Requirement: Review 上下文压缩

系统 SHALL 压缩传递给 review subagent 的上下文。

#### Scenario: diff + spec 场景传递
- **GIVEN** 代码变更包含 diff，spec 包含相关场景
- **WHEN** 执行 code review
- **THEN** 系统传递 diff + 相关 spec 场景（而非完整文件）

#### Scenario: 结构化摘要
- **GIVEN** review 上下文包含多个信息维度
- **WHEN** 传递 review 上下文
- **THEN** 系统使用结构化摘要（JSON 格式，包含 code-changes、spec-context、quality-metrics 字段）

### Requirement: 跨 Action 状态压缩

系统 SHALL 维护轻量级状态文件，记录关键决策和进度。

#### Scenario: 状态文件创建
- **GIVEN** 尚未创建状态文件
- **WHEN** 执行第一个 action
- **THEN** 系统创建轻量级状态文件，大小 ≤500 字符（约 20 行），格式为 YAML，包含 change 名称、当前阶段、关键决策列表

#### Scenario: 状态文件更新
- **GIVEN** 状态文件已存在
- **WHEN** 执行后续 action
- **THEN** 系统更新状态文件，记录关键决策和进度，保持大小 ≤500 字符（约 20 行）

#### Scenario: 状态文件读取
- **GIVEN** 状态文件已存在且格式正确
- **WHEN** 执行 action
- **THEN** 系统读取状态文件获取上下文（而非从 artifact 重新构建）

#### Scenario: 状态文件损坏恢复
- **GIVEN** 状态文件格式错误或内容损坏
- **WHEN** 检测到状态文件损坏
- **THEN** 系统忽略状态文件，从 artifact 重新构建上下文，生成新的状态文件

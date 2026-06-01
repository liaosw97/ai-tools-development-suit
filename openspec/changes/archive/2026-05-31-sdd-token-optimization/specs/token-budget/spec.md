## ADDED Requirements

### Requirement: 定义层 Token 预算

系统 SHALL 建立完整的定义层 token 预算视图。

#### Scenario: SDD Skills 统计
- **GIVEN** ai-tools-bridge/skills/sdd-*/SKILL.md 文件存在
- **WHEN** 分析定义层 token 消耗
- **THEN** 系统统计所有 SDD skill 文件的行数和 token 数（使用 cl100k_base 编码计算）

#### Scenario: Superpowers Skills 统计
- **GIVEN** ai-tools/superpowers/skills/*/SKILL.md 文件存在
- **WHEN** 分析定义层 token 消耗
- **THEN** 系统统计所有 Superpowers skill 文件的行数和 token 数

#### Scenario: 模板和指南统计
- **GIVEN** ai-tools-bridge/schemas/sdd/templates/ 和 guidelines/ 文件存在
- **WHEN** 分析定义层 token 消耗
- **THEN** 系统统计 templates、guidelines、reviewer prompts 的行数和 token 数

### Requirement: 执行层 Token 预算

系统 SHALL 建立完整的执行层 token 预算视图。

#### Scenario: 单个 Action 统计
- **GIVEN** SDD action 正在执行
- **WHEN** 分析执行层 token 消耗
- **THEN** 系统统计单个 action 的 token 消耗，包含以下组件：
  - 系统 prompt（CLAUDE.md 等）
  - skill 定义（当前 action 的 SKILL.md）
  - 底层 skill 定义（委托的 Superpowers skill）
  - 项目上下文（package.json, config.yaml）
  - 已有 artifacts（brainstorm.md, proposal.md 等）
  - 用户输入

#### Scenario: 完整流程统计
- **GIVEN** SDD 完整流程正在执行（brainstorm → propose → ff → plan → code → review → verify → ship）
- **WHEN** 分析执行层 token 消耗
- **THEN** 系统统计完整流程的 token 消耗（所有 action 累计）

### Requirement: Token 消耗测量

系统 SHALL 提供 token 消耗测量方法。

#### Scenario: 峰值消耗测量
- **GIVEN** SDD action 正在执行
- **WHEN** 测量 token 消耗
- **THEN** 系统测量单个 action 执行时的最大 context 占用（单位：tokens）

#### Scenario: 总消耗测量
- **GIVEN** SDD 完整流程正在执行
- **WHEN** 测量 token 消耗
- **THEN** 系统测量完整流程的累计 token 消耗（单位：tokens）

### Requirement: Token 预算报告

系统 SHALL 生成 token 预算报告。

#### Scenario: 报告生成
- **GIVEN** 已完成定义层和执行层 token 消耗统计
- **WHEN** 生成报告
- **THEN** 系统生成 token 预算报告，包含以下内容：
  - 定义层 token 消耗明细（按组件分类）
  - 执行层 token 消耗明细（按 action 分类）
  - 峰值消耗和总消耗统计
  - 优化建议

### Requirement: Token 预算驱动优化

系统 SHALL 根据 token 预算数据识别优化候选并生成建议。

#### Scenario: 定义层超预算标记
- **GIVEN** 已完成定义层 token 消耗统计
- **WHEN** 某组件（skill 文件、template、guideline）token 消耗超过该层总消耗的 30%
- **THEN** 系统标记该组件为优化候选，在预算报告中建议实施懒加载或模块化拆分

#### Scenario: 执行层异常消耗标记
- **GIVEN** 已完成执行层 token 消耗统计
- **WHEN** 某 action 的 token 消耗超过所有 action 平均值的 2 倍
- **THEN** 系统标记该 action 为优化候选，在预算报告中建议对该 action 实施上下文压缩或懒加载

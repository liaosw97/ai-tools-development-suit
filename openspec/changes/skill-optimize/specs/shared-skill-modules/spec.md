## ADDED Requirements

### Requirement: 共享模块目录结构
系统 SHALL 在 `skills/_shared/` 目录下提供 5 个共享模块文件。

#### Scenario: 共享模块文件存在
- **GIVEN** skill-optimize 改造已完成
- **WHEN** 检查 `skills/_shared/` 目录
- **THEN** 存在以下文件：
  - `base-triggers.md`（通用触发条件模板）
  - `output-constraints.md`（输出约束 + 零结果防护）
  - `role-loading.md`（角色加载完整逻辑）
  - `breakdown-mode.md`（拆分模式检测 + 交互流程）
  - `review-loop.md`（review 循环模式）

### Requirement: Include 机制
系统 SHALL 支持通过 `<!-- include: path -->` 语法引用共享模块。

#### Scenario: Include 语法识别
- **GIVEN** SKILL.md 中已写入 `<!-- include -->` 注释
- **WHEN** AI 解析 SKILL.md
- **THEN** 识别 `<!-- include: ../_shared/role-loading.md -->` 并加载 `skills/_shared/role-loading.md` 的内容

#### Scenario: Include 路径解析
- **GIVEN** SKILL.md 位于 `skills/sdd-brainstorm/SKILL.md`
- **WHEN** 解析 include 路径
- **THEN** 相对路径 `../_shared/role-loading.md` 解析为 `skills/_shared/role-loading.md`

### Requirement: 共享模块引用规则
每个 SKILL.md SHALL 根据其功能需求引用对应的共享模块。

#### Scenario: 引用规则定义
- **GIVEN** 14 个 SKILL.md 已完成改造
- **WHEN** 检查 SKILL.md 的功能需求
- **THEN** 按以下规则引用共享模块：
  - `base-triggers.md`：所有 14 个 SKILL（通用触发条件格式）
  - `output-constraints.md`：所有 14 个 SKILL（输出约束和零结果防护）
  - `role-loading.md`：9 个有角色系统的 SKILL（sdd-brainstorm、sdd-code、sdd-plan、sdd-propose、sdd-review-code、sdd-review-spec、sdd-ship、sdd-test-code、sdd-verify）
  - `breakdown-mode.md`：1 个支持拆分的 SKILL（sdd-brainstorm）
  - `review-loop.md`：2 个有 review 循环的 SKILL（sdd-brainstorm、sdd-plan）

### Requirement: 共享模块内容完整性
每个共享模块 SHALL 包含从原始 SKILL.md 提取的完整内容。

#### Scenario: base-triggers.md 内容
- **GIVEN** `skills/_shared/base-triggers.md` 已从原始 SKILL.md 提取
- **WHEN** 读取该文件
- **THEN** 包含以下具体内容：
  - 触发条件格式模板（**触发**/**不触发**/**歧义处理**）
  - 至少 3 个示例触发词
  - 不触发条件的箭头指向格式（→ `/sdd-xxx`）

#### Scenario: output-constraints.md 内容
- **GIVEN** `skills/_shared/output-constraints.md` 已从原始 SKILL.md 提取
- **WHEN** 读取该文件
- **THEN** 包含以下具体内容：
  - 禁止输出列表（开场白、工具调用描述、未验证结论、已知信息复述）
  - 零结果防护规则（决策引用来源、无法形成决策时的输出、关键决策为空时的警告）

#### Scenario: role-loading.md 内容
- **GIVEN** `skills/_shared/role-loading.md` 已从原始 SKILL.md 提取
- **WHEN** 读取该文件
- **THEN** 包含以下具体内容：
  - 参数解析流程（`--role <name>` 提取和验证）
  - 角色优先级规则（参数 > 会话级 > 默认）
  - 角色查找流程（用户级 > 项目级 > 内置）
  - 降级策略（角色不存在时的警告和默认角色）
  - 格式错误处理（YAML 解析失败、缺少字段）

#### Scenario: breakdown-mode.md 内容
- **GIVEN** `skills/_shared/breakdown-mode.md` 已从原始 SKILL.md 提取
- **WHEN** 读取该文件
- **THEN** 包含以下具体内容：
  - 触发条件（参数 `--breakdown`、关键词"拆分/分层/逐步探索/功能模块"）
  - L1 功能模块拆分流程（AI 提议 → 用户确认）
  - L2 功能单元拆分流程（细化 + 即时追问）
  - L3 功能点拆分流程（可选，>3 个独立操作时触发）
  - 目录冲突检测（相似度阈值 >60%）

#### Scenario: review-loop.md 内容
- **GIVEN** `skills/_shared/review-loop.md` 已从原始 SKILL.md 提取
- **WHEN** 读取该文件
- **THEN** 包含以下具体内容：
  - Review 流程（dispatch reviewer → 展示 issues → 修复 → 重新 review）
  - 轮次限制（默认 3 轮，从 config.yaml 读取）
  - 达限处理（提示、列出未解决 issues、提供继续/接受选项）
  - 用户选择"继续修复"后取消轮次限制

### Requirement: 覆盖机制
SKILL.md SHALL 能够覆盖共享模块的默认值。

#### Scenario: 差异覆盖
- **GIVEN** SKILL.md 在 `<!-- include -->` 之后写入了差异内容
- **WHEN** AI 解析 SKILL.md
- **THEN** 差异内容覆盖共享模块的默认值

#### Scenario: 默认角色覆盖
- **GIVEN** `role-loading.md` 定义默认角色为通用值，SKILL.md 写入了 `**默认角色**: xxx`
- **WHEN** AI 加载角色配置
- **THEN** SKILL.md 的 `**默认角色**: xxx` 覆盖为特定值

### Requirement: 降级策略
系统 SHALL 在 include 解析失败时降级运行。

#### Scenario: Include 文件不存在
- **GIVEN** SKILL.md 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的文件不存在
- **THEN** AI 输出警告但不阻断执行，SKILL.md 仍可独立运行

#### Scenario: Include 路径错误
- **GIVEN** SKILL.md 包含格式错误的 `<!-- include -->` 路径
- **WHEN** AI 解析 include 路径
- **THEN** AI 输出警告并继续执行

### Requirement: 引用完整性验证
系统 SHALL 验证所有 SKILL.md 的共享模块引用完整性。

#### Scenario: 引用完整性验证
- **GIVEN** 14 个 SKILL.md 已完成改造，`skills/_shared/` 下 5 个共享模块文件均存在
- **WHEN** 扫描所有 SKILL.md 的 `<!-- include -->` 引用
- **THEN** 验证以下完整性规则：
  - 每个 SKILL.md 引用的共享模块文件均存在于 `skills/_shared/` 目录
  - 每个共享模块文件至少被一个 SKILL.md 引用（无孤立模块）
  - 引用路径格式正确（相对路径以 `../_shared/` 开头）

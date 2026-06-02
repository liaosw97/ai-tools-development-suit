## MODIFIED Requirements

### Requirement: sdd-plan 技能定义
sdd-plan SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-plan/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`
  - `<!-- include: ../_shared/review-loop.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-plan/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-plan`、"生成计划"、"细化任务"、"TDD 计划"、"实施计划"
  - 不触发条件：要直接编码（→ `/sdd-code`）；要审查 spec（→ `/sdd-review-spec`）
  - 默认角色：`eng-manager`
  - 可选角色：`ceo`
  - 前置校验：
    - tasks.md 不存在 → 阻断
    - tasks.md 存在但内容为空 → 阻断
    - specs/ 目录下无 spec 文件 → 阻断
    - tasks 中部分任务缺少 `[spec:domain#scenario]` 链接 → 警告
  - 核心执行：委托 `superpowers:writing-plans`
  - 后置逻辑：
    - Plan Review 循环（最多 N 轮，N = limits.review-rounds，默认 3）
    - 产物校验（plan.md 存在、每个 task 有实施步骤、包含 TDD RED/GREEN 结构、保留 spec 链接）
    - 完成引导

#### Scenario: 任务规模检测
- **GIVEN** tasks.md 已存在且包含任务列表
- **WHEN** 统计 tasks.md 中的任务数量
- **THEN** 根据规模选择处理策略：
  - 小型（≤10）：直接生成完整 plan.md
  - 中型（11-25）：提示用户选择一次性生成或分批生成
  - 大型（>25）：强建议拆分或分批

#### Scenario: 分批生成模式
- **GIVEN** 用户已选择分批生成方式
- **WHEN** 执行分批生成
- **THEN** 按依赖关系分为 N 批（每批 5-10 个任务），逐批生成并带批次标记

#### Scenario: 功能树读取（拆分模式）
- **GIVEN** brainstorm.md 存在且包含"## 功能拆分"节
- **WHEN** 解析功能树
- **THEN** 提取叶子节点、用于任务组标注 `[unit:模块/单元/功能点]`

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-plan/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-plan`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 286 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 286 行减少至 ≤120 行（减少 58%）

### Requirement: Include 降级策略
sdd-plan SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-plan/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-plan SKILL.md 仍可独立运行（使用内联内容）

## MODIFIED Requirements

### Requirement: sdd-brainstorm 技能定义
sdd-brainstorm SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-brainstorm/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`
  - `<!-- include: ../_shared/breakdown-mode.md -->`
  - `<!-- include: ../_shared/review-loop.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-brainstorm/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-brainstorm`、"探索需求"、"头脑风暴"、"方案比较"、"深度设计"
  - 不触发条件：需求已明确（→ `/sdd-propose`）；直接写代码（→ `/sdd-code`）
  - 默认角色：`yc-office-hours`
  - 可选角色：`ceo`、`designer`
  - 前置校验：无前置依赖
  - 核心执行：委托 `superpowers:brainstorming`
  - 后置逻辑：产物校验（需求描述、方案探索、关键决策）

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-brainstorm/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-brainstorm`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 472 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 472 行减少至 ≤180 行（减少 62%）

### Requirement: Include 降级策略
sdd-brainstorm SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-brainstorm/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-brainstorm SKILL.md 仍可独立运行（使用内联内容）

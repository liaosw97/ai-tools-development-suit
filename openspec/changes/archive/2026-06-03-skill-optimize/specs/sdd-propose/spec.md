## MODIFIED Requirements

### Requirement: sdd-propose 技能定义
sdd-propose SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-propose/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-propose/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-propose`、"创建提案"、"固化需求"、"写 proposal"
  - 不触发条件：要深度探索需求（→ `/sdd-brainstorm`）；要批量生成文档（→ `/sdd-ff`）
  - 默认角色：`ceo`
  - 可选角色：`eng-manager`
  - 前置校验：
    - 如果 brainstorm.md 存在，检查关键决策项是否有空项 → 警告（用户确认后可强制继续）
  - 核心执行：
    - 如果 change 目录已存在且有其他 artifact → invoke `openspec-continue-change`
    - 如果是全新变更 → invoke `openspec-propose`
  - 后置逻辑：
    - 决策追溯检查（如果 brainstorm.md 存在，验证 proposal 引用了每个关键决策）
    - 跨模块影响扫描（检查 specs/ 子目录数量，N ≥ 2 时执行完整跨模块分析）
    - 产物校验（proposal.md 存在且包含变更意图、范围、决策追溯节）
    - 完成引导

#### Scenario: 跨模块影响扫描
- **GIVEN** proposal.md 已生成且包含范围节
- **WHEN** 执行 sdd-propose 后置逻辑
- **THEN** 读取 proposal.md 的范围节，结合项目结构评估跨模块影响：
  - N ≥ 2：执行完整跨模块分析
  - N ≤ 1 或 specs/ 不存在：简化提示

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-propose/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-propose`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 148 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 148 行减少至 ≤65 行（减少 56%）

### Requirement: Include 降级策略
sdd-propose SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-propose/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-propose SKILL.md 仍可独立运行（使用内联内容）

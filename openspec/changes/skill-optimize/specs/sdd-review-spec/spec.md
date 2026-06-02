## MODIFIED Requirements

### Requirement: sdd-review-spec 技能定义
sdd-review-spec SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-review-spec/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-review-spec/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-review-spec`、"审查 spec"、"检查规格质量"、"验证场景完整性"
  - 不触发条件：要审查代码质量（→ `/sdd-review-code`）；要修改 spec（→ `/sdd-ff`）
  - 默认角色：`eng-manager`
  - 可选角色：`ceo`、`designer`
  - 前置校验：
    - `specs/` 不存在或无 spec 文件 → 阻断
  - 核心执行：SDD 自有 subagent（读取 `spec-reviewer-prompt.md`，dispatch subagent 审查）
  - 后置逻辑：
    - 规范扫描（条件执行，从 proposal.md 推断工作类型，涉及 skill 开发时调用 skill-craft-adapter:skill-check）
    - 输出审查报告（产物写入 `reviews/spec-r<N>.md`）
    - 审查结果处理（APPROVED 或 NEEDS_REVISION）
    - 完成引导

#### Scenario: 审查覆盖
- **GIVEN** `specs/` 目录下存在 spec 文件
- **WHEN** 执行 sdd-review-spec
- **THEN** 审查覆盖所有 spec 文件、proposal 与 spec 的一致性、brainstorm 决策追溯完整性

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-review-spec/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-review-spec`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 126 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 126 行减少至 ≤55 行（减少 56%）

### Requirement: Include 降级策略
sdd-review-spec SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-review-spec/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-review-spec SKILL.md 仍可独立运行（使用内联内容）

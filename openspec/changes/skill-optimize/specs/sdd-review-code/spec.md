## MODIFIED Requirements

### Requirement: sdd-review-code 技能定义
sdd-review-code SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-review-code/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-review-code/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-review-code`、"审查代码"、"代码 review"、"检查代码质量"
  - 不触发条件：要审查 spec 质量（→ `/sdd-review-spec`）；要补全测试（→ `/sdd-test-code`）
  - 默认角色：`staff-engineer`
  - 可选角色：`cso`、`qa-lead`
  - 前置校验：
    - 无代码变更（git 无未提交更改）或 `specs/` 不存在 → 阻断
    - spec 场景总数少于 tasks 数量 → 警告
  - 核心执行（三阶段）：
    - Phase 1: Spec 合规审查（SDD 自有 subagent，产出 `reviews/spec-compliance-r<N>.md`）
    - Phase 1.5: 规范扫描（条件执行，检测工作类型，调用 skill-craft-adapter 或查询可用 skill）
    - Phase 2: 代码质量审查（委托 `superpowers:requesting-code-review`，产出 `reviews/code-quality-r<N>.md`）
  - 后置逻辑：
    - 汇总审查结果（Phase 1/1.5/2 结果）
    - 完成引导

#### Scenario: 工作类型检测
- **GIVEN** Phase 1.5 规范扫描已触发
- **WHEN** 执行 Phase 1.5 规范扫描
- **THEN** 通过 git diff 检查变更文件路径，判断是 skill 开发还是代码开发

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-review-code/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-review-code`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 185 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 185 行减少至 ≤80 行（减少 57%）

### Requirement: Include 降级策略
sdd-review-code SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-review-code/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-review-code SKILL.md 仍可独立运行（使用内联内容）

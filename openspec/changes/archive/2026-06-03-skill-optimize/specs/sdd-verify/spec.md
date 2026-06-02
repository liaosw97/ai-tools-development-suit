## MODIFIED Requirements

### Requirement: sdd-verify 技能定义
sdd-verify SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-verify/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-verify/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-verify`、"验证"、"全面验证"、"运行所有测试"、"检查覆盖率"
  - 不触发条件：要审查代码质量（→ `/sdd-review-code`）；要归档（→ `/sdd-ship`）
  - 默认角色：`qa-lead`
  - 可选角色：`cso`、`sre`
  - 前置校验：
    - `specs/` 不存在或无代码文件 → 阻断
  - 核心执行：
    - 代码验证（invoke `superpowers:verification-before-completion`，运行单元测试、集成测试、Lint、类型检查、构建验证）
    - Spec 验证（invoke `openspec-verify-change`，验证变更的 spec 合规性）
  - 后置逻辑：
    - Scenario 覆盖率统计（逐条检查 spec 场景，标记 ✅/❌/⚠️）
    - 验证报告（PASSED/FAILED 判定）
    - 完成引导

#### Scenario: 测试失败处理
- **GIVEN** 代码验证阶段运行单元测试或集成测试
- **WHEN** 测试执行失败
- **THEN** 输出失败的测试名称和错误信息，标记验证结果为 FAILED，推荐执行 `/sdd-code` 修复

#### Scenario: Spec 覆盖率不达标
- **GIVEN** 已完成 Scenario 覆盖率统计
- **WHEN** 存在 ❌ 标记的未覆盖场景
- **THEN** 输出未覆盖场景列表，标记验证结果为 FAILED，推荐执行 `/sdd-test-code` 补全

#### Scenario: 验证报告判定标准
- **GIVEN** 代码验证和 Spec 验证均已执行完毕
- **WHEN** 生成验证报告
- **THEN** 按以下标准判定：
  - PASSED：所有测试通过 + Lint/类型检查/构建无错误 + 所有 spec 场景标记为 ✅
  - FAILED：任一测试失败 或 Lint/类型检查/构建错误 或 存在 ❌ 标记的场景

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-verify/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-verify`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 142 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 142 行减少至 ≤65 行（减少 54%）

### Requirement: Include 降级策略
sdd-verify SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-verify/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-verify SKILL.md 仍可独立运行（使用内联内容）

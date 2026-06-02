## MODIFIED Requirements

### Requirement: sdd-test-code 技能定义
sdd-test-code SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-test-code/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-test-code/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-test-code`、"补全测试"、"补充缺失测试"、"修复测试质量"
  - 不触发条件：要写新功能代码（→ `/sdd-code`）；要审查代码（→ `/sdd-review-code`）
  - 默认角色：`qa-lead`
  - 可选角色：`staff-engineer`
  - 前置校验：
    - `reviews/` 不存在或为空 → 阻断
  - 核心执行：
    - 场景补全：补全 PARTIAL/MISSING 场景的测试，严格约束不修改实现代码
    - 测试质量修复：按 TDD 规范修复测试质量问题，不修改实现代码
  - 后置逻辑：
    - 补全统计（PARTIAL/MISSING 补全/跳过/失败数量）
    - 推荐操作（/sdd-verify 或 /sdd-ship）

#### Scenario: 定位最新 review 报告
- **GIVEN** `reviews/` 目录下已存在 review 报告文件
- **WHEN** 执行 sdd-test-code
- **THEN** 扫描 `reviews/` 目录，按最新修改时间排序，定位最新的 spec-compliance 和 code-quality 报告

#### Scenario: 提取补全目标
- **GIVEN** 已定位最新的 spec-compliance 和 code-quality 报告
- **WHEN** 解析报告内容
- **THEN** 从 spec-compliance 报告提取 PARTIAL/MISSING 场景，从 code-quality 报告提取测试质量 issues

#### Scenario: 空操作提示
- **GIVEN** spec-compliance 报告中无 PARTIAL/MISSING 场景，且 code-quality 报告中无测试质量 issues
- **WHEN** 执行 sdd-test-code
- **THEN** 输出"所有场景均已覆盖，无测试质量问题"，直接进入后置推荐

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-test-code/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-test-code`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 135 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 135 行减少至 ≤60 行（减少 56%）

### Requirement: Include 降级策略
sdd-test-code SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-test-code/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-test-code SKILL.md 仍可独立运行（使用内联内容）

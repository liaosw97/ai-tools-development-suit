## MODIFIED Requirements

### Requirement: sdd-continue 技能定义
sdd-continue SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-continue/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-continue/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-continue`、"逐步补充"、"下一个 artifact"、"继续推进"
  - 不触发条件：要一次性生成所有缺失文档（→ `/sdd-ff`）；要开始编码（→ `/sdd-code`）
  - 默认角色：无（文档生成工具）
  - 可选角色：无
  - 前置校验：无前置阻断，依赖链中任何位置均可触发
  - 核心执行：委托 `openspec-continue-change`（生成依赖链中下一个缺失的 artifact）
  - 后置逻辑：
    - 格式校验（文件存在且非空、包含模板要求的必填字段、spec 有 GIVEN/WHEN/THEN、tasks 有 spec 链接）
    - 决策追溯检查（仅生成 proposal 时，如果 brainstorm.md 存在）
    - 完成引导

#### Scenario: 识别已有 artifact
- **GIVEN** `openspec/changes/<name>/` 目录下已存在部分 artifact
- **WHEN** 执行 sdd-continue
- **THEN** 按依赖链顺序检查：brainstorm.md → proposal.md → specs/ → design.md → tasks.md

#### Scenario: 确定下一个缺失 artifact
- **GIVEN** 依赖链中存在至少一个缺失的 artifact
- **WHEN** 执行 sdd-continue
- **THEN** 找到依赖链中第一个缺失的 artifact，按顺序：proposal → specs → design（可选）→ tasks

#### Scenario: 全部存在提示
- **GIVEN** 依赖链中所有 artifact 均已存在
- **WHEN** 执行 sdd-continue
- **THEN** 输出"所有规划文档已完成"

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-continue/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-continue`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 122 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 122 行减少至 ≤55 行（减少 55%）

### Requirement: Include 降级策略
sdd-continue SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-continue/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-continue SKILL.md 仍可独立运行（使用内联内容）

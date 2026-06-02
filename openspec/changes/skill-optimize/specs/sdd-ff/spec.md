## MODIFIED Requirements

### Requirement: sdd-ff 技能定义
sdd-ff SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-ff/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-ff/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-ff`、"快进"、"批量生成"、"生成所有文档"
  - 不触发条件：要逐步推进（→ `/sdd-continue`）；要开始编码（→ `/sdd-code`）
  - 默认角色：无（文档生成工具）
  - 可选角色：无
  - 前置校验：
    - `proposal.md` 不存在 → 阻断
    - `proposal.md` 存在但影响分析为空或含占位符 → 警告（用户确认后可强制继续）
  - 核心执行：委托 `openspec-ff-change`（生成所有缺失 artifact，截止到 tasks.md）
  - 后置逻辑：
    - 逐个格式校验（proposal 意图明确、spec 有 GIVEN/WHEN/THEN、design 技术方案可行、tasks 有 spec 链接）
    - 完成引导

#### Scenario: 评估当前状态
- **GIVEN** `openspec/changes/<name>/` 目录下已存在部分 artifact
- **WHEN** 执行 sdd-ff
- **THEN** 列出已有和缺失的 artifact，展示将生成的 artifact 列表

#### Scenario: 不生成 plan.md
- **GIVEN** sdd-ff 的职责范围不包含 plan.md
- **WHEN** 执行 sdd-ff
- **THEN** 不生成 plan.md（plan.md 由 sdd-plan 单独生成）

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-ff/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-ff`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 127 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 127 行减少至 ≤55 行（减少 57%）

### Requirement: Include 降级策略
sdd-ff SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-ff/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-ff SKILL.md 仍可独立运行（使用内联内容）

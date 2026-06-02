## MODIFIED Requirements

### Requirement: sdd-code 技能定义
sdd-code SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-code/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-code/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-code`、"开始编码"、"TDD 实施"、"实现功能"、"写代码"
  - 不触发条件：要补全测试（→ `/sdd-test-code`）；要审查代码（→ `/sdd-review-code`）
  - 默认角色：`developer`
  - 可选角色：无（执行阶段角色固定为 developer）
  - 前置校验：
    - tasks.md 不存在 → 阻断
    - tasks 数量 >15 且 plan.md 不存在 → 警告（用户确认后可强制继续）
  - 核心执行：
    - 委托 `superpowers:using-git-worktrees`（如需）
    - 委托 `superpowers:test-driven-development`
    - 委托 `superpowers:systematic-debugging`（仅在测试意外失败时）
  - 后置逻辑：
    - 更新 tasks.md（标记已完成任务为 `[x]`）
    - 产物校验（commit 已创建、tasks.md 已更新、无幻觉函数、无硬编码敏感信息）
    - 完成引导

#### Scenario: 功能单元选择（拆分模式）
- **GIVEN** plan.md 已生成且包含 `[unit:模块/单元/功能点]` 标注
- **WHEN** 解析功能单元状态
- **THEN** 输出状态列表、用户选择功能单元

#### Scenario: 目录冲突检测（拆分模式）
- **GIVEN** 项目目录中已存在部分文件结构
- **WHEN** 创建文件前扫描项目目录
- **THEN** 判断相似目录（相似度 >60%）、发现冲突时暂停询问用户

#### Scenario: Worktree 准备
- **GIVEN** 当前工作目录不在 git worktree 中
- **WHEN** sdd-code 开始执行
- **THEN** 建议创建 worktree，分支命名：`sdd/<change-name>`

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-code/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-code`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 211 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 211 行减少至 ≤90 行（减少 57%）

### Requirement: Include 降级策略
sdd-code SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-code/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-code SKILL.md 仍可独立运行（使用内联内容）

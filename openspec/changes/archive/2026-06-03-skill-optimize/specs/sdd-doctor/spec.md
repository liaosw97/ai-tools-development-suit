## MODIFIED Requirements

### Requirement: sdd-doctor 技能定义
sdd-doctor SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-doctor/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-doctor/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-doctor`、"检查环境"、"诊断"、"当前状态"、"推荐路径"
  - 不触发条件：用户要执行具体操作（→ 对应 action）；用户要修改代码（→ `/sdd-code`）
  - 默认角色：无（诊断工具）
  - 可选角色：无
  - 前置校验：无前置依赖，校验直接通过
  - 核心执行：无底层 skill 委托，由 SDD 自有逻辑执行
  - 后置逻辑：
    - 输出诊断报告（工具状态、限制配置、活跃变更状态）
    - 路径推荐（根据复杂度评级推荐工作流路径）
    - 完成引导

#### Scenario: 检查工具安装
- **GIVEN** 用户执行 `/sdd-doctor` 命令
- **WHEN** 执行 sdd-doctor
- **THEN** 检测 OpenSpec 和 Superpowers 是否可用

#### Scenario: 检查 Change 状态
- **GIVEN** `openspec/changes/` 目录存在
- **WHEN** 执行 sdd-doctor
- **THEN** 扫描 `openspec/changes/` 目录，列出所有活跃变更，检查已有 artifact

#### Scenario: 复杂度评估
- **GIVEN** 活跃变更存在 `specs/` 或 `tasks.md`
- **WHEN** 执行 sdd-doctor 复杂度评估
- **THEN** 按五个维度采集指标（spec 场景数量、tasks 数量、影响文件数、涉及领域数、外部依赖变更），给出评级（简单/中等/复杂）

#### Scenario: 路径推荐
- **GIVEN** 复杂度评估已完成
- **WHEN** 完成复杂度评估
- **THEN** 根据评级推荐工作流路径：
  - 简单(S)：推荐 /sdd-quick
  - 中等(M)：推荐标准路径 /sdd-propose → /sdd-ff → /sdd-plan → /sdd-code
  - 复杂(L)：推荐完整流程

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-doctor/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-doctor`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 187 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 187 行减少至 ≤80 行（减少 57%）

### Requirement: Include 降级策略
sdd-doctor SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-doctor/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-doctor SKILL.md 仍可独立运行（使用内联内容）

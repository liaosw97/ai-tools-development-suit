## MODIFIED Requirements

### Requirement: sdd-ship 技能定义
sdd-ship SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-ship/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`
  - `<!-- include: ../_shared/role-loading.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-ship/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-ship`、"归档"、"合并分支"、"完成变更"、"ship"
  - 不触发条件：用户只想查看变更状态（→ `/sdd-doctor`）；用户要修改代码（→ `/sdd-code`）
  - 默认角色：`release-engineer`
  - 可选角色：`sre`
  - 前置校验：
    - 未执行 sdd-verify → 警告（用户确认后可强制继续）
    - 存在未通过的 review issues → 警告（用户确认后可强制继续）
  - 核心执行（三步顺序执行）：
    - Step 1: Sync Specs（invoke `openspec-sync-specs`）
    - Step 2: Archive Change（invoke `openspec-archive-change`）
    - Step 3: Finish Branch（invoke `superpowers:finishing-a-development-branch`）
  - 后置逻辑：
    - 确认归档（验证变更目录已移至 archive/、活跃目录已移除、全局 specs 已更新、分支已合并）
    - 完成引导

#### Scenario: 行为准则
- **GIVEN** 变更已完成验证，准备执行归档
- **WHEN** 执行归档过程
- **THEN** 遵循以下准则：
  - 归档前必须确认（不可逆操作）
  - 验证后才归档
  - 失败时停止而非跳过

#### Scenario: 延后项提取
- **GIVEN** proposal.md 存在且包含延后项（P1/P2）
- **WHEN** 归档前
- **THEN** 从 proposal.md 中提取延后项（P1/P2），写入 `openspec/backlog.md`

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-ship/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-ship`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 206 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 206 行减少至 ≤90 行（减少 56%）

### Requirement: Include 降级策略
sdd-ship SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-ship/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-ship SKILL.md 仍可独立运行（使用内联内容）

## MODIFIED Requirements

### Requirement: sdd-role 技能定义
sdd-role SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-role/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-role/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-role`
  - 不触发条件：无
  - 默认角色：无（角色管理工具）
  - 可选角色：无
  - 前置校验：无
  - 核心执行：SDD 自有逻辑（无底层 skill 委托）
  - 后置逻辑：无

#### Scenario: 显示当前角色（无参数）
- **GIVEN** 用户未指定角色参数
- **WHEN** 用户执行 `/sdd-role`（无参数）
- **THEN** 输出当前角色信息（名称、来源、身份、可用 action）

#### Scenario: 切换角色（有参数）
- **GIVEN** 用户指定了角色名称参数
- **WHEN** 用户执行 `/sdd-role <name>`
- **THEN** 解析角色名称、查找角色定义（按优先级：用户级 > 项目级 > 内置）、设置会话级角色

#### Scenario: 列出角色（--list）
- **GIVEN** 用户指定了 `--list` 参数
- **WHEN** 用户执行 `/sdd-role --list`
- **THEN** 扫描所有角色定义源，按分类输出角色列表（Planning、Execution、Review、Release）

#### Scenario: 角色优先级规则
- **GIVEN** 多个角色来源存在冲突
- **WHEN** 确定生效角色
- **THEN** 按优先级顺序：`--role` 参数 > `/sdd-role` 设置的会话级角色 > action 默认角色

#### Scenario: 错误处理
- **GIVEN** 用户输入了不存在的角色名称或格式错误的参数
- **WHEN** 解析角色名称
- **THEN** 输出错误信息 + 可用角色列表

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-role/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-role`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 169 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 169 行减少至 ≤70 行（减少 59%）

### Requirement: Include 降级策略
sdd-role SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-role/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-role SKILL.md 仍可独立运行（使用内联内容）

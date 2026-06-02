## MODIFIED Requirements

### Requirement: sdd-quick 技能定义
sdd-quick SKILL.md SHALL 引用共享模块并保留差异内容。

#### Scenario: Include 共享模块
- **GIVEN** `skills/sdd-quick/SKILL.md` 已完成改造
- **WHEN** 加载该 SKILL.md
- **THEN** 包含以下 include 引用：
  - `<!-- include: ../_shared/base-triggers.md -->`
  - `<!-- include: ../_shared/output-constraints.md -->`

#### Scenario: 保留差异内容
- **GIVEN** `skills/sdd-quick/SKILL.md` 已完成共享模块引用改造
- **WHEN** 读取改造后的 SKILL.md
- **THEN** 保留以下差异内容：
  - 触发词：`/sdd-quick`、"快速模式"、"简单需求"、"小修复"、"一站完成"
  - 不触发条件：复杂需求涉及架构或跨模块重构（→ `/sdd-propose`）；要深度探索（→ `/sdd-brainstorm`）
  - 默认角色：无（快速模式）
  - 可选角色：无
  - 前置校验：无前置依赖，校验直接通过
  - 核心执行：
    - 交互收集（invoke 内联 `/grill-me` 追问技巧，提问上限 limits.quick-questions，默认 5）
    - 文档生成（invoke `openspec-continue-change`，生成 proposal.md、specs/、tasks.md）
    - TDD 编码（invoke `superpowers:test-driven-development`，使用紧凑 TDD 循环）
  - 后置逻辑：
    - 产物校验（proposal.md、specs/、tasks.md 已生成，代码实现和测试已完成）
    - 轻量级决策追溯（如果 brainstorm.md 存在）
    - 格式校验（proposal 意图明确、spec 有 GIVEN/WHEN/THEN、tasks 有 spec 链接）
    - 完成引导

#### Scenario: 前置自检：复杂度评估
- **GIVEN** 用户输入了需求描述
- **WHEN** 执行 sdd-quick
- **THEN** 评估需求复杂度，检测疑似复杂信号（新领域建模、跨模块重构、外部 API 变更、需要设计决策）

#### Scenario: Limits 配置读取
- **GIVEN** `openspec/config.yaml` 存在且包含 `limits` 节
- **WHEN** 执行 sdd-quick
- **THEN** 读取 `openspec/config.yaml` 的 `limits` 节：
  - `quick-questions`（默认 5）：需求收集提问上限
  - `quick-scenarios`（默认 5）：场景数量上限
  - `quick-tasks`（默认 10）：任务数量上限

#### Scenario: 达限处理
- **GIVEN** 提问/场景/任务数量已达到配置上限
- **WHEN** 继续生成超出上限
- **THEN** 停止生成并提示用户，可选择继续追问（无上限）或切换到标准路径

#### Scenario: Frontmatter 不变
- **GIVEN** `skills/sdd-quick/SKILL.md` 已完成改造
- **WHEN** 检查 SKILL.md 的 frontmatter
- **THEN** `name` 字段为 `sdd-quick`，`description` 字段保持不变

#### Scenario: Token 减少
- **GIVEN** 改造前 SKILL.md 为 213 行
- **WHEN** 对比改造前后的行数
- **THEN** 从 213 行减少至 ≤90 行（减少 58%）

### Requirement: Include 降级策略
sdd-quick SHALL 在共享模块 include 失败时降级运行。

#### Scenario: Include 失败降级
- **GIVEN** `skills/sdd-quick/SKILL.md` 包含 `<!-- include -->` 引用
- **WHEN** `<!-- include: path -->` 指向的共享模块文件不存在或路径错误
- **THEN** AI 输出警告但不阻断执行，sdd-quick SKILL.md 仍可独立运行（使用内联内容）

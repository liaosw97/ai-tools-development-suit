# Proposal: quick-limit-fallback

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

为 SDD 工作流中所有存在硬编码上限的 action 增加达限兜底选择机制和可配置上限值，确保用户在达到上限时获得明确选项而非静默跳过。

## 范围

### 包含
- 在 `openspec/config.yaml` 中新增 `limits` 配置节（4 个配置项：quick-questions、quick-scenarios、quick-tasks、review-rounds）
- 修改 `sdd-quick` SKILL.md：需求收集达限 → 给用户选择（继续追问/切换标准路径）；场景/任务达限 → 停止并提示可配置
- 修改 `sdd-brainstorm` SKILL.md：review 循环达限 → 给用户选择（继续修复/接受并继续）
- 修改 `sdd-plan` SKILL.md：review 循环达限 → 给用户选择（继续修复/接受并继续）
- 修改 `sdd-doctor` SKILL.md：诊断报告新增"限制配置"节，输出当前 limits 值
- 修改 `guidelines/quality-checkpoints.md`：全局约定从"最多 3 轮"改为"默认最多 N 轮（可配置）"
- 更新测试用例 `review-loops.test.ts` 适配新行为

### 不包含
- 不修改 `superpowers:brainstorming` 底层 skill（SDD 仅通过 override 指令控制行为）
- 不修改 `openspec-continue-change` 或 `openspec-propose` 等 OpenSpec 底层 skill
- 不为 config.yaml 增加 schema 校验（纯 Markdown 指令，依赖 AI 读取）
- 不涉及 sdd-review-code 和 sdd-review-spec（当前无硬编码上限，不在本次变更范围内）
- 不涉及其他 SDD action（当前无硬编码上限）

## 决策追溯

- 选择 [区分场景给选项] 而非 [统一两个选项]：提问场景和 review 场景用户意图不同，选项应匹配上下文（见 brainstorm.md §决策 1）
- 选择 [config.yaml 新增 limits 节] 而非 [新建独立 limits.yaml]：现有项目配置文件用户熟悉，与 openspec 生态一致（见 brainstorm.md §决策 2）
- 选择 [默认值回退] 而非 [强制配置]：向后兼容，现有项目不配置即保持当前行为（见 brainstorm.md §决策 3）
- 选择 [所有 action 统一应用] 而非 [仅 sdd-quick]：一致性，用户无需记忆哪个 action 有兜底（见 brainstorm.md §决策 4）
- 选择 [sdd-doctor + 达限提示双触点] 而非 [仅 config.yaml 注释]：doctor 是入口诊断用户必看，达限时是用户最需要知道可配置的时刻（见 brainstorm.md §决策 5）

## 影响分析

### 影响的模块
- `ai-tools-bridge/skills/sdd-quick/SKILL.md` — 需求收集达限分支 + 场景/任务达限提示 + 读取 limits 配置
- `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` — review 循环达限分支 + 读取 limits 配置
- `ai-tools-bridge/skills/sdd-plan/SKILL.md` — review 循环达限分支 + 读取 limits 配置
- `ai-tools-bridge/skills/sdd-doctor/SKILL.md` — 新增限制配置诊断节
- `ai-tools-bridge/guidelines/quality-checkpoints.md` — 全局约定更新
- `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` — 测试适配
- `openspec/config.yaml` — 新增 limits 节（可选，不配即用默认值）

### 风险评估
- **低风险**：所有改动限于 Markdown 文本（SKILL.md）和测试文件，无运行时代码
- **向后兼容**：不配 limits 即等同当前行为，不破坏现有项目
- **测试回归**：review-loops.test.ts 需更新断言，但改动是文本匹配，不涉及逻辑变更

## 成功标准

- [ ] sdd-quick 达到提问上限时，用户可选择"继续追问"或"切换标准路径"
- [ ] sdd-quick 达到场景/任务上限时，停止生成并提示可在 config.yaml 调整
- [ ] sdd-brainstorm/sdd-plan review 达到上限时，用户可选择"继续修复"或"接受并继续"
- [ ] openspec/config.yaml 配置 limits 节后，action 读取配置值而非默认值
- [ ] openspec/config.yaml 未配置 limits 时，所有行为等同当前硬编码值
- [ ] sdd-doctor 诊断报告输出当前 limits 配置（含默认值）
- [ ] 达限提示消息包含"可在 config.yaml 调整"的可发现性提示
- [ ] 测试用例全部通过

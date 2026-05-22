# Tasks: quick-limit-fallback

> 任务清单 — 将 spec 拆解为可执行的任务

---

## 任务

### 配置机制

- [x] 1.1 修改 sdd-quick SKILL.md：前置逻辑中增加读取 openspec/config.yaml limits 节的指令，未配置时使用默认值 [spec:limits-config#读取已配置的 limits 值]
- [x] 1.2 修改 sdd-brainstorm SKILL.md：后置 review 逻辑中增加读取 limits.review-rounds 配置的指令 [spec:limits-config#读取已配置的 limits 值]
- [x] 1.3 修改 sdd-plan SKILL.md：后置 review 逻辑中增加读取 limits.review-rounds 配置的指令 [spec:limits-config#读取已配置的 limits 值]
- [x] 1.4 修改 sdd-doctor SKILL.md：前置逻辑中增加读取 limits 配置的指令 [spec:limits-config#sdd-doctor 读取 limits 配置值]
- [x] 1.5 修改 sdd-doctor SKILL.md：诊断步骤中新增"限制配置"节，输出每个配置项的当前值，未配置标注"(默认值)" [spec:limits-config#sdd-doctor 输出 limits 配置状态]

### sdd-quick 达限兜底

- [x] 2.1 修改 sdd-quick SKILL.md：需求收集提问达限时，输出已达上限提示并列出已澄清/未澄清要点，提供选项"继续追问"或"切换标准路径" [spec:quick-limit-fallback#需求收集提问达限 — 用户选择继续追问]
- [x] 2.2 修改 sdd-quick SKILL.md：用户选择"继续追问"后，取消提问次数限制继续苏格拉底式提问 [spec:quick-limit-fallback#需求收集提问达限 — 用户选择继续追问]
- [x] 2.3 修改 sdd-quick SKILL.md：用户选择"切换标准路径"后，保留已生成制品，推荐 /sdd-propose 继续 [spec:quick-limit-fallback#需求收集提问达限 — 用户选择切换标准路径]
- [x] 2.4 修改 sdd-quick SKILL.md：场景数量达限时停止生成，输出超限提示，建议通过 /sdd-propose 或 /sdd-ff 继续 [spec:quick-limit-fallback#场景数量达到上限]
- [x] 2.5 修改 sdd-quick SKILL.md：任务数量达限时停止生成，输出超限提示，建议通过 /sdd-propose 或 /sdd-ff 继续 [spec:quick-limit-fallback#任务数量达到上限]

### Review 循环达限兜底

- [x] 3.1 修改 sdd-brainstorm SKILL.md：review 循环达限时，输出已达上限提示并列出剩余 issues，提供选项"继续修复"或"接受并继续" [spec:review-limit-fallback#brainstorm review 达限 — 用户选择继续修复]
- [x] 3.2 修改 sdd-brainstorm SKILL.md：用户选择"继续修复"后，取消轮次限制继续 review [spec:review-limit-fallback#brainstorm review 达限 — 用户选择继续修复]
- [x] 3.3 修改 sdd-brainstorm SKILL.md：用户选择"接受并继续"后，终止 review 并在文件中标注"用户接受" [spec:review-limit-fallback#brainstorm review 达限 — 用户选择接受并继续]
- [x] 3.4 修改 sdd-plan SKILL.md：review 循环达限时，输出已达上限提示并列出剩余 issues，提供选项"继续修复"或"接受并继续" [spec:review-limit-fallback#plan review 达限 — 用户选择继续修复]
- [x] 3.5 修改 sdd-plan SKILL.md：用户选择"继续修复"后，取消轮次限制继续 review [spec:review-limit-fallback#plan review 达限 — 用户选择继续修复]
- [x] 3.6 修改 sdd-plan SKILL.md：用户选择"接受并继续"后，终止 review 并在文件中标注"用户接受" [spec:review-limit-fallback#plan review 达限 — 用户选择接受并继续]

### 可发现性提示

- [x] 4.1 所有达限提示消息末尾统一附加"可在 openspec/config.yaml 的 limits 节中调整上限" [spec:limits-config#达限提示包含可发现性信息]

### 全局约定与测试

- [x] 5.1 修改 guidelines/quality-checkpoints.md：将"最多 3 轮"改为"默认最多 N 轮（可在 config.yaml limits 节配置）" [spec:limits-config#读取未配置的 limits — 默认值回退]
- [x] 5.2 更新 tests/l2-orchestration/review-loops.test.ts：适配可配置 limits 的新行为 [spec:limits-config#读取已配置的 limits 值]

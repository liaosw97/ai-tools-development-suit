# Plan Review — Round 1

**审查对象:** plan.md
**日期:** 2026-05-21

## 总结

plan.md 将 tasks.md 的 18 个任务组织为 3 个批次，批次间设置了 checkpoint，依赖关系清晰（批次 2/3 依赖批次 1 的配置机制）。每个任务遵循 RED/GREEN TDD 循环，测试命令指向已有的 `review-loops.test.ts`，`readSkillBody` 辅助函数已存在。整体质量较高，但存在以下需关注的问题。

## Issues

### [severity: minor] Task 2.2 缺少独立 RED 测试

- **位置:** plan.md §Task 2.2
- **描述:** Task 2.2 的 RED 步骤写为"已包含在 2.1 的测试中，此任务无独立测试"。这本身是合理的（2.2 是 2.1 分支逻辑的延续），但 2.2 的 GREEN 步骤仍然添加了实质性内容（"继续苏格拉底式提问，不再计数"）。如果 2.1 的测试仅检查 `继续追问` 和 `标准路径` 关键词存在，则 2.2 添加的"不再计数"行为没有被任何测试覆盖。
- **建议:** 在 2.1 的测试中追加检查"不再计数"或"不再限制"等关键词，确保 2.2 的 GREEN 变更可被验证；或接受现状并在备注中说明 2.1+2.2 属于同一逻辑块的连续修改。

### [severity: minor] Task 3.2/3.3/3.5/3.6 缺少独立 RED 测试

- **位置:** plan.md §Task 3.2, 3.3, 3.5, 3.6
- **描述:** 与 Task 2.2 同理，这四个任务各自补充了分支逻辑的后续行为（继续修复、接受并继续），但 RED 步骤均标注为"已包含在 3.1/3.4 测试中"。3.1 的测试检查 `继续修复` + `接受当前状态` 两个关键词，3.3 添加的"用户接受，剩余 issues 未修复"标注行为未被测试覆盖。
- **建议:** 在 3.1/3.4 的测试中追加检查"用户接受"或"剩余 issues"关键词，以覆盖 3.3/3.6 的 GREEN 变更。

### [severity: minor] Task 5.2 与 1.2/1.3 存在潜在冲突

- **位置:** plan.md §Task 5.2
- **描述:** Task 5.2 要"更新原有测试断言，从检查'最多 3 轮'改为检查可配置行为"。但 Task 1.2/1.3 已经新增了检查 `review-rounds` 的测试。5.2 应明确说明是修改现有的第 10-27 行的两个 test case（`sdd-brainstorm post-logic mentions max 3 review rounds` 和 `sdd-plan post-logic mentions max 3 review rounds`），而不是新增重复测试。当前描述中给出的代码示例与 1.2/1.3 新增的测试几乎相同（都检查 `review-rounds` + `默认`），可能导致同一 describe block 内出现重复测试。
- **建议:** Task 5.2 的 RED 步骤应明确标注"修改现有测试用例（第 10-27 行）"，删除示例中的新增测试代码，改为展示对现有断言的修改 diff。

### [severity: minor] Task 5.1 无测试覆盖

- **位置:** plan.md §Task 5.1
- **描述:** 修改 `quality-checkpoints.md` 全局约定，RED 步骤标注"无独立测试（guidelines 为参考文档，非 SKILL.md）"。这是合理的——guidelines 是参考文档。但项目中存在 `tests/l1-structural/guidelines.test.ts`，该文件可能对 guidelines 有结构验证。如果不检查此文件，修改后可能导致该测试失败。
- **建议:** 运行 `cd ai-tools-bridge && pnpm vitest run tests/l1-structural/guidelines.test.ts` 确认不会因修改而失败，或在 Task 5.1 中补充说明已确认该测试不受影响。

### [severity: minor] Task 2.1 选项措辞与 tasks.md 不完全一致

- **位置:** plan.md §Task 2.1
- **描述:** tasks.md 2.1 使用"继续追问"和"切换标准路径"两个选项名。plan.md GREEN 步骤中写的是 `① 继续追问（无上限）` / `② 切换到标准路径`，措辞略有差异（"切换标准路径" vs "切换到标准路径"）。虽然不影响功能，但为保持一致性建议统一。
- **建议:** 确保最终 SKILL.md 中的选项名与 tasks.md 和 spec 保持一致。

## Spec 对齐检查

| Task | Plan 对应 | 状态 |
|------|-----------|------|
| 1.1 修改 sdd-quick — 读取 limits 配置 | Task 1.1 | OK |
| 1.2 修改 sdd-brainstorm — 读取 review-rounds | Task 1.2 | OK |
| 1.3 修改 sdd-plan — 读取 review-rounds | Task 1.3 | OK |
| 1.4 修改 sdd-doctor — 诊断节 | Task 1.4 | OK |
| 2.1 sdd-quick 需求收集提问达限 | Task 2.1 | OK |
| 2.2 继续追问 — 取消限制 | Task 2.2 | OK |
| 2.3 切换标准路径 | Task 2.3 | OK |
| 2.4 场景数量达限 | Task 2.4 | OK |
| 2.5 任务数量达限 | Task 2.5 | OK |
| 3.1 brainstorm review 达限 | Task 3.1 | OK |
| 3.2 brainstorm 继续修复 | Task 3.2 | OK |
| 3.3 brainstorm 接受并继续 | Task 3.3 | OK |
| 3.4 plan review 达限 | Task 3.4 | OK |
| 3.5 plan 继续修复 | Task 3.5 | OK |
| 3.6 plan 接受并继续 | Task 3.6 | OK |
| 4.1 可发现性提示 | Task 4.1 | OK |
| 5.1 修改 quality-checkpoints.md | Task 5.1 | OK |
| 5.2 更新测试 | Task 5.2 | OK |

**结果:** 18/18 任务全部覆盖，无遗漏。任务分组合理（批次 1: 基础配置，批次 2: quick 达限，批次 3: review 达限 + 收尾）。

## Approved

- [x] 任务粒度 — 每个任务均为修改单个 SKILL.md + 添加测试断言，2-5 分钟内可完成
- [x] TDD 步骤完整性 — 所有主要任务有 RED/GREEN 循环；4 个子任务（2.2, 3.2, 3.3, 3.5, 3.6）无独立测试，但作为父任务的延续可接受（有 minor 级改进空间）
- [x] Spec 对齐 — 18/18 全覆盖
- [x] 运行命令正确性 — `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts` 指向真实存在的测试文件，`readSkillBody` 辅助函数已存在

## 结论

**APPROVED** — 存在 5 个 minor 级问题，均不阻塞实施。建议在执行 Task 5.2 时特别注意与 1.2/1.3 的测试去重，以及在执行 Task 5.1 前确认 guidelines.test.ts 不受影响。

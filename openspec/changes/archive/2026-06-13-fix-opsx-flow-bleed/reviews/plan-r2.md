# Plan Review — Round 2

**审查对象:** plan.md
**日期:** 2026-06-12

## 总结

plan.md 整体结构清晰，批次划分合理（模板设计 → 后置逻辑修改 → 文档更新 → 验证），TDD 骨架完整。第一轮提出的 5 个问题中，3 个已解决（Risk 3 一致性验证、手动测试风险标记、共享模板路径明确），2 个仍存在（spec 场景覆盖不完整、RED 步骤定义偏差）。新增发现 1 个问题。

## Issues

### [major] sdd-quick 不完整实现场景未被单独覆盖

- **位置:** plan.md §Task 2.6
- **描述:** spec 定义了两个 sdd-quick 场景：
  1. "User completes sdd-quick with all artifacts generated" — 推荐 `/sdd-ship`
  2. "User completes sdd-quick with incomplete implementation" — 推荐 `/sdd-verify`

  Task 2.6 的 GREEN 步骤提到了"区分完整实现和不完整实现两种场景"，但 RED 步骤只验证"看不到 SDD 流程指引"，没有验证"不完整实现"场景的指引内容是否正确。实际上 GREEN 示例内容只包含"不完整实现"的指引，缺少"完整实现"场景的指引内容。
- **建议:** 将 Task 2.6 拆分为两个子任务，或在 GREEN 步骤中明确列出两种场景的完整指引内容，并在 RED 步骤中分别验证两种场景的指引缺失。

### [major] RED 步骤定义不符合 TDD 规范 — 验证的是"不存在"而非"功能失败"

- **位置:** plan.md §Task 1.1, 1.2, 2.1-2.7, 3.1-3.2
- **描述:** 当前 RED 步骤使用 `grep ... || echo "NOT FOUND"` 验证"文件/内容不存在"，这是静态检查而非功能失败验证。TDD 的 RED 步骤应该验证"功能不可用"或"行为不符合预期"。

  例如 Task 2.1 的 RED 步骤验证"SKILL.md 中没有 SDD 流程指引"，但正确的 RED 应该是"执行 /sdd-propose 后，输出中没有 SDD 流程指引"。
- **建议:** 将 RED 步骤改为验证功能失败。对于 Task 2.x，RED 步骤应为"模拟执行 /sdd-xxx，验证输出中不包含 SDD 流程指引"。对于 Task 1.x，RED 步骤可保留为静态检查（因为是模板设计阶段）。

### [minor] Task 4.1 RED 步骤逻辑错误

- **位置:** plan.md §Task 4.1
- **描述:** Task 4.1 的 RED 步骤是"验证测试套件存在且通过"，GREEN 步骤是"运行测试确保修改不破坏现有功能"。这两个步骤做的事情完全相同（都是 `pnpm test`），没有体现 RED/GREEN 的区别。
- **建议:** Task 4.1 是回归测试任务，不适用于 TDD 的 RED/GREEN 模式。建议改为单一的验证步骤："运行 `pnpm test`，确认所有测试通过"，并移除 RED/GREEN 标签。

### [minor] design.md 缺少共享模板文件路径定义

- **位置:** design.md
- **描述:** plan.md Task 1.1 明确了共享模板文件路径为 `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`，但 design.md 中没有定义此路径。Risk 3 的缓解措施提到"创建共享模板或参考示例"，但没有指定具体路径。
- **建议:** 在 design.md 的 Decision 部分或 Migration Plan 中添加共享模板文件路径定义，与 plan.md 保持一致。

## Approved

- [x] 任务粒度 — Task 粒度合理，2-5 分钟可完成
- [ ] TDD 步骤完整性 — RED 步骤定义偏差（见 Issue #2）
- [ ] Spec 对齐 — sdd-quick 不完整实现场景未单独覆盖（见 Issue #1）
- [x] 依赖顺序 — 批次间依赖正确（模板 → 修改 → 文档 → 验证）
- [x] 风险识别 — 手动测试已标记高风险，Risk 3 已添加一致性验证任务

## 结论

**NEEDS_REVISION**

plan.md 需要修订以下内容后方可通过：
1. 修复 sdd-quick 场景覆盖（Issue #1）
2. 修正 RED 步骤定义，使其符合 TDD 规范（Issue #2）

其余 Issue 为 minor 级别，可在后续迭代中修复。

# Plan Review — Round 1

**审查对象:** plan.md
**日期:** 2026-06-12

## 总结

plan.md 整体结构清晰，采用四批次顺序执行（模板设计 → 后置逻辑修改 → 文档更新 → 验证），任务粒度基本合理（2-5 分钟），TDD 步骤完整。但存在三个主要问题：(1) 三个 spec 场景未被 plan 覆盖；(2) 多个 RED 步骤不符合 TDD 规范（仅检查文件/内容是否存在，而非验证功能失败）；(3) Task 4.2 手动测试缺乏自动化验证手段且未标记为高风险。

## Issues

### [major] 三个 spec 场景未被 plan 覆盖

- **位置:** plan.md 整体
- **描述:** spec.md 中定义了以下三个场景，但 plan.md 中没有对应的任务：
  1. **"User completes sdd-quick with incomplete implementation"** (spec 第 103-108 行) — 当 sdd-quick 代码实现不完整时，应提示用户先验证实现再执行 /sdd-ship
  2. **"OPSX command fails during sdd-propose"** (spec 第 144-150 行) — 当 OPSX 命令失败时，SDD 后置逻辑仍应显示流程指引并建议用户检查环境后重试
  3. **"User accidentally executed OPSX command directly"** (spec 第 152-157 行) — 用户误执行 OPSX 命令后的恢复路径
- **建议:** 在 plan.md 中为这三个场景添加对应的任务。场景 1 可合并到 Task 2.6（sdd-quick 修改）中，作为条件分支处理。场景 2 需要在每个 Task 2.x 中添加错误路径的流程指引。场景 3 属于文档说明，可合并到 Task 3.1 或 Task 3.2 中。

### [major] 多个 RED 步骤不符合 TDD 规范

- **位置:** plan.md Task 1.1、Task 1.2、Task 2.1-2.6、Task 3.1-3.2、Task 4.1
- **描述:** 当前 RED 步骤使用 `ls` 或 `grep` 检查文件/内容是否存在，这不是真正的 TDD RED 步骤。TDD 的 RED 步骤应该是"写一个会失败的测试"，而非"验证某个东西不存在"。例如：
  - Task 1.1 的 RED 是 `ls ... || echo "NOT EXISTS"` — 这只是检查文件是否存在，不是测试失败
  - Task 2.1-2.6 的 RED 是 `grep "SDD 流程指引" ... || echo "NOT FOUND"` — 这只是检查内容是否存在
- **建议:** 重新定义 RED 步骤为：
  - 对于 Task 1.1/1.2：创建一个测试脚本，验证模板文件的内容格式是否符合预期（当前不存在，所以测试失败）
  - 对于 Task 2.1-2.6：创建一个测试脚本，验证 SKILL.md 中是否包含符合格式要求的 SDD 流程指引（当前不存在，所以测试失败）
  - 对于 Task 3.1-3.2：类似地，创建测试脚本验证文档内容

### [minor] Task 4.2 手动测试缺乏自动化验证

- **位置:** plan.md Task 4.2
- **描述:** Task 4.2 是手动测试 `/sdd-propose` 流程，没有具体的自动化验证命令。手动测试依赖人工执行和判断，无法在 CI/CD 中自动运行，且执行结果不可复现。
- **建议:** 
  - 将 Task 4.2 标记为 **[高风险]**，因为无法自动化验证
  - 考虑是否可以将手动测试转化为自动化测试（例如，通过脚本模拟 `/sdd-propose` 执行并检查输出）
  - 如果必须手动测试，添加详细的测试步骤和预期结果检查清单

### [minor] design.md 中的 Risk 3 未在 plan 中体现

- **位置:** plan.md 整体
- **描述:** design.md 中提到的 Risk 3（维护 12 个 SKILL.md 的一致性）在 plan.md 中没有标记。Task 2.1-2.6 是重复性修改，容易出现格式不一致。
- **建议:** 在 plan.md 中添加说明，建议在完成 Task 2.1-2.6 后运行一致性检查脚本（例如，检查所有 6 个 SKILL.md 中的 SDD 流程指引格式是否一致）。

### [minor] Task 1.1 创建的共享模板文件路径未在 design.md 中定义

- **位置:** plan.md Task 1.1
- **描述:** Task 1.1 提出创建 `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` 共享模板文件，但 design.md 中没有提到这个文件。design.md 的 Decision 3 提到"为每个 SDD action 定制下一步建议"，但没有说明是否使用共享模板。
- **建议:** 确认是否需要共享模板文件。如果需要，在 design.md 中补充说明；如果不需要，在 plan.md 中移除 Task 1.1 和 Task 1.2，直接在 Task 2.1-2.6 中各自定义流程指引内容。

## Approved

- [ ] 任务粒度 — 基本合理，但 Task 4.2 手动测试缺乏自动化验证
- [ ] TDD 步骤完整性 — RED 步骤不符合 TDD 规范（详见 Issue #2）
- [ ] Spec 对齐 — 三个 spec 场景未被覆盖（详见 Issue #1）
- [x] 依赖顺序 — 批次顺序合理，Task 1.1 → 1.2 → 2.x → 3.x → 4.x 依赖链清晰
- [ ] 风险识别 — design.md 中的 Risk 3 未在 plan 中体现，Task 4.2 未标记为高风险

## 结论

**NEEDS_REVISION**

plan.md 需要修订以下内容后重新提交审查：
1. 补充三个缺失的 spec 场景覆盖（sdd-quick 不完整实现、OPSX 命令失败、误执行 OPSX 恢复）
2. 重新定义 RED 步骤为真正的 TDD 测试失败场景
3. 标记 Task 4.2 为高风险或转化为自动化测试
4. 确认共享模板文件的设计决策并在 design.md 中补充说明

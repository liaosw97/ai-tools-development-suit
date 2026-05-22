# Spec Review — Round 1

**审查对象:** specs/ 目录下所有 spec 文件
- specs/limits-config/spec.md
- specs/quick-limit-fallback/spec.md
- specs/review-limit-fallback/spec.md
**日期:** 2026-05-20

## 总结

三个 spec 文件整体质量较高。场景均使用标准的 GIVEN/WHEN/THEN 格式，涵盖了正常路径、用户选择分支和关键边界条件。与 proposal 和 brainstorm 的决策方向完全一致，Delta 标记（ADDED/MODIFIED）使用正确。配置默认值在 limits-config 和各消费 spec 之间保持统一。可测试性方面，WHEN/THEN 中的行为描述足够具体，可转化为断言。发现 2 个 major 问题和 2 个 minor 问题需要修订。

## Issues

### [severity: major] limits-config 缺少非法配置值的显式测试场景

- **位置:** specs/limits-config/spec.md -- 边界条件
- **描述:** 边界条件中提到"非数字"和"0 或负数"两种非法输入，但这些仅写在边界条件段落，没有以 GIVEN/WHEN/THEN 场景形式呈现。其他两个 spec 的场景格式能直接转化为测试用例，而 limits-config 的边界情况缺少可执行的场景描述，测试覆盖率存在缺口。
- **建议:** 将"limits 节存在但值为非数字"和"值为 0 或负数"分别补充为完整的 GIVEN/WHEN/THEN 场景，或在现有"读取未配置的 limits"场景中明确 WHEN 包含这些非法值情况，THEN 中明确哪些值会被视为"未配置"并回退到默认值。

### [severity: major] review-limit-fallback brainstorm 和 plan 场景完全重复

- **位置:** specs/review-limit-fallback/spec.md -- "brainstorm review 达限" 与 "plan review 达限" 全部四个场景
- **描述:** brainstorm review 达限的两个场景（继续修复 / 接受并继续）与 plan review 达限的两个场景在结构、选项文案、THEN 断言上完全相同，仅在 GIVEN 中的 action 名称和配置项引用不同。proposal 的范围中明确将 sdd-brainstorm 和 sdd-plan 列为两个独立影响模块，但 spec 未体现两个 action 之间是否存在任何行为差异。如果行为完全一致，应明确声明"plan review 行为与 brainstorm review 完全一致，参考上述场景"以消除歧义；如果存在差异（如后置逻辑不同），则应在 THEN 中区分。
- **建议:** 方案 A：在 spec 能力描述中明确声明"两个 action 的达限行为完全一致"，将 plan review 的两个场景标记为"同 brainstorm review，仅 action 名称不同"，避免读者对比两个完全相同场景时产生"是否遗漏差异"的疑问。方案 B：如果后置逻辑产物不同（brainstorm 进入产物校验 vs plan 进入执行引导），在 THEN 的"进入后置逻辑"步骤中分别描述各自的后置产物。

### [severity: minor] limits-config 场景"读取已配置的 limits 值"中 WHEN 提到的 action 列表不完整

- **位置:** specs/limits-config/spec.md -- "读取已配置的 limits 值"
- **描述:** WHEN 中仅提到"sdd-quick、sdd-brainstorm、sdd-plan"三个 action，但未包含 sdd-doctor。虽然 sdd-doctor 不"消费"limits 值来控制行为，但它"读取"limits 值用于诊断输出，可归为"读取配置"的范畴。另外，proposal 的范围中明确包含 sdd-doctor 读取 limits。这一不一致可能让实现者疑惑 sdd-doctor 是否需要读取 limits 配置。
- **建议:** 在 WHEN 中补充说明 sdd-doctor 也会读取 limits 配置用于诊断输出，或者将 WHEN 改为更通用的描述如"任何需要 limits 值的 SDD action 或诊断工具执行时"。

### [severity: minor] quick-limit-fallback 缺少"所有 issues 已解决但仍在提问"的场景

- **位置:** specs/quick-limit-fallback/spec.md -- 场景覆盖
- **描述:** brainstorm 和 plan review 有一个边界条件"review 第 1 轮即通过（无 issues）：不触发达限逻辑，正常完成"，但 quick-limit-fallback 缺少对应的正面路径：需求收集在未达限前已完成（AI 判断需求已清晰），此时不触发达限逻辑，正常继续。虽然这是一个隐含的正常行为，但显式说明有助于测试完整性。
- **建议:** 在 quick-limit-fallback 的边界条件中补充一条："需求收集阶段在未达提问上限前 AI 判断需求已清晰：不触发达限逻辑，正常进入后续阶段"。

## Approved

- [x] 场景完整性
- [x] 可测试性
- [x] 一致性
- [x] 决策追溯
- [x] 范围控制
- [x] 跨模块一致性（N/A — 单模块变更，仅修改 ai-tools-bridge 内 SKILL.md）

> 注：虽然标记为通过，但两个 major issue 建议在实施前修订，以提高 spec 的精确性和可维护性。

## 结论

**NEEDS_REVISION** — 存在 2 个 major issue 需要修订：(1) limits-config 的非法配置值边界缺少完整场景描述；(2) review-limit-fallback 的 brainstorm/plan 场景完全重复且未声明是否意图一致。2 个 minor issue 建议一并处理。

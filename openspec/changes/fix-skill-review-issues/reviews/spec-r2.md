# Spec Review — Round 2

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-06-15
**角色:** eng-manager

## 总结

spec 文件整体结构清晰，基本覆盖了核心流程。但存在场景完整性不足、可测试性细节缺失、以及跨 spec 引用不明确等问题。交互式修复的 4 个选项中，仅"自动修复"有详细场景，"手动修复"和"标记为已修复"缺少场景描述。此外，proposal 中提到的修复模板内容在 spec 层未被定义。

## Issues

### [major] 手动修复场景缺失
- **位置:** specs/interactive-fix/spec.md §自动修复执行
- **描述:** Requirement 中定义了 4 个选项（自动修复/手动修复/跳过/标记为已修复），但只有"自动修复"有 Scenario 描述。"手动修复"和"标记为已修复"缺少场景定义，导致实现时无法确定预期行为。
- **建议:** 添加以下场景：
  - `Scenario: 用户选择手动修复` — THEN 提供文件位置和行号，暂停等待用户编辑，用户确认后继续下一个问题
  - `Scenario: 用户选择标记为已修复` — THEN 记录该问题已标记，继续下一个问题
  - `Scenario: 用户选择跳过` — THEN 继续下一个问题

### [major] 所有问题处理完成后的场景缺失
- **位置:** specs/interactive-fix/spec.md §逐个问题交互
- **描述:** 没有定义所有问题处理完成后的预期行为。用户处理完最后一个问题后，系统应该输出什么、推荐什么下一步？
- **建议:** 添加 `Scenario: 所有问题处理完成` — THEN 输出修复汇总（已修复 N 个、跳过 M 个、标记 K 个）AND 输出完成引导

### [major] 跨 spec 引用不明确
- **位置:** specs/sdd-review-code/spec.md §Phase 3 触发条件、specs/sdd-review-spec/spec.md §交互式修复触发条件
- **描述:** 两个 review spec 都声明"执行交互式修复"，但未引用 `specs/interactive-fix/spec.md` 中定义的具体行为。实现者无法确认 Phase 3 的具体流程是否遵循 interactive-fix spec。
- **建议:** 在 THEN 中添加引用，如 `THEN 按 specs/interactive-fix 中定义的流程执行交互式修复`

### [minor] 模板名称不具体
- **位置:** specs/interactive-fix/spec.md §流程指引格式不一致
- **描述:** `THEN 对照模板更新 SKILL.md` 中的"模板"未指定是哪个文件。proposal 中提到 `skills/_shared/sdd-flow-guidance.md`，但 spec 中未体现。
- **建议:** 改为 `THEN 对照 skills/_shared/sdd-flow-guidance.md 中对应 action 的模板更新 SKILL.md`

### [minor] Phase 1.5 条件执行规则未定义
- **位置:** specs/sdd-review-code/spec.md §完整审查流程
- **描述:** Phase 1.5 标注为"条件执行"，但未定义触发条件。什么时候执行 Phase 1.5，什么时候跳过？
- **建议:** 添加 Phase 1.5 的触发/跳过场景，或改为"总是执行"（如果不需要条件）

### [minor] 缺少 GIVEN 上下文
- **位置:** specs/interactive-fix/spec.md 全部场景
- **描述:** 所有场景使用 WHEN/THEN 格式，但缺少 GIVEN 前置条件。例如：GIVEN 用户正在执行审查命令 AND 审查已完成。
- **建议:** 为关键场景添加 GIVEN 条件，明确前置状态

## Approved

- [ ] 场景完整性 — 手动修复/标记已修复场景缺失，完成后场景缺失
- [x] 可测试性 — WHEN/THEN 格式基本可测试（修复后）
- [x] 一致性 — spec 间无矛盾，与 proposal 范围一致
- [x] 决策追溯 — proposal 正确引用 brainstorm 决策，否决方案未出现
- [x] 范围控制 — 无隐含功能扩展，scope 可控
- [ ] 跨模块一致性 — review spec 未明确引用 interactive-fix spec

## 规范扫描

**扫描状态:** SKIPPED — 变更涉及 skill 开发，但 skill-check 作用于 SKILL.md 文件，不适用于 spec 文件扫描。

## 结论

**NEEDS_REVISION** — 需要补充手动修复/标记已修复场景、完成后汇总场景，并明确跨 spec 引用关系。

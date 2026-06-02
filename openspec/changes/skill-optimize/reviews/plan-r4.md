# Plan Review — Round 4

**审查对象:** plan.md
**日期:** 2026-06-02
**前轮:** Round 3 (APPROVED)

## Round 3 建议项修复状态

### [minor] Task 5.2-6.2 的 RED/GREEN 标签不一致
- **状态:** 已修复
- **说明:** Task 5.2-6.2 已改为"执行步骤/验证"标签，不再使用 RED/GREEN 标签，与这些验证/文档任务的性质一致。

### [minor] 缺少测试文件结构说明
- **状态:** 已修复
- **说明:** 文档开头新增"测试文件说明"部分，明确说明所有测试集中在 `ai-tools-bridge/tests/shared-modules.test.ts`，使用 `describe` 块按模块组织，每个任务的测试追加到同一文件。

## 总结

plan.md 整体质量良好，经过三轮审查后结构完整、粒度合理。14 个 SKILL.md 改造任务的 include 引用规则与 shared-skill-modules/spec.md 的引用规则完全对齐。依赖顺序清晰（批次一 → 批次二-四并行 → 批次五），TDD 步骤完整（批次一-四均有 RED/GREEN），验证步骤（批次五）结构合理。R3 的两项建议均已修复。本轮发现 3 个 minor 级别问题，不影响计划可执行性。

## Issues

### [minor] 缺少共享模块内容验证测试
- **位置:** plan.md §Task 1.2-1.6
- **描述:** 批次一的每个任务只验证共享模块文件存在且包含关键词（如 `toContain('**触发**')`），但未验证共享模块内容的完整性。例如，spec 要求 `role-loading.md` 包含"参数解析流程"、"角色优先级规则"、"角色查找流程"、"降级策略"、"格式错误处理"五个部分，但测试只验证 `toContain('--role')`、`toContain('优先级')`、`toContain('降级')`，无法确保五个部分都完整提取。
- **建议:** 在 Task 1.4 的 RED 步骤中增加更精细的断言，验证每个必需部分的存在：
  ```typescript
  expect(content).toContain('参数解析');
  expect(content).toContain('角色查找');
  expect(content).toContain('格式错误');
  ```
  同样适用于 Task 1.2（base-triggers.md）、Task 1.5（breakdown-mode.md）、Task 1.6（review-loop.md）。

### [minor] 缺少共享模块引用完整性测试
- **位置:** plan.md §批次五
- **描述:** spec 的"引用完整性验证"场景要求"每个共享模块文件至少被一个 SKILL.md 引用（无孤立模块）"。Task 5.4 验证 include 路径有效性（目标文件存在），但不验证反向引用（共享模块是否被至少一个 SKILL 引用）。如果某个共享模块创建后没有被任何 SKILL.md 引用，Task 5.4 不会检测到。
- **建议:** 在 Task 5.4 中增加反向引用验证，或新增一个验证步骤：
  ```bash
  for shared in ai-tools-bridge/skills/_shared/*.md; do
    name=$(basename "$shared")
    count=$(grep -rl "include:.*$name" ai-tools-bridge/skills/*/SKILL.md | wc -l)
    if [ "$count" -eq 0 ]; then echo "ORPHAN: $shared"; fi
  done
  ```

### [minor] 缺少"差异覆盖"机制的测试
- **位置:** plan.md §批次二-四
- **描述:** spec 的"覆盖机制"要求"SKILL.md 在 `<!-- include -->` 之后写入差异内容覆盖共享模块默认值"。当前测试验证 include 引用存在和差异内容保留，但未验证差异内容的位置（必须在 include 引用之后）。如果差异内容出现在 include 引用之前，覆盖机制可能不生效。
- **建议:** 可选优化，在批次二-四的测试中增加位置验证（使用 `indexOf` 比较 include 引用和差异内容的位置）。此为可选改进，因为改造后的 SKILL.md 结构本身就应该是 include 在前、差异在后。

## Approved
- [x] 任务粒度
- [x] TDD 步骤完整性
- [x] Spec 对齐
- [x] 依赖顺序
- [x] 风险识别

## 结论
APPROVED

**理由：**
1. R3 的两项建议（RED/GREEN 标签不一致、测试文件结构说明）均已修复
2. 任务粒度合理：批次一 5 个任务（创建共享模块）、批次二-四 14 个任务（改造 SKILL.md）、批次五 7 个任务（验证+文档），每个任务 2-5 分钟可完成
3. TDD 步骤完整：批次一-四 的 19 个任务均有 RED/GREEN 步骤，包含可执行的 vitest 测试代码；批次五的 7 个任务使用"执行步骤/验证"标签
4. Spec 对齐：14 个 SKILL.md 的 include 引用规则与 shared-skill-modules/spec.md 完全一致（base-triggers: 14 个、output-constraints: 14 个、role-loading: 9 个、breakdown-mode: 1 个、review-loop: 2 个）
5. 依赖顺序清晰：批次一无依赖 → 批次二-四依赖批次一且可并行 → 批次五依赖批次二-四
6. 风险标记充分：已标记 include 机制约定性和差异内容保留两个主要风险
7. 本轮发现的 3 个 minor 问题均为测试覆盖增强建议，不影响计划的可执行性

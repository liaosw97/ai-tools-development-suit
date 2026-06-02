# Spec Review — Round 3

**审查对象:** specs/ 目录下所有 spec 文件（15 个）
**日期:** 2026-06-01
**前轮:** Round 2 (NEEDS_REVISION)

## Round 2 Issues 修复状态

### [major] 共享模块引用规则与实际引用不一致
- **状态:** 已修复
- **说明:** shared-skill-modules/spec.md 第 34 行已修正为 `role-loading.md：9 个有角色系统的 SKILL（sdd-brainstorm、sdd-code、sdd-plan、sdd-propose、sdd-review-code、sdd-review-spec、sdd-ship、sdd-test-code、sdd-verify）`，与实际引用完全一致。
- **验证明细:**
  - role-loading.md：规则 9 个，实际引用 9 个（sdd-brainstorm、sdd-code、sdd-plan、sdd-propose、sdd-review-code、sdd-review-spec、sdd-ship、sdd-test-code、sdd-verify），一致
  - breakdown-mode.md：规则 1 个，实际引用 1 个（sdd-brainstorm），一致
  - base-triggers.md：规则 14 个，实际引用 14 个，一致
  - output-constraints.md：规则 14 个，实际引用 14 个，一致
  - review-loop.md：规则 5 个（sdd-brainstorm、sdd-plan、sdd-review-code、sdd-review-spec、sdd-verify），实际引用 2 个（sdd-brainstorm、sdd-plan），不一致（详见新增 issues）

### [major] 内容完整性断言不具体
- **状态:** 已修复（保持）
- **说明:** 5 个共享模块的内容场景仍包含具体的、可验证的断言项，与 Round 2 一致，未发生回退。

### [major] 降级策略覆盖不完整
- **状态:** 已修复（保持）
- **说明:** 所有 14 个 MODIFIED spec 仍保留独立的"Include 降级策略"Requirement，降级场景定义完整，与 Round 2 一致。

### [minor] Token 减少场景简单
- **状态:** 未修复
- **说明:** 各 spec 的 Token 减少场景仍为简单行数对比，未增加降级验证维度。影响低，可在实现阶段补充。

### [minor] 缺乏错误路径描述
- **状态:** 未修复
- **说明:** sdd-code/spec.md 的 Worktree 准备和目录冲突检测场景仍缺乏错误路径描述。影响低，属于保留差异内容中的既有行为。

### [minor] 超出 proposal 范围
- **状态:** 无需修复
- **说明:** 经 Round 2 重新评估，这些场景属于"保留差异内容"范畴，不构成范围扩展。

### [minor] 配置读取降级未明确
- **状态:** 未修复
- **说明:** sdd-quick/spec.md 的 Limits 配置读取场景仍未说明 config.yaml 不存在时的处理。影响低，默认值已列出。

## 新增 Issues

### [major] review-loop.md 引用规则与实际引用不一致
- **位置:** shared-skill-modules/spec.md 第 36 行 + sdd-review-code/spec.md、sdd-review-spec/spec.md、sdd-verify/spec.md
- **描述:** shared-skill-modules/spec.md 定义 review-loop.md 适用于"5 个有 review 循环的 SKILL（sdd-brainstorm、sdd-plan、sdd-review-code、sdd-review-spec、sdd-verify）"，但实际只有 2 个 spec 引用了 review-loop.md：
  - 已引用（2 个）：sdd-brainstorm（第 13 行）、sdd-plan（第 12 行）
  - 未引用（3 个）：sdd-review-code、sdd-review-spec、sdd-verify
- **分析:**
  - sdd-review-code：有 Phase 1/1.5/2 审查流程，但 spec 中未引用 review-loop，审查流程由差异内容自行描述
  - sdd-review-spec：有审查报告输出，但 spec 中未引用 review-loop
  - sdd-verify：有验证报告输出，但 spec 中未引用 review-loop
  - 实际引用 review-loop 的 SKILL 为 2 个（非 5 个）
- **建议:** 修正规则为"review-loop.md：2 个有 review 循环的 SKILL（sdd-brainstorm、sdd-plan）"，或为 sdd-review-code、sdd-review-spec、sdd-verify 补充 review-loop 引用

## Approved
- [x] 场景完整性 — 覆盖正常路径和边界条件，降级策略完整
- [x] 可测试性 — 内容完整性断言具体化，可转化为自动化测试
- [ ] 一致性 — review-loop.md 引用规则与实际引用存在不一致（声明 5 个，实际 2 个）
- [x] 决策追溯 — proposal 与 brainstorm 决策一致
- [x] 范围控制 — 保留场景属于"差异内容"范畴
- [ ] 跨模块一致性 — review-loop.md 引用规则与实际引用不一致

## 结论

**NEEDS_REVISION**

Round 2 的 major 问题中：
- 3 个已修复/保持修复（引用规则修正、内容完整性断言具体化、降级策略覆盖完整）

新发现 1 个 major 问题：
- review-loop.md 引用规则与实际引用不一致（声明 5 个 SKILL 引用，实际 2 个）

4 个 minor 问题未修复（Token 场景简单、错误路径缺失、配置降级未明确），影响较低，可在实现阶段补充。

**需要修订：**
1. 修正 shared-skill-modules/spec.md 的 review-loop.md 引用规则，与实际引用保持一致（将"5 个"改为"2 个"），或为 sdd-review-code、sdd-review-spec、sdd-verify 补充 review-loop 引用

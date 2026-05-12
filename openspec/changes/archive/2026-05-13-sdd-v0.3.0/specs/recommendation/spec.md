# Spec: 统一推荐操作机制

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

在每个 SDD action 完成后，统一输出动态推荐操作列表。推荐分三级：★ 推荐下一步（1 个，最符合当前进度）、○ 可选操作（2-3 个，附前置条件）、△ 跳跃操作（允许但不推荐）。推荐内容根据当前 action 和复杂度评级动态生成。

---

## 场景

### sdd-code 完成后输出 ★○△ 推荐操作 `[ADDED]`

**GIVEN** sdd-code 已完成（代码和测试已生成，测试通过）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-review-code [M/L] 或 /sdd-ship [S]（根据复杂度评级动态选择）、○ /sdd-verify（全面验证 Spec 场景覆盖）、无 △ 跳跃操作

---

### sdd-ff 完成后根据复杂度动态推荐 `[ADDED]`

**GIVEN** sdd-ff 已完成（spec 和 tasks 已生成）
**WHEN** 系统输出完成信息
**THEN** 读取当前 change 的复杂度评级：若为简单(S)推荐 ★ /sdd-code（直接进入编码）、若为中等(M)或复杂(L)推荐 ★ /sdd-plan（先生成实施计划）；○ /sdd-review-spec；△ /sdd-quick（重新走快速路径）

---

### sdd-ship 完成后无后续推荐 `[ADDED]`

**GIVEN** sdd-ship 已完成（变更已归档合并）
**WHEN** 系统输出完成信息
**THEN** 输出"变更已完成，无后续操作"，不输出 ★○△ 推荐列表

---

### sdd-quick 完成后推荐审查或归档 `[ADDED]`

**GIVEN** sdd-quick 已完成（propose → spec → tasks → code 全流程）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-review-code（审查代码质量和 Spec 合规）或 /sdd-ship（快速变更可直接归档）、○ /sdd-verify（全面验证）、无 △ 跳跃操作

---

### 所有 action 推荐格式一致性 `[ADDED]`

**GIVEN** 任意一个 SDD action 完成
**WHEN** 系统输出推荐操作
**THEN** 推荐输出遵循统一格式：
```
★ 推荐下一步: /sdd-xxx — 简要说明
  ○ /sdd-xxx — 简要说明（前置条件：xxx）
  △ /sdd-xxx — 简要说明
```
包含产物路径、推荐操作、"/clear 提示"三个部分，顺序一致

---

### sdd-doctor 完成后输出路径推荐 `[ADDED]`

**GIVEN** sdd-doctor 已完成诊断，包含复杂度评估结果
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ 根据复杂度推荐完整路径（如复杂度简单推荐 /sdd-quick）、○ /sdd-brainstorm 或 /sdd-propose（手动选择起点）、无 △ 跳跃操作

---

### sdd-brainstorm 完成后推荐 `[ADDED]`

**GIVEN** sdd-brainstorm 已完成（brainstorm.md 已生成）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-propose（固化提案）、○ /sdd-ff（跳过 propose 直接生成）、△ /sdd-quick（重新走快速路径）

---

### sdd-propose 完成后推荐 `[ADDED]`

**GIVEN** sdd-propose 已完成（proposal.md 已生成）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-ff（快进生成所有文档）、○ /sdd-plan（需先有 spec+tasks）、△ /sdd-brainstorm（回退补充探索）

---

### sdd-plan 完成后推荐 `[ADDED]`

**GIVEN** sdd-plan 已完成（plan.md 已生成）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-code（开始 TDD 实施）、○ /sdd-review-spec（先审查 spec 质量）

---

### sdd-review-code 完成后推荐 `[ADDED]`

**GIVEN** sdd-review-code 已完成（代码审查报告已生成）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-test-code（TDD 循环补全缺失测试，这是决策 6 的核心体现）、○ /sdd-code（回退修复实现）、△ /sdd-ship（跳过测试补全直接归档）

---

### sdd-test-code 完成后推荐 `[ADDED]`

**GIVEN** sdd-test-code 已完成（缺失测试已补全）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-verify（全面验证 Spec 场景覆盖）、○ /sdd-ship（归档合并）

---

### sdd-verify 完成后推荐 `[ADDED]`

**GIVEN** sdd-verify 已完成（验证报告已生成）
**WHEN** 系统输出完成信息
**THEN** 输出推荐操作：★ /sdd-ship（归档合并）、○ /sdd-code（修复验证失败项）

---

## 边界条件

- **复杂度未评估时**：推荐操作使用中等(M)的默认推荐路径，并标注"复杂度未评估，使用默认推荐"
- **action 未完成（执行失败）时**：不输出推荐操作，输出失败信息和修复建议
- **推荐中的 action 不存在**（如未来版本移除某 action）：跳过该推荐项，不影响其他推荐输出
- **sdd-continue 完成后**：根据当前已生成的 artifact 进度，动态推荐下一个缺失 artifact 的生成方式

# Spec: review-limit-fallback

> Review 循环达限兜底 — brainstorm 和 plan review 循环达限时的用户选择

## 能力描述

修改 sdd-brainstorm 和 sdd-plan 的 review 循环行为：达到上限轮次时不再静默停止，而是给用户提供"继续修复"或"接受并继续"的选项。

> **注意**：brainstorm 和 plan 的 review 达限行为完全一致（相同的选项和流程），因为两者共享同一套 review 循环机制，仅 review 对象不同（brainstorm.md vs plan.md）。本 spec 因此使用统一的行为描述。

---

## 场景

### brainstorm review 达限 — 用户选择继续修复 `ADDED`

**GIVEN**
- sdd-brainstorm 的 review 循环已执行到 `limits.review-rounds` 轮（默认 3）
- 仍有未解决的 issues

**WHEN**
- 达到 review 上限轮次

**THEN**
- 输出已达 review 上限的提示，列出剩余未解决的 issues
- 提供选项：`① 继续修复` / `② 接受当前状态并继续`
- 用户选择"继续修复" → 进入下一轮 review，不再有轮次限制
- 提示消息包含可发现性信息："可在 openspec/config.yaml 的 limits 节中调整上限"

---

### brainstorm review 达限 — 用户选择接受并继续 `ADDED`

**GIVEN**
- sdd-brainstorm 的 review 循环已达到上限轮次
- 仍有未解决的 issues

**WHEN**
- 用户选择"接受当前状态并继续"

**THEN**
- review 循环终止
- 在 review 文件中标注"用户接受，剩余 issues 未修复"
- 进入后置逻辑的产物校验和完成引导

---

### plan review 达限 — 用户选择继续修复 `ADDED`

**GIVEN**
- sdd-plan 的 review 循环已执行到 `limits.review-rounds` 轮（默认 3）
- 仍有未解决的 issues

**WHEN**
- 达到 review 上限轮次

**THEN**
- 输出已达 review 上限的提示，列出剩余未解决的 issues
- 提供选项：`① 继续修复` / `② 接受当前状态并继续`
- 用户选择"继续修复" → 进入下一轮 review，不再有轮次限制
- 提示消息包含可发现性信息："可在 openspec/config.yaml 的 limits 节中调整上限"

---

### plan review 达限 — 用户选择接受并继续 `ADDED`

**GIVEN**
- sdd-plan 的 review 循环已达到上限轮次
- 仍有未解决的 issues

**WHEN**
- 用户选择"接受当前状态并继续"

**THEN**
- review 循环终止
- 在 review 文件中标注"用户接受，剩余 issues 未修复"
- 进入后置逻辑的产物校验和完成引导

---

## 边界条件

- 用户选择"继续修复"后多轮仍有 issues：无上限，直到所有 issues 解决或用户主动选择接受
- review 第 1 轮即通过（无 issues）：不触发达限逻辑，正常完成
- 用户选择"继续修复"后每轮结束时：再次提供"继续修复"或"接受并继续"选项，确保用户可随时退出
- 用户选择"继续修复"后 AI 无法解决某些 issues（技术限制/需求冲突）：用户可通过"接受并继续"选项退出，在 review 文件中标注未解决原因

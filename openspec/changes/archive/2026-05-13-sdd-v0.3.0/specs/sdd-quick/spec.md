# Spec: sdd-quick 快速模式

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

`sdd-quick` 是 SDD 工作流的快速模式 action，用一条命令完成简单需求的 propose → spec → tasks → code 全流程。通过前置自检评估需求复杂度，对低风险、小范围变更进行连续生成。超出快速范围时提示回退到标准路径，已生成的中间产物可复用。

---

## 场景

### 简单需求从零开始走 quick 全流程 `[ADDED]`

**GIVEN**
- 用户通过 `/sdd-quick` 启动快速模式
- 当前 change 目录下不存在 `proposal.md`
- 用户描述了一个低风险、小范围的需求

**WHEN**
- 前置自检评估复杂度为"简单"（S 级）
- 通过内联 `/grill-me` 追问技巧交互收集需求（最多 5 个问题）
- 委托 `openspec-continue-change` 依次生成 proposal → spec（最多 5 个场景）→ tasks（最多 10 个）
- 委托 `superpowers:test-driven-development` 执行 TDD 循环编码

**THEN**
- 生成 `proposal.md`、`specs/`、`tasks.md`
- 按 TDD 循环完成代码实现和测试
- 不生成 `brainstorm.md`、`design.md`、`plan.md`
- 输出 ★○△ 推荐操作

---

### 有已有 proposal 时的 quick 流程 `[ADDED]`

**GIVEN**
- 用户通过 `/sdd-quick` 启动快速模式
- 当前 change 目录下已存在 `proposal.md`

**WHEN**
- 前置自检检测到已有 `proposal.md`
- 跳过交互收集，直接从 proposal 推导
- 委托生成 spec → tasks → code

**THEN**
- 已有 `proposal.md` 被保留复用
- 生成 `specs/` 和 `tasks.md`
- 按 TDD 循环完成编码
- 流程比从零开始更短

---

### 需求超出 quick 范围时的回退提示 `[ADDED]`

**GIVEN**
- 用户通过 `/sdd-quick` 启动快速模式
- 用户描述的需求属于：新领域建模、跨模块重构、涉及外部 API 变更、需要设计决策

**WHEN**
- 前置自检评估复杂度为中等(M)或大型(L)

**THEN**
- 输出提示："该需求可能超出 quick 模式适用范围，建议使用 /sdd-propose 开始标准路径"
- 询问用户是否继续
- 用户选择继续 → 附风险提示按正常流程执行
- 用户选择回退 → 退出 quick，不生成任何文件

---

### 生成过程中超出上限的回退提示 `[ADDED]`

**GIVEN**
- 需求通过了前置自检，已进入文档生成阶段

**WHEN**
- 生成 spec 时场景数量超过 5 个，或生成 tasks 时任务数量超过 10 个

**THEN**
- 立即停止 quick 流程
- 输出超限提示（具体超出场景上限 5 个或任务上限 10 个）
- 告知已生成的中间产物可复用于标准路径
- 建议通过 `/sdd-propose` 或 `/sdd-ff` 继续
- 不删除任何已生成文件

---

### quick 完成后的推荐操作 `[ADDED]`

**GIVEN** `sdd-quick` 已成功完成全流程

**WHEN** 输出完成总结

**THEN**
- ★ /sdd-review-code（审查代码质量和 Spec 合规）或 /sdd-ship（快速变更可直接归档）
- ○ /sdd-verify（全面验证 Spec 场景覆盖）
- 推荐格式与所有 SDD action 后置逻辑一致

---

## 边界条件

- **超限处理**：场景上限 5，任务上限 10。超限时保留中间产物，用户可切换到标准路径
- **质量折中**：quick 省略 brainstorm、design、plan 和 review。后续可由 `/sdd-review-code` + `/sdd-verify` 补充
- **交互收集上限**：苏格拉底式问题最多 5 个，超过后自动进入生成阶段
- **已有 proposal 兼容**：仅提取与 spec/tasks 相关部分，忽略不适用的制品引用
- **委托边界**：spec/tasks 委托 `openspec-continue-change`，code 委托 `superpowers:test-driven-development`
- **不可恢复操作**：quick 不删除任何已有文件，超限回退时保留所有已生成内容

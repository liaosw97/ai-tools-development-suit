# Spec: sdd-test-code TDD 循环补全

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

sdd-test-code 是一个 TDD 循环补全 action，在 sdd-review-code 审查完成后，针对被标记为 PARTIAL 或 MISSING 的场景补充缺失测试，并修复 code-quality 审查中发现的测试质量问题。该 action 严格遵循"只补充/修复测试、不修改实现代码"的 Override 约束，委托 superpowers:test-driven-development skill 执行 RED-GREEN 循环，内联引用 /tdd 的 tests.md 和 mocking.md 作为参考。

---

## 场景

### PARTIAL 场景的 TDD 补全 `[ADDED]`

**GIVEN** `reviews/` 目录下存在最新的 spec-compliance 审查报告，且报告中包含一个或多个标记为 `PARTIAL` 的场景
**WHEN** 用户执行 `/sdd-test-code`
**THEN** 系统逐个读取 PARTIAL 场景的定义，针对每个场景执行 RED-GREEN 循环：先编写失败测试（RED），再补充测试代码使其通过（GREEN），全程不修改实现代码；每个场景独立提交，最终输出补全统计（场景名、补全状态、提交 hash）

---

### MISSING 场景的 TDD 补全 `[ADDED]`

**GIVEN** `reviews/` 目录下存在最新的 spec-compliance 审查报告，且报告中包含一个或多个标记为 `MISSING` 的场景
**WHEN** 用户执行 `/sdd-test-code`
**THEN** 系统逐个读取 MISSING 场景的定义，针对每个场景从零编写完整测试：先编写失败测试（RED），再编写足够使其通过的测试代码（GREEN），全程不修改实现代码；每个场景独立提交，最终输出补全统计

---

### 测试质量 issues 的修复 `[ADDED]`

**GIVEN** `reviews/` 目录下存在最新的 code-quality 审查报告，且报告中包含测试质量相关的 issues
**WHEN** 用户执行 `/sdd-test-code`
**THEN** 系统提取所有测试质量相关 issues，对每个 issue 执行修复：定位对应的测试文件，按照 /tdd 的 tests.md 和 mocking.md 规范修复问题；每个修复独立提交，最终输出修复统计

---

### 无缺失时的空操作提示 `[ADDED]`

**GIVEN** `reviews/` 目录下存在最新的审查报告，且报告中所有场景状态均为 `COVERED`，无 PARTIAL/MISSING 标记，且无测试质量相关 issues
**WHEN** 用户执行 `/sdd-test-code`
**THEN** 系统输出空操作提示，报告所有场景均已覆盖、无测试质量问题，建议跳过当前步骤继续执行后续推荐操作

---

### 独立触发时读取最新 review 报告 `[ADDED]`

**GIVEN** `reviews/` 目录下存在一个或多个审查报告，且用户独立执行 `/sdd-test-code`（非通过推荐链触发）
**WHEN** 系统开始执行
**THEN** 系统自动定位 `reviews/` 下按时间排序的最新 spec-compliance 和 code-quality 审查报告，从中提取 PARTIAL/MISSING 场景和测试质量 issues；若最新报告时间跨度较大，输出警告提示用户确认时效性

---

### 补全完成后的推荐操作 `[ADDED]`

**GIVEN** sdd-test-code 已完成所有补全和修复，且运行全部测试均通过
**WHEN** 系统输出补全统计后
**THEN** 系统输出推荐操作：★ /sdd-verify（全面验证） ○ /sdd-ship（归档合并）

---

## 边界条件

- **无 review 报告**：`reviews/` 目录不存在或为空时，输出错误提示建议先执行 `/sdd-review-code`，终止流程
- **review 报告无 PARTIAL/MISSING 标记且无测试质量 issues**：输出空操作提示
- **测试修复引入新失败**：回滚最后一个场景的测试提交，输出警告，继续处理剩余场景
- **PARTIAL/MISSING 场景对应的 spec 定义无法定位**：跳过该场景，标记为 `SKIPPED`，继续处理其余
- **code-quality 报告不存在**：仅基于 spec-compliance 报告执行补全，输出提示说明跳过了测试质量检查
- **spec-compliance 报告不存在但 code-quality 报告存在**：仅处理测试质量 issues，输出提示说明跳过了场景覆盖补全
- **委托 skill 执行失败**：输出错误详情，标记该场景为 `FAILED`，继续处理下一个

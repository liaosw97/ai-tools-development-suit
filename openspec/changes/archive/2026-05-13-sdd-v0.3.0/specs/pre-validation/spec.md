# Spec: 前置校验机制

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

在每个 SDD action 执行前，自动进行三级前置校验：检查前置制品是否存在且完整、检查上下文清晰度（需求描述非占位符、关键字段已填充）、根据校验结果决定通过/警告/阻断。将用户手动确认上下文状态的习惯内置为系统行为，减少因制品缺失或内容不完整导致的执行失败。

---

## 场景

### 校验通过 — 无前置依赖的 action `[ADDED]`

**GIVEN** 用户触发 `sdd-brainstorm`、`sdd-quick` 或 `sdd-continue`（校验规则映射表中无前置依赖的 action）
**WHEN** 前置校验执行
**THEN** 校验结果为"通过"，action 正常执行，不输出任何警告或阻断信息

---

### 校验通过 — 前置制品完整 `[ADDED]`

**GIVEN** 用户触发 `sdd-ff`，且 `proposal.md` 存在且内容完整（影响分析已填充）
**WHEN** 前置校验执行
**THEN** 校验结果为"通过"，`sdd-ff` 正常执行

---

### 警告级缺失 — 提示缺失项，用户可强制继续 `[ADDED]`

**GIVEN** 用户触发 `sdd-propose`，且 `brainstorm.md` 存在但其中关键决策项留空（或制品包含未替换的 HTML 注释占位符 `<!-- ... -->`）
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出具体缺失项（含占位符检测：识别 `<!-- ... -->` 格式的未替换模板占位符），建议用户补充，并询问是否强制继续；用户确认后 action 可继续执行

---

### 阻断级缺失 — 拒绝执行并输出修复建议 `[ADDED]`

**GIVEN** 用户触发某 action，其必需前置制品不存在
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行该 action，输出具体缺失项和修复建议，action 不执行

---

### sdd-ff 阻断 — proposal 不存在 `[ADDED]`

**GIVEN** 用户触发 `sdd-ff`，且 `proposal.md` 不存在
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行 `sdd-ff`，输出"缺少 proposal.md，请先执行 /sdd-propose 生成 proposal"

---

### sdd-code 警告 — tasks 超过 15 项无 plan `[ADDED]`

**GIVEN** 用户触发 `sdd-code`，且 `tasks.md` 存在但任务数量超过 15 项，且 `plan.md` 不存在
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出"tasks.md 包含 N 项任务但缺少 plan.md，建议先执行 /sdd-plan 生成实施计划"，用户确认后可强制继续

---

### sdd-plan 阻断 — tasks 或 spec 不存在 `[ADDED]`

**GIVEN** 用户触发 `sdd-plan`，且 `tasks.md` 不存在或 `specs/` 目录下无 spec 文件
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行 `sdd-plan`，输出具体缺失项和修复建议

---

### sdd-plan 警告 — tasks 无 spec 链接 `[ADDED]`

**GIVEN** 用户触发 `sdd-plan`，且 `tasks.md` 和 spec 均存在，但 tasks 中部分任务缺少 `[spec:domain#scenario]` 链接
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出缺少 spec 链接的任务列表，建议补充

---

### sdd-review-code 阻断 — 无代码变更或无 spec `[ADDED]`

**GIVEN** 用户触发 `sdd-review-code`，且无代码变更（git 无未提交更改）或 `specs/` 不存在
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行，输出具体缺失项和修复建议

---

### sdd-review-code 警告 — spec 场景数少于 tasks 数 `[ADDED]`

**GIVEN** 用户触发 `sdd-review-code`，且代码变更和 spec 均存在，但 spec 场景总数少于 tasks 数量
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出"spec 场景数（N）少于 tasks 数量（M），可能存在未覆盖的功能点"

---

### sdd-verify 阻断 — spec 或代码不存在 `[ADDED]`

**GIVEN** 用户触发 `sdd-verify`，且 `specs/` 不存在或无代码文件
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行 `sdd-verify`，输出具体缺失项和修复建议

---

### sdd-review-spec 警告 — spec 无 GIVEN/WHEN/THEN 格式 `[ADDED]`

**GIVEN** 用户触发 `sdd-review-spec`，且部分 spec 文件未使用 GIVEN/WHEN/THEN 格式
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出格式不规范的 spec 文件列表，建议修正后再审查

**GIVEN** 用户触发 `sdd-code`，且 `tasks.md` 存在但任务数量超过 15 项，且 `plan.md` 不存在
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出"tasks.md 包含 N 项任务但缺少 plan.md，建议先执行 /sdd-plan 生成实施计划"，用户确认后可强制继续

---

### sdd-test-code 阻断 — review 报告不存在 `[ADDED]`

**GIVEN** 用户触发 `sdd-test-code`，且 `reviews/` 下无审查报告
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行 `sdd-test-code`，输出"缺少代码审查报告，请先执行 /sdd-review-code 生成审查报告"

---

### sdd-ship 阻断 — verify 未执行 `[ADDED]`

**GIVEN** 用户触发 `sdd-ship`，且无验证报告（sdd-verify 未执行）
**WHEN** 前置校验执行
**THEN** 校验结果为"阻断"，拒绝执行 `sdd-ship`，输出"验证未完成，请先执行 /sdd-verify"

---

### sdd-ship 警告 — 有未通过的 review `[ADDED]`

**GIVEN** 用户触发 `sdd-ship`，所有制品存在且 verify 已执行，但存在未通过的审查项
**WHEN** 前置校验执行
**THEN** 校验结果为"警告"，输出未通过的审查项列表，建议修复后再归档，用户确认后可强制继续

---

## 边界条件

- **制品存在但内容为空**：视为等同于不存在，触发阻断级校验失败
- **制品包含未替换的模板占位符**：视为警告级缺失，提示用户填充
- **多个警告同时存在**：汇总所有警告项一次性输出，而非逐个提示
- **警告与阻断同时存在**：以阻断为准，输出所有缺失项，action 不执行
- **用户强制跳过警告后出错**：错误信息中回溯提示"此前跳过的警告项 [X] 可能是错误原因"
- **change 目录不存在**：所有 action 均阻断并提示先创建 change

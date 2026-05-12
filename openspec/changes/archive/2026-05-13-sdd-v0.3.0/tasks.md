# Tasks: sdd-v0.3.0

> 任务清单 — 将 spec 拆解为可执行的任务

---

## 任务

### sdd-quick 新增

- [x] 1.1 创建 `skills/sdd-quick/` 目录结构 [spec:sdd-quick#简单需求从零开始走 quick 全流程]
- [x] 1.2 编写 `skills/sdd-quick/SKILL.md`：YAML 前置元数据 + 前置自检逻辑 + 核心执行（委托 openspec-continue-change + superpowers:test-driven-development）+ 后置推荐 [spec:sdd-quick#简单需求从零开始走 quick 全流程]
- [x] 1.3 实现前置自检逻辑：复杂度评估 + 疑似复杂回退提示 [spec:sdd-quick#需求超出 quick 范围时的回退提示]
- [x] 1.4 实现 proposal 存在时跳过交互收集的逻辑 [spec:sdd-quick#有已有 proposal 时的 quick 流程]
- [x] 1.5 实现场景/任务上限检测与超限回退提示 [spec:sdd-quick#生成过程中超出上限的回退提示]
- [x] 1.6 实现完成后 ★○△ 推荐操作输出 [spec:sdd-quick#quick 完成后的推荐操作]
- [x] 1.7 提取 `/grill-me` 追问技巧到 `reference-grill.md`（含来源标注） [spec:sdd-quick#简单需求从零开始走 quick 全流程]
- [x] 1.8 提取 `/tdd` 核心流程到 `reference-tdd-compact.md`（含来源标注） [spec:sdd-quick#简单需求从零开始走 quick 全流程]

### sdd-test-code 新增

- [x] 2.1 创建 `skills/sdd-test-code/` 目录结构 [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]
- [x] 2.2 编写 `skills/sdd-test-code/SKILL.md`：前置逻辑（读取 review 报告）+ 核心执行（委托 superpowers:test-driven-development + Override：不修改实现代码）+ 后置推荐 [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]
- [x] 2.3 实现读取最新 spec-compliance 审查报告并提取 PARTIAL/MISSING 场景 [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]
- [x] 2.4 实现读取 code-quality 审查报告并提取测试质量 issues [spec:sdd-test-code#测试质量 issues 的修复]
- [x] 2.5 实现 RED-GREEN 循环：每个场景独立提交 [spec:sdd-test-code#MISSING 场景的 TDD 补全]
- [x] 2.6 实现无缺失时的空操作提示 [spec:sdd-test-code#无缺失时的空操作提示]
- [x] 2.7 实现独立触发时定位最新报告 + 时间跨度警告 [spec:sdd-test-code#独立触发时读取最新 review 报告]
- [x] 2.8 实现完成后推荐操作（★ /sdd-verify, ○ /sdd-ship） [spec:sdd-test-code#补全完成后的推荐操作]
- [x] 2.9 提取 `/tdd/tests.md` 到 `reference-tdd-tests.md`（含来源标注） [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]
- [x] 2.10 提取 `/tdd/mocking.md` 到 `reference-tdd-mocking.md`（含来源标注） [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]

### sdd-plan 分批生成

- [x] 3.1 修改 `skills/sdd-plan/SKILL.md` 前置逻辑：增加任务规模检测（≤10/11-25/>25） [spec:sdd-plan#小型任务正常生成完整 plan]
- [x] 3.2 实现中型任务提示：询问用户选择一次性或分批生成 [spec:sdd-plan#中型任务提示用户选择模式]
- [x] 3.3 实现大型任务强建议：拆分 change 或分批生成 [spec:sdd-plan#大型任务强制建议拆分或分批]
- [x] 3.4 实现分批生成逻辑：按依赖关系分组（每批 5-10 任务）+ checkpoint 格式 [spec:sdd-plan#分批模式逐批生成流程]
- [x] 3.5 实现拆分 change 提示：建议回到 /sdd-propose [spec:sdd-plan#用户选择拆分 change 时的提示]
- [x] 3.6 实现分批模式 reviewer：按批次独立审查 + 跨批次一致性检查 [spec:sdd-plan#分批模式下的 reviewer 审查]
- [x] 3.7 增加前置校验（tasks.md + spec 存在性检查） [spec:pre-validation#sdd-ff 阻断 — proposal 不存在]
- [x] 3.8 增加后置推荐操作（★ /sdd-code, ○ /sdd-review-spec） [spec:recommendation#sdd-code 完成后输出 ★○△ 推荐操作]

### sdd-doctor 复杂度评估

- [x] 4.1 修改 `skills/sdd-doctor/SKILL.md`：增加复杂度评估段落（五维度 + S/M/L 评级） [spec:sdd-doctor#有 spec/tasks 时评估复杂度评级]
- [x] 4.2 实现纯环境诊断保持原有行为（无 change 时不评估） [spec:sdd-doctor#纯环境诊断保持原有行为]
- [x] 4.3 实现 change 无 spec/tasks 时仅输出环境状态 [spec:sdd-doctor#有 change 但无 spec/tasks 时仅输出环境状态]
- [x] 4.4 实现简单(S)评级推荐 /sdd-quick [spec:sdd-doctor#简单(S)评级时推荐 /sdd-quick 路径]
- [x] 4.5 实现中等(M)评级推荐标准路径 [spec:sdd-doctor#中等(M)评级时推荐标准路径]
- [x] 4.6 实现复杂(L)评级推荐完整流程 [spec:sdd-doctor#复杂(L)评级时推荐完整流程]
- [x] 4.7 增加后置推荐操作（★ 按复杂度推荐路径） [spec:recommendation#sdd-doctor 完成后输出路径推荐]

### 前置校验（所有 action）

- [x] 5.1 修改 `skills/sdd-brainstorm/SKILL.md`：增加前置校验段落（无前置依赖，直接通过） [spec:pre-validation#校验通过 — 无前置依赖的 action]
- [x] 5.2 修改 `skills/sdd-propose/SKILL.md`：增加前置校验（警告：brainstorm 决策有空项） [spec:pre-validation#警告级缺失 — 提示缺失项，用户可强制继续]
- [x] 5.3 修改 `skills/sdd-ff/SKILL.md`：增加前置校验（阻断：proposal 不存在；警告：影响分析为空） [spec:pre-validation#sdd-ff 阻断 — proposal 不存在]
- [x] 5.4 修改 `skills/sdd-code/SKILL.md`：增加前置校验（阻断：tasks 不存在；警告：>15 任务无 plan） [spec:pre-validation#sdd-code 阻断 — tasks 不存在]
- [x] 5.5 修改 `skills/sdd-review-code/SKILL.md`：增加前置校验（阻断：无代码变更或无 spec；警告：场景数 < tasks 数） [spec:pre-validation#阻断级缺失 — 拒绝执行并输出修复建议]
- [x] 5.6 修改 `skills/sdd-verify/SKILL.md`：增加前置校验（阻断：spec 或代码不存在） [spec:pre-validation#sdd-verify 阻断 — spec 或代码不存在]
- [x] 5.7 修改 `skills/sdd-ship/SKILL.md`：增加前置校验（阻断：verify 未执行；警告：有未通过 review） [spec:pre-validation#sdd-ship 阻断 — verify 未执行]
- [x] 5.8 修改 `skills/sdd-continue/SKILL.md`：增加前置校验（依赖链中无前置阻断） [spec:pre-validation#校验通过 — 无前置依赖的 action]

### 推荐操作（所有 action）

- [x] 6.1 修改 `skills/sdd-brainstorm/SKILL.md` 后置逻辑：增加 ★/sdd-propose, ○/sdd-ff, △/sdd-quick [spec:recommendation#所有 action 推荐格式一致性]
- [x] 6.2 修改 `skills/sdd-propose/SKILL.md` 后置逻辑：增加 ★/sdd-ff, ○/sdd-plan, △/sdd-brainstorm [spec:recommendation#所有 action 推荐格式一致性]
- [x] 6.3 修改 `skills/sdd-ff/SKILL.md` 后置逻辑：增加 ★/sdd-plan[M/L]或/sdd-code[S], ○/sdd-review-spec, △/sdd-quick [spec:recommendation#sdd-ff 完成后根据复杂度动态推荐]
- [x] 6.4 修改 `skills/sdd-code/SKILL.md` 后置逻辑：增加 ★/sdd-review-code[M/L]或/sdd-ship[S], ○/sdd-verify [spec:recommendation#sdd-code 完成后输出 ★○△ 推荐操作]
- [x] 6.5 修改 `skills/sdd-review-code/SKILL.md` 后置逻辑：增加 ★/sdd-test-code, ○/sdd-code, △/sdd-ship [spec:recommendation#所有 action 推荐格式一致性]
- [x] 6.6 修改 `skills/sdd-review-spec/SKILL.md` 后置逻辑：增加 ★/sdd-propose, ○/sdd-ff [spec:recommendation#所有 action 推荐格式一致性]
- [x] 6.7 修改 `skills/sdd-verify/SKILL.md` 后置逻辑：增加 ★/sdd-ship, ○/sdd-code [spec:recommendation#所有 action 推荐格式一致性]
- [x] 6.8 修改 `skills/sdd-ship/SKILL.md` 后置逻辑：增加"变更已完成，无后续操作" [spec:recommendation#sdd-ship 完成后无后续推荐]
- [x] 6.9 修改 `skills/sdd-continue/SKILL.md` 后置逻辑：增加按进度动态推荐 [spec:recommendation#所有 action 推荐格式一致性]

### 配置与文档

- [x] 7.1 修改 `schemas/sdd/schema.yaml`：新增 sdd-quick 和 sdd-test-code 的 action 定义 [spec:sdd-quick#简单需求从零开始走 quick 全流程]
- [x] 7.2 修改 `.claude-plugin/plugin.json`：注册 sdd-quick 和 sdd-test-code [spec:sdd-quick#简单需求从零开始走 quick 全流程]
- [x] 7.3 修改 `README.md`：增加内联引用标注表（4 个 reference 文件来源） [spec:sdd-quick#简单需求从零开始走 quick 全流程]
- [x] 7.4 修改 `README.md`：增加路径推荐说明（S/M/L 三级路径表） [spec:sdd-doctor#简单(S)评级时推荐 /sdd-quick 路径]
- [x] 7.5 修改 `README.md`：更新 action 列表（11 → 13）和版本号 v0.3.0 [spec:sdd-quick#简单需求从零开始走 quick 全流程]

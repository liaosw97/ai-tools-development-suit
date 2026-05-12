# Proposal: sdd-v0.3.0

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

优化 SDD 工作流的 4 个核心痛点：plan 大变更超时、链路过长、自动触发不准确、review-code 后无 test-code 能力，将 ai-tools-bridge 从 v0.2.0 升级到 v0.3.0。

## 范围

### 包含
- 新增 `/sdd-quick` 快速模式 action（简单需求一键完成 propose → code）
- 新增 `/sdd-test-code` TDD 循环补全 action（审查后补充缺失测试）
- 修改 `/sdd-plan`：增加分批生成能力 + 任务规模上限检测
- 修改 `/sdd-doctor`：增加复杂度评估（S/M/L 三级）+ 路径推荐
- 修改所有 action 前置逻辑：增加前置校验机制（上下文完整性检查）
- 修改所有 action 后置逻辑：统一推荐操作机制（★推荐 / ○可选 / △跳跃）
- 内联 4 个 skills reference 文件到对应 action 目录
- 更新 README.md：引用标注 + 路径推荐说明
- 版本号升级至 v0.3.0

### 不包含
- 不内联与本次 4 个痛点无关的 skills（diagnose、grill-with-docs、review、improve-codebase-architecture、prototype、zoom-out、handoff、caveman）
- 不修改现有 action 的核心执行逻辑（委托关系不变）
- 不修改 OpenSpec 或 Superpowers 插件本身
- 不做架构重组（保持 11 → 13 个 action 的增量改进）

## 决策追溯

- 选择 [直接内联 reference 文件] 而非 [保持引用 + 标注]：减少外部依赖，简化安装和维护（见 brainstorm.md §决策 1: Skills 合并方式 — 直接内联）
- 选择 [按需分批内联 4 个文件] 而非 [全部合并]：最小化本次变更范围，降低风险（见 brainstorm.md §决策 2: Skills 内联范围 — 按需分批）
- 选择 [可拆则拆 + 分批生成] 而非 [大变更跳过 plan]：保留 TDD 级别的实施指导，质量不下降（见 brainstorm.md §决策 3: Plan 超时解决方案）
- 选择 [分级路径 + 自由组合 + /sdd-quick + 推荐操作] 而非 [只做其中一个]：四者互补覆盖链路长的各种场景（见 brainstorm.md §决策 4: 链路优化方式 — 三合一）
- 选择 [前置校验 + 智能分级触发] 而非 [全部手动触发 / 仅间接缓解]：前置校验将手动触发的"确认"机制内置，从根因提升准确性（见 brainstorm.md §决策 5: 触发方式 — 前置校验 + 智能分级触发）
- 选择 [独立 sdd-test-code action] 而非 [嵌入 sdd-review-code 后置逻辑]：职责清晰，可独立触发，与 sdd-code 形成互补（见 brainstorm.md §决策 6: test-code 功能定位）

## 影响分析

### 影响的模块
- `skills/sdd-quick/` — 新增（SKILL.md + 2 个 reference 文件）
- `skills/sdd-test-code/` — 新增（SKILL.md + 2 个 reference 文件）
- `skills/sdd-plan/SKILL.md` — 修改前置/后置逻辑
- `skills/sdd-doctor/SKILL.md` — 修改前置/后置逻辑
- `skills/sdd-brainstorm/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-propose/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-ff/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-code/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-review-code/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-review-spec/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-verify/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-ship/SKILL.md` — 修改后置逻辑（推荐操作）
- `skills/sdd-continue/SKILL.md` — 修改后置逻辑（推荐操作）
- `schemas/sdd/schema.yaml` — 修改（新增 sdd-quick、sdd-test-code action 定义）
- `.claude-plugin/plugin.json` — 修改（注册新 action）
- `README.md` — 修改（引用标注 + 路径推荐 + 版本号）

### 风险评估
- **中风险 — 前置校验过严：** 校验规则可能误阻断合法操作。缓解：警告级不阻断，阻断级只针对致命缺失，用户可强制跳过警告
- **低风险 — 复杂度阈值不准：** S/M/L 阈值为经验值，可能与实际不符。缓解：标注为初始值，待迭代调整
- **低风险 — 向后兼容：** 新增 action 不影响现有流程；修改后置逻辑只增加推荐输出，不改变核心行为

## 成功标准

- [ ] `/sdd-quick` 能完成简单需求的 propose → spec → tasks → code 全流程，超限时正确提示回退
- [ ] `/sdd-test-code` 能读取 review 报告并补全 PARTIAL/MISSING 场景的测试
- [ ] `/sdd-plan` 对 >25 任务的大型变更提示分批生成，分批模式可正常逐批生成
- [ ] `/sdd-doctor` 能评估已有 change 的复杂度并推荐路径
- [ ] 每个 action 完成后输出 ★○△ 格式的推荐操作
- [ ] 每个 action 前置逻辑包含上下文完整性校验，阻断条件正确拒绝执行
- [ ] 4 个 reference 文件已内联，README 中标注了引用来源
- [ ] 版本号更新为 v0.3.0

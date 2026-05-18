# Spec Review R1

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-17

## 总结

三个 spec 文件（propose-impact-scan、deferred-capture、review-enhancement）整体结构清晰，GIVEN/WHEN/THEN 格式使用一致，覆盖了 proposal 的全部 5 个改造项和 brainstorm 的 3 个关键决策。场景划分合理，正常路径、跳过路径和边界条件基本齐全。主要问题集中在：(1) 部分断言不够具体，依赖 AI 主观判断但未在 spec 中声明这一约束；(2) 跨模块 issue severity 被不当地限制为 minor；(3) deferred-capture SC-01 中"未完成"状态的判定标准与 proposal 描述存在歧义；(4) 个别场景描述的是实现细节而非用户可观测行为。建议修订后可进入实现阶段。

## Issues

### [severity: major] propose-impact-scan SC-01 "识别相关模块"缺少判定标准

- **位置:** specs/propose-impact-scan/spec.md §SC-01
- **描述:** THEN 中"识别出与当前变更相关的其他模块"是一个关键断言，但"相关"没有定义判定标准。propose-impact-scan SC-04 说明扫描依赖 AI 分析项目结构，但 SC-01 的断言写法暗示存在确定性的"识别"结果。实际上这是一个启发式判断，spec 应明确声明：(a) 相关性由 AI 基于项目结构和已有 specs 内容推导，无硬性规则；(b) 扫描结果需要用户确认（SC-03 已覆盖确认步骤，但 SC-01 的 THEN 描述了扫描本身，应区分"AI 建议"和"确认结果"）。
- **建议:** 在 SC-01 的 THEN 中将"识别出与当前变更相关的其他模块"改为"基于项目结构和已有 specs 内容，列出可能与当前变更相关的模块，由用户确认相关性"。同时将输出警告中的 N 明确定义为"specs/ 下的子目录数量"。

### [severity: major] review-enhancement SC-02 severity 限制不合理

- **位置:** specs/review-enhancement/spec.md §SC-02
- **描述:** THEN 中"Issues 区域可包含 severity 标记为 minor 的跨模块一致性问题"将跨模块一致性问题的严重度限制为 minor。但在实际场景中，遗漏关键模块的同步变更（如安全增强遗漏了审计模块）可能是 major 甚至 critical。这个限制与 brainstorm 中描述的原始问题（安全扫描 P2 项被遗忘导致 audit-guide 缺少安全检查）矛盾——那正是一个 high severity 的跨模块遗漏。
- **建议:** 移除 severity 限制，改为"Issues 区域可包含跨模块一致性问题，severity 根据遗漏影响范围判定为 minor/major/critical"。

### [severity: major] deferred-capture SC-01 "未完成"状态判定与 proposal 描述不一致

- **位置:** specs/deferred-capture/spec.md §SC-01
- **描述:** GIVEN 条件要求"至少有 1 个标记项的状态为未完成"，但 proposal 的影响分析描述为"搜索 P1/P2/延后/后续迭代等标记"。在 proposal 中，P2 延后项通常没有"完成/未完成"状态的概念——被标记为 P2 就意味着延后待做。要求额外判断"状态为未完成"引入了一个 proposal 中不存在的状态维度，可能导致实现时混淆：P2 标记本身是否就算"未完成"？还是需要一个显式的完成标记？
- **建议:** 将 GIVEN 条件简化为"proposal.md 包含 P1/P2/延后/后续迭代等延后标记"，移除"状态为未完成"这一条件。在边界条件中补充说明：如果延后项在 proposal 中已被标注为"已完成"（通过删除线或其他标记），则跳过该项。

### [severity: minor] propose-impact-scan SC-04 描述实现位置而非用户可观测行为

- **位置:** specs/propose-impact-scan/spec.md §SC-04
- **描述:** SC-04 描述的是"跨模块影响扫描在 SKILL.md 中的位置"，这是实现细节（步骤编号 1.5、位于决策追溯检查之后产物校验之前），而非用户可观测的行为。其他场景（SC-01~03）描述的是功能行为，SC-04 风格不一致。
- **建议:** 将 SC-04 从场景移到"实现约束"章节，或改为描述用户可观测的行为差异——例如"跨模块影响扫描在 proposal 已生成但尚未校验时执行，用户会看到扫描结果在决策追溯检查之后、最终校验之前出现"。

### [severity: minor] deferred-capture SC-05 用户"关联"后的行为未定义

- **位置:** specs/deferred-capture/spec.md §SC-05
- **描述:** THEN 中"用户可选择关联或忽略"，但没有定义"关联"的具体行为。如果用户选择关联某个 open 项，brainstorm.md 或 proposal.md 中是否需要引用该 backlog 项？还是仅作为上下文参考？这个行为影响 brainstorm.md 的格式和 sdd-brainstorm 的输出。
- **建议:** 补充 THEN 断言：如果用户选择关联，在 brainstorm.md 的"需求描述"或"参考资源"中引用相关 backlog 项；如果忽略，仅在 brainstorm.md 中记录"已评估 backlog，未发现关联项"。

### [severity: minor] propose-impact-scan SC-02 简化后的输出格式不明确

- **位置:** specs/propose-impact-scan/spec.md §SC-02
- **描述:** THEN 中"简化为列出变更可能影响的文件/目录范围"没有说明输出的具体形式——是追加到 proposal.md 的范围节？还是作为终端输出提示？对比 SC-03（确认后更新 proposal），SC-02 缺少输出位置的定义。
- **建议:** 明确 SC-02 的输出是作为 AI 内部分析的参考（不修改 proposal），还是追加到 proposal 的范围节。与 SC-03 保持一致的输出模式。

### [severity: minor] propose-impact-scan 边界条件"proposal 已包含跨模块分析"缺少对应场景

- **位置:** specs/propose-impact-scan/spec.md §边界条件
- **描述:** 边界条件中提到"proposal.md 的范围节已包含跨模块分析：跳过扫描，不重复提示"，但这个行为没有对应的 GIVEN/WHEN/THEN 场景。它既不属于 SC-01（多模块）也不属于 SC-02（单模块），是一个独立的跳过路径。
- **建议:** 新增场景或在 SC-01 的 GIVEN 条件中补充"AND proposal 的范围节未包含跨模块影响分析"作为前置条件，当该条件不满足时描述跳过行为。或者在 SC-01 中增加一个 THEN 分支：如果 proposal 已包含跨模块分析，输出"已检测到跨模块影响分析，跳过扫描"。

### [severity: minor] deferred-capture SC-03 重复项判定标准不够具体

- **位置:** specs/deferred-capture/spec.md §SC-03
- **描述:** "相同来源和简述"作为重复判定标准，但"简述"是自由文本，精确匹配不现实。两个延后项可能语义相同但措辞不同。
- **建议:** 将判定标准改为"来源变更相同且简述高度相似"，并补充行为：提示用户人工判断是否合并，而非自动合并。

### [severity: minor] review-enhancement SC-01 检查项缺少判定指引

- **位置:** specs/review-enhancement/spec.md §SC-01
- **描述:** 第 3 个检查项"是否有应同步变更但被遗漏的关联模块"是一个高度主观的判断。与 propose-impact-scan SC-01 的问题类似，spec 应声明这依赖于审查员（AI）的分析而非确定性规则。边界条件中提到"共享功能定义主观"，但仅针对检查项 2，检查项 3 同样存在主观性问题。
- **建议:** 在边界条件中将主观性声明扩展到所有 3 个检查项，或增加一条通用说明："跨模块一致性的判定依赖审查员对项目结构和 spec 间引用关系的分析，不做硬性断言。"

## Approved
- [x] 场景完整性 — 基本覆盖正常/跳过/边界路径，但 propose-impact-scan 缺少"proposal 已含跨模块分析"的场景，deferred-capture SC-05 关联行为未定义
- [ ] 可测试性 — 3 个 major issue 影响可测试性：相关模块判定标准缺失、severity 限制不合理、未完成状态定义歧义
- [x] 一致性 — 三个 spec 之间无矛盾，与 proposal 范围一致，与 brainstorm 决策方向一致
- [x] 决策追溯 — brainstorm 3 个决策在 spec 中均有对应场景；proposal 决策追溯节正确引用了 brainstorm；无被否决方案出现在 spec 中
- [x] 范围控制 — spec 严格限定在 proposal 的 5 个改造项内，无隐含功能扩展；backlog.md 明确为可选制品；sdd-quick/sdd-ff 不单独修改

## 结论

**NEEDS_REVISION**

需要修复 3 个 major issue 后重新审查：
1. propose-impact-scan SC-01 明确"相关模块"的判定机制（AI 启发式 + 用户确认）和 N 的定义
2. review-enhancement SC-02 移除 severity 为 minor 的硬性限制
3. deferred-capture SC-01 统一"未完成"的判定标准，与 proposal 描述对齐

6 个 minor issue 建议同步修复，但不阻塞审批。

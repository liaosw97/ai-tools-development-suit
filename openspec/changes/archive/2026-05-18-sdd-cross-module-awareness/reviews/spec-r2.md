# Spec Review R2

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-17

## 总结

三个 spec 文件（propose-impact-scan、deferred-capture、review-enhancement）经过 R1 修复后质量显著提升。R1 的 3 个 major issue 和 6 个 minor issue 全部得到有效修复。GIVEN/WHEN/THEN 格式使用一致且规范，场景覆盖了正常路径、跳过路径和边界条件。可测试性良好——每个 WHEN/THEN 断言均可转化为具体的自动化验证点。三个 spec 之间无矛盾，与 proposal 的范围完全一致，brainstorm 的 3 个关键决策在 spec 中均有对应场景和正确引用。无新发现 issue。

## R1 Issues 修复验证

| # | Issue | 修复状态 | 验证说明 |
|---|-------|---------|---------|
| 1 | propose-impact-scan SC-01 "识别相关模块"判定标准 | **已修复** | THEN 第1条改为"基于 specs/ 目录结构和已有 specs 内容，列出可能与当前变更相关的模块（AI 启发式推导，需用户确认相关性）"，明确了 AI 启发式机制和用户确认环节；THEN 第3条中 N 明确定义为"specs/ 下子目录数量" |
| 2 | review-enhancement SC-02 severity 限制 | **已修复** | THEN 最后一条改为"Issues 区域可包含跨模块一致性问题，severity 根据遗漏影响范围判定为 minor/major/critical"，移除了硬性 minor 限制，与 brainstorm 中描述的高严重度跨模块遗漏场景一致 |
| 3 | deferred-capture SC-01 "未完成"状态判定 | **已修复** | GIVEN 条件简化为"proposal.md 包含 P1/P2/延后/后续迭代等延后标记"，移除了"状态为未完成"这一歧义条件；THEN 中补充"如果延后项在 proposal 中已有删除线或显式标注为'已完成'，跳过该项"，通过正向描述跳过条件替代了原来的反向状态判断 |
| 4 | propose-impact-scan SC-04 实现位置 | **已修复** | 原实现位置信息（步骤 1.5、位于决策追溯检查之后产物校验之前）已移至"实现约束"章节（第65-70行）；SC-04 重新定义为"已包含跨模块分析时的跳过"场景，描述用户可观测行为（输出提示、不重复提示、不修改 proposal） |
| 5 | deferred-capture SC-05 关联行为 | **已修复** | THEN 补充了具体行为定义："如果用户选择关联某 open 项，在 brainstorm.md 的'参考资源'中引用该 backlog 项"；"如果用户选择忽略，不记录（仅作为上下文参考）"。两种用户选择的行为路径均明确 |
| 6 | propose-impact-scan SC-02 输出格式 | **已修复** | THEN 四条断言明确定义了输出行为：(1) AI 内部分析作为决策追溯参考；(2) 不修改 proposal.md；(3) 不输出跨模块影响警告；(4) 不阻断 proposal 生成。输出位置为 AI 内部分析，与 SC-01/03 的面向用户输出形成合理区分 |
| 7 | propose-impact-scan 边界条件缺少场景 | **已修复** | 新增 SC-04"已包含跨模块分析时的跳过"场景，GIVEN 条件包含"proposal.md 的'范围'节已包含跨模块影响分析段落"和"项目 specs/ 目录下存在多个子目录"，WHEN/THEN 描述了跳过行为 |
| 8 | deferred-capture SC-03 重复项判定 | **已修复** | THEN 改为"如检测到来源变更相同且简述高度相似的已有项，提示用户人工判断是否合并（不自动合并）"，以"高度相似"替代"相同"，并明确不自动合并 |
| 9 | review-enhancement SC-01 检查项主观性 | **已修复** | THEN 新增最后一条通用声明："跨模块一致性的判定依赖审查员（AI）对项目结构和 spec 间引用关系的分析，不做硬性断言——所有 3 个检查项的结论均为'基于分析的判断，需人工确认'"，覆盖全部检查项 |

## 新发现 Issues

无。

各维度详细分析：

**场景完整性**：三个 spec 共 12 个场景（propose-impact-scan 4 个、deferred-capture 6 个、review-enhancement 3 个），覆盖了正常路径（SC-01）、跳过路径（SC-02/04/06）、已存在状态处理（SC-03）、降级处理（review-enhancement SC-03），以及边界条件（每个 spec 文件末尾的"边界条件"章节）。propose-impact-scan 的边界条件中"用户拒绝所有跨模块建议"和"AI 无法确定模块相关性"均有明确的行为定义。

**可测试性**：所有 WHEN/THEN 断言具体且可验证。例如 deferred-capture SC-01 THEN 包含 5 条可逐一断言的行为；propose-impact-scan SC-01 的警告消息包含可匹配的具体文本和变量 N；review-enhancement SC-02 的 Approved 清单和 Issues 区域格式变更均可通过模板对比验证。

**一致性**：三个 spec 对"多模块/单模块"的判定标准一致（基于 specs/ 子目录数量 ≥2 vs 0-1）；backlog.md 的存储路径（openspec/backlog.md）在 deferred-capture 的多个场景中一致；跨模块影响分析的概念在 propose-impact-scan 和 review-enhancement 中语义一致。

**决策追溯**：brainstorm 的 3 个关键决策（方案 A、backlog 定位、结构化提问策略）在 proposal 决策追溯节有完整引用，在 spec 中有对应场景。proposal 和 spec 中均未出现被否决的方案 B/C 的实现细节。

**范围控制**：spec 严格限定在 proposal 的 5 个改造项内。sdd-quick/sdd-ff 不单独修改、backlog.md 为可选制品、不引入 config 依赖——这些约束在 spec 中通过跳过场景和边界条件正确体现。

## Approved
- [x] 场景完整性
- [x] 可测试性
- [x] 一致性
- [x] 决策追溯
- [x] 范围控制

## 结论

**APPROVED**

R1 的 3 个 major issue 和 6 个 minor issue 全部有效修复，spec 质量达到实现标准。场景覆盖完整，断言具体可测试，三个 spec 之间及与 proposal/brainstorm 之间保持一致。无新发现 issue。建议进入 tasks.md 拆分阶段。

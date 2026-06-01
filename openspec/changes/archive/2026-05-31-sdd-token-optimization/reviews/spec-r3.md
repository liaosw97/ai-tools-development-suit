# Spec Review — Round 3

**审查对象:** specs/ 目录下所有 spec 文件（4 个领域，39 个场景）
**日期:** 2026-05-30
**角色:** eng-manager

## 总结

4 个 spec 文件整体结构规范，均使用 GIVEN/WHEN/THEN 格式，覆盖了 proposal 中定义的主要范围。主要问题集中在可测试性维度：部分场景的判定标准模糊（如"关键字段"未定义、token 阈值无偏差范围），以及 token-budget 的 spec 缺少行动导向（仅描述测量，未关联优化决策）。

## Issues

### [severity: critical] 关键字段定义缺失
- **位置:** specs/context-compression/spec.md §关键字段保留
- **描述:** 场景要求"关键信息覆盖率 ≥95%"，但未定义"关键字段"的具体内容。提案中提到"关键字段强制保留（spec 场景、task 链接、决策结论）"，但 spec 未将此定义纳入，导致无法编写自动化测试验证覆盖率。
- **建议:** 在场景的 THEN 中明确列出关键字段清单：`spec 场景名 + GIVEN/WHEN/THEN`、`task 编号 + spec 链接`、`决策结论 + 理由`，并定义覆盖率计算公式。

### [severity: critical] 状态文件大小度量不可测
- **位置:** specs/context-compression/spec.md §状态文件创建、§状态文件更新
- **描述:** 状态文件大小约束使用"≤250 tokens（使用 cl100k_base 编码计算）"，但实际场景中：(1) AI 生成文本时无法精确控制 token 数；(2) cl100k_base 编码需要额外依赖；(3) token 数在不同模型间不一致。此约束在测试中难以自动化验证。
- **建议:** 改为可测试的度量方式，如"≤500 字符"或"≤30 行"，或改为"状态文件大小约为原始 artifact 的 5%，偏差不超过 ±2%"。

### [severity: major] 精度验证阈值无偏差范围
- **位置:** specs/precision-verification/spec.md §验证通过、§验证失败
- **描述:** 通过标准要求"峰值 token 消耗降低 ≥30% 且总消耗降低 ≥35%"，失败标准为"<15% 或 <20%"。但未定义 15%-30%（峰值）和 20%-35%（总消耗）之间的灰色地带如何处理。实际测试中，优化效果可能落在该区间。
- **建议:** 增加"需人工评估"区间场景：当峰值降低在 15%-30% 或总消耗在 20%-35% 时，系统标记为 NEEDS_REVIEW，输出详细对比报告供人工决策。

### [severity: major] Token 预算与优化决策未关联
- **位置:** specs/token-budget/spec.md 全文
- **描述:** token-budget 的 4 个 Requirement（定义层预算、执行层预算、消耗测量、预算报告）仅描述"测量"和"报告"，未描述预算数据如何指导优化决策。例如：定义层 token 超过阈值时应触发什么动作？执行层哪个 action 的消耗最大需要优先优化？
- **建议:** 增加 Requirement: Token 预算驱动优化，包含场景：(1) 定义层某组件 token 超出预算阈值时，系统标记该组件为优化候选；(2) 执行层某 action 消耗超过平均值 2 倍时，系统建议对该 action 实施懒加载或压缩。

### [severity: minor] Guidelines 加载触发条件模糊
- **位置:** specs/lazy-loading/spec.md §quality-checkpoints.md 加载、§decision-strategy.md 加载
- **描述:** "当前 action 需要执行质量门检查"和"当前 action 遇到决策点"的触发条件未明确定义。哪些 action 需要质量门检查？决策点如何识别？实施者需要猜测。
- **建议:** 在场景中列出具体的 action 列表或触发规则。例如：quality-checkpoints.md 在 sdd-ff、sdd-plan、sdd-code、sdd-verify 执行时加载；decision-strategy.md 在 sdd-brainstorm、sdd-propose 执行时加载。

### [severity: minor] 模块加载超时阈值未说明测量方式
- **位置:** specs/lazy-loading/spec.md §模块加载失败降级
- **描述:** 场景要求"加载超时（>5秒）"，但未说明超时如何测量：是文件 I/O 超时还是 AI 上下文加载超时？在 AI agent 场景中，"加载"通常是读取文件内容到 prompt，不存在传统意义上的"超时"。
- **建议:** 改为更准确的描述，如"模块文件不存在或文件大小为 0"，或明确说明超时是指"尝试读取文件超过 5 秒未返回"。

## Approved

- [x] 场景完整性 — 所有 spec 均使用 GIVEN/WHEN/THEN 格式，39 个场景覆盖正常路径、降级路径和边界条件
- [ ] 可测试性 — 2 个 critical issue 影响自动化测试可行性（关键字段定义、状态文件度量）
- [x] 一致性 — 4 个 spec 之间无矛盾，与 proposal 范围一致，ADDED 标记正确
- [x] 决策追溯 — proposal 引用了 brainstorm 的 3 个关键决策，spec 方向与决策一致，未出现被否决方案
- [x] 范围控制 — spec 内容均在 proposal 定义范围内，无隐含功能扩展
- [x] 跨模块一致性 — 4 个 spec 领域相互关联（lazy-loading 服务于 context-compression，precision-verification 验证两者，token-budget 测量整体），依赖关系明确

## 结论

**NEEDS_REVISION** — 2 个 critical issue 需修复（关键字段定义、状态文件度量），2 个 major issue 需处理（阈值灰色地带、预算与优化关联）。

---

## 规范扫描

**状态:** SKIPPED
**原因:** specs/ 目录包含 OpenSpec spec 文件（spec.md），不含 Claude Code Skill 定义文件（SKILL.md）。skill-craft-adapter:skill-check 仅适用于 Skill 质量评估，不适用于 OpenSpec spec 审查。

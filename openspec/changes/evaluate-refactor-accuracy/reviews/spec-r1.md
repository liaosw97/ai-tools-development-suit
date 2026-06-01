# Spec Review — Round 1

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-31

## 总结

spec.md 整体结构清晰，覆盖了 proposal 中定义的三个评估维度（静态 Diff 分析、精度测试验证、场景走查），场景均采用 GIVEN/WHEN/THEN 格式。但存在以下主要问题：场景走查缺少失败路径描述、边界条件未融入对应场景、多个 THEN 断言过于模糊难以转化为自动化测试、决策追溯引用缺失。

## Issues

### [severity: major] 场景走查缺少失败路径
- **位置:** specs/accuracy-evaluation/spec.md §场景走查 - 简单变更、§场景走查 - 复杂变更
- **描述:** 两个场景走查的 THEN 部分只描述了成功路径（"无阻塞问题"、"端到端流程正常"），未定义当流程中断、输出不符合预期、或某个步骤失败时的处理方式。
- **建议:** 在 THEN 中增加错误路径，例如："如果任一步骤失败，记录失败原因和失败步骤到评估报告"、"如果 brainstorm 输出不完整，标记为 PARTIAL 并记录缺失内容"。

### [severity: major] 边界条件未融入场景
- **位置:** specs/accuracy-evaluation/spec.md §边界条件
- **描述:** 边界条件以独立段落列出，未与对应场景关联。特别是"边界情况 1: 测试覆盖不全"应作为"精度测试验证"场景的错误路径；"边界情况 2: 场景走查需要实际执行环境"应融入场景走查的 GIVEN 前置条件。
- **建议:** 将边界条件拆分融入对应场景的 GIVEN/THEN 中，或在边界条件段落明确标注关联的场景名称。

### [severity: major] 静态 Diff 分析的 THEN 断言过于模糊
- **位置:** specs/accuracy-evaluation/spec.md §静态 Diff 分析
- **描述:** THEN 部分"确认语义完整性：无功能丢失"缺乏可操作的判定标准。如何判断"无功能丢失"？是人工逐行比对还是有自动化工具？此外"识别丢失的逻辑"和"识别变更的逻辑"是过程描述而非可验证的断言。
- **建议:** 将 THEN 改为可验证的断言，例如："产出变更清单，包含每个变更的类型（ADDED/MODIFIED/REMOVED）、影响范围、是否为功能性变更"、"功能性变更数量 = 0 或每个功能性变更均有明确理由"。

### [severity: major] 精度测试通过标准不明确
- **位置:** specs/accuracy-evaluation/spec.md §精度测试验证
- **描述:** THEN 部分"所有精度测试通过"未明确是哪些测试、通过率要求是多少。"信息保留率 ≥ 95%"虽然量化了指标，但未说明如何计算（使用哪个函数、哪些测试数据）。
- **建议:** 明确测试范围（`tests/precision/` 和 `tests/unit/` 全部通过）、通过标准（0 failures, 0 errors）、信息保留率计算方式（引用 brainstorm 中提到的 `calculateCoverage` 函数）。

### [severity: minor] 场景走查验证点过于抽象
- **位置:** specs/accuracy-evaluation/spec.md §场景走查 - 简单变更、§场景走查 - 复杂变更
- **描述:** "brainstorm 输出是否保留完整需求信息"、"proposal 是否正确引用 brainstorm 决策"、"plan 是否正确链接 spec 场景"等验证点缺乏具体判定标准，难以转化为自动化测试。
- **建议:** 为每个验证点定义具体检查项，例如："brainstorm 输出包含 §需求描述、§方案探索、§关键决策三个段落"、"proposal 的决策追溯段落引用了 brainstorm 的决策编号"。

### [severity: minor] 缺少决策追溯引用
- **位置:** specs/accuracy-evaluation/spec.md 全文
- **描述:** spec.md 未引用 brainstorm.md 或 proposal.md 中的决策。按照项目约定，spec 应体现"决策追溯"，标注场景对应的关键决策。
- **建议:** 在每个场景标题或描述中增加决策引用，例如："组合方案（A + B + C）— 见 brainstorm.md §决策 1"。

## Approved
- [ ] 场景完整性
- [ ] 可测试性
- [ ] 一致性
- [ ] 决策追溯
- [ ] 范围控制
- [x] 跨模块一致性 [N/A — 单模块项目]

## 结论

NEEDS_REVISION

需要修订 4 个 major 问题后重新审查。主要修订方向：(1) 为场景走查增加失败路径；(2) 将边界条件融入场景；(3) 细化 THEN 断言为可验证的具体标准；(4) 增加决策追溯引用。

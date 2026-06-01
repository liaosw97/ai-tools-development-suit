# Spec Review — Round 3

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-31

## 总结

spec.md 整体质量良好，四个场景均使用 GIVEN/WHEN/THEN 格式，覆盖了 proposal 中定义的全部评估维度（静态 Diff 分析、精度测试验证、简单/复杂场景走查），且每个场景都包含失败路径。决策追溯引用了 brainstorm 的四个决策点，Delta Spec 标记正确。主要问题集中在可测试性方面：部分 THEN 断言不够具体，存在实现细节泄漏到 spec 层的情况，边界条件覆盖偏薄。

## Issues

### [major] 静态 Diff 分析场景的 THEN 断言不够具体，缺乏可量化标准
- **位置:** specs/accuracy-evaluation/spec.md §静态 Diff 分析
- **描述:** THEN 第二条"功能性变更数量 = 0 或每个功能性变更均有明确理由"是一个模糊的 OR 条件。"有明确理由"无法自动化验证，且与第三条"无功能丢失"存在语义重叠。与之对比，精度测试场景有明确的"≥ 95%"量化标准。
- **建议:** 拆分为两条独立断言：(1) 功能性变更数量和类型清单（可直接从 diff 输出验证）；(2) 每个 MODIFIED/REMOVED 类型变更附带 reason 字段（可检查字段是否存在）。删除"或"的模糊表述。

### [major] THEN 断言引用了实现细节（函数名），降低了 spec 的稳定性
- **位置:** specs/accuracy-evaluation/spec.md §精度测试验证
- **描述:** GIVEN 中列出 `summarizeSpec`、`passSpecToSubagent`、`compressReviewContext`、`calculateCoverage` 等具体函数名，THEN 中引用 `calculateCoverage` 函数。这些是实现细节，若重构时函数重命名，spec 需要同步修改，违反 spec 与实现解耦的原则。
- **建议:** GIVEN 改为描述覆盖范围（"覆盖 summarizer 模块的核心功能"），THEN 改为描述预期行为（"信息保留率通过精度测试套件中的覆盖率计算验证"），不引用具体函数名。

### [major] 场景走查的验证点偏向格式检查，缺少语义级断言
- **位置:** specs/accuracy-evaluation/spec.md §场景走查 - 简单变更、§场景走查 - 复杂变更
- **描述:** 两个场景走查的 THEN 验证点集中在格式层面（"包含 §需求描述、§方案探索、§关键决策"、"引用 brainstorm 决策编号"、"包含 spec 链接"）。缺少对语义正确性的断言——例如 brainstorm 的决策是否被 proposal 正确采纳，plan 的任务是否真正覆盖了 spec 的场景。
- **建议:** 在每个场景走查的 THEN 中增加一条语义级断言，例如："brainstorm 中的每个关键决策在 proposal 中均有对应的采纳记录"，"tasks.md 中的每个任务至少覆盖一个 spec 场景"。

### [minor] 边界条件仅列出 3 条，未覆盖测试套件本身存在 bug 的情况
- **位置:** specs/accuracy-evaluation/spec.md §边界条件
- **描述:** 当前边界条件覆盖了测试不全、执行环境、信息保留率计算三个方面。但遗漏了一个重要边界：如果测试套件本身存在 bug（如断言过于宽松导致误通过），评估结论可能不可靠。
- **建议:** 增加边界条件："测试套件可靠性 — 如果测试全部通过但场景走查发现异常，需要人工复核测试断言的严格程度（关联场景：精度测试验证）"。

### [minor] 决策追溯格式未完全遵循开发约定
- **位置:** specs/accuracy-evaluation/spec.md 全文
- **描述:** 开发约定要求决策追溯格式为"选择 [X] 而非 [Y]：[原因]（见 brainstorm.md §<标题>）"。spec 中的引用格式为"对应决策：组合方案（A + B + C）— 见 brainstorm.md §决策 1"，虽然可追溯但未严格遵循约定格式。
- **建议:** 场景注释中的决策引用改为遵循约定格式，或在 spec 层面说明使用简化格式的理由。

## Approved
- [ ] 场景完整性
- [ ] 可测试性
- [x] 一致性
- [ ] 决策追溯
- [ ] 范围控制
- [x] 跨模块一致性 [N/A — 单模块项目]

## 结论

NEEDS_REVISION

三个 major 问题需要修订：(1) 静态 Diff 分析的 THEN 断言需具体化以支持自动化验证；(2) 精度测试场景不应引用具体函数名；(3) 场景走查需增加语义级断言。两个 minor 问题建议一并处理。修订后可达到 APPROVED 标准。

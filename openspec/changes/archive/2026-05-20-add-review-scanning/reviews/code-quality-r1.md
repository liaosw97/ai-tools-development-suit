# 代码质量审查报告 — add-review-scanning (r1)

**审查范围**: 7 个文件（2 SKILL.md 修改 + 2 scan-reviewer-prompt.md 新增 + 3 测试文件）

---

## Critical (0)

无。

## Major (3)

### M1. sdd-review-spec 扫描阶段结构归属模糊

- 位置: `skills/sdd-review-spec/SKILL.md:68-88`
- 问题: "规范扫描阶段"放在"核心执行"和"后置逻辑"之间，不属于三段式任何一节
- 修复: 纳入后置逻辑作为子节

### M2. 两个 prompt 检测策略差异未解释

- 位置: `scan-reviewer-prompt.md` (review-code:17-20 vs review-spec:14-17)
- 问题: 检测来源不同但未解释原因
- 修复: 在 spec 版本 prompt 中增加说明

### M3. description "三阶段"可能误导（条件执行阶段）

- 位置: `skills/sdd-review-code/SKILL.md:2`
- 问题: Phase 1.5 为条件执行，多数场景下跳过
- 修复: 调整描述避免误导

## Minor (6)

- m1: 代码开发关键词硬编码 (review-code/scan-reviewer-prompt.md:32-33)
- m2: 流程表达风格不一致（树状 vs 伪代码）
- m3: sdd-review-spec 推荐下一步重复 (SKILL.md:117-123)
- m4: 缺少 sdd-review-spec 的 skill-craft-adapter 测试
- m5: severity 检测逻辑宽松 (reviewer-prompts.test.ts:39-44)
- m6: spec 版本缺少"建议修复方案"节

## 总结

整体设计模式遵循项目三段式架构，扫描阶段对现有流程侵入性低。主要问题集中在结构归属和一致性上，无功能性缺陷。

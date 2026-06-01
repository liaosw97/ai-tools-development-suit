# Spec Review — Round 1

**审查对象:** specs/ 目录下所有 spec 文件（lazy-loading、context-compression、precision-verification、token-budget）
**日期:** 2026-05-30

## 总结

四个 spec 文件整体结构清晰，与 proposal 的四大优化方向（懒加载、上下文压缩、精度验证、token 预算）一一对应，ADDED 标记使用正确。但存在一个系统性缺陷：**所有场景均缺少 GIVEN 前置条件**，仅使用 WHEN/THEN 格式，不符合 GIVEN/WHEN/THEN 三段式规范。此外，多个场景的 THEN 断言缺乏具体可度量的标准，可测试性不足。brainstorm 中识别的异常流（懒加载失败、摘要丢失信息、状态文件损坏）未在 spec 中覆盖。proposal 中提到的"更新 token-optimization.md 指南"在 spec 中无对应覆盖。

## Issues

### [severity: critical] 所有场景缺少 GIVEN 前置条件
- **位置:** 所有 spec 文件的全部场景
- **描述:** 四个 spec 文件中没有任何场景使用 GIVEN/WHEN/THEN 完整格式。所有场景仅使用 WHEN/THEN，缺少描述初始状态的 GIVEN 前置条件。这违反了 spec-reviewer-prompt.md 中"每个 spec 是否使用 GIVEN/WHEN/THEN 格式描述场景"的审查要求，也违反了 proposal 成功标准中"100% 场景有 GIVEN/WHEN/THEN"的验收标准。
- **建议:** 为每个场景补充 GIVEN 前置条件，描述执行 WHEN 动作前的系统状态。例如：
  - lazy-loading §sdd-brainstorm 拆分：`GIVEN sdd-brainstorm skill 文件为单体结构（~472行）`
  - context-compression §状态文件创建：`GIVEN 尚未创建状态文件`
  - precision-verification §验证通过：`GIVEN 精度验证已完成所有测试用例执行`

### [severity: major] brainstorm 异常流未在 spec 中覆盖
- **位置:** brainstorm.md §异常流处理 → specs/ 目录
- **描述:** brainstorm.md 详细定义了三种异常场景的处理和预防策略：(1) 懒加载失败——模块文件不存在或加载超时；(2) 摘要丢失信息——摘要算法丢失关键信息；(3) 状态文件损坏——格式错误或内容损坏。但四个 spec 文件均未覆盖这些异常路径，缺少对应的错误处理场景。
- **建议:** 在对应 spec 中增加异常场景：
  - `specs/lazy-loading/spec.md`：增加"模块加载失败降级"场景（GIVEN 模块文件不存在 WHEN 执行 skill 加载 THEN 降级到完整加载并记录错误日志）
  - `specs/context-compression/spec.md`：增加"摘要信息丢失降级"场景和"状态文件损坏恢复"场景

### [severity: major] THEN 断言缺乏具体可度量标准
- **位置:** 多个 spec 文件的多个场景
- **描述:** 大量场景的 THEN 断言使用模糊描述，无法直接转化为自动化测试。例如：
  - lazy-loading §token-optimization.md 加载："系统加载 token-optimization.md 一次，后续隐式遵循"——"一次"如何验证？"隐式遵循"如何断言？
  - context-compression §结构化摘要："系统使用结构化摘要代替自然语言描述"——结构化摘要的格式和字段未定义
  - context-compression §状态文件创建："系统创建轻量级状态文件（~200 tokens）"——"~200 tokens"是目标还是约束？实际允许范围是多少？
- **建议:** 将模糊断言转化为可度量的具体标准。例如：
  - "系统加载 token-optimization.md 一次"→ "系统在 SDD 工作流初始化阶段加载 token-optimization.md，后续 action 执行时不再重复加载（可通过加载计数器验证）"
  - "~200 tokens" → "≤250 tokens（使用 cl100k_base 编码计算）"

### [severity: major] proposal 中"更新 token-optimization.md 指南"无 spec 覆盖
- **位置:** proposal.md §包含 → specs/ 目录
- **描述:** proposal 的"包含"范围明确列出"更新 token-optimization.md 指南"，但四个 spec 文件中没有任何一个覆盖此需求。lazy-loading spec 提到"token-optimization.md 加载"，但这是关于加载行为的规格，而非对指南内容的更新。
- **建议:** 在 lazy-loading spec 或单独 spec 中增加对 token-optimization.md 内容更新的规格，描述更新后的指南应包含哪些优化策略和使用规则。

### [severity: major] precision-verification spec 通过/失败标准缺少具体指标值
- **位置:** specs/precision-verification/spec.md §验证通过、§验证失败
- **描述:** "所有量化指标达到目标值"和"任一指标低于回滚阈值"中的"目标值"和"回滚阈值"未在 spec 中定义。brainstorm.md 中明确定义了目标值（峰值降低≥30%、总消耗降低≥35%）和回滚阈值（峰值<15%、总消耗<20%），但 spec 中未引用或复述这些具体数值。
- **建议:** 在 spec 中明确引用或定义具体的量化标准，例如："WHEN 峰值 token 消耗降低 ≥30% 且总消耗降低 ≥35% 且无 critical 问题 THEN 系统标记精度验证通过"

### [severity: minor] token-budget spec 场景存在冗余
- **位置:** specs/token-budget/spec.md §SDD Skills 统计、§Superpowers Skills 统计、§模板和指南统计
- **描述:** 三个统计场景的 WHEN 条件完全相同（"分析定义层 token 消耗"），仅 THEN 的统计对象不同。同样，§峰值消耗测量和§总消耗测量的 WHEN 条件也完全相同。这使得 WHEN 条件缺乏区分度，难以独立测试。
- **建议:** 考虑合并为单个场景（THEN 中列出所有统计对象），或细化 WHEN 条件以区分不同触发上下文。

### [severity: minor] precision-verification spec "回滚"触发边界不清
- **位置:** specs/precision-verification/spec.md §验证失败
- **描述:** THEN 描述"系统标记精度验证失败，触发回滚"，但回滚操作在 brainstorm.md 中定义为分阶段操作（懒加载回滚、压缩回滚、全量回滚），spec 未说明触发哪种回滚，也未说明回滚由谁执行（自动 vs 人工确认）。
- **建议:** 明确回滚的触发方式和范围，例如："THEN 系统标记精度验证失败，输出回滚建议（含回滚范围和命令），等待用户确认后执行"

## Approved
- [ ] 场景完整性 — 所有场景缺少 GIVEN 前置条件，异常路径未覆盖
- [ ] 可测试性 — 多个 THEN 断言缺乏具体可度量标准
- [x] 一致性 — spec 之间无矛盾，ADDED 标记正确
- [x] 决策追溯 — proposal 正确引用了 brainstorm 的 3 个关键决策，spec 与决策方向一致
- [ ] 范围控制 — "更新 token-optimization.md 指南"未被 spec 覆盖
- [x] 跨模块一致性 — 四个 spec 均针对 ai-tools-bridge 模块，proposal 已列出影响分析，无遗漏的关联模块

## 结论

**NEEDS_REVISION**

主要问题：(1) 所有场景必须补充 GIVEN 前置条件以满足 GIVEN/WHEN/THEN 规范；(2) brainstorm 中定义的异常流需要在 spec 中覆盖；(3) 多个 THEN 断言需要具体化以支持自动化测试；(4) proposal 范围内的"更新 token-optimization.md 指南"需要补充 spec 覆盖。

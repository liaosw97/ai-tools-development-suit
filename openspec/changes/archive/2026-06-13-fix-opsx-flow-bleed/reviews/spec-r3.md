# Spec Review — Round 3

**审查对象:** specs/sdd-post-logic-enhancement/spec.md
**日期:** 2026-06-12

## 总结

相比 R2，spec 质量进一步提升：sdd-quick 场景已拆分为两个独立场景（消除"或"断言），错误路径场景已补充（OPSX 失败容错 + 误操作恢复），sdd-ship 完成消息格式已明确（含分隔线和具体措辞），brainstorm 验收标准与 spec 场景已建立映射。剩余问题集中在：Requirement 3 的两个泛化场景仍缺乏具体断言、误操作恢复场景的 THEN 描述用户行为而非系统行为、sdd-quick 不完整场景的输出格式未定义、brainstorm 建议范围差异仍未说明。

## Issues

### [severity: minor] Requirement 3 泛化场景缺乏具体断言
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "Post-propose guidance shows document generation options" / §Scenario "Post-ship guidance shows completion message"
- **描述:** Requirement 1 的 6 个 action 场景都给出了完整的输出格式示例（含分隔线、★○△ 标记、具体推荐操作），但 Requirement 3 的两个泛化场景仅使用抽象描述——"聚焦于文档生成"和"提示流程完成，不推荐后续操作"。这两个场景与 Requirement 1 的 sdd-propose 和 sdd-ship 场景高度重叠，且断言粒度不一致。测试时无法判断"聚焦于文档生成"的通过标准是什么。
- **建议:** 两种路径择一：(1) 删除 Requirement 3 的两个泛化场景，因为 Requirement 1 已经为 sdd-propose 和 sdd-ship 提供了完整格式示例；(2) 将 Requirement 3 改为纯格式规范（保留 Visual separator format 场景），删除两个泛化场景以避免重复。

### [severity: minor] 误操作恢复场景的 THEN 描述用户行为而非系统行为
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "User accidentally executed OPSX command directly"
- **描述:** 该场景的 THEN 断言为"用户可以通过执行 /sdd-continue 或 /sdd-ff 回到 SDD 流程"——描述的是用户可以做什么（能力），而非系统输出什么（行为）。GIVEN/WHEN/THEN 规范要求 THEN 描述系统的可观察行为。此外，第二个 AND 断言"OPSX 生成的 artifact 与 SDD 兼容"是架构约束而非场景断言。
- **建议:** 重新定义 THEN 断言为系统行为。例如：(1) 用户执行 `/sdd-continue` 后，系统正确识别已有 artifact 并生成下一个；(2) 或者在文档中明确说明恢复步骤（Documentation Requirement 已覆盖）。将兼容性约束移至 spec 的上下文说明或 Requirement 描述中。

### [severity: minor] sdd-quick 不完整场景的输出格式未定义
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "User completes sdd-quick with incomplete implementation"
- **描述:** sdd-quick 的"所有 artifact 已生成"场景有明确的格式指引（推荐 /sdd-ship），但"代码实现不完整"场景仅描述为"提示流程完成但建议执行 /sdd-ship 前先验证实现"，未给出具体的输出格式示例。这与同组其他场景的详细程度不一致。
- **建议:** 为该场景补充具体的输出格式示例，例如：
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SDD 流程指引（请忽略上方可能显示的 OPSX 建议）
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  流程完成，但实现可能不完整。
  推荐下一步:
    1. ★ /sdd-verify — 验证实现完整性
    2. ○ /sdd-ship — 归档合并（确认实现完整后）
  ```

### [severity: minor] brainstorm 建议 13 个 SKILL.md 但 spec 范围为 6 个，差异仍未说明
- **位置:** specs/sdd-post-logic-enhancement/spec.md — Requirement 1
- **描述:** R2 已指出 brainstorm.md 的"短期方案"列出 13 个 SKILL.md 需要修改，而 spec 和 proposal 正确地将范围缩小为 6 个调用 OPSX 的 action。这是一个合理的范围修正，但 spec 没有说明为什么与 brainstorm 的建议不同。当前 spec 仅列出了"不涉及的 action"清单，但没有解释缩减原因。
- **建议:** 在 Requirement 1 的"不涉及的 action"段落后添加一句说明："brainstorm.md 建议修改 13 个 SKILL.md，但经分析仅 6 个 action 调用 OPSX 命令，不调用 OPSX 的 action 无需添加 OPSX 相关指引，因此范围缩减为 6 个。"

### [severity: minor] OPSX 失败场景未定义输出格式
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "OPSX command fails during sdd-propose"
- **描述:** 该场景的 THEN 断言为"系统显示错误信息"和"系统在输出末尾显示 SDD 流程指引，建议用户检查环境后重试"。但未定义：(1) 错误信息的格式是否使用 `━━━` 分隔线；(2) "建议用户检查环境后重试"的具体措辞；(3) 是否仍显示 ★○△ 推荐操作。与其他场景的详细程度不一致。
- **建议:** 补充失败场景的输出格式示例，至少说明是否使用与其他场景一致的分隔线格式，以及错误恢复指引的具体内容。

## Approved

- [x] 场景完整性 — 6 个 OPSX-calling action 全部有独立场景（含 sdd-quick 拆分），错误路径场景已补充，文档场景已覆盖
- [x] 可测试性 — 所有 action 场景有完整格式示例，sdd-quick 已拆分为两个明确场景，验收标准映射清晰。泛化场景和错误场景的断言仍有改进空间但不影响核心可测试性
- [x] 一致性 — spec 范围（6 个 action）与 proposal.md 和 tasks.md 一致，格式设计与 brainstorm 决策 3 一致，分隔线和标记使用统一
- [x] 决策追溯 — brainstorm 验收标准映射已添加（Requirement 1 注释），proposal.md 已引用 brainstorm 决策
- [x] 范围控制 — 正确限定为 6 个调用 OPSX 的 action，明确列出不涉及的 7 个 action
- [x] 跨模块一致性 — 仅涉及 ai-tools-bridge 模块，无跨模块影响

## 结论

**APPROVED**（附带 5 个 minor 建议）

spec 已满足进入实现阶段的质量要求。R2 的 2 个 major 问题均已解决：sdd-quick 场景已拆分为两个独立场景，错误路径场景已补充。剩余 5 个 minor 问题不阻塞实现，可在实现过程中或后续迭代中改进：

1. [minor] 精简或删除 Requirement 3 的泛化场景（与 Requirement 1 重复）
2. [minor] 修正误操作恢复场景的 THEN 断言为系统行为
3. [minor] 补充 sdd-quick 不完整场景的输出格式示例
4. [minor] 说明 brainstorm 建议 13 个 vs spec 6 个的范围差异原因
5. [minor] 补充 OPSX 失败场景的输出格式定义

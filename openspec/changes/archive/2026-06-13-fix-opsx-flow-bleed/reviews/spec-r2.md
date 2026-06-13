# Spec Review — Round 2

**审查对象:** specs/sdd-post-logic-enhancement/spec.md
**日期:** 2026-06-11

## 总结

相比 R1，spec 质量有显著提升：所有场景已补充 GIVEN 前置条件，范围正确收敛为调用 OPSX 的 6 个 action（并明确列出 7 个不涉及的 action），★○△ 标记分配规则已在 "Visual separator format" 场景中定义，多数场景的 THEN 断言已具体化。剩余问题集中在：sdd-quick 场景的"或"导致不可测试、错误路径场景仍未补充、文档场景的断言过于模糊、brainstorm 验收标准未被引用。

## Issues

### [severity: major] sdd-quick 场景断言含"或"，不可测试
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "User completes sdd-quick and sees SDD flow guidance"
- **描述:** THEN 断言为"提示流程完成**或**推荐 `/sdd-ship`"。"或"使得测试无法确定预期行为——到底应该显示"流程完成"还是推荐 `/sdd-ship`？这取决于什么条件？spec 未定义分支条件。
- **建议:** 消除"或"，改为基于条件的明确断言。例如：当所有 artifact 和代码已生成时显示"流程完成"；当代码未生成时推荐 `/sdd-code`。或者如果两种情况确实都存在，拆分为两个独立场景并分别给出明确断言。

### [severity: major] 仍缺少错误路径场景
- **位置:** specs/sdd-post-logic-enhancement/spec.md — 全局
- **描述:** R1 已指出缺少错误路径场景，本轮仍未补充。至少需要覆盖：(1) OPSX 命令执行失败时，SDD 后置逻辑是否仍显示流程指引？(2) 用户误执行 OPSX 命令后如何恢复？brainstorm.md 的"误操作恢复方案"已给出答案（/sdd-doctor 检测 + /sdd-continue 恢复），但 spec 未将这些转化为可测试场景。
- **建议:** 补充至少 2 个错误路径场景：
  - Scenario: OPSX command fails but SDD flow guidance still displays（验证后置逻辑的容错性）
  - Scenario: User accidentally runs OPSX command and recovers via SDD（可在 Documentation Requirement 中覆盖，明确恢复步骤的格式和内容）

### [severity: minor] sdd-ship 完成消息格式未明确
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "User completes sdd-ship and sees SDD flow guidance"
- **描述:** THEN 断言为"提示流程完成，无后续操作"，但未定义"流程完成"的具体措辞。其他场景（如 sdd-propose）给出了完整的输出格式示例，sdd-ship 却没有。
- **建议:** 明确 sdd-ship 的完成消息格式，例如：`✓ SDD 流程完成 — 变更已归档`，并说明是否仍使用 `━━━` 分隔线。

### [severity: minor] 文档场景断言过于模糊
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "CLAUDE.md contains SDD flow explanation" / §Scenario "README.md contains SDD flow explanation"
- **描述:** 两个文档场景的 THEN 断言分别是"文档包含说明 SDD 流程独立于 OPSX 的段落"和"文档说明何时使用 SDD 流程 vs 直接使用 OPSX"。这些断言无法验证——任何包含"SDD"和"OPSX"这两个词的段落都能通过。同时，CLAUDE.md 场景要求"包含误操作恢复指南"但未定义指南的内容和格式。
- **建议:** 为文档场景提供更具体的断言，至少应包含：(1) 必须出现的关键短语（如"SDD 流程独立于 OPSX"）；(2) 误操作恢复指南的步骤数量和格式要求。

### [severity: minor] brainstorm 验收标准仍未被引用
- **位置:** specs/sdd-post-logic-enhancement/spec.md — 全局
- **描述:** R1 已指出 spec 未引用 brainstorm.md 的量化验收标准（"主流程无泄露"、"SDD 引导可见"、"误操作可恢复"）。本轮仍未补充。这些验收标准是可测试的，应与 spec 场景建立映射关系。
- **建议:** 在 spec 中添加注释或 Requirement，明确映射关系。例如：Requirement 1 的场景群对应验收标准 2（"SDD 引导可见"），错误路径场景对应验收标准 3（"误操作可恢复"）。

### [severity: minor] brainstorm 建议修改 13 个 SKILL.md 但 spec 范围为 6 个，差异未说明
- **位置:** specs/sdd-post-logic-enhancement/spec.md — Requirement 1
- **描述:** brainstorm.md 的"短期方案"列出 13 个 SKILL.md 需要修改（含 sdd-brainstorm、sdd-plan 等不调用 OPSX 的 action）。spec 和 proposal 正确地将范围缩小为 6 个调用 OPSX 的 action。这是一个合理的范围修正，但 spec 没有说明为什么与 brainstorm 的建议不同。
- **建议:** 在 spec 的 Requirement 1 中添加简短说明，例如："brainstorm.md 建议修改 13 个 SKILL.md，但经分析仅 6 个 action 调用 OPSX 命令，因此范围缩减为 6 个。"（注意：tasks.md 已正确反映 6 个 action 的范围）

## Approved

- [x] 场景完整性 — 6 个 OPSX-calling action 全部有独立场景，格式场景和文档场景补充完整，仅缺错误路径
- [ ] 可测试性 — sdd-quick 的"或"断言、sdd-ship 的模糊完成消息、文档场景的泛化断言仍不可测试
- [x] 一致性 — spec 范围（6 个 action）与 proposal.md 和 tasks.md 一致，格式设计与 brainstorm 决策 3 一致
- [ ] 决策追溯 — spec 未引用 brainstorm 的验收标准，未说明与 brainstorm 建议范围的差异
- [x] 范围控制 — 正确限定为 6 个调用 OPSX 的 action，明确列出不涉及的 7 个 action
- [x] 跨模块一致性 — 仅涉及 ai-tools-bridge 模块，无跨模块影响

## 结论

**NEEDS_REVISION**

需要修订的优先项：
1. [major] 消除 sdd-quick 场景的"或"断言，改为基于条件的明确断言或拆分为两个场景
2. [major] 补充错误路径场景（OPSX 失败时的容错 + 误操作恢复）
3. [minor] 明确 sdd-ship 完成消息的具体格式
4. [minor] 细化文档场景的断言（关键短语 + 恢复指南格式）
5. [minor] 添加 brainstorm 验收标准的引用映射

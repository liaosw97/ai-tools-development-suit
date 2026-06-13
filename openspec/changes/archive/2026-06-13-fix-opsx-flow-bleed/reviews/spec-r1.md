# Spec Review — Round 1

**审查对象:** specs/sdd-post-logic-enhancement/spec.md
**日期:** 2026-06-11

## 总结

spec.md 定义了 4 个 Requirement，覆盖 SDD 后置逻辑增强的核心目标：统一流程指引格式、视觉分隔、上下文适配、文档更新。整体方向与 proposal 和 brainstorm 的决策一致，但存在若干质量问题：所有场景缺少 GIVEN 前置条件（违反 GIVEN/WHEN/THEN 格式规范）、12 个 action 中仅 3 个有具体场景描述（其余用模糊措辞带过）、错误路径和边界条件完全缺失。需要修订后方可进入实现阶段。

## Issues

### [severity: critical] 所有场景缺少 GIVEN 前置条件
- **位置:** specs/sdd-post-logic-enhancement/spec.md — 全部 8 个场景
- **描述:** 所有场景仅使用 WHEN/THEN 格式，缺少 GIVEN 条件。根据项目约定（CLAUDE.md: "规格场景：GIVEN/WHEN/THEN 格式"），场景必须描述前置状态。当前 spec 无法让读者知道场景执行的前提条件是什么（如：change 目录是否存在、proposal.md 是否已生成）。
- **建议:** 为每个场景补充 GIVEN 条件。例如：
  - Scenario "User completes sdd-propose": `GIVEN user has an active change directory with brainstorm.md`
  - Scenario "Post-ship guidance": `GIVEN sdd-ship has completed all archival steps`

### [severity: critical] 场景覆盖严重不足 — 12 个 action 仅覆盖 3 个
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Requirement 1
- **描述:** Requirement 1 声称覆盖"any SDD action"，但仅提供了 sdd-propose、sdd-ff、sdd-code 三个具体场景。其余 9 个 action（sdd-continue、sdd-brainstorm、sdd-plan、sdd-review-spec、sdd-review-code、sdd-test-code、sdd-verify、sdd-ship、sdd-quick）没有具体场景。Requirement 3 补充了 post-brainstorm、post-plan、post-ship 三个场景，但仍有 6 个 action 完全没有场景覆盖。
- **建议:** 为每个 SDD action 补充独立场景，或至少在 Requirement 1 中明确列出所有 12 个 action 的预期输出格式。参考 brainstorm.md 中已列出的 12 个 SKILL.md 文件清单。

### [severity: major] 场景描述不可测试 — "with next actions specific to post-xx state"
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Scenario "User completes sdd-ff" / §Scenario "User completes sdd-code"
- **描述:** 场景 2 和场景 3 的 THEN 断言使用了模糊措辞 "with next actions specific to post-ff state" 和 "with next actions specific to post-code state"，没有给出具体的预期输出。这使得场景无法转化为自动化测试——测试代码无法判断"specific to post-ff state"到底意味着什么。
- **建议:** 为每个场景提供完整的预期输出示例（如同场景 1 那样）。至少应列出每个 action 完成后的 ★○△ 推荐操作列表。

### [severity: major] 范围隐含扩展 — 修改不调用 OPSX 的 action
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Requirement 1 "After any SDD action that invokes an OPSX command"
- **描述:** Requirement 1 的描述限定为"invokes an OPSX command"的 action，但 tasks.md 和 proposal.md 列出了 12 个 SKILL.md 需要修改，其中包括不调用 OPSX 的 action（sdd-brainstorm 委托 superpowers:brainstorming、sdd-plan 委托 superpowers:writing-plans、sdd-code 委托 superpowers 系列、sdd-review-spec 使用 SDD 自有子代理、sdd-review-code 使用 SDD 子代理、sdd-test-code 委托 superpowers:test-driven-development）。为不调用 OPSX 的 action 添加"请忽略 OPSX 建议"的指引在逻辑上不成立，会让用户困惑。
- **建议:** 两种路径择一：(1) 将范围限定为实际调用 OPSX 的 6 个 action（sdd-propose、sdd-continue、sdd-ff、sdd-quick、sdd-verify、sdd-ship），相应更新 tasks.md；(2) 明确说明所有 12 个 action 都需要统一流程指引，但对不调用 OPSX 的 action 去掉"请忽略 OPSX 建议"的警告文字。

### [severity: major] 缺少错误路径场景
- **位置:** specs/sdd-post-logic-enhancement/spec.md — 全局
- **描述:** brainstorm.md 的"误操作恢复方案"描述了用户误执行 OPSX 命令后的恢复路径，但 spec 中没有任何错误路径场景覆盖以下情况：
  1. OPSX 命令执行失败时，SDD 后置逻辑是否仍显示流程指引？
  2. 用户误执行 OPSX 命令后，如何通过 SDD 流程恢复？（brainstorm 提到了 /sdd-doctor 和 /sdd-continue）
  3. SDD action 部分成功（如 OPSX 成功但后置逻辑失败）时的行为？
- **建议:** 至少补充 2 个错误路径场景：(1) OPSX 命令失败时的后置逻辑行为；(2) 用户误执行 OPSX 后的恢复指引（可在文档 Requirement 中覆盖）。

### [severity: minor] 数量声明需核实 — "12 SDD actions"
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Requirement 2 line 34
- **描述:** spec 声称"across all 12 SDD actions"。根据 ai-tools-bridge/CLAUDE.md 的架构表，共有 14 个 SDD action（含 sdd-doctor 和 sdd-role），排除这 2 个后确实是 12 个。但 spec 和 proposal 都没有明确说明排除 sdd-doctor 和 sdd-role 的理由（虽然 brainstorm 提到 sdd-doctor 无 OPSX 调用）。sdd-role 同样不调用 OPSX，但排除原因未在 spec 中记录。
- **建议:** 在 spec 的 Requirement 或上下文中明确列出 12 个 action 的清单，以及排除 sdd-doctor 和 sdd-role 的理由。

### [severity: minor] ★○△ 标记分配规则未定义
- **位置:** specs/sdd-post-logic-enhancement/spec.md §Requirement 2 / §Requirement 3
- **描述:** spec 提到使用 ★○△ 标记区分优先级（★ recommended, ○ optional, △ alternative），但没有定义分配规则。例如：什么条件下一个 action 被标记为 ★ 而非 ○？sdd-propose 完成后 /sdd-ff 是 ★、/sdd-continue 是 ○、/sdd-brainstorm 是 △——这个分配的依据是什么？这会导致实现时对每个 action 的标记产生分歧。
- **建议:** 在 spec 中补充标记分配规则，或引用 design.md 中的 Decision 4 作为依据。至少为 Requirement 3 的每个场景明确 ★○△ 的分配。

### [severity: minor] 未引用 brainstorm 验收标准
- **位置:** specs/sdd-post-logic-enhancement/spec.md — 全局
- **描述:** brainstorm.md 包含量化的验收标准（"主流程无泄露"、"SDD 引导可见"、"误操作可恢复"），这些标准是可测试的。但 spec 没有引用这些验收标准，也没有在场景中体现。proposal.md 正确引用了 brainstorm 的决策，但 spec 层面缺失了这个追溯链。
- **建议:** 在 spec 中添加一个 Requirement 或注释，明确映射到 brainstorm 的验收标准。例如：场景"User completes sdd-propose and sees SDD flow guidance"对应验收标准 2（"SDD 引导可见"）。

## Approved

- [ ] 场景完整性 — 12 个 action 仅覆盖 6 个（含 Requirement 3），缺少 GIVEN 条件，缺少错误路径
- [ ] 可测试性 — 3 个场景有具体输出格式，其余场景断言模糊不可测试
- [x] 一致性 — spec 的 12 个 action 数量与 proposal/tasks.md 一致（排除 sdd-doctor 和 sdd-role），格式设计与 brainstorm 决策 3 一致
- [ ] 决策追溯 — spec 未引用 brainstorm 的决策和验收标准（proposal 已正确引用）
- [ ] 范围控制 — 隐含扩展到不调用 OPSX 的 action，超出问题描述范围
- [x] 跨模块一致性 — 仅涉及 ai-tools-bridge 模块，无跨模块影响

## 结论

**NEEDS_REVISION**

需要修订的优先项：
1. [critical] 为所有场景补充 GIVEN 条件
2. [critical] 补充剩余 6 个 action 的具体场景
3. [major] 消除"with next actions specific to post-xx state"的模糊断言
4. [major] 明确修改范围：限定为调用 OPSX 的 6 个 action，或为不调用 OPSX 的 action 去掉 OPSX 相关警告
5. [major] 补充错误路径场景

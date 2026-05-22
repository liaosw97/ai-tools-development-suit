# Spec Review — Round 4

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-21

## 总结

上一轮（r3）发现 7 个 minor 问题，本轮已全部修复。修正内容如下：

| # | 问题描述 | 修复方式 |
|---|---------|---------|
| 1 | limits-config 缺少 sdd-doctor 读取配置场景 | 新增"sdd-doctor 读取 limits 配置值"场景，描述读取和默认值回退逻辑 |
| 2 | review-limit-fallback 缺少"继续修复后如何退出"边界条件 | 新增边界条件：每轮结束再次提供选项、AI 无法解决时用户可接受并退出 |
| 3 | quick-limit-fallback 场景/任务达限缺少"不给用户选择"说明 | 新增设计说明块，明确与提问达限的区别及原因 |
| 4 | limits-config 边界条件与场景重复 | 保留边界条件作为简洁列表，场景详细描述处理逻辑，两者互补 |
| 5 | 缺少 sdd-review-code/sdd-review-spec 范围说明 | limits-config 新增"范围说明"节，proposal.md 新增排除项 |
| 6 | 达限提示消息格式未明确 | 新增"关键信息要求"说明，允许语义等价表述 |
| 7 | sdd-doctor 输出格式未明确 | 新增输出格式示例 |

## Issues

无。

## Approved

- [x] 场景完整性 — limits-config 新增 sdd-doctor 读取配置场景；review-limit-fallback 补充退出边界条件；quick-limit-fallback 补充设计说明
- [x] 可测试性 — 达限提示消息定义关键信息要求；sdd-doctor 输出提供格式示例
- [x] 一致性 — 三个 spec 文件之间无矛盾，与 proposal 范围一致
- [x] 决策追溯 — proposal.md 正确引用了 brainstorm.md 的 5 个关键决策，spec 与决策方向一致
- [x] 范围控制 — proposal.md 新增排除项，limits-config 新增范围说明节，明确排除 sdd-review-code/sdd-review-spec
- [x] 跨模块一致性 — limits-config spec 明确说明涉及的 action 和排除的 action

## 结论

APPROVED — 所有 r3 issues 已修复，spec 质量通过审查
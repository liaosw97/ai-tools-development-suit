# Spec Review — Round 2

**审查对象:** specs/ 目录下所有 spec 文件（cli-scripts.md、skill-integration.md、testing.md）
**日期:** 2026-05-31
**Round 1 修复验证:** 全部通过

## 总结

Round 1 发现的 8 个问题（2 个 major、6 个 minor）已全部修复。修复质量良好，场景覆盖完整，格式统一。新发现 5 个 minor 级别问题，主要集中在描述一致性和歧义性方面，不影响整体 spec 质量，建议在实施阶段一并修复。

## Round 1 修复验证

| 问题 | 修复状态 | 验证结果 |
|------|----------|----------|
| [major] compress-review.mjs 缺少 spec 文件不存在的错误路径 | ✅ 已修复 | 场景已添加（cli-scripts.md 第 93-100 行） |
| [major] summarize-tasks.mjs 缺少边界条件场景 | ✅ 已修复 | 新增 2 个场景（cli-scripts.md 第 55-71 行） |
| [major] summarize-tasks.mjs GIVEN 未包含 `- [x]` | ✅ 已修复 | GIVEN 已修改为包含 `- [ ]` 和 `- [x]`（cli-scripts.md 第 39 行） |
| [minor] testing.md 断言模糊 | ✅ 已修复 | 断言已具体化（testing.md 第 35 行） |
| [minor] state-file 端到端正则模糊 | ✅ 已修复 | 断言已具体化（testing.md 第 59-62 行） |
| [minor] sdd-verify 缺少参数占位符 | ✅ 已修复 | 参数占位符已补充（skill-integration.md 第 36-37 行） |
| [minor] 缺少 [ADDED] 标记 | ✅ 已修复 | 所有场景标题已添加 [ADDED] 标记 |
| [minor] compress-review 缺少 spec 无场景边界 | ✅ 已修复 | 场景已添加（cli-scripts.md 第 103-109 行） |

## Issues（仅列出新发现的问题）

### [severity: minor] cli-scripts.md summarize-spec.mjs 场景的 THEN 描述不够具体
- **位置:** specs/cli-scripts.md §summarize-spec.mjs
- **描述:** "输出包含场景名称和 GIVEN/WHEN/THEN 摘要的文本" 描述模糊，testing.md 中的端到端测试场景有更明确的格式描述。
- **建议:** 统一描述为 "输出格式为每行 '场景: <name>' 后跟 GIVEN/WHEN/THEN 缩进行"

### [severity: minor] testing.md summarize-tasks 端到端场景缺少输出格式描述
- **位置:** specs/testing.md §summarize-tasks 端到端
- **描述:** THEN 只说 "输出任务总数 5、已完成 3、待完成 2"，没有说明输出格式。
- **建议:** 补充输出格式描述，例如 "输出格式为 '总数: 5, 已完成: 3, 待完成: 2'"

### [severity: minor] testing.md compress-review 端到端场景缺少输出格式描述
- **位置:** specs/testing.md §compress-review 端到端
- **描述:** THEN 只说 "输出包含变更文件列表和匹配场景的结构化内容"，没有具体说明格式。
- **建议:** 补充结构化内容的格式描述

### [severity: minor] cli-scripts.md tasks 文件为空场景的 THEN 描述有歧义
- **位置:** specs/cli-scripts.md §summarize-tasks.mjs
- **描述:** "输出任务总数 0 或提示'无任务'" 中的 "或" 关系不明确。
- **建议:** 选择一个确定的行为，例如 "输出任务总数 0"

### [severity: minor] testing.md 所有脚本 node 直接执行无错误场景的 WHEN 描述有歧义
- **位置:** specs/testing.md §脚本可执行性测试
- **描述:** "对每个脚本运行 `node scripts/<name>.mjs --help` 或无参数调用" 中的 "或" 关系不明确。
- **建议:** 明确为两个独立的测试场景，或者选择一个确定的行为

## Approved

- [x] 场景完整性 — 正常路径、错误路径、边界条件覆盖完整（15 + 7 + 7 = 29 个场景）
- [x] 可测试性 — WHEN/THEN 基本可转化为自动化测试，minor 描述歧义不影响实施
- [x] 一致性 — spec 间无矛盾，与 proposal 一致，格式统一
- [x] 决策追溯 — 与 brainstorm 决策一致，无已否决方案出现
- [x] 范围控制 — 不超出 proposal 范围（4 个脚本 + 6 个 SKILL.md 集成 + 测试）
- [x] 跨模块一致性 — 单模块项目（ai-tools-bridge），自动通过

## 结论

**APPROVED**

Round 1 修复全部通过验证，spec 质量良好。新发现的 5 个 minor 问题均为描述一致性和歧义性问题，不影响实施启动。建议在实施阶段一并修复这些 minor 问题。

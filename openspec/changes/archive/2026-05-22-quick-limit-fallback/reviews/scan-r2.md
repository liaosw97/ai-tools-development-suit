# 规范扫描报告 — quick-limit-fallback

**扫描批次**: r1
**工作类型**: skill 开发
**扫描状态**: SCANNED

## 扫描结果

### 扫描工具: 结构化审查

| 维度 | 级别 | 描述 | 修复建议 |
|------|------|------|---------|
| frontmatter 完整性 | info | 4 个 SKILL.md 均包含完整的 YAML frontmatter（name、description） | 无需修复 |
| 触发条件完整性 | info | 4 个 SKILL.md 均包含"触发"、"不触发"、"歧义处理"三个决策门 | 无需修复 |
| 输出约束完整性 | info | 4 个 SKILL.md 均定义了明确的输出约束（禁止输出项、零结果防护等） | 无需修复 |
| 硬编码路径 | minor | sdd-quick SKILL.md 第 74 行引用 `reference-grill.md` 使用相对路径，依赖 skill 执行时的 CWD | 建议使用相对于 SKILL.md 的路径或明确说明路径解析规则 |
| 硬编码路径 | minor | sdd-quick SKILL.md 第 143 行引用 `reference-tdd-compact.md` 使用相对路径 | 同上 |
| 引用一致性 | info | sdd-quick 引用的 `reference-grill.md` 和 `reference-tdd-compact.md` 均存在于同目录 | 无需修复 |
| 引用一致性 | info | sdd-brainstorm 引用的 `brainstorm-reviewer-prompt.md` 存在于同目录 | 无需修复 |
| 引用一致性 | info | sdd-plan 引用的 `plan-reviewer-prompt.md` 存在于同目录 | 无需修复 |
| 模板引用一致性 | info | sdd-brainstorm 第 68 行引用 `schemas/sdd/templates/brainstorm.md`，该文件存在 | 无需修复 |
| 模板引用一致性 | info | sdd-plan 第 94 行引用 `schemas/sdd/templates/plan.md`，该文件存在 | 无需修复 |
| 过宽触发 | info | 4 个 SKILL.md 的触发条件均包含明确的用户意图关键词，无过宽触发风险 | 无需修复 |
| 模糊描述 | info | 所有描述均使用具体动词和可验证条件，无模糊描述 | 无需修复 |
| 达限处理完整性 | info | sdd-quick 包含完整的提问达限、场景达限、任务达限处理逻辑，含用户选项和可发现性提示 | 无需修复 |
| 达限处理完整性 | info | sdd-brainstorm 和 sdd-plan 包含完整的 review 达限处理逻辑，含"继续修复"和"接受并继续"选项 | 无需修复 |
| 配置值验证 | info | 4 个 SKILL.md 均包含配置值验证逻辑（不存在/非数字/零或负数 → 使用默认值） | 无需修复 |
| sdd-doctor 特殊检查 | info | sdd-doctor 包含 Evidence completeness ceiling 规则（需采集至少 2 个高权重维度才能评级），防止数据不足时给出误导性评级 | 无需修复 |

## 总结

- critical: 0 项
- major: 0 项
- minor: 2 项
- info: 13 项

## 结论

[SCANNED] 扫描完成，发现 2 个 minor 问题

**问题摘要**：
1. `sdd-quick/SKILL.md` 第 74 行和第 143 行引用参考文件使用相对路径 `reference-grill.md` 和 `reference-tdd-compact.md`，未明确说明路径解析规则。当前这些文件与 SKILL.md 同目录，实际可正常工作，但建议在文档中明确说明路径是相对于 SKILL.md 所在目录解析。

**整体评价**：4 个 SKILL.md 结构完整，决策门清晰，达限处理逻辑健全，引用文件均存在。质量符合 SDD skill 开发规范。
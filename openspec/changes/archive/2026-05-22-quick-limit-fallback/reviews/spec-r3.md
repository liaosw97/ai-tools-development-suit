# Spec Review — Round 3

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-21

## 总结

上一轮（r2）结论为 APPROVED。本轮进行独立审查，发现 7 个 minor 级别问题。整体质量良好，三个 spec 文件均采用 GIVEN/WHEN/THEN 格式，场景覆盖了正常路径、错误路径和边界条件。决策追溯完整，proposal.md 正确引用了 brainstorm.md 的 5 个关键决策。范围控制得当，未超出 proposal 定义的范围。问题主要集中在可测试性细节和边界条件补充。

## Issues

### [severity: minor] limits-config spec 缺少 sdd-doctor 读取配置的场景

- **位置:** specs/limits-config/spec.md
- **描述:** spec 提到 sdd-doctor 需要输出 limits 配置状态，但场景列表中只有"sdd-doctor 输出 limits 配置状态"一个场景，缺少 sdd-doctor 如何读取配置的前置场景。proposal.md 明确 sdd-doctor 需要读取 limits 配置，这与 limits-config 的核心能力（配置读取）直接相关。
- **建议:** 在 limits-config spec 中补充一个场景："sdd-doctor 读取 limits 配置值"，描述 sdd-doctor 如何读取配置并处理默认值回退。或明确说明 sdd-doctor 的配置读取行为由 limits-config spec 统一定义，避免重复。

### [severity: minor] review-limit-fallback spec 缺少"用户选择继续修复后仍无 issues 解决"的边界条件

- **位置:** specs/review-limit-fallback/spec.md §边界条件
- **描述:** 边界条件提到"用户选择'继续修复'后多轮仍有 issues：无上限，直到所有 issues 解决或用户主动选择接受"，但缺少一个具体场景描述：如果用户选择"继续修复"后，AI 多轮修复仍无法解决某些 issues（如技术限制或需求冲突），用户如何退出？是否需要再次提供"接受并继续"选项？
- **建议:** 补充边界条件或场景：用户选择"继续修复"后，每轮修复结束时是否再次提供选项？还是仅在用户主动请求时才提供退出选项？明确交互终止条件。

### [severity: minor] quick-limit-fallback spec 场景/任务达限缺少"用户选择"的明确描述

- **位置:** specs/quick-limit-fallback/spec.md §场景数量达到上限 / §任务数量达到上限
- **描述:** 这两个场景标记为 `MODIFIED`，但 THEN 部分只描述了"停止生成并提示"，没有给用户选择。而 proposal.md 和 brainstorm.md 明确说明场景/任务达限是"停止并提示可配置"，与提问达限（给用户选择）不同。spec 正确反映了决策，但建议在 spec 中明确说明"此场景不给用户选择，仅提示可配置"，以避免与提问达限场景混淆。
- **建议:** 在场景描述中补充说明："此场景不给用户选择，仅停止生成并提示可配置性。与提问达限场景不同，场景/任务达限不提供'继续生成'选项，因为生成内容的质量难以在达限后保证。"

### [severity: minor] limits-config spec 边界条件与场景重复

- **位置:** specs/limits-config/spec.md §边界条件 / §配置值为非法类型时回退默认值
- **描述:** 边界条件部分列出了"config.yaml 文件不存在"、"limits 节存在但值为非数字"、"limits 节中配置项值为 0 或负数"三种情况，但最后一个场景"配置值为非法类型时回退默认值"又重复描述了非数字和无效值的情况。建议合并或明确区分。
- **建议:** 将边界条件部分整合为场景，或删除重复的场景，保留边界条件作为简洁的边界情况列表。

### [severity: minor] 跨模块一致性：缺少 sdd-review-code 和 sdd-review-spec 的 limits 配置说明

- **位置:** specs/limits-config/spec.md
- **描述:** proposal.md 范围中提到"修改 sdd-doctor SKILL.md"，但未明确 sdd-review-code 和 sdd-review-spec 是否也受 limits 配置影响。brainstorm.md 的决策 4 表格中只列出了 sdd-quick、sdd-brainstorm、sdd-plan 三个 action。但 sdd-review-code 和 sdd-review-spec 也可能存在 review 循环或上限。spec 应明确说明这些 action 是否在本次变更范围内，或明确排除。
- **建议:** 在 limits-config spec 中补充说明：sdd-review-code 和 sdd-review-spec 当前无硬编码上限，不在本次变更范围内。或在 proposal.md 的"不包含"部分明确排除。

### [severity: minor] 可测试性：达限提示消息的具体格式未明确

- **位置:** specs/limits-config/spec.md §达限提示包含可发现性信息
- **描述:** THEN 部分要求"提示消息末尾附加：'可在 openspec/config.yaml 的 limits 节中调整上限'"，但未明确这是否为精确字符串匹配。测试用例需要知道是否允许轻微的措辞变化。
- **建议:** 明确提示消息是精确匹配还是允许语义等价的变体。例如："提示消息必须包含以下关键信息：配置文件路径、配置节名称、可调整上限的说明。"

### [severity: minor] 可测试性：sdd-doctor 输出格式未明确

- **位置:** specs/limits-config/spec.md §sdd-doctor 输出 limits 配置状态
- **描述:** THEN 部分要求"报告中包含'限制配置'节"，但未明确输出格式（表格、列表、键值对？）。测试用例需要知道如何验证输出。
- **建议:** 补充输出格式示例，例如：
  ```
  ## 限制配置
  - quick-questions: 5 (默认值)
  - quick-scenarios: 8
  - quick-tasks: 10 (默认值)
  - review-rounds: 3 (默认值)
  ```

## Approved

- [x] 场景完整性 — 场景覆盖了正常路径、错误路径、边界条件，但 sdd-doctor 读取配置场景可补充
- [x] 可测试性 — 大部分场景可转化为自动化测试，但提示消息和 doctor 输出格式需明确
- [x] 一致性 — 三个 spec 文件之间无矛盾，与 proposal 范围一致
- [x] 决策追溯 — proposal.md 正确引用了 brainstorm.md 的 5 个关键决策，spec 与决策方向一致
- [x] 范围控制 — spec 仅包含 proposal 范围内的内容，无隐含功能扩展
- [x] 跨模块一致性 — 已识别 sdd-review-code/sdd-review-spec 的潜在影响，建议明确排除

## 结论

**NEEDS_REVISION** — 存在 7 个 minor 级别问题，建议修复后重新审查。主要问题集中在：
1. 可测试性细节（提示消息格式、doctor 输出格式）
2. 边界条件与场景的重复/遗漏
3. 跨模块一致性说明（明确排除 sdd-review-code/sdd-review-spec）

所有问题均为 minor 级别，不影响核心功能设计，但修复后将提高 spec 的可执行性和测试覆盖率。
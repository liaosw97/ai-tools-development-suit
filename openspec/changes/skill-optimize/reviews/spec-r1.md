# Spec Review — Round 1

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-06-01

## 总结

spec 文件整体质量良好，结构清晰，使用了规范的 WHEN/THEN 格式描述场景。15 个 spec 文件（1 个 ADDED + 14 个 MODIFIED）与 proposal.md 的范围基本一致，Delta Spec 标记正确。主要问题集中在：(1) 共享模块引用数量不一致，缺乏明确的引用规则；(2) 部分场景断言不够具体，难以转化为自动化测试；(3) 降级策略覆盖不完整，只有 shared-skill-modules 描述了 include 失败的处理方式。建议在修订时重点关注这些问题，以提高 spec 的可测试性和一致性。

## Issues

### [major] 共享模块引用数量不一致
- **位置:** 多个 spec 文件
- **描述:** shared-skill-modules 定义了 5 个共享模块（base-triggers、output-constraints、role-loading、breakdown-mode、review-loop），但各 skill 引用的共享模块数量从 2 到 5 不等：
  - sdd-brainstorm: 5 个（全部引用）
  - sdd-plan: 4 个（缺少 breakdown-mode）
  - sdd-code: 3 个（缺少 breakdown-mode、review-loop）
  - sdd-quick: 2 个（仅 base-triggers、output-constraints）
  - sdd-ship/sdd-doctor/sdd-role/sdd-propose/sdd-verify/sdd-test-code/sdd-ff/sdd-review-spec/sdd-continue: 2-3 个
- **建议:** 在 shared-skill-modules/spec.md 中明确说明每个共享模块的适用场景和引用规则，或在各 skill spec 中说明为什么选择引用特定的共享模块。

### [major] 内容完整性场景断言不具体
- **位置:** specs/shared-skill-modules/spec.md §共享模块内容完整性
- **描述:** 多个场景的断言过于笼统，难以转化为自动化测试：
  - "包含通用触发条件模板（触发/不触发/歧义处理格式）"
  - "包含输出约束（禁止输出列表）和零结果与幻觉防护规则"
  - "包含完整的角色加载逻辑（参数解析、查找、降级、错误处理）"
- **建议:** 将断言细化为可验证的结构化内容，例如："base-triggers.md 包含 '## 触发条件'、'## 不触发条件'、'## 歧义处理' 三个子节"。

### [major] 降级策略覆盖不完整
- **位置:** 大部分 MODIFIED spec 文件
- **描述:** 只有 shared-skill-modules/spec.md 描述了 include 解析失败的降级场景（文件不存在、路径错误），其他 14 个 skill spec 均未说明当共享模块 include 失败时如何处理。
- **建议:** 在各 skill spec 中增加降级场景，或在 shared-skill-modules 中明确说明降级策略适用于所有引用共享模块的 skill。

### [minor] Token 减少场景过于简单
- **位置:** 多个 MODIFIED spec 文件
- **描述:** 大部分 skill spec 的 "Token 减少" 场景只是简单对比改造前后的行数（如 "从 472 行减少至约 180 行（减少 62%）"），缺乏更详细的验证维度。
- **建议:** 考虑增加以下验证维度：
  - 改造后的 SKILL.md 是否仍然可独立理解（不依赖共享模块）
  - 共享模块的加载是否引入额外的 token 开销
  - 总 token 消耗（SKILL.md + 共享模块）是否真正减少

### [minor] 部分场景缺乏错误路径描述
- **位置:** specs/sdd-code/spec.md §Worktree 准备、specs/sdd-code/spec.md §目录冲突检测
- **描述:** 这些场景只描述了正常路径，未说明失败时的处理方式：
  - Worktree 创建失败时如何处理？
  - 用户拒绝创建 Worktree 时如何处理？
  - 目录冲突检测失败时如何处理？
- **建议:** 增加错误路径场景，明确失败时的降级策略或用户提示。

### [minor] 隐含功能扩展
- **位置:** specs/sdd-plan/spec.md §任务规模检测、specs/sdd-plan/spec.md §分批生成模式、specs/sdd-code/spec.md §目录冲突检测
- **描述:** 这些场景描述的功能可能超出了 proposal.md 的范围。proposal 只提到"改造为引用共享模块，保留差异内容"，未提及新增任务规模检测、分批生成模式、目录冲突检测等功能。
- **建议:** 确认这些功能是否属于"保留差异内容"的范畴。如果是，请在 proposal.md 中补充说明；如果不是，请从 spec 中移除。

### [minor] 缺少配置读取的具体路径
- **位置:** specs/sdd-quick/spec.md §Limits 配置读取
- **描述:** 场景描述了读取 `openspec/config.yaml` 的 `limits` 节，但未说明：
  - 如果 config.yaml 不存在时如何处理？
  - 如果 limits 节不存在时如何处理？
  - 默认值是否在代码中硬编码？
- **建议:** 增加配置文件不存在或配置项缺失时的降级场景。

## Approved
- [x] 场景完整性 — 大部分 spec 使用 WHEN/THEN 格式，覆盖了正常路径和部分边界条件
- [ ] 可测试性 — 部分场景断言不够具体，难以转化为自动化测试
- [x] 一致性 — spec 之间无明显矛盾，Delta Spec 标记正确
- [x] 决策追溯 — proposal 引用了 brainstorm 的关键决策，spec 与决策方向一致
- [ ] 范围控制 — 部分 spec 包含可能超出 proposal 范围的功能
- [x] 跨模块一致性 — 单模块项目，自动通过

## 结论

**NEEDS_REVISION**

spec 文件整体结构良好，但存在 3 个 major 问题需要修订：
1. 共享模块引用数量不一致，缺乏明确的引用规则
2. 内容完整性场景断言不具体，难以转化为自动化测试
3. 降级策略覆盖不完整，需要在各 skill spec 中补充说明

建议修订后重新审查。

# Spec Review — Round 1

**审查对象:** specs/ 目录下所有 spec 文件（cli-scripts.md、skill-integration.md、testing.md）
**日期:** 2026-05-31

## 总结

三个 spec 文件整体结构清晰，场景基本遵循 GIVEN/WHEN/THEN 格式，与 proposal 和 brainstorm 的决策方向一致。主要问题集中在：(1) 部分边界条件覆盖不足；(2) 个别 THEN 断言过于模糊，可测试性受限；(3) 缺少 ADDED/MODIFIED/REMOVED 增量标记。这些问题不影响整体方向，但需要补充后才能进入实施。

## Issues

### [severity: major] compress-review.mjs 缺少 spec 文件不存在的错误路径
- **位置:** specs/cli-scripts.md §compress-review.mjs
- **描述:** 场景覆盖了 diff 文件为空的情况，但没有覆盖 spec 文件不存在的情况。作为接受两个输入参数的脚本，两个参数的错误路径都应有场景覆盖。
- **建议:** 新增场景：
  ```
  ### 场景: spec 文件不存在

  GIVEN 一个有效的 diff 文件路径和一个不存在的 spec 文件路径
  WHEN 运行 `node scripts/compress-review.mjs <diff-path> <invalid-spec-path>`
  THEN 输出错误信息到 stderr
  AND 退出码为非 0
  ```

### [severity: major] summarize-tasks.mjs 缺少边界条件场景
- **位置:** specs/cli-scripts.md §summarize-tasks.mjs
- **描述:** 只覆盖了"正常 tasks.md"和"文件不存在"两种情况，缺少两个重要边界条件：(1) tasks.md 存在但无任何 checkbox 行；(2) tasks.md 为空文件。这两种情况在实际工作流中可能出现（例如 tasks.md 刚创建但尚未填写内容）。
- **建议:** 新增两个场景：
  ```
  ### 场景: tasks 文件无 checkbox

  GIVEN 一个不包含 `- [ ]` 或 `- [x]` 的 tasks.md 文件
  WHEN 运行 `node scripts/summarize-tasks.mjs <tasks-path>`
  THEN 输出任务总数 0
  AND 退出码为 0

  ### 场景: tasks 文件为空

  GIVEN 一个空的 tasks.md 文件
  WHEN 运行 `node scripts/summarize-tasks.mjs <tasks-path>`
  THEN 输出任务总数 0 或提示"无任务"
  AND 退出码为 0
  ```

### [severity: major] summarize-tasks.mjs 缺少 `- [x]` 已完成任务的显式场景
- **位置:** specs/cli-scripts.md §summarize-tasks.mjs
- **描述:** GIVEN 描述只提到 `- [ ]` checkbox，没有提到 `- [x]`。虽然"输出任务总数、已完成数、待完成数"暗示了已完成任务的存在，但 GIVEN 条件应明确包含两种状态的 checkbox，否则测试可能遗漏已完成任务的解析。
- **建议:** 将 GIVEN 修改为：`GIVEN 一个包含 - [ ] 和 - [x] checkbox 的 tasks.md 文件`

### [severity: minor] testing.md 断言过于模糊
- **位置:** specs/testing.md §summarize-spec 端到端
- **描述:** `THEN 输出包含 3 个场景的摘要 AND 输出格式符合预期` 中"输出格式符合预期"不可测试。测试代码无法判断什么是"符合预期"，除非定义具体的输出格式。
- **建议:** 引用 design.md 中定义的输出格式，改为：`AND 输出格式为每行 "场景: <name>" 后跟 GIVEN/WHEN/THEN 缩进行`

### [severity: minor] testing.md state-file 端到端正则过于模糊
- **位置:** specs/testing.md §state-file 端到端
- **描述:** `THEN state.yaml 正确创建、读取和更新` 中"正确"一词不可量化。测试需要知道具体验证什么字段。
- **建议:** 改为：`THEN create 后文件存在且包含 phase 字段 AND read 输出包含 phase: brainstorm AND update 后 phase 字段变为 propose`

### [severity: minor] skill-integration.md sdd-verify 场景缺少参数占位符
- **位置:** specs/skill-integration.md §sdd-verify 集成
- **描述:** THEN 中写的是 `调用 node scripts/summarize-spec.mjs` 但没有像其他场景一样给出 `<spec-path>` 占位符。虽然上下文可以推断，但与其他场景的格式不一致。
- **建议:** 补充参数占位符，改为：`调用 node scripts/summarize-spec.mjs <spec-path>`

### [severity: minor] 缺少 ADDED/MODIFIED/REMOVED 增量标记
- **位置:** 所有 3 个 spec 文件
- **描述:** 根据项目约定，spec 应使用 ADDED/MODIFIED/REMOVED 增量标记。本次变更全部为新增功能（4 个新脚本 + SKILL.md 集成），所有场景应标记为 `[ADDED]`。
- **建议:** 在每个场景标题后添加 `[ADDED]` 标记，例如：`### 场景: 提取 spec 场景列表 [ADDED]`

### [severity: minor] compress-review.mjs 缺少 spec 无场景的边界条件
- **位置:** specs/cli-scripts.md §compress-review.mjs
- **描述:** spec 文件存在但不包含任何 GIVEN/WHEN/THEN 场景时，compress-review 的行为未定义。summarize-spec 有"spec 无场景"场景，但 compress-review 没有对应的场景。
- **建议:** 新增场景：spec 文件无场景时输出"无匹配场景"或类似提示，退出码为 0

## Approved

- [x] 决策追溯 — proposal.md 完整引用了 brainstorm 的 3 个关键决策，spec 与决策方向一致，未出现已否决方案
- [x] 范围控制 — spec 只包含 proposal 范围内的 4 个脚本 + 6 个 SKILL.md 集成 + 测试，无隐含扩展
- [x] 跨模块一致性 — 单模块项目（ai-tools-bridge），自动通过
- [ ] 场景完整性 — 存在 2 个 major 级别边界条件缺失
- [ ] 可测试性 — 存在 2 个 minor 级别断言模糊问题
- [ ] 一致性 — 缺少 ADDED 标记，格式细节不统一

## 结论

**NEEDS_REVISION**

需要修订 2 个 major 问题（边界条件缺失）后可进入实施。minor 问题建议在实施阶段一并修复。整体 spec 质量良好，修改量较小。

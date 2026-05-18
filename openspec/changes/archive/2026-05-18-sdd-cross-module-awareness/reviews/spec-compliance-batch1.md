# Spec Compliance Review -- Batch 1

**日期:** 2026-05-18

## 总结

[10/13] 个场景已实现。2 个 PARTIAL，1 个 MISSING。

## 逐场景审查

---

### specs/propose-impact-scan/spec.md

| 场景 | 状态 | 验证说明 |
|------|------|---------|
| SC-01 | IMPLEMENTED | THEN-1（列出相关模块）：SKILL.md 步骤 1.5 第 3 点"读取现有 specs 内容，识别与当前 proposal 主题相关的模块"覆盖。THEN-2（提示用户确认）：步骤 4 "以下模块可能与本次变更相关：[列表]。是否需要纳入范围？"覆盖。THEN-3（未提及时的警告）：步骤 3 "如未提及 -> 输出警告：'当前 proposal 未提及跨模块影响。项目中存在 N 个模块/领域...'"覆盖。 |
| SC-02 | IMPLEMENTED | THEN-1（内部分析范围）：SKILL.md 步骤 2 "简化为'请确认变更影响的文件/目录范围是否完整'"覆盖。THEN-2/3/4（不修改/不警告/不阻断）：步骤 2 明确"不修改 proposal，跳到步骤 2"，即不修改、不输出跨模块警告、不阻断。 |
| SC-03 | IMPLEMENTED | THEN-1（追加到范围节）：步骤 4 "用户确认纳入 -> 将影响项追加到 proposal.md 的'范围 > 包含'节"覆盖。THEN-2（追加到决策追溯）：步骤 4 同一句"和'决策追溯'节"覆盖。 |
| SC-04 | IMPLEMENTED | THEN-1（输出跳过提示）：步骤 1 "如果 proposal.md 的'范围'节已包含跨模块影响分析段落，输出'已检测到跨模块影响分析，跳过扫描'"覆盖。THEN-2/3（不重复提示/不修改）：跳到步骤 2 即隐含不重复提示和不修改。 |

实现约束验证：
- 步骤编号为"1.5"，位于"决策追溯检查"（步骤 1）之后、"产物校验"（步骤 2）之前 -- 符合。

---

### specs/deferred-capture/spec.md

| 场景 | 状态 | 验证说明 |
|------|------|---------|
| SC-01 | IMPLEMENTED | THEN-1（读取/创建 backlog）：SKILL.md 步骤 2.5 第 3a/3b 点"检查 backlog.md 是否存在 -> 不存在则使用模板创建 -> 已存在则读取"覆盖。THEN-2（追加到表格）：步骤 3d "将新项追加到表格末尾"覆盖。THEN-3（每项包含四字段）：步骤 3d "每项格式：`| 来源变更名 | P1/P2 | 简述 | open |`"覆盖。THEN-4（跳过已完成项）：步骤 2 "如果延后项已有删除线或显式标注'已完成'，跳过该项"覆盖。THEN-5（展示结果并确认）：步骤 3f "展示提取结果，用户确认后继续"覆盖。 |
| SC-02 | IMPLEMENTED | THEN-1（输出跳过提示）：步骤 3 "如果无延后项 -> 输出'proposal 中无延后项，跳过 backlog 更新'"覆盖。THEN-2（继续归档不创建/修改）：同一句"继续归档"隐含不创建/修改 backlog.md。 |
| SC-03 | IMPLEMENTED | THEN-1（追加不覆盖）：步骤 3d "将新项追加到表格末尾"明确追加而非覆盖。THEN-2（相似项提示人工判断）：步骤 3e "如检测到来源变更相同且简述高度相似的已有项，提示用户人工判断是否合并（不自动合并）"覆盖。 |
| SC-04 | IMPLEMENTED | THEN-1（# Backlog 标题）：模板文件 backlog.md 第 1 行 `# Backlog` 覆盖。THEN-2（说明段落）：模板第 3 行 `> 跨变更延后项追踪文件。归档时从 proposal 中提取未完成 P1/P2 项写入。` 覆盖。THEN-3（Markdown 表格列头）：模板第 5 行 `| 来源变更 | 优先级 | 简述 | 状态 |` 覆盖。THEN-4（模板路径）：SKILL.md 步骤 3b "使用 `schemas/sdd/templates/backlog.md` 模板创建"覆盖，且模板实际存在于该路径。 |
| SC-05 | PARTIAL | THEN-1（输出提示）：SKILL.md 步骤 2 第 1 点"输出：'backlog 中有 N 个 open 项，是否有与当前需求相关的？'"覆盖。THEN-2（列出 open 项）：步骤 2 第 2 点"列出所有 open 项的来源变更和简述"覆盖。THEN-3（用户关联时引用到 brainstorm）：步骤 2 第 3 点"用户选择关联 -> 在 brainstorm.md 的'参考资源'中引用该 backlog 项"覆盖。THEN-4（用户忽略不记录）：步骤 2 第 4 点"用户选择忽略 -> 不记录（仅作为上下文参考）"覆盖。**但是**：spec 边界条件指出"backlog.md 存在但为空（仅有标题和表头，无数据行）：视为不存在，不提示"。代码中步骤 2 条件为"如果存在且表格中含状态为 `open` 的项"，这意味着空表格（无 open 项）走 else 分支"跳过，不输出任何 backlog 相关提示"，与边界条件一致。**综合判定 IMPLEMENTED**，但发现 THEN 断言中未明确处理边界条件"存在但无 open 项"的情况，代码实现补充了该处理（在 else 分支），与边界条件对齐。重新审视：SKILL.md 第 36 行"如果不存在或无 open 项：跳过，不输出任何 backlog 相关提示，不创建 backlog.md"已明确覆盖。判定修正为 **IMPLEMENTED**。 |
| SC-06 | IMPLEMENTED | THEN-1/2/3（不输出/不创建/正常继续）：SKILL.md 步骤 2 最后一句"如果不存在或无 open 项：跳过，不输出任何 backlog 相关提示，不创建 backlog.md"覆盖。正常继续由流程隐含（无阻断逻辑）。 |

---

### specs/review-enhancement/spec.md

| 场景 | 状态 | 验证说明 |
|------|------|---------|
| SC-01 | IMPLEMENTED | THEN-1（新增第 6 维度）：spec-reviewer-prompt.md 第 32-37 行新增 `### 6. 跨模块一致性` 覆盖。THEN-2（3 个检查项）：(1) "本次变更是否考虑了对其他模块的影响" 第 33 行覆盖。(2) "共享功能在所有相关模块中的覆盖是否确认" 第 34 行覆盖。(3) "是否有应该同步变更但被遗漏的关联模块" 第 35 行覆盖。THEN-3（非硬性断言，需人工确认）：第 37 行注释 "跨模块一致性的判定依赖审查员对项目结构和 spec 间引用关系的分析，不做硬性断言。所有检查项的结论均为基于分析的判断，需人工确认" 覆盖。 |
| SC-02 | IMPLEMENTED | THEN-1（Approved 清单增加勾选项）：第 65 行 `- [ ] 跨模块一致性` 覆盖。THEN-2（位于范围控制之后）：第 64 行为"范围控制"，第 65 行为"跨模块一致性"，顺序正确。THEN-3（Issues 区域可包含跨模块问题，severity 按影响范围判定）：第 39 行 HTML 注释 `<!-- Issues severity 说明：跨模块一致性问题的 severity 根据遗漏影响范围判定为 minor/major/critical -->` 覆盖。 |
| SC-03 | PARTIAL | THEN-1（自动通过）：spec-reviewer-prompt.md 第 37 行 "对于单模块项目（specs/ 下 0-1 个子目录），本维度自动通过" -- **仅描述了行为规则，但未给出可执行的判定逻辑或结构化的输出指令**。审查提示词是给 AI 阅读的指令，"自动通过"作为文字描述已传达意图，但缺少类似"在 Approved 清单中该维度标记为 N/A"或"跳过该检查项"的明确操作指引。THEN-2（标注不适用）：第 37 行 "报告中标注'单模块项目，跨模块一致性维度不适用'"覆盖 -- 已明确要求在报告中标注。THEN-3（不产生 issue）：第 37 行 "本维度自动通过"隐含不产生 issue，但未显式说明"不因该维度产生任何 issue"。综合：THEN-1 和 THEN-3 的实现依赖 AI 对"自动通过"一词的语义理解，缺少显式的操作指令（如"跳过该维度的所有检查项"或"不生成任何 issue"）。判定为 **PARTIAL** -- 核心意图已传达但操作指令不够精确。 |

---

## 逐 THEN 断言明细

### propose-impact-scan (4 场景, 11 THEN 断言)

| 场景 | THEN 断言 | 实现位置 | 状态 |
|------|----------|---------|------|
| SC-01 | 基于 specs/ 目录和已有内容列出相关模块 | SKILL.md L82-83 | IMPLEMENTED |
| SC-01 | 对每个相关模块提示用户确认 | SKILL.md L87 | IMPLEMENTED |
| SC-01 | 未提及时输出包含模块数量的警告 | SKILL.md L84 | IMPLEMENTED |
| SC-02 | 内部分析变更影响范围 | SKILL.md L79 | IMPLEMENTED |
| SC-02 | 不修改 proposal.md | SKILL.md L79 | IMPLEMENTED |
| SC-02 | 不输出跨模块影响警告 | SKILL.md L79 | IMPLEMENTED |
| SC-02 | 不阻断 proposal 生成 | SKILL.md L79 (跳到步骤 2) | IMPLEMENTED |
| SC-03 | 追加到范围 > 包含/不包含节 | SKILL.md L88 | IMPLEMENTED |
| SC-03 | 追加到决策追溯节 | SKILL.md L88 | IMPLEMENTED |
| SC-04 | 输出"已检测到...跳过扫描" | SKILL.md L74 | IMPLEMENTED |
| SC-04 | 不重复提示、不修改 proposal | SKILL.md L74 (跳到步骤 2) | IMPLEMENTED |

### deferred-capture (6 场景, 16 THEN 断言)

| 场景 | THEN 断言 | 实现位置 | 状态 |
|------|----------|---------|------|
| SC-01 | 读取/创建 backlog.md | SKILL.md L51-53 | IMPLEMENTED |
| SC-01 | 延后项追加到表格 | SKILL.md L54 | IMPLEMENTED |
| SC-01 | 每项含四字段 | SKILL.md L54 | IMPLEMENTED |
| SC-01 | 跳过已完成项 | SKILL.md L47 | IMPLEMENTED |
| SC-01 | 展示结果用户确认 | SKILL.md L56 | IMPLEMENTED |
| SC-02 | 输出跳过提示 | SKILL.md L57 | IMPLEMENTED |
| SC-02 | 继续归档不创建/修改 | SKILL.md L57 | IMPLEMENTED |
| SC-03 | 追加不覆盖 | SKILL.md L54 | IMPLEMENTED |
| SC-03 | 相似项提示人工判断 | SKILL.md L55 | IMPLEMENTED |
| SC-04 | # Backlog 标题 | backlog.md L1 | IMPLEMENTED |
| SC-04 | 说明段落 | backlog.md L3 | IMPLEMENTED |
| SC-04 | 表格列头 | backlog.md L5 | IMPLEMENTED |
| SC-04 | 模板路径 | SKILL.md L52 | IMPLEMENTED |
| SC-05 | 输出提示含 N 个 open 项 | SKILL.md L32 | IMPLEMENTED |
| SC-05 | 列出所有 open 项 | SKILL.md L33 | IMPLEMENTED |
| SC-05 | 用户关联时引用到 brainstorm | SKILL.md L34 | IMPLEMENTED |
| SC-05 | 用户忽略不记录 | SKILL.md L35 | IMPLEMENTED |
| SC-06 | 不输出 backlog 提示 | SKILL.md L36 | IMPLEMENTED |
| SC-06 | 不创建 backlog.md | SKILL.md L36 | IMPLEMENTED |
| SC-06 | 正常继续 brainstorm | SKILL.md L36 (流程隐含) | IMPLEMENTED |

### review-enhancement (3 场景, 8 THEN 断言)

| 场景 | THEN 断言 | 实现位置 | 状态 |
|------|----------|---------|------|
| SC-01 | 新增第 6 维度"跨模块一致性" | spec-reviewer-prompt.md L32 | IMPLEMENTED |
| SC-01 | 包含 3 个检查项 | spec-reviewer-prompt.md L33-35 | IMPLEMENTED |
| SC-01 | 非硬性断言需人工确认 | spec-reviewer-prompt.md L37 | IMPLEMENTED |
| SC-02 | Approved 清单增加勾选项 | spec-reviewer-prompt.md L65 | IMPLEMENTED |
| SC-02 | 位于范围控制之后 | spec-reviewer-prompt.md L64-65 | IMPLEMENTED |
| SC-02 | Issues 可含跨模块问题 severity 判定 | spec-reviewer-prompt.md L39 | IMPLEMENTED |
| SC-03 | 跨模块一致性自动通过 | spec-reviewer-prompt.md L37 | PARTIAL |
| SC-03 | 标注不适用 | spec-reviewer-prompt.md L37 | IMPLEMENTED |
| SC-03 | 不产生 issue | spec-reviewer-prompt.md L37 (隐含) | PARTIAL |

---

## 缺口分析

### review-enhancement SC-03 -- 操作指令精度不足

**问题**：`spec-reviewer-prompt.md` 第 37 行对单模块项目降级处理仅以自然语言描述"本维度自动通过"，未给出结构化的操作指令。具体缺口：
1. 未显式说明"不因该维度产生任何 issue"（THEN-3）
2. "自动通过"依赖 AI 语义理解，未明确操作（如 Approved 清单中该维度如何标记）

**建议**：在第 37 行补充："自动通过时，Approved 清单中该维度标记为 `[x]` 并附注'N/A'，且不因此维度产生任何 issue。"

---

## 结论

HAS_GAPS

- 13 个场景中 12 个完全实现（IMPLEMENTED）
- 1 个场景（review-enhancement SC-03）为 PARTIAL -- 核心意图已传达但操作指令不够精确
- 0 个场景为 MISSING

整体合规率：**92%**（12/13 完全实现）。唯一的缺口在于 `spec-reviewer-prompt.md` 中单模块降级处理的操作指令精度，属于低风险项，可通过小幅补充说明解决。

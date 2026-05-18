# Plan: sdd-cross-module-awareness

## 批次 1/3：基础设施 — backlog 模板 + propose 跨模块扫描

<!-- 依赖：无 -->
<!-- 任务范围：Task 3 (3.1) + Task 1 (1.1~1.5) -->

### Task 3.1: 创建 backlog.md 模板 [spec:deferred-capture#SC-04]

<!-- 预估：2 分钟 -->

**RED — 验证当前状态：**

```bash
# 确认 backlog.md 模板不存在
ls ai-tools-bridge/schemas/sdd/templates/backlog.md 2>/dev/null
# 期望: 文件不存在
```

**GREEN — 创建模板：**

1. 创建文件 `ai-tools-bridge/schemas/sdd/templates/backlog.md`
2. 写入以下内容：
```markdown
# Backlog

> 跨变更延后项追踪文件。归档时从 proposal 中提取未完成 P1/P2 项写入。

| 来源变更 | 优先级 | 简述 | 状态 |
|---------|--------|------|------|
| <!-- 示例: 2026-01-01-change-name --> | <!-- P1/P2 --> | <!-- 简述 --> | <!-- open/done --> |
```

**验证：**
```bash
# 验证文件存在
ls ai-tools-bridge/schemas/sdd/templates/backlog.md
# 验证标题
head -1 ai-tools-bridge/schemas/sdd/templates/backlog.md
# 期望: # Backlog
# 验证表格列头
grep "来源变更" ai-tools-bridge/schemas/sdd/templates/backlog.md
# 期望: 命中 1 行
```

---

### Task 1.1~1.5: sdd-propose SKILL.md 新增步骤 1.5 [spec:propose-impact-scan#SC-01~SC-04]

<!-- 预估：5 分钟 -->
<!-- 依赖：Task 3.1 无直接依赖，但建议先完成模板以便引用 -->

**RED — 验证当前状态：**

```bash
# 确认当前 sdd-propose 后置逻辑不包含跨模块扫描
grep -n "跨模块" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望: 无命中
```

**GREEN — 修改 SKILL.md：**

1. 读取 `ai-tools-bridge/skills/sdd-propose/SKILL.md`
2. 定位后置逻辑中"### 1. 决策追溯检查"的末尾（"### 2. 产物校验"之前）
3. 在两者之间插入步骤 1.5：

```markdown
### 1.5 跨模块影响扫描

读取 proposal.md 的范围节，结合项目结构评估跨模块影响：

1. **前置判断**：如果 proposal.md 的"范围"节已包含跨模块影响分析段落，输出"已检测到跨模块影响分析，跳过扫描"，跳到步骤 2。

2. **扫描项目结构**：
   - 检查 `specs/` 目录下的子目录数量（N）
   - N ≥ 2：执行完整跨模块分析（步骤 3）
   - N ≤ 1 或 `specs/` 不存在：简化为"请确认变更影响的文件/目录范围是否完整"，不修改 proposal，跳到步骤 2

3. **多模块分析**：
   - 读取现有 specs 内容，识别与当前 proposal 主题相关的模块
   - 检查 proposal 的"范围"节是否已提及跨模块影响
   - 如未提及 → 输出警告："⚠️ 当前 proposal 未提及跨模块影响。项目中存在 N 个模块/领域（N = specs/ 下子目录数量），请确认变更范围是否完整。"

4. **用户确认**：
   - "以下模块可能与本次变更相关：[列表]。是否需要纳入范围？"
   - 用户确认纳入 → 将影响项追加到 proposal.md 的"范围 > 包含"节和"决策追溯"节
   - 用户拒绝 → 在决策追溯中记录"已评估跨模块影响，不需要同步"的理由
   - AI 无法确定模块相关性 → 列出所有模块，由用户逐一确认
```

**验证：**
```bash
# 验证步骤 1.5 存在
grep -n "### 1.5" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望: 命中 1 行

# 验证包含 SC-01 关键内容（多模块分析）
grep -c "跨模块影响" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望: ≥ 3

# 验证包含 SC-02 关键内容（单模块简化）
grep "简化" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望: 命中

# 验证包含 SC-03 关键内容（用户确认后更新）
grep "追加到 proposal.md" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望: 命中

# 验证包含 SC-04 关键内容（已含分析时跳过）
grep "已检测到跨模块影响分析" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望: 命中

# 验证步骤编号连续性：1 → 1.5 → 2
grep -n "^### [0-9]" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望后置逻辑区域出现: ### 1., ### 1.5, ### 2.
```

--- checkpoint ---

批次 1 完成。请确认后继续批次 2。

**验证批次 1 整体：**
```bash
# 验证模板文件格式正确
cat ai-tools-bridge/schemas/sdd/templates/backlog.md
# 期望: 标题 + 说明 + 表格

# 验证 sdd-propose 后置逻辑结构完整
grep -n "^### " ai-tools-bridge/skills/sdd-propose/SKILL.md | tail -6
# 期望后置逻辑中包含: ### 1. 决策追溯检查, ### 1.5 跨模块影响扫描, ### 2. 产物校验, ### 3. 完成引导
```

---

## 批次 2/3：核心功能 — ship 延后项提取 + review-spec 审查维度

<!-- 依赖：批次 1（backlog.md 模板需先存在） -->
<!-- 任务范围：Task 2 (2.1~2.5) + Task 4 (4.1~4.5) -->

### Task 2.1~2.5: sdd-ship SKILL.md 新增步骤 2.5 [spec:deferred-capture#SC-01~SC-03]

<!-- 预估：5 分钟 -->
<!-- 依赖：批次 1 的 backlog.md 模板已创建 -->

**RED — 验证当前状态：**

```bash
# 确认当前 sdd-ship 不包含延后项提取
grep -n "延后" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 无命中
```

**GREEN — 修改 SKILL.md：**

1. 读取 `ai-tools-bridge/skills/sdd-ship/SKILL.md`
2. 定位前置逻辑中"### 2. 最终验证"的末尾（"## 核心执行"之前）
3. 在两者之间插入步骤 2.5：

```markdown
### 2.5 延后项提取

归档前从 proposal.md 中提取延后项，写入 `openspec/backlog.md`：

1. **扫描 proposal.md**，搜索以下延后标记关键词：
   - `P1`、`P2`（后跟"延后"、"后续"、"迭代"、"非本次"、"不在范围"等上下文）
   - `延后项`、`后续迭代`、`不在范围`、`不包含`（后跟功能描述）

2. **过滤已完成项**：如果延后项在 proposal 中已有删除线（`~~...~~`）或显式标注"已完成"，跳过该项。

3. **处理提取结果**：
   - 如果存在未过滤的延后项：
     a. 检查 `openspec/backlog.md` 是否存在
     b. 不存在 → 使用 `schemas/sdd/templates/backlog.md` 模板创建
     c. 已存在 → 读取现有内容
     d. 将新项追加到表格末尾，每项格式：`| 来源变更名 | P1/P2 | 简述 | open |`
     e. 如检测到来源变更相同且简述高度相似的已有项，提示用户人工判断是否合并（不自动合并）
     f. 展示提取结果，用户确认后继续
   - 如果无延后项 → 输出"proposal 中无延后项，跳过 backlog 更新"，继续归档
```

**验证：**
```bash
# 验证步骤 2.5 存在
grep -n "### 2.5" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中 1 行

# 验证包含 SC-01 关键内容（延后标记扫描）
grep "P1.*P2" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中

# 验证包含 SC-01 跳过已完成项
grep "删除线" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中

# 验证包含 SC-02 跳过逻辑
grep "无延后项" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中

# 验证包含 SC-03 追加逻辑
grep "高度相似" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中

# 验证引用了 backlog 模板
grep "backlog.md" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中 ≥ 2

# 验证步骤编号连续性
grep -n "^### [0-9]" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望前置逻辑区域出现: ### 0., ### 1., ### 2., ### 2.5
```

---

### Task 4.1~4.5: spec-reviewer-prompt.md 新增维度 6 [spec:review-enhancement#SC-01~SC-03]

<!-- 预估：4 分钟 -->
<!-- 依赖：无（独立于 sdd-ship 修改） -->

**RED — 验证当前状态：**

```bash
# 确认当前仅有 5 个审查维度
grep -c "^### [0-9]" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 5

# 确认不包含跨模块一致性
grep "跨模块" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 无命中
```

**GREEN — 修改 reviewer prompt：**

1. 读取 `ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md`
2. 在"### 5. 范围控制"块的末尾（"## 输出格式"之前）插入：

```markdown

### 6. 跨模块一致性
- [ ] 如果项目有多个模块/领域（specs/ 下有多个子目录），本次变更是否考虑了对其他模块的影响
- [ ] 如果某个功能在多个模块中共享（如验证脚本、通用工具），spec 是否确认了所有相关模块的覆盖
- [ ] 是否有应该同步变更但被遗漏的关联模块

> 注：跨模块一致性的判定依赖审查员对项目结构和 spec 间引用关系的分析，不做硬性断言。所有检查项的结论均为基于分析的判断，需人工确认。对于单模块项目（specs/ 下 0-1 个子目录），本维度自动通过，报告中标注"单模块项目，跨模块一致性维度不适用"。
```

3. 更新输出格式中的 Approved 清单：在"范围控制"之后增加一行：

```markdown
- [ ] 跨模块一致性
```

4. 更新 Issues 说明：在输出格式之前添加注释：

```markdown
<!-- Issues severity 说明：跨模块一致性问题的 severity 根据遗漏影响范围判定为 minor/major/critical -->
```

**验证：**
```bash
# 验证维度 6 存在
grep -n "### 6" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 命中 1 行

# 验证包含 3 个检查项
grep -c "跨模块" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: ≥ 5

# 验证 Approved 清单包含 6 项
grep -c "\- \[ \]" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: ≥ 6

# 验证包含降级逻辑说明
grep "单模块项目" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 命中

# 验证 severity 说明存在
grep "minor/major/critical" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 命中
```

--- checkpoint ---

批次 2 完成。请确认后继续批次 3。

**验证批次 2 整体：**
```bash
# 验证 sdd-ship 步骤结构
grep -n "^### " ai-tools-bridge/skills/sdd-ship/SKILL.md | head -8
# 期望前置逻辑包含: ### 0. 前置校验, ### 1. 定位, ### 2. 最终验证, ### 2.5 延后项提取

# 验证 spec-reviewer 维度数量
grep -c "^### [0-9]" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 6
```

---

## 批次 3/3：补全验证 — brainstorm 读取 + 全局验证

<!-- 依赖：批次 1（backlog 模板）+ 批次 2（ship/review 修改完成） -->
<!-- 任务范围：Task 5 (5.1~5.3) + Task 6 (6.1~6.4) -->

### Task 5.1~5.3: sdd-brainstorm SKILL.md 增加 backlog 读取 [spec:deferred-capture#SC-05~SC-06]

<!-- 预估：3 分钟 -->
<!-- 依赖：批次 1 的 backlog.md 模板已存在 -->

**RED — 验证当前状态：**

```bash
# 确认当前 sdd-brainstorm 不读取 backlog
grep "backlog" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md
# 期望: 无命中
```

**GREEN — 修改 SKILL.md：**

1. 读取 `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`
2. 定位"### 2. 读取项目上下文"步骤
3. 在现有读取项（config.yaml 之后）追加：

```markdown
- 读取 `openspec/backlog.md`（如有）：
  - 如果存在且表格中含状态为 `open` 的项：
    1. 输出："backlog 中有 N 个 open 项，是否有与当前需求相关的？"
    2. 列出所有 open 项的来源变更和简述
    3. 用户选择关联 → 在 brainstorm.md 的"参考资源"中引用该 backlog 项（格式：`backlog 项: [来源变更] [简述]`）
    4. 用户选择忽略 → 不记录（仅作为上下文参考）
  - 如果不存在或无 open 项：跳过，不输出任何 backlog 相关提示，不创建 backlog.md
```

**验证：**
```bash
# 验证包含 backlog 读取
grep "backlog" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md
# 期望: 命中 ≥ 2

# 验证包含 SC-05 提示逻辑
grep "open 项" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md
# 期望: 命中

# 验证包含 SC-05 关联行为
grep "参考资源" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md
# 期望: 命中

# 验证包含 SC-06 静默跳过
grep "不创建 backlog" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md
# 期望: 命中
```

---

### Task 6.1~6.4: 全局验证 [spec:propose-impact-scan#SC-01, deferred-capture#SC-01,SC-04, review-enhancement#SC-01,SC-02]

<!-- 预估：3 分钟 -->
<!-- 依赖：Task 1~5 全部完成 -->

**步骤：**

1. **验证 sdd-propose 编号连续性**（Task 6.1）：
```bash
grep -n "^### [0-9]" ai-tools-bridge/skills/sdd-propose/SKILL.md
# 期望后置逻辑区域: ### 1. 决策追溯检查 → ### 1.5 跨模块影响扫描 → ### 2. 产物校验 → ### 3. 完成引导
```

2. **验证 sdd-ship 编号连续性**（Task 6.2）：
```bash
grep -n "^### [0-9]" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望前置逻辑区域: ### 0. 前置校验 → ### 1. 定位 → ### 2. 最终验证 → ### 2.5 延后项提取
```

3. **验证 spec-reviewer-prompt 完整性**（Task 6.3）：
```bash
grep -c "^### [0-9]" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 6

grep "跨模块一致性" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: 命中 ≥ 2

grep -c "\- \[ \]" ai-tools-bridge/skills/sdd-review-spec/spec-reviewer-prompt.md
# 期望: ≥ 6（Approved 清单项）
```

4. **验证 backlog.md 模板**（Task 6.4）：
```bash
head -1 ai-tools-bridge/schemas/sdd/templates/backlog.md
# 期望: # Backlog

grep "来源变更" ai-tools-bridge/schemas/sdd/templates/backlog.md
# 期望: 命中（表格列头）
```

5. **跨文件一致性验证**：
```bash
# 验证 backlog 模板路径在 sdd-ship 中正确引用
grep "schemas/sdd/templates/backlog.md" ai-tools-bridge/skills/sdd-ship/SKILL.md
# 期望: 命中

# 验证 backlog 路径在 sdd-brainstorm 中正确引用
grep "openspec/backlog.md" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md
# 期望: 命中
```

--- checkpoint ---

批次 3 完成。全部 3 批次已生成。

## 执行顺序

```
批次 1 (backlog 模板 + propose 扫描)
    ↓
批次 2 (ship 延后项 + review 维度)
    ↓
批次 3 (brainstorm 读取 + 全局验证)
```

## 风险点

| 步骤 | 风险 | 缓解 |
|------|------|------|
| Task 1 | 插入步骤 1.5 时 markdown 格式破坏 | 插入后用 Read 验证上下文缩进 |
| Task 2 | 延后标记格式不统一导致提取遗漏 | 扫描多种关键词模式 |
| Task 4 | reviewer prompt 维度顺序影响审查习惯 | 新增维度放在最后，不改变现有 5 个维度 |
| Task 6 | 步骤编号不连续 | 逐文件 grep 验证 |

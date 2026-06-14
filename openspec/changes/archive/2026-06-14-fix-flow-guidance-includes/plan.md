# Plan: fix-flow-guidance-includes

> 实施计划 — TDD 级别的详细步骤

---

## 批次一：更新使用说明

### Task 1.1: 修改"使用方式"节 — 明确"直接复制"是推荐方式 [spec:sdd-flow-guidance-docs#用户阅读使用说明了解推荐方式]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证当前使用说明未明确"直接复制"是推荐方式（功能失败：用户不知道推荐方式）
  ```bash
  grep "推荐方式.*直接复制" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "功能缺失：未明确推荐方式"
  ```
- **运行验证失败**: `功能缺失：未明确推荐方式`
- **GREEN**: 修改"使用方式"节，添加"推荐方式：直接复制"子节，说明原因和步骤
- **运行验证通过**: `grep "推荐方式.*直接复制" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

### Task 1.2: 解释原因 — 说明 include 机制不支持条件渲染 [spec:sdd-flow-guidance-docs#用户阅读使用说明了解推荐方式]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证当前文档未说明 include 机制的限制（功能失败：用户不理解为什么不使用 include）
  ```bash
  grep "不支持条件渲染" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "功能缺失：未说明 include 限制"
  ```
- **运行验证失败**: `功能缺失：未说明 include 限制`
- **GREEN**: 在"使用方式"节添加"不推荐的方式：include 引用"子节，说明 include 机制不支持条件渲染
- **运行验证通过**: `grep "不支持条件渲染" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

### Task 1.3: 提供复制指南 — 说明如何从模板中复制对应 action 的内容 [spec:sdd-flow-guidance-docs#用户阅读使用说明了解推荐方式]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证当前文档无复制步骤说明（功能失败：用户不知道如何复制）
  ```bash
  grep "复制步骤" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "功能缺失：无复制步骤说明"
  ```
- **运行验证失败**: `功能缺失：无复制步骤说明`
- **GREEN**: 在"推荐方式：直接复制"子节添加"复制步骤"，列出 3 个步骤
- **运行验证通过**: `grep "复制步骤" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

---

## 批次二：添加一致性检查指南

### Task 2.1: 添加"一致性检查"节 — 说明如何验证格式一致性 [spec:sdd-flow-guidance-docs#用户使用一致性检查指南验证格式]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证当前文档无"一致性检查"节（功能失败：用户无法验证格式一致性）
  ```bash
  grep "## 一致性检查" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "功能缺失：无一致性检查节"
  ```
- **运行验证失败**: `功能缺失：无一致性检查节`
- **GREEN**: 在文档末尾添加"一致性检查"节，说明验证目的
- **运行验证通过**: `grep "## 一致性检查" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

### Task 2.2: 提供检查命令 — 包含 grep 命令示例 [spec:sdd-flow-guidance-docs#用户使用一致性检查指南验证格式]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证"一致性检查"节无检查命令（功能失败：用户不知道如何检查）
  ```bash
  grep "检查命令" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "功能缺失：无检查命令"
  ```
- **运行验证失败**: `功能缺失：无检查命令`
- **GREEN**: 在"一致性检查"节添加"检查命令"子节，包含 grep 命令示例
- **运行验证通过**: `grep "检查命令" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

### Task 2.3: 列出一致性要求 — 分隔线、标题、标记格式 [spec:sdd-flow-guidance-docs#用户使用一致性检查指南验证格式]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证"一致性检查"节无一致性要求列表（功能失败：用户不知道一致性的具体要求）
  ```bash
  grep "一致性要求" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "功能缺失：无一致性要求"
  ```
- **运行验证失败**: `功能缺失：无一致性要求`
- **GREEN**: 在"一致性检查"节添加"一致性要求"子节，列出分隔线、标题、标记格式要求
- **运行验证通过**: `grep "一致性要求" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

---

## 批次三：验证

### Task 3.1: 运行检查命令 — 确认 6 个 SKILL.md 包含 SDD 流程指引 [spec:sdd-flow-guidance-docs#用户使用一致性检查指南验证格式]

- **文件**: 无
- **验证步骤**: 运行"一致性检查"节中的检查命令
  ```bash
  for skill in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
    grep "SDD 流程指引" ai-tools-bridge/skills/$skill/SKILL.md > /dev/null && echo "$skill: OK" || echo "$skill: MISSING"
  done
  ```
- **运行验证通过**: 所有 6 个 skill 输出 OK

### Task 3.2: 验证格式一致性 — 确认分隔线和标记格式一致 [spec:sdd-flow-guidance-docs#用户使用一致性检查指南验证格式]

- **文件**: 无
- **验证步骤**: 运行分隔线检查命令
  ```bash
  for skill in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
    grep "━━━" ai-tools-bridge/skills/$skill/SKILL.md > /dev/null && echo "$skill: OK" || echo "$skill: MISSING"
  done
  ```
- **运行验证通过**: 所有 6 个 skill 输出 OK

---

<!-- 格式说明:
  - 每个任务必须有 RED/GREEN 步骤（TDD 铁律）
  - RED 步骤验证"功能失败"（用户看不到预期行为），而非"文件不存在"
  - 每个步骤有具体的运行验证命令
  - 粒度: 2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
-->

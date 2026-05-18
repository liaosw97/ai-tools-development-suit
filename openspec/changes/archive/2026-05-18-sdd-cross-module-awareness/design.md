# Design: sdd-cross-module-awareness

> 技术设计 — 增强跨模块感知的具体实现方案

## 技术方案

### 方案概述

修改 4 个 SDD skill 的 SKILL.md 文件 + 新增 1 个模板文件，通过提示词引导增强 SDD 工作流的跨模块感知能力。不引入新的自动化机制或配置文件。

### 改造项 1: sdd-propose 后置逻辑

在 `skills/sdd-propose/SKILL.md` 的后置逻辑中，步骤 1（决策追溯检查）和步骤 2（产物校验）之间插入步骤 1.5。

**插入内容：**
```
### 1.5 跨模块影响扫描

读取 proposal.md 的范围节，结合项目结构评估跨模块影响：

1. 扫描 `specs/` 目录结构：
   - 如存在 ≥2 个子目录 → 执行完整跨模块分析
   - 如存在 0-1 个子目录 → 简化为"影响文件/目录范围"提示
2. 对多模块项目：
   - 读取现有 specs 内容，识别与当前 proposal 主题相关的模块
   - 检查 proposal 的"范围"节是否已提及跨模块影响
   - 如未提及 → 输出警告并列出相关模块
3. 提示用户确认：
   - "以下模块可能与本次变更相关：[列表]。是否需要纳入范围？"
   - 用户确认后更新 proposal.md
4. 首次使用 SDD 的项目（无 specs/）：
   - 读取项目目录结构（顶层目录列表）
   - 简化提示："请确认变更影响的文件/目录范围是否完整"
```

**影响范围：** 仅修改 SKILL.md 文本，不影响核心执行逻辑。

### 改造项 2: sdd-ship 延后项提取

在 `skills/sdd-ship/SKILL.md` 的前置逻辑中，步骤 2（最终验证）之后、核心执行之前插入步骤 2.5。

**插入内容：**
```
### 2.5 延后项提取

归档前从 proposal.md 中提取延后项：

1. 读取 proposal.md，扫描以下关键词模式：
   - `P1`、`P2`（后跟"延后"、"后续"、"迭代"、"非本次"等）
   - `延后项`、`后续迭代`、`不在范围`、`不包含`（后跟功能描述）
2. 提取结果为列表：`[来源变更名, 优先级, 简述, 状态]`
3. 如果存在未完成延后项：
   a. 检查 `openspec/backlog.md` 是否存在
   b. 不存在 → 使用 `schemas/sdd/templates/backlog.md` 创建
   c. 已存在 → 读取现有内容
   d. 将新项追加到表格末尾（状态 open）
   e. 检查是否与已有 open 项重复
   f. 展示提取结果，用户确认后继续
4. 无延后项 → 输出"proposal 中无延后项，跳过"并继续
```

**影响范围：** 仅修改 SKILL.md 文本，新增对 proposal.md 的解析和对 backlog.md 的写入。

### 改造项 3: sdd-review-spec 审查维度

修改 `skills/sdd-review-spec/spec-reviewer-prompt.md`。

**修改 1：** 在"### 5. 范围控制"之后新增"### 6. 跨模块一致性"：
```markdown
### 6. 跨模块一致性
- [ ] 如果项目有多个模块/领域（specs/ 下有多个子目录），本次变更是否考虑了对其他模块的影响
- [ ] 如果某个功能在多个模块中共享（如验证脚本、通用工具），spec 是否确认了所有相关模块的覆盖
- [ ] 是否有应该同步变更但被遗漏的关联模块
```

**修改 2：** 更新输出格式中的 Approved 清单，增加 `- [ ] 跨模块一致性`。

**影响范围：** 仅修改 reviewer prompt 文本，不改变审查流程逻辑。

### 改造项 4: sdd-brainstorm 前置逻辑

修改 `skills/sdd-brainstorm/SKILL.md` 的步骤 2（读取项目上下文）。

**修改内容：** 在现有读取项末尾追加：
```
- 读取 openspec/backlog.md（如有）
  - 如果存在且含状态为 open 的项：
    输出："backlog 中有 N 个 open 项，是否有与当前需求相关的？"
    列出所有 open 项的来源变更和简述
  - 如果不存在或无 open 项：跳过，不输出
```

**影响范围：** 仅修改 SKILL.md 文本，不改变 brainstorm 核心流程。

### 改造项 5: backlog.md 模板

创建 `schemas/sdd/templates/backlog.md`。

**内容：**
```markdown
# Backlog

> 跨变更延后项追踪文件。归档时从 proposal 中提取未完成 P1/P2 项写入。

| 来源变更 | 优先级 | 简述 | 状态 |
|---------|--------|------|------|
| <!-- 示例: 2026-01-01-change-name --> | <!-- P1/P2 --> | <!-- 简述 --> | <!-- open/done --> |
```

**影响范围：** 新增文件，不影响现有文件。

## 决策追溯

- 选择 [提示词引导] 而非 [config 自动化]：当前仅发生过一次遗漏，YAGNI（见 brainstorm.md §决策1）
- 选择 [backlog.md 可选制品] 而非 [核心依赖链制品]：backlog 不属于制品依赖链（见 brainstorm.md §决策2）

## 文件变更预估

| 文件 | 操作 | 说明 |
|------|------|------|
| `skills/sdd-propose/SKILL.md` | Modify | 后置逻辑插入步骤 1.5（~15 行） |
| `skills/sdd-ship/SKILL.md` | Modify | 前置逻辑插入步骤 2.5（~12 行） |
| `skills/sdd-review-spec/spec-reviewer-prompt.md` | Modify | 新增第 6 审查维度 + 更新 Approved 清单（~8 行） |
| `skills/sdd-brainstorm/SKILL.md` | Modify | 步骤 2 增加 backlog 读取（~5 行） |
| `schemas/sdd/templates/backlog.md` | Create | backlog 模板（~8 行） |

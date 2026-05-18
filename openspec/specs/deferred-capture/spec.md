# Spec: deferred-capture — sdd-ship 延后项提取与 backlog 追踪

> 功能规格 — sdd-ship 归档前的延后项提取步骤 + backlog.md 模板 + sdd-brainstorm 的 backlog 读取

## 能力描述

在 sdd-ship 归档前，自动扫描 proposal.md 中的 P1/P2/延后标记，将未完成项写入 `openspec/backlog.md`。sdd-brainstorm 启动时读取 backlog，提示用户关注相关的 open 项。

---

## 场景

### SC-01: proposal 含延后项时的提取 `[ADDED]`

**GIVEN** 当前变更的 proposal.md 包含 P1/P2/延后/后续迭代等延后标记

**WHEN** 执行 sdd-ship 的延后项提取步骤

**THEN** 读取 `openspec/backlog.md`（如不存在则使用模板创建）
**AND** 将延后项追加到 backlog 表格
**AND** 每项包含：来源变更名称、优先级（P1/P2）、简述、状态（open）
**AND** 如果延后项在 proposal 中已有删除线或显式标注为"已完成"，跳过该项（不追加）
**AND** 向用户展示提取结果，确认后继续归档

---

### SC-02: proposal 无延后项时的跳过 `[ADDED]`

**GIVEN** 当前变更的 proposal.md 不包含任何 P1/P2/延后标记

**WHEN** 执行 sdd-ship 的延后项提取步骤

**THEN** 输出"proposal 中无延后项，跳过 backlog 更新"
**AND** 继续归档流程，不创建或修改 backlog.md

---

### SC-03: backlog.md 已存在时的追加 `[ADDED]`

**GIVEN** `openspec/backlog.md` 已存在
**AND** 其中已包含来自之前变更的 open/done 项

**WHEN** 当前变更的延后项被提取

**THEN** 新项追加到表格末尾，不覆盖已有项
**AND** 如检测到来源变更相同且简述高度相似的已有项，提示用户人工判断是否合并（不自动合并）

---

### SC-04: backlog.md 模板格式 `[ADDED]`

**GIVEN** 需要创建新的 `openspec/backlog.md`

**WHEN** sdd-ship 创建 backlog.md

**THEN** 文件以 `# Backlog` 标题开头
**AND** 包含一段说明："跨变更延后项追踪文件。归档时从 proposal 中提取未完成 P1/P2 项写入。"
**AND** 包含 Markdown 表格，列头为 `来源变更 | 优先级 | 简述 | 状态`
**AND** 模板存储在 `schemas/sdd/templates/backlog.md`

---

### SC-05: sdd-brainstorm 读取 backlog `[ADDED]`

**GIVEN** `openspec/backlog.md` 存在
**AND** 其中包含 N 个状态为 open 的项

**WHEN** 执行 sdd-brainstorm 的前置逻辑"读取项目上下文"步骤

**THEN** 输出提示："backlog 中有 N 个 open 项，是否有与当前需求相关的？"
**AND** 列出所有 open 项的来源变更和简述
**AND** 如果用户选择关联某 open 项，在 brainstorm.md 的"参考资源"中引用该 backlog 项
**AND** 如果用户选择忽略，不记录（仅作为上下文参考）

---

### SC-06: backlog.md 不存在时的静默跳过 `[ADDED]`

**GIVEN** `openspec/backlog.md` 不存在

**WHEN** 执行 sdd-brainstorm 的前置逻辑"读取项目上下文"步骤

**THEN** 不输出任何 backlog 相关提示
**AND** 不创建 backlog.md
**AND** 正常继续 brainstorm 流程

---

## 边界条件

- backlog.md 存在但为空（仅有标题和表头，无数据行）：视为不存在，不提示
- proposal 中的延后标记格式不统一（如"P2"、"P2 延后"、"后续迭代"）：扫描时应匹配多种关键词
- 归档后 backlog.md 中的 done 项：保留在表格中，不删除（提供历史追溯）

# Design: sdd-v0.3.0

> 技术设计 — 描述实现方案和技术决策

## 技术方案

### 方案概述

本次变更为纯 Markdown 插件的增量改进，无运行时代码。实现方式为：

1. **新增 2 个 action 目录**（`sdd-quick/`、`sdd-test-code/`），各含 SKILL.md + reference 文件
2. **修改 9 个现有 SKILL.md** 的前置/后置逻辑段落
3. **修改配置文件**（schema.yaml、plugin.json、README.md）

所有变更通过编辑 Markdown 提示词实现，不涉及编译或构建。

### 架构图

```
SDD v0.3.0 Action 体系（13 个 action）

┌─────────────────────────────────────────────────────────┐
│  入口层                                                  │
│  /sdd-doctor ─── 复杂度评估(S/M/L) + 路径推荐            │
│  /sdd-quick  ─── 快速模式（propose→spec→tasks→code）     │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│  规划层                                                  │
│  /sdd-brainstorm → /sdd-propose → /sdd-ff               │
│  /sdd-continue → /sdd-review-spec                       │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│  实施层                                                  │
│  /sdd-plan（分批生成）→ /sdd-code                        │
│  /sdd-test-code ← /sdd-review-code                      │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│  收尾层                                                  │
│  /sdd-verify → /sdd-ship                                │
└─────────────────────────────────────────────────────────┘

横切关注点：
  [前置校验] ← 所有 action 执行前
  [推荐操作] ← 所有 action 完成后
```

### 前置校验架构

每个 SKILL.md 的前置逻辑段落增加校验子段落：

```
前置逻辑：
  1. 定位 change 目录（已有）
  2. 读取前置 artifact（已有）
  3. 【新增】前置校验
     a. 检查必需制品是否存在
     b. 检查上下文清晰度
     c. 校验结果：通过/警告/阻断
  4. 现有逻辑继续...
```

校验规则通过提示词自然语言描述，无需代码实现。校验逻辑在每个 SKILL.md 中内联（不抽取为独立文件），因为每个 action 的校验规则不同。

### 推荐操作架构

每个 SKILL.md 的后置逻辑段落末尾增加推荐子段落：

```
后置逻辑：
  1. 现有审查/校验逻辑（已有）
  2. 产物校验（已有）
  3. 【新增】输出推荐操作
     a. 读取复杂度评级（如有）
     b. 根据映射表生成 ★○△ 推荐
     c. 输出统一格式
  4. 现有完成引导（修改为包含推荐）
```

推荐映射表以 Markdown 表格形式嵌入每个 SKILL.md，确保每个 action 自包含。

## 决策追溯

- 选择 [校验规则内联到各 SKILL.md] 而非 [抽取为独立校验配置文件]：纯 Markdown 插件无法加载外部配置，内联是最简方案（见 brainstorm.md §决策 1: Skills 合并方式 — 直接内联）
- 选择 [推荐映射表嵌入各 SKILL.md] 而非 [集中定义推荐逻辑]：每个 action 自包含，修改一个 action 不影响其他（见 brainstorm.md §方案 A: 渐进增强）
- 选择 [分批生成通过 plan.md 格式变更实现] 而非 [多文件 plan]：保持单文件，便于审查和版本管理（见 brainstorm.md §决策 3: Plan 超时解决方案）

## 数据模型

本次变更不涉及运行时数据模型。变更的数据结构为：

### 新增 SKILL.md 元数据

sdd-quick 和 sdd-test-code 的 SKILL.md YAML 前置元数据：
```yaml
---
name: sdd-quick  # 或 sdd-test-code
description: 快速模式...  # 触发条件描述
---
```

### 新增 reference 文件格式

每个 reference 文件头部包含来源标注：
```markdown
<!-- 来源: skills/engineering/<original-path> -->
<!-- 提取自 mattpocock-skills，仅提取核心原则 -->

[内联内容]
```

### plan.md 批次格式

```markdown
## 批次 1/N：<批次名称>
<!-- 任务范围：task-X ~ task-Y -->

### RED: [TDD 步骤]
### GREEN: [TDD 步骤]

--- checkpoint ---
```

## 接口设计

本次变更无 API 接口。用户界面为 Claude Code 斜杠命令：

### 新增斜杠命令

| 命令 | 触发方式 | 说明 |
|------|---------|------|
| `/sdd-quick` | 用户手动输入 | 快速模式，一条命令完成 propose→code |
| `/sdd-test-code` | 用户手动输入或 sdd-review-code 推荐触发 | TDD 循环补全 |

### 修改的输出格式

所有 action 完成后的输出增加推荐操作段落：
```
★ 推荐下一步: /sdd-xxx — 简要说明
  ○ /sdd-xxx — 简要说明
  △ /sdd-xxx — 简要说明
```

## 文件变更预估

| 文件 | 操作 | 说明 |
|------|------|------|
| `skills/sdd-quick/SKILL.md` | Create | 快速模式 action 定义 |
| `skills/sdd-quick/reference-grill.md` | Create | 提取自 /grill-me 追问技巧 |
| `skills/sdd-quick/reference-tdd-compact.md` | Create | 提取自 /tdd 核心流程 |
| `skills/sdd-test-code/SKILL.md` | Create | TDD 循环补全 action 定义 |
| `skills/sdd-test-code/reference-tdd-tests.md` | Create | 提取自 /tdd/tests.md |
| `skills/sdd-test-code/reference-tdd-mocking.md` | Create | 提取自 /tdd/mocking.md |
| `skills/sdd-brainstorm/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-propose/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-ff/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-plan/SKILL.md` | Modify | 增加分批生成 + 前置校验 + 后置推荐 |
| `skills/sdd-code/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-review-code/SKILL.md` | Modify | 增加前置校验 + 后置推荐（含 /sdd-test-code） |
| `skills/sdd-review-spec/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-verify/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-ship/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-continue/SKILL.md` | Modify | 增加前置校验 + 后置推荐 |
| `skills/sdd-doctor/SKILL.md` | Modify | 增加复杂度评估 + 路径推荐 + 后置推荐 |
| `schemas/sdd/schema.yaml` | Modify | 新增 sdd-quick、sdd-test-code action 定义 |
| `.claude-plugin/plugin.json` | Modify | 注册 sdd-quick、sdd-test-code |
| `README.md` | Modify | 引用标注 + 路径推荐 + 版本号 v0.3.0 |

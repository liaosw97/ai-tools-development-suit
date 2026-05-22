# Design: quick-limit-fallback

> 技术设计 — 描述实现方案和技术决策

## 技术方案

### 方案概述

本次变更的核心是修改 SDD action 的 SKILL.md 文本，在达限点增加分支逻辑。由于 SKILL.md 是 AI 读取执行的纯 Markdown 指令，"读取配置"通过在指令中写明"读取 openspec/config.yaml 的 limits 节，未配置时使用默认值"实现。

技术方案分为三层：

1. **配置层**：config.yaml 新增 `limits` 节，定义 4 个配置项及默认值
2. **指令层**：各 SKILL.md 在达限点增加分支逻辑，先读取配置值，达到上限时给用户选择
3. **诊断层**：sdd-doctor 读取并展示 limits 配置状态

### 执行流程

```
Action 执行到上限点
    ↓
读取 openspec/config.yaml limits 节
    ↓
未配置？ → 使用默认值
已配置？ → 使用配置值
    ↓
计数器 < 上限值 → 正常继续
计数器 = 上限值 → 触发达限分支
    ↓
提问场景 → ① 继续追问 / ② 切换标准路径
Review 场景 → ① 继续修复 / ② 接受并继续
场景/任务上限 → 停止生成 + 提示可配置
```

## 决策追溯

- 选择 [config.yaml limits 节] 而非 [独立 limits.yaml]：减少文件数量，与 openspec 生态一致（见 brainstorm.md §决策 2）
- 选择 [默认值回退] 而非 [强制配置]：向后兼容，不破坏现有项目（见 brainstorm.md §决策 3）
- 选择 [AI 指令式读取配置] 而非 [运行时解析]：SKILL.md 是纯 Markdown，无运行时逻辑，依赖 AI 读取并遵循配置值

## 数据模型

### 配置结构

```yaml
# openspec/config.yaml
limits:
  quick-questions: 5      # int, sdd-quick 提问上限
  quick-scenarios: 5      # int, sdd-quick 场景上限
  quick-tasks: 10         # int, sdd-quick 任务上限
  review-rounds: 3        # int, review 循环上限
```

无新增运行时数据结构。配置值仅在 AI 执行 SKILL.md 时作为指令参数使用。

## 接口设计

无新增 API 或函数接口。本次变更全部作用于 Markdown 指令文本。

### 修改的交互接口

| 交互点 | 修改内容 |
|--------|---------|
| sdd-quick 达限提示 | 从"自动进入生成阶段"改为"给用户选择" |
| sdd-brainstorm review 达限 | 从"静默停止"改为"给用户选择" |
| sdd-plan review 达限 | 从"静默停止"改为"给用户选择" |
| sdd-doctor 输出 | 新增"限制配置"节 |

## 文件变更预估

| 文件 | 操作 | 说明 |
|------|------|------|
| ai-tools-bridge/skills/sdd-quick/SKILL.md | Modify | 需求收集达限分支 + 场景/任务达限提示 + 读取 limits |
| ai-tools-bridge/skills/sdd-brainstorm/SKILL.md | Modify | review 循环达限分支 + 读取 limits |
| ai-tools-bridge/skills/sdd-plan/SKILL.md | Modify | review 循环达限分支 + 读取 limits |
| ai-tools-bridge/skills/sdd-doctor/SKILL.md | Modify | 新增限制配置诊断节 |
| ai-tools-bridge/guidelines/quality-checkpoints.md | Modify | 全局约定更新为可配置 |
| ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts | Modify | 适配新的可配置行为 |
| openspec/config.yaml | Modify（可选） | 新增 limits 节示例 |

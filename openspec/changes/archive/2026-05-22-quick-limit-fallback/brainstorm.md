# Brainstorm: quick-limit-fallback

> 深度探索记录 — 记录需求探索过程和关键决策

## 需求描述

SDD 工作流的多个 action 存在硬编码上限（sdd-quick 最多 5 个提问，brainstorm/plan review 最多 3 轮）。达到上限后直接进入下一阶段，可能导致需求未充分澄清或文档质量不足。

需要为所有存在上限的 action 增加"兜底选择"机制：达到上限时给用户提供明确选项，而非静默跳过。同时将上限值从硬编码改为可配置。

## 方案探索

### 方案 A: 仅加兜底提示（不改配置）

在 SKILL.md 中为每个上限点添加 if-limit-reached 分支逻辑，提示用户选择。上限值保持硬编码在 SKILL.md 中。

- **优点:** 改动范围小，只涉及 SKILL.md 文本修改
- **缺点:** 改上限值需手动编辑 SKILL.md，不够灵活；不同项目可能需要不同上限

### 方案 B: 兜底选择 + 可配置上限（推荐）

在 SKILL.md 中添加 if-limit-reached 分支逻辑 + 在 `openspec/config.yaml` 中新增 `limits` 配置节。SKILL.md 读取配置值，未配置时使用默认值。

- **优点:** 项目级可定制；向后兼容（无配置 = 当前行为）；一处配置影响所有 action
- **缺点:** 改动范围稍大，涉及 config schema 和 SKILL.md 读取逻辑

### 方案比较

方案 B 更优。硬编码上限在不同使用场景下缺乏灵活性，且配置机制是一次性投入，后续新增 action 自动受益。向后兼容通过默认值保证。

选择 [B] 而非 [A]：配置机制虽增加初始工作量，但消除了反复修改 SKILL.md 的维护成本（见本节"方案比较"）

## 关键决策

### 决策 1: 兜底选择的交互形式
- **选择:** 区分场景给出不同选项
- **理由:** 提问场景和 review 场景的用户意图不同，选项应匹配上下文
- **被否决的替代:** 统一两个选项 — 过于简化，不符合各场景的实际需求

具体行为：
- **提问场景**（sdd-quick 需求收集）：达到上限 → `① 继续追问（无上限）` / `② 切换到标准路径`
- **Review 场景**（brainstorm/plan review）：达到上限 → `① 继续修复` / `② 接受当前状态并继续`

### 决策 2: 配置位置
- **选择:** `openspec/config.yaml` 新增 `limits` 节
- **理由:** 现有项目配置文件，用户熟悉，与 openspec 生态一致
- **被否决的替代:** 新建独立 `openspec/limits.yaml` — 增加文件复杂度，无额外收益

### 决策 3: 配置缺失时的行为
- **选择:** 使用当前硬编码值作为默认值
- **理由:** 向后兼容 — 现有项目不配置 `limits` 即保持当前行为
- **被否决的替代:** 强制要求配置 — 破坏现有用户体验

配置结构设计：
```yaml
# openspec/config.yaml
limits:
  quick-questions: 5      # sdd-quick 需求收集提问上限，默认 5
  quick-scenarios: 5      # sdd-quick 场景数量上限，默认 5
  quick-tasks: 10         # sdd-quick 任务数量上限，默认 10
  review-rounds: 3         # review 循环上限（brainstorm/plan 等），默认 3
```

### 决策 4: 影响范围
- **选择:** 所有存在上限的 action 统一应用
- **理由:** 一致性 — 用户在任何 action 中遇到上限都有明确选择，无需记忆哪个 action 有兜底
- **被否决的替代:** 仅 sdd-quick — 行为不一致，用户可能在其他 action 中困惑

涉及的 action 和上限点：
| Action | 上限点 | 类型 | 默认值 |
|--------|--------|------|--------|
| sdd-quick | 需求收集提问 | 提问场景 | 5 |
| sdd-quick | 场景数量上限 | 生成场景 | 5 |
| sdd-quick | 任务数量上限 | 生成任务 | 10 |
| sdd-brainstorm | brainstorm review 循环 | Review 场景 | 3 |
| sdd-plan | plan review 循环 | Review 场景 | 3 |

sdd-quick 的场景/任务上限达限行为：达到上限后停止生成，提示"已达到上限，可在 config.yaml 中调整"并列出已生成的制品，推荐通过 `/sdd-propose` 或 `/sdd-ff` 继续（与当前行为一致，仅增加可配置性和提示）。

### 决策 5: 配置可发现性
- **选择:** 通过 sdd-doctor + 达上限提示两个触点让用户知道可配置
- **理由:** sdd-doctor 是入口诊断用户首次接触项目就会跑；达上限时是用户最需要知道可配置的时刻
- **被否决的替代:** 仅在 config.yaml 注释中说明 — 现有项目不会自动获得，用户不会主动翻看配置文件

具体实现：
1. **sdd-doctor** — 诊断报告中新增"限制配置"节，输出当前 limits 配置（含默认值）
2. **兜底提示** — 达到上限的提示消息末尾附加"可在 openspec/config.yaml 的 limits 节中调整上限"

## 约束识别

### 技术约束
- SKILL.md 是纯 Markdown，由 AI 读取执行，无运行时逻辑 — "读取配置"意味着在指令中写明"读取 openspec/config.yaml 的 limits 节，未配置时使用默认值"
- config.yaml 目前无 `limits` 节，新增节需保持与现有结构兼容
- quality-checkpoints.md 中"最多 3 轮"的全局约定需同步更新

### 团队约束
- 改动涉及插件文件（`C:\Users\Dell\.claude\plugins\...`），需在 ai-tools-bridge 源码修改后通过插件更新生效
- 测试用例需同步更新（review-loops.test.ts 验证"最多 3 轮"）

## 未解决的问题

（无）

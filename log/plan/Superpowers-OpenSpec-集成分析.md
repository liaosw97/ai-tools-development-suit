# 分析：Superpowers + OpenSpec 集成

## 当前状态：两个工具的角色

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          SUPERPOWERS                                        │
│                    "HOW to build" (行为规范)                                  │
│                                                                             │
│  brainstorming → writing-plans → subagent-dev → code-review → finish-branch │
│       ↓                ↓              ↓              ↓              ↓       │
│  设计讨论          实现计划         任务执行        代码审查        分支管理    │
│                                                                             │
│  存储: docs/superpowers/specs/ 和 docs/superpowers/plans/                   │
│  强项: TDD纪律, 系统调试, 子代理驱动开发, 行为塑造                            │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                          OPENSPEC                                           │
│                    "WHAT to build" (规格管理)                                 │
│                                                                             │
│  propose → explore → specs → design → tasks → apply → verify → archive     │
│      ↓        ↓       ↓        ↓       ↓        ↓        ↓        ↓       │
│   意图     问题探索   需求规格   技术方案  任务清单   实现执行  验证    归档     │
│                                                                             │
│  存储: openspec/changes/<name>/  (proposal.md, specs/, design.md, tasks.md) │
│  强项: Delta规格管理, 归档历史, Schema自定义, CLI状态管理, 跨工具兼容         │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 核心问题：功能重叠与冲突

```
┌──────────────────────┬──────────────────────┬────────────────────┐
│        阶段          │     Superpowers      │     OpenSpec       │
├──────────────────────┼──────────────────────┼────────────────────┤
│ 需求探索/设计        │ brainstorming skill  │ /opsx:explore      │
│                      │                      │ /opsx:propose      │
├──────────────────────┼──────────────────────┼────────────────────┤
│ 设计文档             │ docs/superpowers/    │ openspec/changes/  │
│                      │   specs/*.md         │   proposal.md      │
├──────────────────────┼──────────────────────┼────────────────────┤
│ 实现计划             │ writing-plans skill  │ design.md +        │
│                      │ docs/superpowers/    │   tasks.md         │
│                      │   plans/*.md         │                    │
├──────────────────────┼──────────────────────┼────────────────────┤
│ 任务执行             │ subagent-driven-dev  │ /opsx:apply        │
├──────────────────────┼──────────────────────┼────────────────────┤
│ 代码审查/验证        │ requesting-code-     │ /opsx:verify       │
│                      │   review             │                    │
├──────────────────────┼──────────────────────┼────────────────────┤
│ 完成/归档            │ finishing-a-         │ /opsx:archive      │
│                      │   dev-branch         │                    │
└──────────────────────┴──────────────────────┴────────────────────┘
```

**当两个插件同时安装时的问题：**

1. **Token浪费** — 两个bootstrap同时注入会话，brainstorming + opsx:explore 重复加载
2. **决策冲突** — Agent不知道该用 brainstorming skill 还是 /opsx:propose
3. **存储碎片化** — 设计文档分散在 docs/superpowers/ 和 openspec/ 两个位置
4. **流程冗余** — 同一个设计被讨论两次、文档写两份

## 建议的集成方案

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      集成后的统一工作流                                      │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  第一层: OpenSpec (规格管理) — "建什么"                              │    │
│  │                                                                     │    │
│  │  /opsx:explore  →  /opsx:propose  →  specs  →  design  →  tasks   │    │
│  │       │                 │              │          │          │       │    │
│  │    问题探索          提案+范围      需求规格    技术方案   任务清单    │    │
│  │                                                                     │    │
│  │  存储: openspec/changes/<name>/  (单一来源)                         │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                              │                                              │
│                              │ tasks.md 驱动                                │
│                              ▼                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  第二层: Superpowers (执行纪律) — "怎么建"                           │    │
│  │                                                                     │    │
│  │  test-driven-dev → subagent-driven-dev → code-review → finish      │    │
│  │       │                    │                   │              │      │    │
│  │    TDD红绿环           分任务执行           代码质量审查    分支管理   │    │
│  │                                                                     │    │
│  │  保留的skills: TDD, debugging, subagent-dev, code-review,           │    │
│  │               git-worktrees, verification                          │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 具体做法：三个层面

### 1. 修改 Superpowers 的 brainstorming skill，让它委托给 OpenSpec

```
当前流程:
  用户说"我要做X"
    → superpowers 触发 brainstorming skill
    → brainstorming 触发 writing-plans
    → 写到 docs/superpowers/specs/ 和 plans/

改后流程:
  用户说"我要做X"
    → superpowers brainstorming 检测到 OpenSpec 存在
    → 委托给 /opsx:propose (规格生成)
    → OpenSpec 生成 proposal.md + specs/ + design.md + tasks.md
    → 任务执行阶段仍用 superpowers 的 subagent-driven-development
```

核心改动：brainstorming 的 checklist 中，步骤 6（写设计文档）和步骤 9（转入 writing-plans）改为：
- 读取 OpenSpec 的 tasks.md 作为任务源
- 调用 `subagent-driven-development` 或 `executing-plans` 来执行

### 2. 统一存储位置

```
当前:
  docs/superpowers/specs/     ← superpowers 的设计文档
  docs/superpowers/plans/     ← superpowers 的计划文档
  openspec/changes/<name>/    ← OpenSpec 的所有工件

改后:
  openspec/changes/<name>/    ← 统一存储所有工件
    ├── proposal.md           ← 来自 OpenSpec
    ├── specs/                ← 来自 OpenSpec
    ├── design.md             ← 来自 OpenSpec
    ├── tasks.md              ← 来自 OpenSpec (superpowers 消费这个)
    └── execution-log.md      ← 可选: superpowers 执行日志
```

### 3. 减少 Token 消耗的具体策略

```
┌──────────────────────┬─────────────────────────────────────────────────┐
│     Token 消耗点      │               优化策略                          │
├──────────────────────┼─────────────────────────────────────────────────┤
│ Bootstrap重复         │ 合并 using-superpowers + openspec skills       │
│                      │ 为一个统一的 bootstrap                         │
├──────────────────────┼─────────────────────────────────────────────────┤
│ brainstorming 加载   │ 让 brainstorming 不再加载完整内容，              │
│ (约2000 tokens)      │ 而是转发到 /opsx:propose                        │
├──────────────────────┼─────────────────────────────────────────────────┤
│ writing-plans 加载   │ 完全跳过，用 OpenSpec 的 tasks.md 替代          │
│ (约1500 tokens)      │ subagent-dev 直接读取 tasks.md                  │
├──────────────────────┼─────────────────────────────────────────────────┤
│ 重复读取设计文档      │ 统一从 openspec/changes/ 读取，                 │
│                      │ 不再有两个来源                                  │
├──────────────────────┼─────────────────────────────────────────────────┤
│ OpenSpec 模板注入    │ 在 openspec/config.yaml 中精简 context，       │
│ (每次工件创建)       │ 只放项目关键技术栈信息                           │
└──────────────────────┴─────────────────────────────────────────────────┘

预估 Token 节省: 每次 "从想法到实现" 的完整循环可省约 3000-5000 tokens
```

## 需要回答的问题

在我深入到具体实现之前，有几个方向性的问题想确认：

1. **你的主要使用场景是什么？** 是个人项目还是团队协作？这会影响集成深度——团队场景可能更依赖 OpenSpec 的规格管理，个人场景可能更看重 Superpowers 的执行效率。

2. **你倾向于哪种集成方式？**
   - **方案 A：桥接层** — 写一个轻量级的 glue skill，让两个插件保持独立但互相感知
   - **方案 B：定制 Superpowers fork** — 直接修改 brainstorming 和 writing-plans skill，内嵌 OpenSpec 感知逻辑
   - **方案 C：定制 OpenSpec schema** — 在 OpenSpec 的 schema 中嵌入 Superpowers 的执行纪律

3. **你主要使用哪个 AI 编码工具？** Claude Code？Cursor？还是多个并用？这影响 skill 的具体实现格式。

4. **Token 消耗的具体痛点在哪里？** 是在规划阶段（brainstorming + 设计）还是在执行阶段（subagent 执行 + code review），还是全局的 bootstrap 开销？

这些问题的答案会决定我们应该走哪条路。你可以先回答，也可以我们继续深挖某个方向。

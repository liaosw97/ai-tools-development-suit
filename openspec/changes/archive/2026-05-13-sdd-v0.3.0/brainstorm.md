# Brainstorm: sdd-v0.3.0

> 深度探索记录 — 记录需求探索过程和关键决策

## 需求描述

使用 ai-tools-bridge 插件过程中发现 4 个核心痛点：

1. **Plan 大变更超时**：改动过多时，`/sdd-plan` 生成内容过长甚至超时
2. **链路太长**：即使简单需求变更，走完全流程也要 2 小时
3. **自动触发不准确**：手动触发 skill 生成文档更准确，自动触发的结果明显不够精确
4. **review-code 后无 test-code**：`/sdd-review-code` 完成后缺少测试补全能力

用户提出的初步方案方向：将 skills 子模块中需要的部分内联合并到 ai-tools-bridge 插件中，并在 README 中标注引用来源。

## 方案探索

### 方案 A: 渐进增强（已选定）

在现有 11 个 action 基础上做增量改进，不改变整体架构。

- 新增 2 个 action（`sdd-quick`、`sdd-test-code`）
- 修改 6 个现有 action 的前置/后置逻辑
- 新增复杂度评估基础设施
- 按需内联 skills 内容
- README 标注引用

- **优点：** 改动可控，向后兼容，现有流程不受影响
- **缺点：** action 数量从 11 增到 13，仍然有一定复杂度

### 方案 B: 架构重组

重新设计 action 体系，按"快/中/慢"三条路径重组。

- 快速路径 `/sdd-quick`、标准路径、深度路径
- 全部内联 skills 的 TDD、diagnose、grill-me、review
- plan 拆为轻量排序和详细计划两个模式

- **优点：** 从根本上解决链路长的问题
- **缺点：** 改动范围大，需重写大部分 SKILL.md，用户需适应新体系

### 方案 C: 最小改动

只做最必要的改动。

- `sdd-plan` 加分批生成
- `sdd-review-code` 后置增加 TDD 补全步骤（不新增独立 action）
- 新增 `/sdd-quick`
- 每个 action 完成后输出推荐操作

- **优点：** 改动最少，风险最低
- **缺点：** 不解决自动触发准确性问题，缺少复杂度评估机制

### 方案比较

选择方案 A 而非 B/C：方案 A 在改动可控性和功能完整性之间取得平衡。13 个 action 仍然可控，新增的 `sdd-quick` 和 `sdd-test-code` 各自职责清晰，复杂度评估 + 推荐操作从根本上改善了路径选择问题，且完全向后兼容。

## 关键决策

### 决策 1: Skills 合并方式 — 直接内联
- **选择:** 将 skills 中有用内容提取为 reference-*.md 文件放入对应 action 目录
- **理由:** 减少外部依赖，简化插件安装和维护
- **被否决的替代:** 保持引用 + 标注（仍依赖 skills 子模块，增加安装复杂度）

### 决策 2: Skills 内联范围 — 按需分批
- **选择:** 本次只内联解决 4 个痛点所需的部分（4 个 reference 文件），其他后续按需
- **理由:** 最小化本次变更范围，降低风险
- **被否决的替代:** 全部合并（改动过大，很多技能与本次痛点无关）

### 决策 3: Plan 超时解决方案 — 可拆则拆 + 分批生成
- **选择:** 需求可拆则拆 change，不可拆则 plan 分批生成（每批 5-10 个任务）
- **理由:** 两种策略互补，覆盖不同场景
- **被否决的替代:** 大变更跳过 plan（失去 TDD 级别的实施指导，质量下降）

### 决策 4: 链路优化方式 — 三合一
- **选择:** 分级路径 + 自由组合 + 新增 /sdd-quick + 推荐操作，全部纳入
- **理由:** 四者互补 — 分级路径是自动推荐，自由组合是手动灵活性，快速命令是一键直达，推荐操作是每步引导
- **被否决的替代:** 只做其中一个（无法全面覆盖链路长的各种场景）

### 决策 5: 触发方式 — 前置校验 + 智能分级触发
- **选择:** 两层改进：(1) 每个 action 增加前置校验逻辑，自动触发前检查上下文完整性（如已有制品、需求清晰度、前置依赖），上下文不足时拒绝自动触发并提示用户补充；(2) 保留自动触发但增加复杂度判断，简单需求走精简流程，复杂需求走完整流程
- **理由:** 手动触发更准确是因为手动触发时用户会先确认上下文状态。前置校验将这种"确认"机制内置到自动触发流程中，从根因上提升准确性
- **被否决的替代:** 全部手动触发（失去自动化便利性）；仅间接缓解（推荐操作引导，不修触发逻辑本身）

### 决策 6: test-code 功能定位 — 独立 TDD 循环补全 action
- **选择:** 新增 `sdd-test-code` action，审查后执行 TDD RED-GREEN 循环补全缺失测试
- **理由:** 职责清晰，只补测试不改实现，与 `sdd-code` 的从零实现形成互补
- **被否决的替代:** 在 sdd-review-code 后置逻辑中嵌入（耦合度高，不可独立触发）

## 设计详情

### 1. 新增 Action: /sdd-quick

快速模式，一条命令完成简单需求的 propose → spec → tasks → code。

**适用边界：**
- 目标场景：低风险、小范围变更（1-3 个文件，明确的行为变更）
- 不适用场景：新领域建模、跨模块重构、涉及外部 API 变更、需要设计决策的需求

**前置自检（进入 quick 流程前）：**
```
/sdd-quick
  → 自检：评估需求复杂度
    → 疑似复杂（超出快速范围）→ 提示用户："该需求可能超出 quick 模式适用范围，
       建议使用 /sdd-propose 开始标准路径。是否继续？"
    → 简单 → 继续
  → 检查是否有 proposal.md
    → 无：交互式收集需求（精简版，最多 5 个苏格拉底式问题）
    → 有：读取已有 proposal
  → 生成 spec/tasks 时检查上限：
    → 场景 > 5 或 任务 > 10 → 提示用户超出 quick 范围，
       已生成的中间产物（proposal/spec）可复用于标准路径
    → 用户选择：回到 /sdd-propose 继续标准路径，或强制继续 quick（风险自担）
  → 连续生成 spec（最多 5 个场景）→ tasks（最多 10 个）→ code（TDD 循环，无 plan.md）
  → 运行测试确认通过
  → 推荐：/sdd-review-code 或 /sdd-ship
```

**质量折中说明：** quick 模式省略 brainstorm、design、plan 和 review 环节。适用于需求明确、影响可控的变更。省略的质量保障由后续 `/sdd-review-code` + `/sdd-verify` 补充。

**委托：**
- 交互收集：内联 `/grill-me` 追问技巧
- spec/tasks：委托 `openspec-continue-change`
- code：委托 `superpowers:test-driven-development`

### 2. 新增 Action: /sdd-test-code

TDD 循环补全，审查后补充缺失测试。

**流程：**
```
/sdd-test-code
  → 读取 reviews/ 最新审查报告
  → 提取 PARTIAL/MISSING 场景 + 测试质量 issues
  → 对每个场景执行 RED-GREEN 循环
    （Override：不修改实现代码，只补充/修复测试）
  → 运行全部测试确认通过
  → 输出补全统计 + 推荐：/sdd-verify 或 /sdd-ship
```

**委托：** `superpowers:test-driven-development`
**内联参考：** `/tdd` 的 tests.md + mocking.md

### 3. 修改 Action: /sdd-plan 分批生成

**前置逻辑新增：**
- 读取 tasks.md 统计任务数量
- 小型（≤10）：正常生成
- 中型（11-25）：提示选择一次性或分批
- 大型（>25）：强制建议拆分 change 或分批

**分批模式：**
- 每批 5-10 个任务，按依赖关系分组
- 逐批生成，每批独立 checkpoint
- reviewer 按批次审查

### 4. 修改 Action: /sdd-doctor 复杂度评估

**新增评估维度：**

| 指标 | 权重 | 来源 |
|------|------|------|
| spec 场景数量 | 高 | specs/*/spec.md |
| tasks 数量 | 高 | tasks.md checkbox |
| 影响文件数 | 中 | proposal.md |
| 涉及领域数 | 中 | specs/ 子目录 |
| 外部依赖变更 | 低 | proposal.md |

**评级（初始经验值，待根据 v0.3.0 使用反馈迭代调整）：**
- 简单(S)：1-3 场景，≤5 任务，单领域
- 中等(M)：4-8 场景，6-15 任务，1-2 领域
- 复杂(L)：>8 场景，>15 任务，3+ 领域

**路径推荐：**
- 简单 → /sdd-quick 或短路径
- 中等 → 标准路径（跳过 brainstorm，可选 review）
- 复杂 → 完整流程

### 5. 前置校验机制（直接修复痛点 3）

**根因分析：** 手动触发更准确的根因是 — 手动触发时用户处于主动确认状态，会自然检查当前上下文（已有制品、需求是否清晰）再决定触发哪个 action。自动触发缺少这层"确认"，在上下文不充分时盲目执行，导致产出不准。

**直接修复方案：为每个 action 增加前置校验层**

每个 action 的前置逻辑中增加上下文完整性检查：

```
前置校验流程：
  1. 检查前置制品是否存在且完整
     - 例：sdd-ff 需要 proposal.md 存在且非空
     - 例：sdd-code 需要 tasks.md 存在且有 checkbox 任务项
  2. 检查上下文清晰度
     - 需求描述是否足够明确（非占位符、非空节）
     - 前置制品的关键字段是否已填充
  3. 校验结果：
     - 通过 → 正常执行
     - 警告（非致命缺失）→ 提示用户缺失项，建议补充后重试，用户确认可强制继续
     - 阻断（致命缺失）→ 拒绝执行，输出具体缺失项和修复建议
```

**校验规则映射表：**

| Action | 必需前置 | 警告条件 | 阻断条件 |
|--------|---------|---------|---------|
| sdd-brainstorm | 无 | — | — |
| sdd-propose | 无 | brainstorm 存在但关键决策有空项 | — |
| sdd-ff | proposal.md | proposal 中影响分析为空 | proposal 不存在 |
| sdd-plan | tasks.md + spec | tasks 无 spec 链接 | tasks 或 spec 不存在 |
| sdd-code | tasks.md（+ plan.md 推荐） | tasks 超过 15 项无 plan | tasks 不存在 |
| sdd-review-code | 代码变更 + spec | spec 场景数 < tasks 数 | 无代码变更或无 spec |
| sdd-test-code | review 报告 | review 中无 PARTIAL/MISSING | review 报告不存在 |
| sdd-verify | spec + 代码 | — | spec 或代码不存在 |
| sdd-ship | 所有制品 | 有未通过的 review | verify 未执行 |
| sdd-quick | 无 | — | — |

### 6. 统一推荐操作机制

每个 action 完成后输出动态推荐：

```
★ 推荐下一步（1 个，最符合当前进度）
○ 可选操作（2-3 个，附前置条件）
△ 跳跃操作（允许但不推荐）
```

推荐映射表：

| 完成的 action | ★ 推荐 | ○ 可选 | △ 跳跃 |
|--------------|--------|--------|---------|
| sdd-brainstorm | /sdd-propose | /sdd-ff | /sdd-quick |
| sdd-propose | /sdd-ff | /sdd-plan | /sdd-brainstorm |
| sdd-ff | /sdd-plan [M/L] /sdd-code [S] | /sdd-review-spec | /sdd-quick |
| sdd-plan | /sdd-code | /sdd-review-spec | — |
| sdd-code | /sdd-review-code [M/L] /sdd-ship [S] | /sdd-verify | — |
| sdd-review-code | /sdd-test-code | /sdd-code | /sdd-ship |
| sdd-test-code | /sdd-verify | /sdd-ship | — |
| sdd-verify | /sdd-ship | /sdd-code | — |
| sdd-review-spec | /sdd-propose | /sdd-ff | — |
| sdd-quick | /sdd-review-code /sdd-ship | /sdd-verify | — |
| sdd-doctor | ★ 按复杂度推荐完整路径（如：/sdd-quick） | ○ /sdd-brainstorm 或 /sdd-propose（手动选择起点） | — |
| sdd-ship | 完成 | — | — |
| sdd-continue | 按进度推荐 | — | — |

### 7. Skills 内联范围

**本次内联（4 个文件）：**

| 来源 | 目标 | 用途 |
|------|------|------|
| /grill-me 追问技巧 | sdd-quick/reference-grill.md | 快速需求收集 |
| /tdd 核心流程 | sdd-quick/reference-tdd-compact.md | 快速 TDD 指导 |
| /tdd/tests.md | sdd-test-code/reference-tdd-tests.md | 测试质量标准 |
| /tdd/mocking.md | sdd-test-code/reference-tdd-mocking.md | Mock 原则 |

**不内联（保持现状）：** /diagnose、/grill-with-docs、/review、/improve-codebase-architecture、/prototype、/zoom-out、/handoff、/caveman

**许可证合规：** skills 子模块（mattpocock-skills）与 ai-tools-bridge 属同一项目体系，均由本工作区管理。内联的 reference 文件头部保留原始出处标注。

## 约束识别

### 技术约束
- ai-tools-bridge 是纯 Markdown 插件，无可执行代码
- 所有逻辑通过 SKILL.md 的提示词实现
- 委托底层 skill 时需通过 Override 指令控制行为
- 复杂度评估只能基于文件内容分析（非运行时计算）

### 团队约束
- 向后兼容：现有用户的工作流不能被破坏
- 版本升级：本次变更将 ai-tools-bridge 从 v0.2.0 升级到 v0.3.0
- README 需标注内联内容的原始来源

## 未解决的问题

（全部已解决，无遗留问题）

## 完整变更清单

| 类型 | 内容 | 对应痛点 |
|------|------|---------|
| 新增 action | `sdd-quick`（快速模式） | 2, 3 |
| 新增 action | `sdd-test-code`（TDD 循环补全） | 4 |
| 修改 action | `sdd-plan`（分批生成 + 上限检测） | 1 |
| 修改 action | `sdd-doctor`（复杂度评估 + 路径推荐） | 2, 3 |
| 修改 action | 所有 action 前置逻辑（前置校验） | 3 |
| 修改 action | 所有 action 后置逻辑（统一推荐操作） | 2, 3 |
| 新增基础设施 | 复杂度评估逻辑 | 2, 3 |
| 内联 skills | 4 个 reference 文件 | 支撑新 action |
| 文档更新 | README.md 引用标注 + 路径推荐 | 文档 |

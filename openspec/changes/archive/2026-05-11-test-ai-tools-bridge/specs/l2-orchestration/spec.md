# Spec: L2 编排验证

> 验证 ai-tools-bridge 插件流程编排的正确性——依赖链、委托关系、覆盖指令、审查循环、制品前置条件

## 能力描述

验证 SDD 工作流编排的内部一致性：schema.yaml 的依赖链与 skill 前置逻辑中检查的制品是否匹配、skill 委托目标是否有效、覆盖指令是否完整、审查循环配置是否正确。

---

## 场景

### dependency-chain-matches-artifact-definitions `ADDED`

**GIVEN**
- `schemas/sdd/schema.yaml` 中 `dependency_chain.chain` 列出了 artifact 的生成顺序
- `schemas/sdd/schema.yaml` 中 `artifacts` 定义了每个 artifact 的属性

**WHEN**
- 提取 `chain` 数组中的每个 artifact 名称
- 检查每个名称是否在 `artifacts` 中有对应定义

**THEN**
- `chain` 中每个名称在 `artifacts` 中存在
- `artifacts` 中标记 `required: true` 的 artifact（proposal, spec, tasks）全部出现在 `chain` 中

---

### artifact-dependencies-reference-valid-artifacts `ADDED`

**GIVEN**
- 每个 artifact 定义包含 `dependencies` 数组（如 spec 的 dependencies 为 `["proposal"]`）

**WHEN**
- 遍历每个 artifact 的 `dependencies` 列表

**THEN**
- 每个 dependency 名称在 `artifacts` 中有定义
- 无循环依赖（dependency 图无环）

---

### skill-delegation-targets-valid `ADDED`

**GIVEN**
- 每个 SKILL.md 的核心执行节可能引用外部技能名（如 `superpowers:brainstorming`、`openspec-continue-change`）
- 已知的外部技能来源：`superpowers:*` 系列和 `openspec-*` 系列

**WHEN**
- 从每个 SKILL.md 中提取所有委托目标技能名

**THEN**
- 提取的委托目标与 CLAUDE.md 中记录的委托表一致
- 每个委托目标格式为 `superpowers:<name>` 或 `openspec-<name>` 或 `openspec-continue-change` 等已知前缀

---

### override-instructions-complete `ADDED`

**GIVEN**
- 以下 skill 的 SKILL.md 包含 Override 指令：
  - `sdd-brainstorm`（委托给 `superpowers:brainstorming`）
  - `sdd-plan`（委托给 `superpowers:writing-plans`）
  - `sdd-review-code` 阶段 2（委托给 `superpowers:requesting-code-review`）

**WHEN**
- 检查每个包含 Override 指令的 SKILL.md

**THEN**
- `sdd-brainstorm` 的 Override 覆盖 4 个要素：
  1. 输出位置重定向到 `openspec/changes/<name>/`
  2. 使用 SDD 模板格式
  3. 禁止自动转场（不自动调用其他 skill）
  4. 跳过内置审查器
- `sdd-plan` 的 Override 覆盖 5 个要素：
  1. 输出位置
  2. 模板格式（保留 spec 链接）
  3. 禁止自动转场
  4. 跳过内置审查器
  5. TDD 步骤要求（RED/GREEN + 验证命令）
- `sdd-review-code` 阶段 2 的 Override 覆盖：
  1. 输出位置
  2. 审查焦点
  3. 跳过功能正确性检查

---

### review-loop-max-3-rounds `ADDED`

**GIVEN**
- 以下 skill 包含审查循环后置逻辑：
  - `sdd-brainstorm`（brainstorm review）
  - `sdd-plan`（plan review）

**WHEN**
- 检查这些 skill 的后置逻辑描述

**THEN**
- 每个审查循环明确说明"最多 3 轮"或"最多 3 轮"的等价表述
- 审查产物命名遵循 `reviews/<artifact>-r<N>.md` 格式（N = 1, 2, 3）

---

### skill-preconditions-match-schema-dependencies `ADDED`

**GIVEN**
- 每个 skill 的前置逻辑声明了需要检查的已有 artifact（如 sdd-plan 检查 tasks.md）
- schema.yaml 中每个 artifact 的 `dependencies` 声明了前置 artifact

**WHEN**
- 对比每个 skill 前置逻辑中检查的 artifact 与 schema 中对应 artifact 的 dependencies

**THEN**
- sdd-plan 前置检查包含 `tasks.md`（与 schema 中 plan 的 dependencies = `["tasks"]` 一致）
- sdd-code 前置检查包含 `tasks.md`（tasks 是实现的基础）
- sdd-verify 前置检查包含 `specs/`（验证需要 spec 场景）
- sdd-ship 前置检查包含 `tasks.md` 且验证所有任务已完成

---

### reviewer-prompts-aligned-with-review-skills `ADDED`

**GIVEN**
- `sdd-brainstorm` 使用 `brainstorm-reviewer-prompt.md`
- `sdd-plan` 使用 `plan-reviewer-prompt.md`
- `sdd-review-spec` 使用 `spec-reviewer-prompt.md`
- `sdd-review-code` 使用 `spec-compliance-reviewer-prompt.md` 和 `code-quality-reviewer-prompt.md`

**WHEN**
- 检查每个 review 类 skill 的 SKILL.md 中引用的 reviewer prompt 文件名

**THEN**
- 引用的文件名与实际文件路径一致
- 每个 reviewer prompt 文件在对应的 skill 目录下存在

---

### skill-three-layer-structure-consistent `ADDED`

**GIVEN**
- SDD 架构定义了三层技能模式：前置逻辑、核心执行、后置逻辑
- 委托类 skill（sdd-brainstorm, sdd-propose, sdd-continue, sdd-ff, sdd-plan, sdd-code, sdd-review-code, sdd-verify, sdd-ship）应有完整三层
- 独立 skill（sdd-doctor, sdd-review-spec）可能只有部分层

**WHEN**
- 检查每个 SKILL.md 的章节结构

**THEN**
- 委托类 skill（9 个）全部包含"前置逻辑"节
- 委托类 skill 全部包含"核心执行"节
- 委托类 skill 全部包含"后置逻辑"节
- `sdd-doctor` 无委托，无 Override
- `sdd-review-spec` 使用 SDD 自有子代理而非外部 skill

---

## 边界条件

- `sdd-code` 的委托是条件性的（3 个 skill 按情况选用），验证时应检查全部 3 个委托目标都被引用
- `sdd-propose` 的委托是条件性选择（`openspec-continue-change` 或 `openspec-propose`），应同时验证两个目标
- `sdd-review-code` 的两阶段委托目标不同（阶段 1 无外部委托，阶段 2 委托给 superpowers），应分别验证
- `sdd-ship` 有 3 个顺序委托步骤，需确保全部 3 个被引用
- schema 中的 optional artifact（brainstorm, design, plan）不应出现在必需 skill 的前置条件中作为必需检查

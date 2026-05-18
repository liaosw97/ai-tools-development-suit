# Proposal: sdd-cross-module-awareness

## 变更意图

增强 SDD 工作流的跨模块感知能力：在 propose 阶段引导跨模块影响分析，在 ship 阶段捕获延后项到 backlog，在 review-spec 阶段增加跨模块一致性审查维度。

## 范围

### 包含

| # | 改造项 | 类型 | 影响文件 |
|---|-------|------|---------|
| 1 | sdd-propose 后置逻辑增加"跨模块影响扫描"引导 | 修改 | `skills/sdd-propose/SKILL.md` |
| 2 | sdd-ship 归档前增加"延后项提取"步骤 | 修改 | `skills/sdd-ship/SKILL.md` |
| 3 | sdd-review-spec 审查维度增加"跨模块一致性" | 修改 | `skills/sdd-review-spec/spec-reviewer-prompt.md` |
| 4 | sdd-brainstorm 前置逻辑增加 backlog.md 读取 | 修改 | `skills/sdd-brainstorm/SKILL.md` |
| 5 | 新增 backlog.md 模板 | 新增 | `schemas/sdd/templates/backlog.md` |

### 不包含

- sdd-quick 的单独修改 — sdd-quick 的 4a 阶段走 propose 路径生成 proposal.md，自动继承改造项 1 的跨模块扫描。4b 阶段基于已有 proposal 生成 specs，跨模块信息已内嵌在 proposal 中
- sdd-ff 的单独修改 — sdd-ff 前置要求 proposal.md 存在，其生成的 specs 基于已包含跨模块分析的 proposal。如需补检，sdd-review-spec（改造项 3）可兜底
- 自动化 backlog 写入 — 手动机制足够（YAGNI）
- 项目配置文件（config.yaml 模块声明） — 不引入 config 依赖

## 决策追溯

- 选择 [方案 A：提示词引导增强] 而非 [方案 B：项目配置+自动化] 或 [方案 C：Spec 目录推导]：当前仅发生过一次遗漏，投入产出比不支持引入 config 或自动化基础设施；SDD 依赖 AI 分析能力而非脚本自动化，提示词增强是 SDD 原生方式（见 brainstorm.md §决策1）

- 选择 [backlog.md 作为项目级可选制品] 而非 [变更级制品或核心依赖链制品]：backlog 不属于制品依赖链（brainstorm → proposal → specs → tasks），是跨变更的追踪工具，不应强制（见 brainstorm.md §决策2）

- 选择 [结构化提问式引导] 而非 [自动化 grep 扫描或 config 驱动检查]：不做自动化扫描，在 propose 后置逻辑中通过结构化提问引导 AI 分析跨模块影响（见 brainstorm.md §决策3）

- 选择 [不单独修改 sdd-quick/sdd-ff] 而非 [为快速路径单独增加跨模块检查]：sdd-quick 走 propose 流程自动继承；sdd-ff 基于 proposal 生成 specs 且可由 sdd-review-spec 兜底；单独修改快速路径违反 DRY（见 review R1 Issue 1）

## 影响分析

### 影响的模块

#### `skills/sdd-propose/SKILL.md`（后置逻辑新增 ~15 行）

在后置逻辑的"决策追溯检查"和"产物校验"之间，新增"跨模块影响扫描"步骤：

```
### 1.5 跨模块影响扫描

读取 proposal.md，检查是否包含跨模块影响分析：
1. 扫描项目结构（specs/ 目录、现有 specs 内容），识别与本次变更相关的其他模块/领域
2. 对每个相关模块，提示用户确认本次变更是否需要同步
3. 如果 proposal 的"范围"节未提及任何跨模块影响，且项目存在多模块结构，输出提示：
   "⚠️ 当前 proposal 未提及跨模块影响。项目中存在 N 个模块/领域，请确认变更范围是否完整。"
4. 如果项目结构不明确（无 specs/、首次使用 SDD），简化为"列出变更可能影响的文件/目录范围"
5. 用户确认后更新 proposal.md（如有新增影响项）
```

#### `skills/sdd-ship/SKILL.md`（前置逻辑新增 ~12 行）

在"最终验证"和"核心执行"之间，新增"延后项提取"步骤：

```
### 2.5 延后项提取

归档前扫描 proposal.md 中的延后项：
1. 读取 proposal.md，搜索 P1/P2/延后/后续迭代等标记
2. 如果存在未完成延后项：
   a. 读取或创建 `openspec/backlog.md`（使用 schemas/sdd/templates/backlog.md 模板）
   b. 将未完成项追加到 backlog 表格，状态为 open
   c. 已完成项标记为 done 并附变更名称
3. 向用户展示提取结果，确认后继续归档
4. 如果 proposal 中无延后项，跳过此步骤
```

#### `skills/sdd-review-spec/spec-reviewer-prompt.md`（新增 1 个审查维度 ~8 行）

在现有 5 个审查维度之后，新增第 6 维度：

```markdown
### 6. 跨模块一致性
- [ ] 如果项目有多个模块/领域（specs/ 下有多个子目录），本次变更是否考虑了对其他模块的影响
- [ ] 如果某个功能在多个模块中共享（如验证脚本、通用工具），spec 是否确认了所有相关模块的覆盖
- [ ] 是否有应该同步变更但被遗漏的关联模块
```

同步更新输出格式的 Approved 清单，增加 `跨模块一致性` 勾选项。

#### `skills/sdd-brainstorm/SKILL.md`（前置逻辑修改 ~5 行）

在"读取项目上下文"步骤中，增加 backlog.md 读取：

```
### 2. 读取项目上下文

- 读取项目的技术栈信息（package.json / go.mod / Cargo.toml 等）
- 读取已有的 CLAUDE.md / GEMINI.md（如有）
- 读取 openspec/config.yaml（如有）
- 读取 openspec/backlog.md（如有）
  - 如果存在且含 open 项，提示用户："backlog 中有 N 个 open 项，是否有与当前需求相关的？"
```

#### `schemas/sdd/templates/backlog.md`（新增 ~15 行）

```markdown
# Backlog

> 跨变更延后项追踪文件。归档时从 proposal 中提取未完成 P1/P2 项写入。

| 来源变更 | 优先级 | 简述 | 状态 |
|---------|--------|------|------|
| <!-- 示例: 2026-01-01-change-name --> | <!-- P1/P2 --> | <!-- 简述 --> | <!-- open/done --> |
```

### 风险评估

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|-------|------|---------|
| 提示词引导被 AI 忽略 | 中 | 低 | sdd-review-spec 的跨模块一致性维度作为兜底检查 |
| backlog.md 手动维护遗忘 | 中 | 低 | sdd-ship 的延后项提取是自动扫描 proposal，仅需用户确认 |
| 跨模块扫描增加 propose 耗时 | 低 | 低 | AI 分析项目结构为秒级，不显著增加耗时 |

## 成功标准

- [ ] **SC-1**: sdd-propose 生成的 proposal 包含跨模块影响分析段落（当项目有多模块时）
- [ ] **SC-2**: sdd-ship 归档后，`openspec/backlog.md` 包含 proposal 中标记的延后项
- [ ] **SC-3**: sdd-review-spec 的审查报告包含"跨模块一致性"维度
- [ ] **SC-4**: sdd-brainstorm 启动时提示 backlog 中的 open 项（当 backlog.md 存在时）
- [ ] **SC-5**: backlog.md 模板符合 schemas/sdd/templates/ 的约定格式

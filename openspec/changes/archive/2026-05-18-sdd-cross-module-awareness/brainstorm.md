# Brainstorm: sdd-cross-module-awareness

## 需求描述

在使用 SkillCraft 项目时，发现安全增强变更（2026-05-17-skill-security-enhancement）将 audit-guide 安全扫描列为 P2 延后项，但归档后该 P2 项无追踪机制，导致被遗忘。最终 skill-audit 在使用中被发现缺少安全检查模块。

根因分析表明这不是单项目问题，而是 **SDD 工作流本身的三个盲区**：

1. **跨模块影响分析缺失**：sdd-propose 生成 proposal 时，没有引导用户考虑"这个功能在其他模块/mode 中是否也需要"。导致变更范围仅覆盖当前焦点，遗漏关联模块。
2. **延后项捕获缺失**：sdd-ship 归档时，不提取 proposal 中的 P1/P2 延后项。归档后这些项尘封在 archive/ 中，无人追踪。
3. **Review 覆盖度不足**：sdd-review-spec 的审查维度（场景完整性、覆盖度、一致性、可测试性、YAGNI）不包含"跨模块一致性"检查，无法发现 spec 遗漏了其他模块中的对应功能。

---

## 方案探索

### 方案 A: 提示词引导增强（轻量）

在现有 SDD skill 的 SKILL.md 中增加提示引导段落，利用 AI 的分析能力而非自动化脚本：

- **sdd-propose**：在 proposal 生成后、定稿前增加"跨模块影响扫描"引导，提示 AI 检查项目结构中是否有其他模块/模式受影响
- **sdd-ship**：在归档前增加"延后项提取"步骤，扫描 proposal 中的 P1/P2/延后标记，写入 `openspec/backlog.md`
- **sdd-review-spec**：在 spec-reviewer-prompt.md 中增加"跨模块一致性"审查维度
- **sdd-brainstorm**：启动时读取 `openspec/backlog.md`（如存在），提示用户是否有相关的 open 项

**优点**: 改动量小（仅修改 SKILL.md 文本）、无新依赖、对现有 SDD 流程零侵入
**缺点**: 依赖 AI 的分析能力，不能保证 100% 覆盖；无自动化兜底

### 方案 B: 项目配置 + 自动化检查（中等）

在 `openspec/config.yaml` 中增加模块结构声明，SDD action 读取后做自动化检查：

```yaml
modules:
  - name: check
    guide: core/references/check-guide.md
  - name: fix
    guide: core/references/fix-guide.md
```

- propose 时自动 grep 相关模块，确认功能覆盖
- ship 时自动扫描 proposal 提取延后项

**优点**: 自动化程度高，CI 可验证
**缺点**: 需要每个项目手动配置模块声明；SDD 目前是无状态的，引入 config 依赖增加复杂度；不同项目的模块结构差异大，难以通用化

### 方案 C: Spec 目录推导（中等）

从 `specs/` 子目录结构自动推导模块划分。SDD action 扫描 specs/ 目录，识别领域/模块边界。

**优点**: 零配置，从已有制品推导
**缺点**: specs/ 结构可能不反映模块划分（按层级而非功能划分）；推导逻辑脆弱

---

## 关键决策

### 决策 1: 采用哪个方案？

**选择: 方案 A（提示词引导增强）**

理由:
- **YAGNI**: 当前仅发生过一次遗漏（SkillCraft），投入产出比不支持引入 config 或自动化基础设施
- **SDD 设计哲学**: SDD 依赖 AI 的分析能力而非脚本自动化，提示词增强是 SDD 原生的方式
- **渐进演进**: 如果提示词引导不够，未来可升级到方案 B（config 驱动），不冲突
- 方案 B 排除理由: 模块结构因项目而异（SkillCraft 是 4 个 mode guide，ai-tools-bridge 是 13 个 skill），难以在 SDD 层面做通用化的 config schema
- 方案 C 排除理由: specs/ 目录结构不稳定，推导逻辑脆弱

**实现路径**:
1. 修改 `sdd-propose/SKILL.md` — 增加跨模块影响扫描引导
2. 修改 `sdd-ship/SKILL.md` — 增加延后项提取步骤
3. 修改 `sdd-review-spec` 的 reviewer prompt — 增加跨模块一致性维度
4. 修改 `sdd-brainstorm/SKILL.md` — 启动时读取 backlog.md
5. 新增 `schemas/sdd/templates/backlog.md` — backlog 模板

### 决策 2: backlog.md 的定位

**选择: 项目级可选制品，非 SDD 核心制品**

理由:
- backlog.md 不属于制品依赖链（brainstorm → proposal → specs → tasks），它是跨变更的追踪工具
- 存储在 `openspec/backlog.md`（项目级），不在 `openspec/changes/<name>/`（变更级）
- 不强制要求存在：sdd-brainstorm/sdd-ship 检查时如文件不存在则跳过，不报错
- 格式简单：Markdown 表格，手动维护

### 决策 3: 跨模块影响扫描的提示策略

**选择: 结构化提问式引导**

理由:
- 不做自动化 grep/扫描（与方案 B/C 的区别）
- 在 propose 的后置逻辑中增加结构化提问：
  1. "列出项目中与本次变更相关的其他模块/模式"
  2. "对每个相关模块，确认本次变更是否需要同步"
  3. "如有延后项，标注 P1/P2 并在范围定义中说明"
- 依赖 AI 读取项目结构和已有 specs 来回答，而非配置文件

---

## 参考资源

1. SkillCraft `audit-security-gap-prevention` 变更 — 问题来源和根因分析
2. `ai-tools-bridge/skills/sdd-propose/SKILL.md` — 待修改：增加跨模块影响扫描
3. `ai-tools-bridge/skills/sdd-ship/SKILL.md` — 待修改：增加延后项提取
4. `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` + reviewer prompt — 待修改：增加跨模块一致性维度
5. `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` — 待修改：启动时读取 backlog
6. `ai-tools-bridge/schemas/sdd/templates/` — 待新增：backlog.md 模板

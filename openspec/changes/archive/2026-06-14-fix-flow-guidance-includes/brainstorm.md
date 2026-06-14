# Brainstorm: SDD 流程指引 include 机制修复

## 问题描述

在 fix-opsx-flow-bleed 变更的代码审查中发现，6 个 SDD action 的流程指引部分使用"直接复制"方式而非"include 引用"方式，导致维护成本高。

**来源**: `openspec/changes/archive/2026-06-13-fix-opsx-flow-bleed/reviews/code-quality-r3.md` (Minor #5)

## 问题分析

### 当前状态

各 SKILL.md 的共享模块引用方式：

| 模块 | 引用方式 | 状态 |
|------|---------|------|
| base-triggers.md | `<!-- include: ../_shared/base-triggers.md -->` | ✅ 使用 include |
| output-constraints.md | `<!-- include: ../_shared/output-constraints.md -->` | ✅ 使用 include |
| role-loading.md | `<!-- include: ../_shared/role-loading.md -->` | ✅ 使用 include |
| sdd-flow-guidance.md | 直接复制内容 | ❌ 未使用 include |

### 问题根源

1. **模板文件已创建** — `skills/_shared/sdd-flow-guidance.md` 已存在
2. **include 机制可用** — 其他共享模块已成功使用 include 引用
3. **流程指引未引用** — 6 个 SKILL.md 的流程指引部分都是直接复制，没有使用 include

### 影响分析

- **维护成本**：修改流程指引格式需要同步修改 6 个文件
- **一致性风险**：手动复制可能导致格式不一致
- **已有问题**：Round 3 审查发现 sdd-quick 和 sdd-verify 的流程指引与模板不一致

## 解决方案探索

### 方案 A: 使用 include 引用整个流程指引块

```markdown
<!-- include: ../_shared/sdd-flow-guidance.md -->
```

**优点**：
- 维护成本最低，改一处即可
- 确保所有 action 的流程指引格式一致

**缺点**：
- 每个 action 的流程指引内容不同，需要条件逻辑
- include 机制可能不支持条件渲染

### 方案 B: 使用 include 引用格式框架，内容保留本地

```markdown
<!-- include: ../_shared/sdd-flow-guidance-framework.md -->
```

框架文件只包含分隔线和标题格式，具体内容由各 SKILL.md 本地定义。

**优点**：
- 格式框架统一
- 内容可定制

**缺点**：
- 需要设计框架和内容的分离方式
- 增加模板复杂度

### 方案 C: 保持现状，在模板文件中明确说明"直接复制"是推荐方式

更新 `sdd-flow-guidance.md` 的使用说明，明确：
- 由于每个 action 的流程指引内容不同，推荐直接复制
- 模板文件仅作为格式参考和内容来源

**优点**：
- 无需修改现有 SKILL.md
- 明确文档说明

**缺点**：
- 维护成本问题未解决
- 需要人工确保一致性

### 方案 D: 创建包含条件逻辑的 include 模板

设计支持条件渲染的模板系统：
```
<!-- include: ../_shared/sdd-flow-guidance.md action="sdd-propose" -->
```

**优点**：
- 完全自动化
- 维护成本最低

**缺点**：
- 需要修改 include 机制支持条件参数
- 实现复杂度高

## 关键决策

### 决策 1: 选择哪种方案？

**技术约束**：
- Include 机制不支持条件参数（仅简单文本插入）
- 修改 include 机制工作量大、风险高

**可行方案**：
- B: include 引用框架 + 本地内容
- C: 保持现状 + 明确文档说明

**选择 [方案 C] 而非 [方案 B]**：
- 方案 C 实现成本最低（仅更新文档说明）
- 方案 B 需要设计框架和内容的分离方式，增加模板复杂度
- 当前"直接复制"方式已经可以工作，只是维护成本略高
- 6 个 SKILL.md 的流程指引格式已经统一（Round 4 修复后），一致性风险已降低

**理由**：
1. include 机制不支持条件渲染，无法实现方案 A 和 D
2. 方案 B 增加的复杂度可能超过其带来的维护收益
3. 方案 C 是最务实的选择，明确文档说明即可

### 决策 2: 是否需要修改 include 机制？

**结论**：不需要

**理由**：
- include 机制的"骨架模板"模式已经足够灵活
- SDD 流程指引的"直接复制"方式是可接受的
- 修改 include 机制的投入产出比不高

## 技术调研

### Include 机制分析

通过检查 `skills/_shared/base-triggers.md` 和实际使用方式，发现：

1. **Include 机制是简单的文本插入** — `<!-- include: path -->` 语法会将目标文件的完整内容插入到当前位置
2. **不支持条件参数** — 没有发现 `<!-- include: path action="xxx" -->` 这样的语法
3. **骨架模板模式** — `base-triggers.md` 使用"骨架模板"模式：
   - 文件内容是占位符模板
   - include 后各 SKILL.md 覆盖具体内容
   - 这种模式适用于"格式框架 + 本地内容"的场景

### SDD 流程指引的特殊性

SDD 流程指引与 base-triggers 不同：
- **base-triggers**: 每个 action 的触发条件不同，但格式相同（骨架模板）
- **sdd-flow-guidance**: 每个 action 的流程指引内容不同，格式也略有差异（如 sdd-ship 使用简化标题）

### 结论

- **方案 A（include 整个块）不可行** — include 机制不支持条件渲染
- **方案 D（条件参数 include）不可行** — 需要修改 include 机制，工作量大
- **方案 B（include 框架 + 本地内容）可行** — 但需要设计框架和内容的分离方式
- **方案 C（保持现状 + 明确文档说明）可行** — 最简单的解决方案

## 参考资源

- 共享模板：`ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`
- 现有 include 示例：`skills/sdd-propose/SKILL.md:12`
- 审查报告：`openspec/changes/archive/2026-06-13-fix-opsx-flow-bleed/reviews/code-quality-r3.md`

## 下一步

1. 确认 Claude Code 的 include 机制能力
2. 选择解决方案
3. 创建 proposal.md 固化决策

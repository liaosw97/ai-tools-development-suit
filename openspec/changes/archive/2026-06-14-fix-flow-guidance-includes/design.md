# Design: SDD 流程指引 include 机制修复

## 技术方案

### 问题背景

Claude Code 的 include 机制（`<!-- include: path -->`）是简单的文本插入，不支持条件参数。由于 SDD 流程指引每个 action 的内容不同，无法使用 include 引用整个块。

### 方案选择

**选择方案 C: 保持现状 + 明确文档说明**

理由：
1. include 机制不支持条件渲染，无法实现方案 A 和 D
2. 方案 B（include 框架 + 本地内容）增加的复杂度可能超过其带来的维护收益
3. 当前"直接复制"方式已经可以工作
4. 6 个 SKILL.md 的流程指引格式已经统一（Round 4 修复后），一致性风险已降低

### 实现细节

#### 1. 更新 `skills/_shared/sdd-flow-guidance.md`

在文件开头的"使用方式"节：

**现有内容**：
```markdown
## 使用方式

各 SKILL.md 可以通过以下方式使用本模板：
1. **直接引用**：使用 `<!-- include: ../_shared/sdd-flow-guidance.md -->` 引用整个模板
2. **复制内容**：将对应 action 的流程指引部分复制到 SKILL.md 的"完成引导"部分

**推荐方式**：由于每个 action 的下一步建议不同，建议直接复制对应 action 的内容到 SKILL.md 中，便于单独定制。
```

**修改为**：
```markdown
## 使用方式

### 推荐方式：直接复制

由于每个 action 的流程指引内容不同，且 Claude Code 的 include 机制不支持条件渲染，**推荐直接复制**对应 action 的内容到 SKILL.md 中。

**复制步骤**：
1. 在本文件中找到对应 action 的流程指引模板（见下方"各 Action 的下一步建议"节）
2. 复制完整的模板内容（包括分隔线）
3. 粘贴到 SKILL.md 的"完成引导"部分

### 不推荐的方式：include 引用

虽然 include 机制（`<!-- include: path -->`）可用于其他共享模块（如 base-triggers.md），但由于 SDD 流程指引每个 action 的内容不同，include 引用会导致所有 action 显示相同的流程指引，不符合预期。
```

#### 2. 添加一致性检查指南

在文件末尾添加：

```markdown
## 一致性检查

当修改流程指引格式时，需要确保 6 个 SKILL.md 的格式一致。

### 检查命令

```bash
# 检查所有 6 个 SKILL.md 是否包含 SDD 流程指引
for skill in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
  grep "SDD 流程指引" ai-tools-bridge/skills/$skill/SKILL.md > /dev/null && echo "$skill: OK" || echo "$skill: MISSING"
done

# 检查分隔线格式
for skill in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
  grep "━━━" ai-tools-bridge/skills/$skill/SKILL.md > /dev/null && echo "$skill: OK" || echo "$skill: MISSING"
done
```

### 一致性要求

- 所有 6 个 SKILL.md 必须包含 SDD 流程指引
- 所有流程指引必须使用 `━━━` 分隔线
- 标题格式必须一致（sdd-ship 使用简化标题）
- 推荐下一步必须使用 ★○△ 标记
```

## 决策追溯

- **选择 [方案 C] 而非 [方案 B]**：include 机制不支持条件渲染，方案 C 实现成本最低（见 brainstorm.md §决策 1）
- **选择 [不修改 include 机制]**：投入产出比不高，当前"骨架模板"模式已足够灵活（见 brainstorm.md §决策 2）

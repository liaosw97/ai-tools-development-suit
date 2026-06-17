# Brainstorm: 修复审查命令无法自动修复文档问题

## 需求描述

**问题**：ai-tools-bridge 插件在文档和代码审查阶段发现了问题，但使用对应的命令（`/sdd-review-spec`、`/sdd-review-code`）并没有修复开发的文档。

**期望**：审查命令发现问题是，能够交互式地询问用户是否修复，并自动执行修复操作。

## 背景分析

### 当前行为

1. `/sdd-review-spec` 和 `/sdd-review-code` 是**审查命令**，只**报告问题**
2. 审查完成后，推荐下一步是 `/sdd-code` 或 `/sdd-test-code` 来修复问题
3. 用户需要手动执行修复命令，或手动编辑文件

### 问题类型

从 `fix-opsx-flow-bleed` 的 review 中发现的问题：

**Important 问题**：
1. sdd-quick 流程指引未区分场景（完整实现 vs 达限中断）
2. sdd-verify 流程指引缺少 `/sdd-test-code` 选项

**Minor 问题**：
3. 共享模板文件未被引用（直接复制而非 include）
4. sdd-flow-guidance.md 中 sdd-quick 的两种场景建议重复

### 根本原因

审查命令的设计是**只报告不修复**，这是合理的职责分离。但用户期望的是**发现问题后能立即修复**，减少上下文切换。

## 方案探索

### 方案 A：增强 review 命令，添加交互式修复

**思路**：在 `/sdd-review-code` 和 `/sdd-review-spec` 的后置逻辑中添加交互式修复阶段。

**优点**：
- 用户体验流畅，发现问题立即修复
- 减少上下文切换
- 修复在发现问题的地方进行

**缺点**：
- 需要修改两个 review 命令
- 逻辑复杂度增加

### 方案 B：创建独立的修复命令 `/sdd-fix`

**思路**：创建新命令，读取 review 文件，逐个询问是否修复。

**优点**：
- 职责分离，review 命令保持简单
- 可以处理多个 review 文件的问题

**缺点**：
- 需要额外步骤
- 用户需要记住新命令

### 方案 C：增强 `/sdd-code` 命令，支持文档修复

**思路**：修改 `/sdd-code`，使其能处理 review 中的文档问题。

**优点**：
- 复用现有命令

**缺点**：
- `/sdd-code` 主要用于代码实现，添加文档修复可能混淆职责

### 方案选择

**选择方案 A**：增强 review 命令，因为修复应该在发现问题的地方进行。

## 设计方案

### 1. 整体架构

在 `/sdd-review-code` 和 `/sdd-review-spec` 的后置逻辑中添加交互式修复阶段：

```
Phase 1: Spec 合规审查
Phase 1.5: 规范扫描
Phase 2: 代码质量审查
Phase 3: 交互式修复（新增）
```

### 2. 交互式修复流程

```
审查完成，发现 N 个问题：
  - [Important] sdd-quick 流程指引未区分场景
  - [Important] sdd-verify 流程指引缺少 /sdd-test-code 选项
  - [Minor] 共享模板文件未被引用

是否进入交互式修复？(y/n)

修复问题 1/3: sdd-quick 流程指引未区分场景
  文件: skills/sdd-quick/SKILL.md:205-211
  建议: 添加两种场景的流程指引

  选项：
  1. 自动修复（按建议修改）
  2. 手动修复（我来修改）
  3. 跳过（不修复）
  4. 标记为已修复（稍后处理）

选择: 1

正在修复...
✅ 已修复: skills/sdd-quick/SKILL.md

修复问题 2/3: sdd-verify 流程指引缺少 /sdd-test-code 选项
  ...
```

### 3. 问题分类和修复策略

| 问题类型 | 修复策略 |
|---------|---------|
| 流程指引格式不一致 | 对照模板，自动更新 SKILL.md |
| 缺少选项 | 添加缺失的选项 |
| 共享模板未被引用 | 添加 include 引用或更新模板说明 |
| 内容重复 | 合并重复内容 |

### 4. 实现细节

**修改的文件**：
- `skills/sdd-review-code/SKILL.md` — 添加 Phase 3
- `skills/sdd-review-spec/SKILL.md` — 添加交互式修复阶段
- `skills/_shared/review-loop.md` — 添加交互式修复模板

**新增的逻辑**：
1. 问题解析：从 review 文件中提取问题列表
2. 交互循环：逐个问题询问是否修复
3. 修复执行：根据问题类型执行相应的修复操作
4. 结果验证：修复后重新检查是否解决问题

### 5. 修复操作示例

**场景 1：流程指引格式不一致**
```markdown
# 读取模板
template = read("skills/_shared/sdd-flow-guidance.md")

# 提取对应 action 的模板内容
action_template = extract_action_template(template, "sdd-quick")

# 更新 SKILL.md
update_skill_file("skills/sdd-quick/SKILL.md", action_template)
```

**场景 2：缺少选项**
```markdown
# 读取当前流程指引
current = read("skills/sdd-verify/SKILL.md", lines: 131-138)

# 添加缺失的选项
updated = add_option(current, "★ /sdd-test-code — FAILED，测试未覆盖场景")

# 更新文件
update_file("skills/sdd-verify/SKILL.md", updated)
```

## 决策追溯

- **选择 [方案 A: 增强 review 命令] 而非 [方案 B: 独立命令]**：修复应该在发现问题的地方进行，减少上下文切换（见方案探索 §方案选择）
- **选择 [交互式修复] 而非 [自动修复]**：保留用户对修复的控制权，避免意外修改（见设计方案 §交互式修复流程）

## 参考资源

- `openspec/changes/archive/2026-06-13-fix-opsx-flow-bleed/reviews/code-quality-r3.md` — 问题来源
- `skills/_shared/sdd-flow-guidance.md` — 流程指引模板
- `skills/_shared/review-loop.md` — Review 循环模板

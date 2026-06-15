# Design: 交互式修复功能

## Context

当前 `/sdd-review-spec` 和 `/sdd-review-code` 命令只报告问题，推荐下一步是 `/sdd-code` 或 `/sdd-test-code`。用户期望审查命令能交互式地询问是否修复问题。

**当前架构**：
- Phase 1: Spec 合规审查（sdd-review-code）
- Phase 1.5: 规范扫描（条件执行）
- Phase 2: 代码质量审查
- 后置逻辑：汇总结果，推荐下一步

## Goals / Non-Goals

**Goals:**
- 在审查命令中添加交互式修复阶段
- 支持逐个问题询问是否修复
- 提供自动修复、手动修复、跳过、标记已修复等选项

**Non-Goals:**
- 不创建独立的修复命令
- 不修改 `/sdd-code` 命令
- 不支持批量自动修复所有问题

## Decisions

### 1. 修复阶段位置

**选择**：在后置逻辑中添加，而非在 Phase 2 之后

**理由**：
- 后置逻辑已经是汇总阶段，适合添加修复选项
- 不影响审查流程的核心逻辑
- 用户可以选择是否进入修复

### 2. 问题解析方式

**选择**：从 review 文件中解析问题列表

**理由**：
- review 文件已经有结构化的问题格式（severity、位置、描述、建议）
- 复用现有格式，无需新增数据结构
- 解析逻辑简单：按 severity 分组，提取问题描述和建议

### 3. 修复执行方式

**选择**：使用 Edit 工具直接修改文件

**理由**：
- 修复操作主要是文本替换（添加选项、更新格式）
- Edit 工具支持精确的字符串替换
- 无需新增复杂的修复逻辑

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|---------|
| 解析 review 文件格式可能失败 | 降级为手动修复选项 |
| 自动修复可能引入新问题 | 修复后重新运行验证 |
| 用户可能误操作跳过重要问题 | 标记为"已跳过"，在汇总中提醒 |

## 实现方案

### 1. 修改 sdd-review-code/SKILL.md

在后置逻辑中添加 Phase 3：

```markdown
### 3. 交互式修复（条件执行）

**仅在发现 Important/Minor issues 时执行。**

询问用户是否进入交互式修复：
- 读取 reviews/code-quality-r<N>.md
- 提取问题列表（按 severity 排序）
- 逐个问题询问：
  1. 自动修复（按建议修改）
  2. 手动修复（我来修改）
  3. 跳过（不修复）
  4. 标记为已修复（稍后处理）

修复后重新运行验证（可选）。
```

### 2. 问题解析逻辑

```markdown
# 从 review 文件中提取问题
def extract_issues(review_file):
    issues = []
    # 匹配 ### [severity: xxx] 标题
    # 提取位置、描述、建议
    return issues

# 生成修复建议
def generate_fix_suggestion(issue):
    if issue.type == "流程指引格式不一致":
        return "对照模板更新 SKILL.md"
    elif issue.type == "缺少选项":
        return "添加缺失的选项"
    # ...
```

### 3. 修复执行逻辑

```markdown
# 执行修复
def execute_fix(issue, choice):
    if choice == "auto":
        # 读取模板，提取对应内容
        # 使用 Edit 工具更新文件
    elif choice == "manual":
        # 显示问题详情，等待用户手动修复
    elif choice == "skip":
        # 记录跳过
    elif choice == "mark":
        # 标记为已修复
```

## Open Questions

1. 是否需要在修复后自动重新运行验证？
2. 是否支持撤销修复操作？
3. 是否需要记录修复历史？

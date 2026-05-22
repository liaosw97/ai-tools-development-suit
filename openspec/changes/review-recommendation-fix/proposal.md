# Proposal: review-recommendation-fix

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

修复 SDD 工作流中审查类 skill 的"推荐下一步"格式问题，包括：无修复选项、选项重复、描述不准确、格式不统一。

## 范围

### 包含
- 统一所有 skill 的"推荐下一步"格式标准
- 为审查类 skill 提供明确的修复路径
- 消除重复和错位的推荐输出

### 不包含
- 非"推荐下一步"相关的 skill 内容修改
- 新增审查功能或审查维度

## 决策追溯

- 选择 [方案 A 的简化版] 而非 [方案 B 或 C]：保持概览性列表 + 展开详情的双层结构，信息层级清晰（见 brainstorm.md §决策 1）
- 选择 [明确修复路径] 而非 [笼统提示"修复后重新"]：用户反馈明确指出缺少具体修复选项（见 brainstorm.md §决策 2）
- 选择 [单一输出点] 而非 [多处输出]：避免验证报告中重复出现"推荐下一步"（见 brainstorm.md §决策 3）

## 影响分析

### 影响的模块
- `ai-tools-bridge/skills/sdd-review-code/SKILL.md` — 后置逻辑的推荐格式
- `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` — 后置逻辑的推荐格式
- `ai-tools-bridge/skills/sdd-verify/SKILL.md` — 验证报告和完成引导的推荐格式
- `ai-tools-bridge/skills/sdd-test-code/SKILL.md` — 完成引导的推荐格式
- `ai-tools-bridge/skills/sdd-plan/SKILL.md` — 完成引导的推荐格式（需统一）
- `ai-tools-bridge/skills/sdd-code/SKILL.md` — 完成引导的推荐格式（需统一）
- `ai-tools-bridge/skills/sdd-quick/SKILL.md` — 完成引导的推荐格式（需统一）
- `ai-tools-bridge/skills/sdd-ff/SKILL.md` — 完成引导的推荐格式（需统一）
- `ai-tools-bridge/skills/sdd-propose/SKILL.md` — 完成引导的推荐格式（需统一）
- `ai-tools-bridge/skills/sdd-continue/SKILL.md` — 完成引导的推荐格式（需统一）

### 风险评估
- **低风险**：仅修改输出格式，不改变核心逻辑
- **兼容性**：现有工作流不受影响

## 成功标准

- [ ] 所有 skill 的"推荐下一步"使用统一格式（★/○/△ 优先级）
- [ ] 审查类 skill 的推荐包含明确的修复路径
- [ ] sdd-verify 不在验证报告中重复输出推荐
- [ ] 所有 skill 的完成引导格式一致

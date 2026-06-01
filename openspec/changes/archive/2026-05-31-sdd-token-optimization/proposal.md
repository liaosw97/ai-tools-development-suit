# Proposal: SDD Token 优化

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

优化 ai-tools-bridge SDD 工作流的 token 消耗，在不影响精度（输出质量和工作流完整性）的前提下，同时降低峰值消耗（context window 占用）和总消耗（成本）。

## 范围

### 包含
- 建立完整的 token 预算视图（定义层 + 执行层）
- 实施懒加载机制（拆分大型 skill、按需加载 guidelines、延迟加载 reviewer prompt）
- 实施上下文压缩（artifact 摘要传递、review 上下文压缩、跨 action 状态压缩）
- 精度验证（3 个典型变更的对比测试）
- 更新 token-optimization.md 指南

### 不包含
- 不修改 Superpowers 核心 skill（仅修改 ai-tools-bridge 的 SDD skill）
- 不改变工作流顺序和依赖关系
- 不减少 review 循环次数（保持最多 3 轮）
- 不简化质量门检查点

## 决策追溯

- 选择 [方案 D（A + B 组合）] 而非 [方案 A（仅懒加载）]：方案 A 总消耗优化有限（仅 10-15%），而方案 D 同时优化峰值和总消耗，最大化效果（见 brainstorm.md §决策 1: 优化方案选择）
- 选择 [小范围测试 + 对比验证] 而非 [不验证直接上线]：不验证风险太高，可能导致精度下降；而小范围测试风险可控，可分阶段验证（见 brainstorm.md §决策 2: 精度验证策略）
- 选择 [先懒加载，后上下文压缩] 而非 [同时实施]：懒加载风险低，可快速见效；压缩需要更多验证，先做不安全（见 brainstorm.md §决策 3: 实施顺序）

## 影响分析

### 影响的模块
- `ai-tools-bridge/skills/sdd-*/SKILL.md` — skill 定义文件需要拆分
- `ai-tools-bridge/guidelines/token-optimization.md` — 需要更新优化策略
- `ai-tools-bridge/schemas/sdd/templates/` — 可能需要调整模板格式
- `openspec/changes/*/` — 状态文件格式变更

### 风险评估
- **精度风险**：摘要可能丢失关键信息 → 缓解：关键字段强制保留 + 人工抽检
- **兼容性风险**：skill 拆分可能影响现有流程 → 缓解：保持向后兼容 + 完整测试
- **复杂度风险**：改动范围大，测试不充分 → 缓解：分阶段实施 + 回归测试

## 成功标准

- [ ] 峰值 token 消耗降低 ≥30%（回滚阈值：<15%）
- [ ] 总 token 消耗降低 ≥35%（回滚阈值：<20%）
- [ ] brainstorm 方案完整性：≥2 个候选方案
- [ ] spec 场景覆盖度：100% 场景有 GIVEN/WHEN/THEN
- [ ] review 循环充分性：最多 3 轮，通过率 ≥80%
- [ ] TDD 步骤严格性：每个任务有 RED/GREEN
- [ ] 精度验证通过：3 个典型变更对比测试无 critical 问题

## 1. 懒加载实现

- [x] 1.1 拆分 sdd-brainstorm（472行 → 3个模块：核心流程、角色系统、拆分模式）[spec:lazy-loading#skill-文件模块化拆分]
- [x] 1.2 拆分 sdd-plan（285行 → 核心流程 + 分批模式）[spec:lazy-loading#skill-文件模块化拆分]
- [x] 1.3 拆分 sdd-code（210行 → 核心流程 + worktree + 调试）[spec:lazy-loading#skill-文件模块化拆分]
- [x] 1.4 实现 guidelines 按需加载机制 [spec:lazy-loading#guidelines-按需加载]
- [x] 1.5 实现 reviewer prompt 延迟加载机制 [spec:lazy-loading#reviewer-prompt-延迟加载]
- [x] 1.6 更新 token-optimization.md 指南 [spec:token-budget#token-消耗测量]

## 2. 上下文压缩实现

- [x] 2.1 设计摘要算法（关键信息提取逻辑）[spec:context-compression#artifact-摘要传递]
- [x] 2.2 实现 spec 摘要传递（场景列表而非完整文件）[spec:context-compression#artifact-摘要传递]
- [x] 2.3 实现 task 摘要传递（任务摘要而非完整 tasks.md）[spec:context-compression#artifact-摘要传递]
- [x] 2.4 实现 review 上下文压缩（diff + spec 场景传递）[spec:context-compression#review-上下文压缩]
- [x] 2.5 设计轻量级状态文件格式（~200 tokens）[spec:context-compression#跨-action-状态压缩]
- [x] 2.6 实现跨 action 状态压缩 [spec:context-compression#跨-action-状态压缩]

## 3. 精度验证

- [x] 3.1 准备 3 个典型变更（简单、中等、复杂）[spec:precision-verification#精度验证测试范围]
- [x] 3.2 执行优化前基线测试（记录 token 消耗和输出质量）[spec:precision-verification#精度对比方法]
- [x] 3.3 执行优化后对比测试（记录相同指标）[spec:precision-verification#精度对比方法]
- [x] 3.4 计算差异并分析结果 [spec:precision-verification#精度对比方法]
- [x] 3.5 人工审核输出质量 [spec:precision-verification#精度验证通过标准]
- [x] 3.6 根据验证结果调优和修复 [spec:precision-verification#精度验证通过标准]

## 4. Token 预算视图

- [x] 4.1 统计定义层 token 消耗（SDD Skills、Superpowers Skills、Templates、Guidelines）[spec:token-budget#定义层-token-预算]
- [x] 4.2 统计执行层 token 消耗（单个 Action、完整流程）[spec:token-budget#执行层-token-预算]
- [x] 4.3 建立 token 预算报告 [spec:token-budget#token-消耗测量]
- [x] 4.4 更新 token-optimization.md 指南 [spec:token-budget#token-消耗测量]

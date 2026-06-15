## 1. 修改 sdd-review-code

- [x] 1.1 在后置逻辑中添加 Phase 3 交互式修复阶段 [spec:sdd-review-code#完整审查流程]
- [x] 1.2 添加问题解析逻辑（从 review 文件提取问题列表） [spec:interactive-fix#显示问题详情]
- [x] 1.3 添加交互循环（逐个问题询问处理方式） [spec:interactive-fix#提供处理选项]
- [x] 1.4 添加修复执行逻辑（自动修复、手动修复、跳过、标记） [spec:interactive-fix#自动修复执行]

## 2. 修改 sdd-review-spec

- [x] 2.1 在后置逻辑中添加交互式修复阶段 [spec:sdd-review-spec#完整审查流程]
- [x] 2.2 复用 sdd-review-code 的问题解析和修复逻辑 [spec:interactive-fix#逐个问题交互]

## 3. 测试验证

- [x] 3.1 测试 sdd-review-code 的交互式修复流程 [spec:sdd-review-code#Phase 3 触发条件]
- [x] 3.2 测试 sdd-review-spec 的交互式修复流程 [spec:sdd-review-spec#交互式修复触发条件]
- [x] 3.3 测试问题解析逻辑（从 review 文件提取问题） [spec:interactive-fix#显示问题详情]
- [x] 3.4 测试修复执行逻辑（自动修复、手动修复、跳过、标记） [spec:interactive-fix#修复完成汇总]

# Tasks: ai-tools-bridge/lib/ CLI 集成

> 实施任务清单

## 1. CLI 脚本开发

- [x] 1.1 实现 summarize-spec.mjs [spec:cli-scripts#提取-spec-场景列表]
- [x] 1.2 实现 summarize-tasks.mjs [spec:cli-scripts#提取任务摘要]
- [x] 1.3 实现 compress-review.mjs [spec:cli-scripts#压缩-review-上下文]
- [x] 1.4 实现 state-file.mjs（create/read/update）[spec:cli-scripts#创建状态文件]

## 2. 集成测试

- [x] 2.1 创建 tests/cli/ 目录和测试基础设施 [spec:testing#使用-vitest-运行集成测试]
- [x] 2.2 编写 summarize-spec 端到端测试 [spec:testing#summarize-spec-端到端]
- [x] 2.3 编写 summarize-tasks 端到端测试 [spec:testing#summarize-tasks-端到端]
- [x] 2.4 编写 compress-review 端到端测试 [spec:testing#compress-review-端到端]
- [x] 2.5 编写 state-file 端到端测试 [spec:testing#state-file-端到端]
- [x] 2.6 验证现有 331 个测试不受影响 [spec:testing#现有测试不受影响]

## 3. SKILL.md 集成

- [x] 3.1 集成 summarize-spec 到 sdd-review-code 前置逻辑 [spec:skill-integration#前置逻辑使用-summarize-spec-获取场景摘要]
- [x] 3.2 集成 compress-review 到 sdd-review-code Phase 2 [spec:skill-integration#phase-2-使用-compress-review-准备上下文]
- [x] 3.3 集成 summarize-spec + summarize-tasks 到 sdd-verify [spec:skill-integration#前置逻辑使用-summarize-spec--summarize-tasks-收集验证材料]
- [x] 3.4 集成 state-file 到 sdd-brainstorm [spec:skill-integration#sdd-brainstorm-创建状态文件]
- [x] 3.5 集成 state-file 到 sdd-propose [spec:skill-integration#sdd-propose-更新状态文件]
- [x] 3.6 集成 state-file 到 sdd-plan [spec:skill-integration#sdd-plan-更新状态文件]
- [x] 3.7 集成 state-file 到 sdd-code [spec:skill-integration#sdd-code-更新状态文件]

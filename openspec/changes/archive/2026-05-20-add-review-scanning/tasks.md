# Tasks: add-review-scanning

## 实施任务

- [x] T1: 新增 scan-reviewer-prompt.md (sdd-review-code) — 扫描子代理提示词，含工作类型检测指令、skill 调度逻辑、结果格式模板 [spec:review-scanning#skill-开发变更的代码审查扫描] [spec:review-scanning#代码开发变更且存在可用规范-skill-的代码审查扫描] [spec:review-scanning#代码开发变更且无可用规范-skill-的代码审查扫描]
- [x] T2: 修改 sdd-review-code SKILL.md — 在 Phase 1 和 Phase 2 之间添加 Phase 1.5 规范扫描阶段，更新后置逻辑汇总模板和完成引导 [spec:review-scanning#skill-开发变更的代码审查扫描] [spec:review-scanning#代码开发变更且存在可用规范-skill-的代码审查扫描] [spec:review-scanning#代码开发变更且无可用规范-skill-的代码审查扫描]
- [x] T3: 新增 scan-reviewer-prompt.md (sdd-review-spec) — spec 审查专用扫描提示词，含 skill 开发检测和 skill-craft 调用逻辑 [spec:review-scanning#skill-开发变更的-spec-审查扫描] [spec:review-scanning#无可用扫描-skill-的-spec-审查]
- [x] T4: 修改 sdd-review-spec SKILL.md — 在主审查后添加规范扫描阶段，更新后置逻辑汇总和完成引导 [spec:review-scanning#skill-开发变更的-spec-审查扫描] [spec:review-scanning#无可用扫描-skill-的-spec-审查]
- [x] T5: 更新测试 — 验证新增/修改的文件符合 ai-tools-bridge 的 schema 约束 [spec:review-scanning#skill-开发变更的代码审查扫描]

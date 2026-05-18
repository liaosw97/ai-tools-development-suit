# Tasks: sdd-cross-module-awareness

> 任务清单 — 将 spec 拆解为可执行的任务

---

## 任务

### 1. sdd-propose 跨模块影响扫描

- [x] 1.1 修改 `skills/sdd-propose/SKILL.md`，在后置逻辑步骤 1 和步骤 2 之间插入步骤 1.5"跨模块影响扫描" [spec:propose-impact-scan#SC-01]
- [x] 1.2 步骤 1.5 包含多模块项目的完整分析逻辑（基于 specs/ 结构和内容推导相关模块，提示用户确认） [spec:propose-impact-scan#SC-01]
- [x] 1.3 步骤 1.5 包含单模块/无 specs 项目的简化处理逻辑（AI 内部分析参考，不修改 proposal） [spec:propose-impact-scan#SC-02]
- [x] 1.4 步骤 1.5 包含用户确认后更新 proposal.md 的引导 [spec:propose-impact-scan#SC-03]
- [x] 1.5 步骤 1.5 包含 proposal 已含跨模块分析时的跳过逻辑 [spec:propose-impact-scan#SC-04]

### 2. sdd-ship 延后项提取

- [x] 2.1 修改 `skills/sdd-ship/SKILL.md`，在前置逻辑步骤 2 之后、核心执行之前插入步骤 2.5"延后项提取" [spec:deferred-capture#SC-01]
- [x] 2.2 步骤 2.5 包含 proposal.md 的 P1/P2/延后关键词扫描逻辑 [spec:deferred-capture#SC-01]
- [x] 2.3 步骤 2.5 跳过 proposal 中已有删除线或显式标注"已完成"的延后项 [spec:deferred-capture#SC-01]
- [x] 2.4 步骤 2.5 包含无延后项时的跳过逻辑 [spec:deferred-capture#SC-02]
- [x] 2.5 步骤 2.5 包含 backlog.md 已存在时的追加逻辑（高度相似项提示用户人工判断） [spec:deferred-capture#SC-03]

### 3. backlog.md 模板

- [x] 3.1 创建 `schemas/sdd/templates/backlog.md`，包含标题、说明段落和表格 [spec:deferred-capture#SC-04]

### 4. sdd-review-spec 审查维度

- [x] 4.1 修改 `skills/sdd-review-spec/spec-reviewer-prompt.md`，在维度 5 之后新增维度 6"跨模块一致性" [spec:review-enhancement#SC-01]
- [x] 4.2 维度 6 包含 3 个检查项，声明判定依赖 AI 分析而非硬性规则 [spec:review-enhancement#SC-01]
- [x] 4.3 更新输出格式中的 Approved 清单，增加"跨模块一致性"勾选项 [spec:review-enhancement#SC-02]
- [x] 4.4 Issues 区域的跨模块问题 severity 根据影响范围判定（minor/major/critical） [spec:review-enhancement#SC-02]
- [x] 4.5 维度 6 包含单模块项目审查时的降级逻辑说明 [spec:review-enhancement#SC-03]

### 5. sdd-brainstorm backlog 读取

- [x] 5.1 修改 `skills/sdd-brainstorm/SKILL.md` 步骤 2，增加 openspec/backlog.md 读取逻辑 [spec:deferred-capture#SC-05]
- [x] 5.2 用户关联 backlog 项时，在 brainstorm.md 的"参考资源"中引用 [spec:deferred-capture#SC-05]
- [x] 5.3 步骤 2 包含 backlog 不存在时的静默跳过逻辑 [spec:deferred-capture#SC-06]

### 6. 全局验证

- [x] 6.1 验证 sdd-propose SKILL.md 的后置逻辑包含步骤 1.0 → 1.5 → 2.0 的编号连续性 [spec:propose-impact-scan#SC-01]
- [x] 6.2 验证 sdd-ship SKILL.md 的前置逻辑包含步骤 2.0 → 2.5 → 核心执行的编号连续性 [spec:deferred-capture#SC-01]
- [x] 6.3 验证 spec-reviewer-prompt.md 包含 6 个审查维度和对应的 Approved 清单 [spec:review-enhancement#SC-01,SC-02]
- [x] 6.4 验证 schemas/sdd/templates/backlog.md 文件存在且格式正确 [spec:deferred-capture#SC-04]

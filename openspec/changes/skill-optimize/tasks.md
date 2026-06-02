## 1. 创建共享模块目录和文件

- [x] 1.1 创建 `skills/_shared/` 目录
- [x] 1.2 提取 `base-triggers.md`（通用触发条件模板）
- [x] 1.3 提取 `output-constraints.md`（输出约束 + 零结果防护）
- [x] 1.4 提取 `role-loading.md`（角色加载完整逻辑）
- [x] 1.5 提取 `breakdown-mode.md`（拆分模式检测 + 交互流程）
- [x] 1.6 提取 `review-loop.md`（review 循环模式）

## 2. 改造 SKILL.md（大文件优先）

- [x] 2.1 改造 `sdd-brainstorm/SKILL.md`（472→124行）
- [x] 2.2 改造 `sdd-plan/SKILL.md`（285→224行）
- [x] 2.3 改造 `sdd-quick/SKILL.md`（212→200行）
- [x] 2.4 改造 `sdd-code/SKILL.md`（210→198行）
- [x] 2.5 改造 `sdd-ship/SKILL.md`（205→193行）

## 3. 改造 SKILL.md（中等文件）

- [x] 3.1 改造 `sdd-doctor/SKILL.md`（186→174行）
- [x] 3.2 改造 `sdd-review-code/SKILL.md`（184→172行）
- [x] 3.3 改造 `sdd-role/SKILL.md`（168→154行）
- [x] 3.4 改造 `sdd-propose/SKILL.md`（147→135行）
- [x] 3.5 改造 `sdd-verify/SKILL.md`（141→129行）

## 4. 改造 SKILL.md（小文件）

- [x] 4.1 改造 `sdd-test-code/SKILL.md`（134→122行）
- [x] 4.2 改造 `sdd-ff/SKILL.md`（126→114行）
- [x] 4.3 改造 `sdd-review-spec/SKILL.md`（125→114行）
- [x] 4.4 改造 `sdd-continue/SKILL.md`（121→109行）

## 5. 验证

- [x] 5.1 运行 `pnpm test` 确认结构验证通过
- [x] 5.2 生成 diff 文件，审查关键 SKILL（sdd-brainstorm、sdd-plan、sdd-code）
- [x] 5.3 执行回归检查清单（frontmatter、触发条件、前置依赖、核心执行、后置逻辑）
- [x] 5.4 验证所有 include 路径有效性
- [x] 5.5 生成 token 节省报告（对比改造前后行数）

## 6. 文档更新

- [x] 6.1 更新 CLAUDE.md 的架构说明（提及共享模块机制）
- [x] 6.2 更新 token-optimization.md 引用新结构

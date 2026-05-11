# Tasks: test-ai-tools-bridge

> 任务清单 — 将 L1/L2 测试 spec 拆解为可执行的任务

---

## 任务

### 基础设施

- [x] 1.1 初始化 package.json，添加 vitest 和 yaml 依赖 [spec:l1-structural#plugin-json-valid]
- [x] 1.2 创建 vitest.config.ts 配置文件 [spec:l1-structural#plugin-json-valid]
- [x] 1.3 创建 tests/setup.ts，实现 resolveRoot 工具函数 [spec:l1-structural#schema-yaml-valid-and-parseable]
- [x] 1.4 在 setup.ts 中实现 parseSkillFrontmatter 函数（YAML frontmatter 提取） [spec:l1-structural#skill-frontmatter-name-description]
- [x] 1.5 在 setup.ts 中实现 loadSchema 函数（schema.yaml 加载与类型化） [spec:l1-structural#schema-yaml-valid-and-parseable]
- [x] 1.6 在 setup.ts 中实现 getSkillDirs 和 getTemplateFiles 辅助函数 [spec:l1-structural#skills-directory-clean]

### L1 结构验证

- [x] 2.1 创建 tests/l1-structural/skill-frontmatter.test.ts — 验证 11 个 SKILL.md 的 YAML frontmatter 含 name 和 description [spec:l1-structural#skill-frontmatter-name-description]
- [x] 2.2 创建 tests/l1-structural/skill-name-matches-dir.test.ts — 验证 frontmatter name 与目录名一致 [spec:l1-structural#skill-name-matches-directory]
- [x] 2.3 创建 tests/l1-structural/skills-directory.test.ts — 验证 skills/ 下只有 sdd-* 子目录且总数为 11 [spec:l1-structural#skills-directory-clean]
- [x] 2.4 创建 tests/l1-structural/plugin-json.test.ts — 验证 plugin.json 合法、含必填字段、version 符合 semver [spec:l1-structural#plugin-json-valid]
- [x] 2.5 创建 tests/l1-structural/template-files.test.ts — 验证模板文件与 schema artifacts 一一对应 [spec:l1-structural#template-files-match-schema-artifacts]
- [x] 2.6 创建 tests/l1-structural/template-placeholders.test.ts — 验证模板占位符覆盖所有 required content_constraints [spec:l1-structural#template-placeholders-cover-content-constraints]
- [x] 2.7 创建 tests/l1-structural/reviewer-prompts.test.ts — 验证 5 个 reviewer prompt 存在、非空、含审查维度和 severity 分级 [spec:l1-structural#reviewer-prompt-files-exist] [spec:l1-structural#reviewer-prompt-has-required-sections]
- [x] 2.8 创建 tests/l1-structural/guidelines.test.ts — 验证 4 个 guidelines 文件存在 [spec:l1-structural#guidelines-files-exist]
- [x] 2.9 创建 tests/l1-structural/schema-yaml.test.ts — 验证 schema.yaml 合法、含 artifacts 和 dependency_chain [spec:l1-structural#schema-yaml-valid-and-parseable]

### L2 编排验证

- [x] 3.1 创建 tests/l2-orchestration/dependency-chain.test.ts — 验证 chain 中的名称在 artifacts 中有定义，required artifact 全在 chain 中 [spec:l2-orchestration#dependency-chain-matches-artifact-definitions]
- [x] 3.2 在 dependency-chain.test.ts 中追加测试 — 验证 artifact dependencies 引用有效且无循环依赖 [spec:l2-orchestration#artifact-dependencies-reference-valid-artifacts]
- [x] 3.3 创建 tests/l2-orchestration/skill-delegation.test.ts — 验证每个 skill 的委托目标与 CLAUDE.md 委托表一致 [spec:l2-orchestration#skill-delegation-targets-valid]
- [x] 3.4 创建 tests/l2-orchestration/override-instructions.test.ts — 验证 sdd-brainstorm(4 要素)、sdd-plan(5 要素)、sdd-review-code(3 要素) 的 Override 完整性 [spec:l2-orchestration#override-instructions-complete]
- [x] 3.5 创建 tests/l2-orchestration/review-loops.test.ts — 验证 sdd-brainstorm 和 sdd-plan 的审查循环含"最多 3 轮"约束 [spec:l2-orchestration#review-loop-max-3-rounds]
- [x] 3.6 创建 tests/l2-orchestration/preconditions.test.ts — 验证 skill 前置条件与 schema 依赖链一致 [spec:l2-orchestration#skill-preconditions-match-schema-dependencies]
- [x] 3.7 创建 tests/l2-orchestration/reviewer-prompt-alignment.test.ts — 验证 SKILL.md 引用的 reviewer prompt 文件路径与实际文件一致 [spec:l2-orchestration#reviewer-prompts-aligned-with-review-skills]
- [x] 3.8 创建 tests/l2-orchestration/three-layer-structure.test.ts — 验证 9 个委托类 skill 有完整三层结构，sdd-doctor 和 sdd-review-spec 结构符合预期 [spec:l2-orchestration#skill-three-layer-structure-consistent]

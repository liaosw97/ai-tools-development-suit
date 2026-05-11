# Plan: test-ai-tools-bridge

> 实施计划 — TDD 级别的详细步骤

---

> **前置条件**: 工作目录为 `D:\Code\AiTools`。所有验证命令假设从此目录执行。

---

## 批次一：基础设施

### Task 1.1: 初始化项目基础设施（package.json + vitest.config.ts + 安装依赖） [spec:l1-structural#plugin-json-valid]

- **文件**: `ai-tools-bridge/package.json` (Create), `ai-tools-bridge/vitest.config.ts` (Create)
- **说明**: 纯基础设施步骤，不做 TDD 循环。vitest 本身的配置有效性会在后续任务中自然验证。
- **实施**:
  1. 创建 `package.json`：`"type": "module"`、`"scripts": {"test": "vitest run"}`、dependencies: `vitest`、`yaml`
  2. 创建 `vitest.config.ts`：配置 `include: ['tests/**/*.test.ts']`
  3. 执行 `cd ai-tools-bridge && npm install`
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run --reporter=verbose`（应报告 "no test files found" 但不报错）

### Task 1.2: 创建 tests/setup.ts，实现 resolveRoot 工具函数 [spec:l1-structural#schema-yaml-valid-and-parseable]

- **文件**: `ai-tools-bridge/tests/setup.ts` (Create), `ai-tools-bridge/tests/setup.test.ts` (Create)
- **RED**: 编写测试验证 resolveRoot 能正确定位 ai-tools-bridge 根目录
  ```
  test('resolveRoot returns path ending with ai-tools-bridge')
  test('resolveRoot("skills") resolves to existing skills/ directory')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`
- **GREEN**: 实现 resolveRoot，基于 `import.meta.url` + `fileURLToPath` + `path.dirname` 向上查找到同时含 `skills/` 和 `schemas/` 子目录的目录作为项目根
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`

### Task 1.3: 在 setup.ts 中实现 parseSkillFrontmatter 函数 [spec:l1-structural#skill-frontmatter-name-description]

- **文件**: `ai-tools-bridge/tests/setup.ts` (Modify), `ai-tools-bridge/tests/setup.test.ts` (Modify)
- **RED**: 编写测试用已知 SKILL.md 内容验证 frontmatter 提取
  ```
  test('parseSkillFrontmatter extracts name and description from sdd-doctor SKILL.md')
  test('parseSkillFrontmatter returns body after frontmatter')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`
- **GREEN**: 实现 parseSkillFrontmatter：正则 `^---\n([\s\S]*?)\n---` 提取 frontmatter 文本，用 `yaml` 库解析，返回 `{ frontmatter, body }`
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`

### Task 1.4: 在 setup.ts 中实现 loadSchema 函数 [spec:l1-structural#schema-yaml-valid-and-parseable]

- **文件**: `ai-tools-bridge/tests/setup.ts` (Modify), `ai-tools-bridge/tests/setup.test.ts` (Modify)
- **RED**: 编写测试验证 loadSchema 返回含 artifacts 和 dependency_chain 的对象
  ```
  test('loadSchema returns artifacts with brainstorm, proposal, spec, design, tasks, plan, review')
  test('loadSchema returns dependency_chain with chain array')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`
- **GREEN**: 实现 loadSchema：读取 schemas/sdd/schema.yaml，用 `yaml` 库解析，缓存结果
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`

### Task 1.5: 在 setup.ts 中实现 getSkillDirs 和 getTemplateFiles 辅助函数 [spec:l1-structural#skills-directory-clean]

- **文件**: `ai-tools-bridge/tests/setup.ts` (Modify), `ai-tools-bridge/tests/setup.test.ts` (Modify)
- **RED**: 编写测试验证函数返回正确路径
  ```
  test('getSkillDirs returns 11 directories matching sdd-*')
  test('getTemplateFiles returns .md files in schemas/sdd/templates/')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`
- **GREEN**: 实现 getSkillDirs（fs.readdirSync 过滤 sdd-*）和 getTemplateFiles（fs.readdirSync 过滤 *.md）
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/setup.test.ts --reporter=verbose`

---

## 批次二：L1 结构验证（上）

### Task 2.1: 创建 skill-frontmatter.test.ts [spec:l1-structural#skill-frontmatter-name-description]

- **文件**: `ai-tools-bridge/tests/l1-structural/skill-frontmatter.test.ts` (Create)
- **RED**: 编写测试验证所有 SKILL.md 的 frontmatter 含非空 name 和 description
  ```
  test.each(skillDirs)('SKILL.md in %s has name and description in frontmatter')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/skill-frontmatter.test.ts --reporter=verbose`
- **GREEN**: 使用 getSkillDirs + parseSkillFrontmatter，遍历 11 个 skill，断言 name/description 非空字符串
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/skill-frontmatter.test.ts --reporter=verbose`

### Task 2.2: 创建 skill-name-matches-dir.test.ts [spec:l1-structural#skill-name-matches-directory]

- **文件**: `ai-tools-bridge/tests/l1-structural/skill-name-matches-dir.test.ts` (Create)
- **RED**: 编写测试验证 frontmatter name 与目录名一致
  ```
  test.each(skillDirs)('frontmatter name in %s matches directory name')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/skill-name-matches-dir.test.ts --reporter=verbose`
- **GREEN**: 提取 path.basename(dir) 与 frontmatter.name 比较
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/skill-name-matches-dir.test.ts --reporter=verbose`

### Task 2.3: 创建 skills-directory.test.ts [spec:l1-structural#skills-directory-clean]

- **文件**: `ai-tools-bridge/tests/l1-structural/skills-directory.test.ts` (Create)
- **RED**: 编写测试验证 skills/ 下只有 sdd-* 子目录且总数为 11
  ```
  test('skills/ has exactly 11 sdd-* subdirectories')
  test('no non-sdd-* directories exist under skills/')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/skills-directory.test.ts --reporter=verbose`
- **GREEN**: 用 fs.readdirSync 列出 skills/ 子目录，过滤 sdd-* 并计数
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/skills-directory.test.ts --reporter=verbose`

### Task 2.4: 创建 plugin-json.test.ts [spec:l1-structural#plugin-json-valid]

- **文件**: `ai-tools-bridge/tests/l1-structural/plugin-json.test.ts` (Create)
- **RED**: 编写测试验证 plugin.json 合法性
  ```
  test('plugin.json is valid JSON with required fields')
  test('version matches semver format')
  test('name is ai-tools-bridge')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/plugin-json.test.ts --reporter=verbose`
- **GREEN**: 读取 .claude-plugin/plugin.json，JSON.parse，断言 name/version/author.name/license 存在，用正则 /^\d+\.\d+\.\d+$/ 验证 semver
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/plugin-json.test.ts --reporter=verbose`

### Task 2.5: 创建 template-files.test.ts [spec:l1-structural#template-files-match-schema-artifacts]

- **文件**: `ai-tools-bridge/tests/l1-structural/template-files.test.ts` (Create)
- **RED**: 编写测试验证模板文件与 schema artifacts 一一对应
  ```
  test('each schema artifact has a corresponding template file')
  test('no extra template files beyond schema artifacts')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/template-files.test.ts --reporter=verbose`
- **GREEN**: 从 schema artifacts 提取 file 字段的文件名（如 brainstorm.md），与 templates/ 目录下的文件名对比
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/template-files.test.ts --reporter=verbose`

---

## 批次三：L1 结构验证（下）

### Task 2.6: 创建 template-placeholders.test.ts [spec:l1-structural#template-placeholders-cover-content-constraints]

- **文件**: `ai-tools-bridge/tests/l1-structural/template-placeholders.test.ts` (Create)
- **`[风险:中]`** 依赖文本匹配（标题行/注释行），匹配规则需兼容中英文字段名
- **RED**: 编写测试验证模板占位符覆盖 required content_constraints
  ```
  test('each required content_constraint field appears in corresponding template')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/template-placeholders.test.ts --reporter=verbose`
- **GREEN**: 遍历 schema artifacts，对每个 required: true 的 content_constraint，在对应模板中搜索 field 名称（匹配 `## <field>` 标题行或含 field 名称的注释行）
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/template-placeholders.test.ts --reporter=verbose`

### Task 2.7: 创建 reviewer-prompts.test.ts [spec:l1-structural#reviewer-prompt-files-exist] [spec:l1-structural#reviewer-prompt-has-required-sections]

- **文件**: `ai-tools-bridge/tests/l1-structural/reviewer-prompts.test.ts` (Create)
- **RED**: 编写测试验证 reviewer prompt 文件存在、非空、含审查维度和 severity 分级
  ```
  test('all 5 reviewer prompt files exist and are non-empty')
  test('each reviewer prompt contains review dimensions section')
  test('each reviewer prompt contains severity levels (critical, major, minor)')
  test('each reviewer prompt specifies output format with 总结, Issues, 结论')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/reviewer-prompts.test.ts --reporter=verbose`
- **GREEN**: 定义 5 个 reviewer prompt 路径映射，逐文件检查内容包含"审查维度"、`critical`/`major`/`minor`、"总结"/"Issues"/"结论"
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/reviewer-prompts.test.ts --reporter=verbose`

### Task 2.8: 创建 guidelines.test.ts [spec:l1-structural#guidelines-files-exist]

- **文件**: `ai-tools-bridge/tests/l1-structural/guidelines.test.ts` (Create)
- **RED**: 编写测试验证 4 个 guidelines 文件存在
  ```
  test('all 4 guideline files exist')
  test.each(['decision-strategy', 'quality-checkpoints', 'token-optimization', 'team-standards'])('%s.md exists')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/guidelines.test.ts --reporter=verbose`
- **GREEN**: 用 resolveRoot + fs.existsSync 检查 4 个文件
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/guidelines.test.ts --reporter=verbose`

### Task 2.9: 创建 schema-yaml.test.ts [spec:l1-structural#schema-yaml-valid-and-parseable]

- **文件**: `ai-tools-bridge/tests/l1-structural/schema-yaml.test.ts` (Create)
- **RED**: 编写测试验证 schema.yaml 合法性
  ```
  test('schema.yaml is valid YAML')
  test('schema.yaml contains artifacts key')
  test('schema.yaml contains dependency_chain with chain array')
  test('artifacts has 7 entries')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/schema-yaml.test.ts --reporter=verbose`
- **GREEN**: 用 loadSchema() 加载，断言 artifacts 有 7 个 key，dependency_chain.chain 是数组
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l1-structural/schema-yaml.test.ts --reporter=verbose`

---

## 批次四：L2 编排验证（上）

### Task 3.1: 创建 dependency-chain.test.ts — chain 与 artifacts 一致性 [spec:l2-orchestration#dependency-chain-matches-artifact-definitions]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/dependency-chain.test.ts` (Create)
- **RED**: 编写测试验证 chain 中每个名称在 artifacts 中有定义，required artifact 全在 chain 中
  ```
  test('every item in dependency_chain.chain exists in artifacts')
  test('every required artifact appears in chain')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/dependency-chain.test.ts --reporter=verbose`
- **GREEN**: 从 loadSchema() 获取 chain 和 artifacts，交叉验证
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/dependency-chain.test.ts --reporter=verbose`

### Task 3.2a: 在 dependency-chain.test.ts 追加测试 — dependencies 引用有效性 [spec:l2-orchestration#artifact-dependencies-reference-valid-artifacts]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/dependency-chain.test.ts` (Modify)
- **RED**: 编写追加测试验证 dependencies 引用有效
  ```
  test('every artifact dependency references a defined artifact')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/dependency-chain.test.ts --reporter=verbose`
- **GREEN**: 遍历每个 artifact 的 dependencies 数组，检查名称在 artifacts 中存在
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/dependency-chain.test.ts --reporter=verbose`

### Task 3.2b: 在 dependency-chain.test.ts 追加测试 — 循环依赖检测 [spec:l2-orchestration#artifact-dependencies-reference-valid-artifacts]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/dependency-chain.test.ts` (Modify)
- **`[风险:中]`** DFS 图算法实现，需注意 visited/recursion-stack 边界处理
- **RED**: 编写追加测试验证无循环依赖
  ```
  test('dependency graph has no cycles')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/dependency-chain.test.ts --reporter=verbose`
- **GREEN**: 构建 artifact 邻接表（name → dependencies），用三色 DFS（white/gray/black）检测环。gray 节点再次访问 = 有环。调试提示：schema 中仅有 7 个 artifact，图很小，可用 console.log 打印遍历路径辅助调试
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/dependency-chain.test.ts --reporter=verbose`

### Task 3.3: 创建 skill-delegation.test.ts [spec:l2-orchestration#skill-delegation-targets-valid]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/skill-delegation.test.ts` (Create)
- **RED**: 编写测试验证每个 skill 的委托目标与 CLAUDE.md 委托表一致
  ```
  test('sdd-brainstorm delegates to superpowers:brainstorming')
  test('sdd-plan delegates to superpowers:writing-plans')
  test('sdd-doctor has no delegation')
  test('all delegation targets in SKILL.md match CLAUDE.md table')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/skill-delegation.test.ts --reporter=verbose`
- **GREEN**: 定义 CLAUDE.md 委托表为 expected map，遍历每个 SKILL.md 的 body 搜索委托目标，与 expected 对比
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/skill-delegation.test.ts --reporter=verbose`

### Task 3.4: 创建 override-instructions.test.ts [spec:l2-orchestration#override-instructions-complete]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/override-instructions.test.ts` (Create)
- **`[风险:中]`** 依赖正则匹配 SKILL.md 正文中的 Override 描述，需注意文本格式可能变化
- **RED**: 编写测试验证 Override 指令完整性
  ```
  test('sdd-brainstorm Override covers 4 elements')
  test('sdd-plan Override covers 5 elements')
  test('sdd-review-code Phase 2 Override covers 3 elements')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/override-instructions.test.ts --reporter=verbose`
- **GREEN**: 读取对应 SKILL.md，在 body 中定位"Override 指令"节，用正则检查：输出位置（`openspec/changes`）、模板格式（`templates`）、禁止转场（`不要自动`）、跳过审查（`跳过`）、TDD 步骤（仅 plan，`RED/GREEN`）
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/override-instructions.test.ts --reporter=verbose`

---

## 批次五：L2 编排验证（下）

### Task 3.5: 创建 review-loops.test.ts [spec:l2-orchestration#review-loop-max-3-rounds]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Create)
- **RED**: 编写测试验证审查循环配置
  ```
  test('sdd-brainstorm post-logic mentions max 3 review rounds')
  test('sdd-plan post-logic mentions max 3 review rounds')
  test('review artifacts follow reviews/<artifact>-r<N>.md naming')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/review-loops.test.ts --reporter=verbose`
- **GREEN**: 读取 sdd-brainstorm 和 sdd-plan 的 SKILL.md body，搜索"最多 3 轮"或"最多 3"或"max 3"，检查产物命名格式
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/review-loops.test.ts --reporter=verbose`

### Task 3.6: 创建 preconditions.test.ts [spec:l2-orchestration#skill-preconditions-match-schema-dependencies]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/preconditions.test.ts` (Create)
- **RED**: 编写测试验证 skill 前置条件与 schema 依赖链一致
  ```
  test('sdd-plan pre-logic checks for tasks.md')
  test('sdd-code pre-logic checks for tasks.md')
  test('sdd-verify pre-logic checks for specs/')
  test('sdd-ship pre-logic checks for tasks.md completion')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/preconditions.test.ts --reporter=verbose`
- **GREEN**: 读取对应 SKILL.md 的前置逻辑节，搜索 artifact 名称（tasks.md、specs/、plan.md 等），与 schema dependencies 对比
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/preconditions.test.ts --reporter=verbose`

### Task 3.7: 创建 reviewer-prompt-alignment.test.ts [spec:l2-orchestration#reviewer-prompts-aligned-with-review-skills]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/reviewer-prompt-alignment.test.ts` (Create)
- **RED**: 编写测试验证 SKILL.md 引用的 reviewer prompt 与实际文件一致
  ```
  test('sdd-brainstorm references brainstorm-reviewer-prompt.md')
  test('sdd-plan references plan-reviewer-prompt.md')
  test('sdd-review-spec references spec-reviewer-prompt.md')
  test('sdd-review-code references spec-compliance and code-quality reviewer prompts')
  test('all referenced reviewer prompt files exist on disk')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/reviewer-prompt-alignment.test.ts --reporter=verbose`
- **GREEN**: 定义 skill→reviewer-prompt 映射，遍历每个 SKILL.md 搜索引用的 prompt 文件名，验证文件存在
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/reviewer-prompt-alignment.test.ts --reporter=verbose`

### Task 3.8: 创建 three-layer-structure.test.ts [spec:l2-orchestration#skill-three-layer-structure-consistent]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/three-layer-structure.test.ts` (Create)
- **RED**: 编写测试验证三层技能模式
  ```
  test('9 delegating skills have 前置逻辑 section')
  test('9 delegating skills have 核心执行 section')
  test('9 delegating skills have 后置逻辑 section')
  test('sdd-doctor has no delegation or Override')
  test('sdd-review-spec uses SDD自有子代理 not external skill')
  ```
- **运行验证失败**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/three-layer-structure.test.ts --reporter=verbose`
- **GREEN**: 定义委托类 skill 列表（排除 sdd-doctor, sdd-review-spec），遍历每个 SKILL.md 搜索"前置逻辑"/"核心执行"/"后置逻辑"标题；单独验证 sdd-doctor 和 sdd-review-spec 的特殊情况
- **运行验证通过**: `cd ai-tools-bridge && npx vitest run tests/l2-orchestration/three-layer-structure.test.ts --reporter=verbose`

---

## 全量验证

完成所有批次后，运行完整测试套件：

```
cd ai-tools-bridge && npx vitest run --reporter=verbose
```

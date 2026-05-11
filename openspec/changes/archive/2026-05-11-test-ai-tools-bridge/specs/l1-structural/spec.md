# Spec: L1 结构验证

> 验证 ai-tools-bridge 插件所有源文件的格式正确性和字段完整性

## 能力描述

对插件的 6 类文件进行静态结构验证：Skill 定义（11 个）、审查提示词（5 个）、制品模板（7 个）、Schema 定义（1 个）、策略文档（4 个）、插件元数据（1 个）。验证内容涵盖文件存在性、YAML/JSON 合法性、必填字段完整性、占位符与 schema 一致性。

---

## 场景

### skill-frontmatter-name-description `ADDED`

**GIVEN**
- `skills/` 目录下存在 11 个 `sdd-*/` 子目录
- 每个 `sdd-*/SKILL.md` 文件以 YAML frontmatter（`---` 分隔）开头

**WHEN**
- 解析每个 `SKILL.md` 的 YAML frontmatter

**THEN**
- 每个 frontmatter 包含 `name` 字段（非空字符串）
- 每个 frontmatter 包含 `description` 字段（非空字符串）
- 共 11 个 SKILL.md 全部通过

---

### skill-name-matches-directory `ADDED`

**GIVEN**
- `skills/` 目录下存在子目录（如 `sdd-doctor/`、`sdd-brainstorm/`）

**WHEN**
- 提取每个 `SKILL.md` frontmatter 中的 `name` 字段值

**THEN**
- `name` 字段值与所在目录名一致（例如 `skills/sdd-doctor/SKILL.md` 的 name 为 `sdd-doctor`）

---

### skills-directory-clean `ADDED`

**GIVEN**
- `skills/` 目录存在

**WHEN**
- 列出 `skills/` 下的所有直接子目录

**THEN**
- 每个子目录名以 `sdd-` 开头
- 无非 `sdd-*` 格式的子目录
- 总数为 11

---

### plugin-json-valid `ADDED`

**GIVEN**
- `.claude-plugin/plugin.json` 文件存在

**WHEN**
- 解析该文件为 JSON

**THEN**
- JSON 合法（无语法错误）
- 包含 `name` 字段，值为 `"ai-tools-bridge"`
- 包含 `version` 字段，值符合 semver 格式（`X.Y.Z`）
- 包含 `author` 对象，含 `name` 字段
- 包含 `license` 字段

---

### template-files-match-schema-artifacts `ADDED`

**GIVEN**
- `schemas/sdd/schema.yaml` 定义了 7 个 artifacts（brainstorm, proposal, spec, design, tasks, plan, review）
- `schemas/sdd/templates/` 目录存在

**WHEN**
- 列出 `templates/` 目录下所有 `.md` 文件
- 列出 schema.yaml 中 artifacts 的 `file` 字段值（去掉路径前缀，仅取文件名）

**THEN**
- 每个 schema artifact 的文件名在 `templates/` 中有对应的 `.md` 文件
- 无多余的模板文件（templates 中的文件都在 schema 中有定义）

---

### template-placeholders-cover-content-constraints `ADDED`

**GIVEN**
- `schemas/sdd/schema.yaml` 中每个 artifact 有 `content_constraints` 列表
- 每个 `content_constraints` 项有 `field` 字段（如"需求描述"、"方案探索"）

**WHEN**
- 读取每个模板文件内容
- 在模板中查找每个 `content_constraints[].field` 名称（作为 `##` 标题或 HTML 注释中的描述文本）

**THEN**
- 每个 artifact 的每个 `required: true` 的 content_constraint field 在对应模板中以标题或注释形式出现

---

### reviewer-prompt-files-exist `ADDED`

**GIVEN**
- 以下 skill 目录应包含 reviewer prompt 文件：
  - `skills/sdd-brainstorm/` → `brainstorm-reviewer-prompt.md`
  - `skills/sdd-plan/` → `plan-reviewer-prompt.md`
  - `skills/sdd-review-spec/` → `spec-reviewer-prompt.md`
  - `skills/sdd-review-code/` → `spec-compliance-reviewer-prompt.md`
  - `skills/sdd-review-code/` → `code-quality-reviewer-prompt.md`

**WHEN**
- 检查每个预期的 reviewer prompt 文件是否存在

**THEN**
- 全部 5 个 reviewer prompt 文件存在
- 每个文件非空

---

### reviewer-prompt-has-required-sections `ADDED`

**GIVEN**
- 5 个 reviewer prompt 文件存在

**WHEN**
- 解析每个 reviewer prompt 文件内容

**THEN**
- 每个文件包含"审查维度"节（以 `## 审查维度` 或包含"审查维度"的标题标记）
- 每个文件包含 severity 分级描述（文本中包含 `critical`、`major`、`minor`）
- 每个文件的输出格式说明包含"总结"、"Issues"、"结论"节

---

### guidelines-files-exist `ADDED`

**GIVEN**
- `guidelines/` 目录存在

**WHEN**
- 列出 `guidelines/` 下所有 `.md` 文件

**THEN**
- 包含 `decision-strategy.md`
- 包含 `quality-checkpoints.md`
- 包含 `token-optimization.md`
- 包含 `team-standards.md`
- 总数为 4

---

### schema-yaml-valid-and-parseable `ADDED`

**GIVEN**
- `schemas/sdd/schema.yaml` 文件存在

**WHEN**
- 用 YAML 解析器解析该文件

**THEN**
- YAML 合法（无语法错误）
- 顶层包含 `artifacts` 键
- 顶层包含 `dependency_chain` 键
- `dependency_chain` 包含 `chain` 数组

---

## 边界条件

- SKILL.md 文件中 frontmatter 前后可能有空白行：解析器应跳过 `---` 之前的空白
- 模板中的 HTML 注释占位符可能用 `<!-- 描述 -->` 或 `<!-- ... -->` 格式：匹配时应查找 field 名称的子串而非精确匹配
- reviewer prompt 中"审查维度"可能以 `## 审查维度` 或在列表项中 `### N. 审查维度名` 形式出现：应匹配包含"审查维度"文本的标题
- plugin.json 中 version 可能有 `v` 前缀：semver 验证应兼容 `"0.2.0"` 格式（无 `v` 前缀）

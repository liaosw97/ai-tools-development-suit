# Design: test-ai-tools-bridge

> 技术设计 — 分层自动化测试的实现方案

## 技术方案

### 方案概述

在 `ai-tools-bridge/tests/` 下建立两层自动化测试，使用 vitest + yaml 库对插件的 Markdown 源文件进行静态分析。

**核心思路**：插件是纯 Markdown，没有运行时 API。测试的本质是"用代码读取 Markdown 文件，验证其结构和内容是否符合约定"。因此设计围绕**文件读取 + 解析 + 断言**三条管线展开。

### 架构图

```
tests/
  setup.ts                          # 共享工具：路径解析、文件遍历
  vitest.config.ts                  # vitest 配置

  l1-structural/                    # L1 结构验证
    skill-frontmatter.test.ts       # 场景: skill-frontmatter-name-description
    skill-name-matches-dir.test.ts  # 场景: skill-name-matches-directory
    skills-directory.test.ts        # 场景: skills-directory-clean
    plugin-json.test.ts             # 场景: plugin-json-valid
    template-files.test.ts          # 场景: template-files-match-schema-artifacts
    template-placeholders.test.ts   # 场景: template-placeholders-cover-content-constraints
    reviewer-prompts.test.ts        # 场景: reviewer-prompt-files-exist + has-required-sections
    guidelines.test.ts              # 场景: guidelines-files-exist
    schema-yaml.test.ts             # 场景: schema-yaml-valid-and-parseable

  l2-orchestration/                  # L2 编排验证
    dependency-chain.test.ts        # 场景: dependency-chain-matches-artifact-definitions + dependencies-reference-valid
    skill-delegation.test.ts        # 场景: skill-delegation-targets-valid
    override-instructions.test.ts   # 场景: override-instructions-complete
    review-loops.test.ts            # 场景: review-loop-max-3-rounds
    preconditions.test.ts           # 场景: skill-preconditions-match-schema-dependencies
    reviewer-prompt-alignment.test.ts # 场景: reviewer-prompts-aligned-with-review-skills
    three-layer-structure.test.ts   # 场景: skill-three-layer-structure-consistent
```

### 关键实现细节

**1. 路径解析**（`setup.ts`）
- 以 `ai-tools-bridge/` 为根目录，通过 `import.meta.url` + `fileURLToPath` 定位项目根
- 导出 `resolveRoot(...segments)` 工具函数

**2. YAML frontmatter 提取**（`setup.ts`）
- 读取文件全文，正则匹配 `^---\n([\s\S]*?)\n---`
- 用 `yaml` 库解析提取的 frontmatter 字符串
- 返回 `{ frontmatter: Record<string, any>, body: string }` 结构

**3. schema.yaml 加载**（`setup.ts`）
- 一次性加载并解析 `schemas/sdd/schema.yaml`
- 导出 `loadSchema()` 函数，返回类型化的 schema 对象

**4. 模板占位符匹配策略**
- 从 schema 的 `content_constraints` 提取 `field` 名称
- 在模板文件中搜索 `## <field>` 标题或 `<!-- ... <field> ... -->` 注释
- 匹配规则：field 名称作为子串出现在标题行或注释行中

**5. 委托目标提取**
- 从 SKILL.md 正文中搜索 `invoke \`xxx\`` 或 `superpowers:xxx`、`openspec-xxx` 模式
- 交叉验证 CLAUDE.md 中的委托表

## 决策追溯

- 选择 [vitest + yaml] 而非 [Jest + 正则]：保持技术栈一致 + 可靠的 YAML 解析（见 brainstorm.md §决策 1, §决策 3）
- 选择 [tests/ 独立目录] 而非 [同目录测试]：避免干扰 skill 发现（见 brainstorm.md §决策 5）
- 选择 [按场景拆分测试文件] 而非 [单文件全包]：每个场景独立可运行，失败时快速定位

## 数据模型

### 新增的数据结构

```typescript
// setup.ts 中定义的类型

interface ParsedSkill {
  dirName: string;              // 目录名，如 "sdd-doctor"
  frontmatter: {
    name: string;               // YAML name 字段
    description: string;        // YAML description 字段
  };
  body: string;                 // frontmatter 之后的正文
}

interface SchemaArtifact {
  description: string;
  required: boolean;
  dependencies: string[];
  file: string;
  content_constraints: {
    field: string;
    required: boolean;
    description: string;
    condition?: string;
  }[];
}

interface SchemaDef {
  artifacts: Record<string, SchemaArtifact>;
  dependency_chain: {
    description: string;
    chain: string[];
    notes: string[];
  };
}
```

## 接口设计

### 新增接口

**`setup.ts` 导出的公共接口：**

| 函数签名 | 用途 |
|---------|------|
| `resolveRoot(...segments: string[]): string` | 解析相对于 `ai-tools-bridge/` 根目录的路径 |
| `parseSkillFrontmatter(filePath: string): ParsedSkill` | 解析 SKILL.md 的 YAML frontmatter |
| `loadSchema(): SchemaDef` | 加载并缓存 schema.yaml |
| `getSkillDirs(): string[]` | 返回 `skills/sdd-*/` 的完整路径列表 |
| `getTemplateFiles(): string[]` | 返回 `schemas/sdd/templates/*.md` 的完整路径列表 |

## 文件变更预估

| 文件 | 操作 | 说明 |
|------|------|------|
| `ai-tools-bridge/package.json` | Create | 项目初始化，含 vitest + yaml 依赖 |
| `ai-tools-bridge/vitest.config.ts` | Create | vitest 配置 |
| `ai-tools-bridge/tests/setup.ts` | Create | 共享工具函数和类型定义 |
| `ai-tools-bridge/tests/l1-structural/*.test.ts` | Create | 9 个 L1 测试文件 |
| `ai-tools-bridge/tests/l2-orchestration/*.test.ts` | Create | 7 个 L2 测试文件 |

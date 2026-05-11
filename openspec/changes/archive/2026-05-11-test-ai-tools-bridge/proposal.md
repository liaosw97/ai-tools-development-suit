# Proposal: test-ai-tools-bridge

> 变更提案 — 为 ai-tools-bridge 插件建立 L1/L2 自动化测试体系

## 变更意图

为 ai-tools-bridge（纯 Markdown 的 SDD 工作流编排器插件）建立自动化测试，通过静态分析验证其 11 个 skill 定义、5 个审查提示词、7 个制品模板、schema 依赖链和 plugin.json 的结构合规性与流程编排正确性。

## 范围

### 包含
- L1 结构验证测试（~12 个用例）：YAML frontmatter 合规、目录结构、plugin.json 校验、模板占位符与 schema content_constraints 匹配、reviewer-prompt 存在性与格式、guidelines 存在性
- L2 编排验证测试（~8 个用例）：schema 依赖链一致性、skill 委托关系正确性、覆盖指令（Override）4 要素完整性、审查循环"最多 3 轮"约束、制品前置条件与 schema 依赖链一致
- 测试基础设施：`tests/` 目录结构、vitest 配置、共享工具函数（YAML 解析、frontmatter 提取、文件遍历）
- `package.json` 初始化（含 vitest + yaml 依赖）

### 不包含
- L3 集成测试（人工验证场景，待后续独立需求处理）
- CI/CD 配置
- 对 Claude Code 运行时行为的测试
- 对 guidelines 内容语义的深度测试（仅验证存在性）

## 决策追溯

- 选择 [vitest] 而非 [Jest]：保持与 OpenSpec 项目技术栈一致，原生 TypeScript 支持（见 brainstorm.md §决策 1）
- 选择 [L1/L2 自动化聚焦] 而非 [同时做 L3 集成场景]：零测试覆盖项目应优先落地可回归的核心测试，L3 占 40% 交付量但无自动化价值（见 brainstorm.md §决策 2）
- 选择 [yaml npm 包] 而非 [正则提取]：需要可靠的 YAML 解析器处理 frontmatter 和 schema.yaml 的嵌套结构（见 brainstorm.md §决策 3）
- 选择 [reviewer-prompt 纳入测试] 而非 [仅验证存在性]：审查提示词是质量保证核心组件，需验证审查维度覆盖完整性（见 brainstorm.md §决策 4）
- 选择 [tests/ 独立目录] 而非 [与 skill 同目录]：避免干扰 Claude Code 的 skill 发现机制（见 brainstorm.md §决策 5）

## 影响分析

### 影响的模块
- `ai-tools-bridge/` — 新增 `tests/` 目录、`package.json`、`vitest.config.ts`（只增不改）
- 现有 skill、template、schema 文件不受任何修改

### 风险评估
- **yaml 库解析边界**：SKILL.md 的 frontmatter 可能包含特殊字符或非标准 YAML，需在测试工具函数中做防御性解析
- **外部技能名变更**：L2 交叉引用测试依赖 superpowers/openspec 的 skill 名称列表，若上游改名需同步更新测试
- **模板占位符约定**：HTML 注释 `<!-- -->` 的匹配规则需明确（是否严格匹配字段名，或允许变体）

## 成功标准

- [ ] `npx vitest run` 在 `ai-tools-bridge/` 目录下成功执行，所有测试通过
- [ ] L1 测试覆盖 brainstorm 待测文件清单中的所有 6 类文件
- [ ] L2 测试验证 schema.yaml 依赖链与 11 个 skill 的前置/委托/后置逻辑一致
- [ ] 每个委托类 skill 的 Override 指令验证 4 要素（输出位置、模板格式、禁止自动转场、跳过内置审查）
- [ ] 共享工具函数支持 YAML frontmatter 提取和 schema.yaml 解析

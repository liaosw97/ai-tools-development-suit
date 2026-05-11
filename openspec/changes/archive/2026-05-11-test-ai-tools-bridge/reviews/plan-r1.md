# Plan Review — Round 1

**审查对象:** plan.md
**日期:** 2026-05-10

## 总结

plan.md 整体结构清晰，按 5 个批次组织了 tasks.md 中全部 22 个任务，每个任务遵循 RED/GREEN/验证 的 TDD 三步格式，spec 链接保留完整。主要问题集中在：(1) 基础设施阶段（Task 1.1-1.2）对自身基础设施的"自举测试"缺乏实际意义，且验证命令指向了错误的测试文件；(2) Task 1.3-1.6 的测试放置位置不明确，基础设施函数的测试散落在 l1-structural 目录中会造成语义混乱；(3) Task 3.2 的循环依赖检测（DFS 图算法）预估耗时超过 5 分钟，粒度偏大；(4) 部分验证命令存在路径假设风险。共发现 2 个 critical、3 个 major、4 个 minor 级别问题。

## Issues

### [severity: critical] Task 1.1 验证命令引用了不存在的测试文件
- **位置:** plan.md §Task 1.1, RED 验证命令
- **描述:** RED 步骤的验证命令为 `npx vitest run tests/l1-structural/schema-yaml.test.ts`，但 Task 1.1 的内容是创建 package.json 并验证其依赖项，与 schema-yaml.test.ts 无关。schema-yaml.test.ts 要到 Task 2.9 才创建。此命令在 Task 1.1 阶段必然报错（文件不存在），无法正确验证 RED 状态。应使用与 package.json 测试对应的命令，或统一使用 `npx vitest run --reporter=verbose 2>&1 || true`。
- **建议:** 将 RED 验证命令改为 `cd ai-tools-bridge && npx vitest run --reporter=verbose 2>&1 || true`，并明确 Task 1.1 的测试应写入哪个文件（例如 `tests/infrastructure/package-json.test.ts` 或直接在 Task 1.1 中标注测试文件路径）。

### [severity: critical] Task 1.1-1.2 的测试文件位置未指定
- **位置:** plan.md §Task 1.1, §Task 1.2
- **描述:** Task 1.1 和 1.2 的 RED 步骤要求"编写测试"，但没有指定测试应写入哪个文件。后续 Task 1.3-1.6 的测试验证命令统一运行 `tests/l1-structural/` 目录，暗示这些基础函数的测试也放在 l1-structural 下，但 l1-structural 是业务验证测试的目录。基础设施函数（resolveRoot, parseSkillFrontmatter, loadSchema 等）的测试放在此处会造成分类混乱。此外，没有明确说明各测试写在哪个具体文件中——是集中在 setup.test.ts 还是分散到后续的各个 l1-structural 测试文件中？
- **建议:** (1) 为基础设施函数创建 `tests/infrastructure/` 目录或 `tests/setup.test.ts`；(2) 在每个任务的 RED 步骤中明确标注测试文件路径，例如 `- **测试文件**: tests/setup.test.ts`。

### [severity: major] Task 3.2 粒度偏大，DFS 环检测实现可能超过 5 分钟
- **位置:** plan.md §Task 3.2
- **描述:** Task 3.2 要求在 dependency-chain.test.ts 中追加测试并实现 DFS 环检测逻辑。编写正确的 DFS 图环检测算法、处理边界情况（空依赖、自引用）、编写对应的测试，预估耗时可能超过 5 分钟。此外，该任务的 GREEN 步骤描述"用 DFS 检测环"过于简略，缺少实现细节（如邻接表构建、visited/recursion stack 的处理）。
- **建议:** 考虑将 Task 3.2 拆分为两个子任务：(a) 依赖引用有效性验证（简单查找）；(b) 循环依赖检测（DFS 实现）。或者在 GREEN 步骤中补充更具体的实现指导。

### [severity: major] Task 1.3 resolveRoot 的定位策略依赖 .claude-plugin 目录
- **位置:** plan.md §Task 1.3, GREEN 步骤
- **描述:** GREEN 步骤描述 resolveRoot"基于 `import.meta.url` + `fileURLToPath` + `path.dirname` 向上查找到含 `.claude-plugin` 的目录"。但实际项目中 `.claude-plugin` 并不一定是 ai-tools-bridge 根目录的标识——经检查，`ai-tools-bridge/` 下未见 `.claude-plugin` 文件或目录（根目录下有 CLAUDE.md、schemas/、skills/ 等）。此定位策略可能无法工作。
- **建议:** 改为查找含 `package.json` 的目录（与 Task 1.1 对齐），或查找含 `skills/` 和 `schemas/` 子目录的目录，或在 GREEN 步骤中明确需要先创建 `.claude-plugin` 标识文件。

### [severity: major] Task 1.5-1.6 的测试在 setup.ts 尚未完成时就需运行
- **位置:** plan.md §Task 1.3-1.6 整体
- **描述:** Task 1.3-1.6 是对同一个文件 `tests/setup.ts` 的增量修改。每个任务的验证命令都是运行 `tests/l1-structural/` 目录下的测试。但 l1-structural 的测试文件在 Task 2.1-2.9 才创建。这意味着在批次一执行时，`tests/l1-structural/` 目录为空或不存在，验证命令实际上不会运行任何测试。基础设施函数的真正验证要等到批次二才能完成，这使得 TDD 的 RED/GREEN 循环在批次一中无法真正闭环。
- **建议:** (1) 为 setup.ts 中的每个函数创建独立的测试文件（如 `tests/setup.test.ts`），使批次一的每个任务都能独立验证；(2) 或调整验证命令，在批次一中使用 `tests/setup.test.ts` 而非 `tests/l1-structural/`。

### [severity: minor] Task 1.1 对 package.json 的"自举测试"意义存疑
- **位置:** plan.md §Task 1.1
- **描述:** Task 1.1 的 RED 步骤要求"创建空 package.json，编写测试检查文件存在且含 vitest/yaml 依赖"。这本质上是在测试自己刚刚创建的文件——如果手动创建了 package.json 并添加了依赖，测试就通过了。这种"测试文件存在"的测试价值较低，且 Task 1.1 还没有安装 vitest（npm install 在 GREEN 步骤），所以 RED 验证命令 `npx vitest` 在此阶段根本无法执行。
- **建议:** 将 Task 1.1 简化为"创建 package.json 并安装依赖"的纯基础设施步骤，不要求 TDD 循环。在 Task 2.4（plugin-json.test.ts）中自然会验证 JSON 解析和字段检查能力。

### [severity: minor] Task 1.2 对 vitest.config.ts 的测试价值较低
- **位置:** plan.md §Task 1.2
- **描述:** 与 Task 1.1 类似，测试"vitest.config.ts exports defineConfig"是在验证 vitest 框架自身的配置约定，而非项目逻辑。vitest 自身会在启动时验证配置文件的有效性。这类测试不测试任何业务规则。
- **建议:** 将 Task 1.2 合并到 Task 1.1 中，作为单个基础设施初始化步骤，跳过 TDD 循环。

### [severity: minor] 验证命令中的相对路径依赖工作目录
- **位置:** plan.md 全部任务的验证命令
- **描述:** 所有验证命令都使用 `cd ai-tools-bridge && npx vitest run ...` 的形式。这假设执行者的工作目录是 `D:\Code\AiTools`。如果工作目录不同，命令会失败。此外，任务中的文件路径（如 `ai-tools-bridge/tests/setup.ts`）也采用相对于项目根目录的写法，但实际测试文件中的路径解析（如 resolveRoot）可能需要不同的相对基准。
- **建议:** 在计划开头添加一个"前置条件"节，明确工作目录假设。或在验证命令中使用绝对路径/环境变量。

### [severity: minor] 缺少失败回退和调试指导
- **位置:** plan.md 全文
- **描述:** 计划中没有标记任何高风险步骤，也没有提供失败时的调试指导。例如：(1) schema.yaml 结构不符合预期时的处理（schema 可能在持续迭代）；(2) SKILL.md 内容格式变更导致正则匹配失败；(3) 循环依赖检测算法的正确性验证。
- **建议:** 在 Task 3.2（DFS 环检测）、Task 2.6（模板占位符匹配）、Task 3.4（Override 指令正则匹配）等依赖文本解析的任务中添加 `[风险:高]` 标记和调试提示。

## Approved
- [x] 任务粒度（除 Task 3.2 外基本合理）
- [ ] TDD 步骤完整性（Task 1.1-1.2 自举测试无实际意义，验证命令路径错误）
- [x] Spec 对齐（全部 22 个 tasks.md 任务已覆盖，spec 链接完整，无额外任务）
- [ ] 依赖顺序（批次一基础设施函数测试无法在 l1-structural 创建前闭环）
- [ ] 风险识别（无风险标记，无回退方案）

## 结论
**NEEDS_REVISION**

plan.md 需要修订后方可执行。核心改动点：(1) 修正 Task 1.1 的验证命令路径错误；(2) 为 Task 1.1-1.6 明确测试文件位置（建议 `tests/setup.test.ts` 或 `tests/infrastructure/`），使批次一的 TDD 循环能独立闭环；(3) 重新评估 Task 1.1-1.2 的 TDD 必要性，考虑合并为纯基础设施步骤；(4) 拆分或细化 Task 3.2；(5) 修正 resolveRoot 的目录定位策略；(6) 添加风险标记和调试提示。

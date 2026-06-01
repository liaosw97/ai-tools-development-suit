# Code Quality Review — Round 1

**审查对象:** ai-tools-bridge f4c9410..ebd11c9
**日期:** 2026-06-01
**Phase 1 状态:** PASSED (with 3 PARTIAL scenarios)

## 审查范围

- lib/ 模块: 4 个文件 (summarizer.ts, review-context.ts, artifact-bridge.ts, state-file.ts)
- scripts/ CLI: 4 个文件 (compress-review.mjs, state-file.mjs, summarize-spec.mjs, summarize-tasks.mjs)
- tests/: 12 个测试文件

## 问题统计

- critical: 2 项
- major: 5 项
- minor: 6 项
- info: 3 项

## Issues 逐项列表

### [critical] YAML 解析实现不一致 — 跨模块状态文件兼容性风险

- **文件**: `lib/state-file.ts` vs `scripts/state-file.mjs`
- **行号**: state-file.ts:2 / state-file.mjs:34-74
- **描述**: TypeScript 模块使用 `yaml` npm 包（`stringify`/`parse`），而 JS CLI 脚本使用手写的简单解析器。两者对同一 YAML 内容的解析行为可能不同：
  - 手写解析器不支持带冒号的值（如 `change: my: project`）、引号字符串、嵌套结构
  - `toYaml` 输出的 `decisions: []` 格式不符合标准 YAML（应为 `decisions: []` 同行或使用 flow style）
  - 手写解析器无法处理 YAML 锚点、别名、多行字符串等
- **建议**: 统一使用 `yaml` npm 包，或在 JS 脚本中通过动态 import 加载 `yaml` 包。如果必须保持无依赖，需大幅增强手写解析器的健壮性，并添加明确的格式文档。

### [critical] `calculateCoverage` 语义与实现不匹配

- **文件**: `lib/summarizer.ts`
- **行号**: 89-105
- **描述**: 函数名和注释表明计算"关键信息覆盖率"，但实现是按空白分词后的单词重叠率。这种实现存在严重问题：
  - 单字符词（如 "a", "I"）会导致大量误匹配
  - 子串匹配过于宽松：`originalField.includes(summaryField)` 意味着 "a" 会匹配所有包含 "a" 的单词
  - 没有区分关键词和停用词，所有词同等权重
  - 对于中文内容完全无效（中文无空格分词）
- **建议**: 重新设计覆盖率算法。至少应：过滤停用词、使用更严格的匹配策略（精确匹配或编辑距离）、对中文使用字符级 n-gram 匹配。

### [major] `extractKeywords` 只提取第一个文件名

- **文件**: `lib/review-context.ts`
- **行号**: 72-74
- **描述**: `diff.match(/diff --git a\/(.+?) b\//)` 使用 `match` 而非 `matchAll`，导致多文件 diff 中只提取第一个文件名。这意味着多文件变更的场景关联会丢失关键信息。
- **建议**: 改用 `matchAll` 或 `exec` 循环提取所有文件名：
  ```typescript
  const fileNameMatches = [...diff.matchAll(/diff --git a\/(.+?) b\//g)];
  fileNameMatches.forEach(m => keywords.push(m[1]));
  ```

### [major] `trimState` 和 `saveStateFile` 重复序列化

- **文件**: `lib/state-file.ts`
- **行号**: 63-72, 77-91
- **描述**: `saveStateFile` 先调用 `stringify(state)` 检查大小，如果超限则调用 `trimState`，`trimState` 内部又循环调用 `stringify` 直到满足大小限制，最后 `saveStateFile` 再次调用 `stringify` 写入。假设 decisions 数组有 N 项，最坏情况下会序列化 N+2 次。
- **建议**: 将 `trimState` 改为返回裁剪后的字符串，避免重复序列化：
  ```typescript
  function trimState(state: StateFile): string {
    let content = stringify(state);
    while (content.length > MAX_SIZE && state.decisions.length > 0) {
      state.decisions.shift();
      content = stringify(state);
    }
    return content;
  }
  ```

### [major] `MAX_SIZE = 500` 过于严格，可能导致数据丢失

- **文件**: `lib/state-file.ts`
- **行号**: 10
- **描述**: 500 字符的限制非常小。假设 change 名称为 50 字符，phase 为 20 字符，YAML 格式开销约 50 字符，留给 decisions 的空间仅约 380 字符。如果有多条较长的决策记录，会被自动裁剪丢失，且没有任何警告或日志。
- **建议**: 
  1. 增大限制（如 2048 或 4096 字符）
  2. 裁剪时输出警告到 stderr
  3. 考虑使用 LIFO 而非 FIFO 策略（保留最新决策而非最旧的）

### [major] `fromYaml` 手写解析器过于脆弱

- **文件**: `scripts/state-file.mjs`
- **行号**: 50-74
- **描述**: 手写 YAML 解析器存在多个边界问题：
  - 值中包含冒号时会被截断（如 `change: my: project`）
  - 不支持引号字符串（`change: "my project"`）
  - `inDecisions` 状态机在遇到非列表项时重置，但如果 decisions 后面紧跟注释会误触发
  - 不处理多行值（`|` 或 `>`）
- **建议**: 使用 `yaml` npm 包，或至少处理带冒号的值（用 `indexOf(':')` 取第一个冒号后的部分）。

### [major] `artifact-bridge.ts` 缺少文件读取错误处理

- **文件**: `lib/artifact-bridge.ts`
- **行号**: 8, 38
- **描述**: `readFileSync(specPath, 'utf-8')` 和 `readFileSync(tasksPath, 'utf-8')` 没有 try-catch 包裹。如果文件不存在或无权限，会抛出未捕获异常，导致调用方收到不友好的错误信息。
- **建议**: 添加 try-catch 并返回有意义的错误信息，或让函数返回 `string | null`。

### [minor] `summarizeSpec` 返回的 `tasks` 字段始终为空数组

- **文件**: `lib/summarizer.ts`
- **行号**: 54
- **描述**: `summarizeSpec` 函数返回的 `SummaryResult` 中 `tasks: []` 是硬编码的空数组。这个字段在 `SummaryResult` 接口中定义但在该函数中从未被填充。这要么是死代码，要么是未完成的功能。
- **建议**: 如果 `tasks` 字段在 spec 摘要中无意义，考虑将 `SummaryResult` 拆分为 `SpecSummaryResult` 和 `TasksSummaryResult` 两个接口。

### [minor] `scenarioPassRate` 硬编码为 0

- **文件**: `lib/review-context.ts`
- **行号**: 26
- **描述**: `scenarioPassRate: 0` 是硬编码值，注释说"需要在实际测试运行后填充"。但如果调用方直接使用这个值而不检查，会产生误导性的质量指标。
- **建议**: 将 `scenarioPassRate` 设为可选字段（`number | null`），或使用 `-1` 表示"未测试"，并在文档中明确说明。

### [minor] 场景正则表达式不一致 — `####` vs `###`

- **文件**: `lib/summarizer.ts` vs `scripts/summarize-spec.mjs`
- **行号**: summarizer.ts:28 / summarize-spec.mjs:29
- **描述**: TypeScript 模块使用 `####\s*Scenario:`（h4），而 JS 脚本使用 `###\s*(?:场景|Scenario):`（h3）。如果 spec 文件使用 h3 格式场景标题，TS 模块会完全无法匹配；如果使用 h4 格式，JS 脚本会匹配不到。
- **建议**: 统一正则表达式，或同时支持 h3 和 h4 级别。

### [minor] `updateStateFile` 直接修改传入参数

- **文件**: `lib/state-file.ts`
- **行号**: 28-34
- **描述**: `updateStateFile` 直接修改 `state` 参数的 `phase` 和 `decisions` 属性。这种 mutation 副作用可能导致调用方意外的状态变化，特别是在并发或重试场景下。
- **建议**: 返回新的 `StateFile` 对象而非修改原对象，或在文档中明确说明此函数会修改输入。

### [minor] `decisions: []` 输出格式非标准 YAML

- **文件**: `scripts/state-file.mjs`
- **行号**: 40-41
- **描述**: 当 decisions 为空时，输出 `  []`（带缩进）。这不是标准的 YAML 空序列表示方式。标准 YAML 应该是 `decisions: []`（同行）或省略该字段。
- **建议**: 改为 `lines.push('decisions: []')` 或直接不输出 decisions 字段。

### [minor] 无路径输入验证

- **文件**: `scripts/state-file.mjs`, `scripts/compress-review.mjs`
- **行号**: state-file.mjs:86, compress-review.mjs:18-19
- **描述**: CLI 脚本直接使用 `resolve()` 处理用户输入的路径，没有验证路径是否在预期目录内。虽然这是本地 CLI 工具风险较低，但如果被其他脚本调用，可能存在路径遍历风险。
- **建议**: 对于本地 CLI 工具，可以接受当前实现。但如果未来作为库使用，应添加路径验证。

### [info] 不安全的类型断言

- **文件**: `lib/state-file.ts`
- **行号**: 47
- **描述**: `const state = parse(content) as StateFile` 使用 `as` 进行类型断言。虽然后续有字段验证（第 50 行），但断言本身是不安全的——如果 YAML 解析返回非对象类型，后续的属性访问会抛出运行时错误。
- **建议**: 使用 Zod 或类似库进行运行时类型验证，或至少添加 `typeof state === 'object'` 检查。

### [info] Import 使用 `.js` 扩展名

- **文件**: `lib/artifact-bridge.ts`
- **行号**: 2
- **描述**: `import { summarizeSpec, summarizeTasks } from './summarizer.js'` 在 TypeScript 文件中使用 `.js` 扩展名。这是 ESM 规范的正确做法（TypeScript 编译后需要 `.js`），但可能对不熟悉此约定的开发者造成困惑。
- **建议**: 保持现状（符合 ESM 规范），但在项目文档中说明此约定。

### [info] `MAX_SIZE` 可能是有意的 Token 优化设计

- **文件**: `lib/state-file.ts`
- **行号**: 10
- **描述**: 结合 CLAUDE.md 中的 "Token 卫生" 约定，500 字符限制可能是有意设计，用于确保状态文件在 AI 上下文中占用最小空间。如果是这样，建议在代码注释中明确说明设计意图。
- **建议**: 添加注释说明此限制与 Token 优化的关系。

## 优点

1. **清晰的模块职责划分**: 每个文件职责单一，`summarizer.ts` 负责解析，`review-context.ts` 负责上下文压缩，`artifact-bridge.ts` 负责桥接，`state-file.ts` 负责状态管理。

2. **TypeScript 接口定义规范**: `ScenarioTriple`, `SummaryResult`, `TaskSummary`, `ReviewContext`, `StateFile` 等接口定义清晰，类型明确。

3. **CLI 脚本的错误处理**: `compress-review.mjs`, `summarize-spec.mjs`, `summarize-tasks.mjs` 等 JS 脚本都有良好的错误处理（try-catch、exit codes、help 信息）。

4. **正则表达式使用合理**: 场景提取、任务提取、diff 解析等正则表达式基本正确，考虑了中英文场景名。

5. **测试覆盖**: 每个 lib 模块和 script 都有对应的测试文件，包括单元测试和精度测试。

6. **函数式风格**: 大部分函数是纯函数或接近纯函数（除了 `updateStateFile`），便于测试和推理。

7. **中文友好的错误信息**: 所有 CLI 脚本的错误信息都使用中文，符合项目约定。

## 结论

**NEEDS_WORK**

发现 2 个 critical 级别问题需要修复：
1. YAML 解析实现不一致可能导致跨模块状态文件损坏
2. `calculateCoverage` 算法语义与实现不匹配，会产生误导性的覆盖率指标

建议在合并前修复 critical 问题，major 问题强烈建议修复但可酌情延后。整体代码结构良好，模块划分清晰，问题主要集中在实现细节和边界条件处理上。

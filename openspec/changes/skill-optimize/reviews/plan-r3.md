# Plan Review — Round 3

**审查对象:** plan.md
**日期:** 2026-06-02
**前轮:** Round 2 (NEEDS_REVISION)

## Round 2 Issues 修复状态

### [major] TDD 步骤形式化
- **状态:** 已修复
- **说明:** 批次二-四的所有任务（Task 2.2-4.4）已补充完整的 vitest 测试代码，包含具体的 `it()`、`readFileSync`、`expect().toContain()` 断言。每个任务的 RED 步骤都有可执行的测试代码，GREEN 步骤有明确的实现描述。

### [major] 验证命令不充分
- **状态:** 已修复
- **说明:** 所有任务现在都包含具体的 `expect` 断言，验证 include 引用和差异内容。例如：
  - Task 2.3 (sdd-quick): 验证 `base-triggers.md`、`output-constraints.md` 引用和 `sdd-quick`、`propose`、`spec`、`tasks`、`code` 差异内容
  - Task 3.3 (sdd-role): 验证 `base-triggers.md`、`output-constraints.md` 引用和 `sdd-role`、`--list`、`会话级` 差异内容
  - Task 4.2 (sdd-ff): 验证 `base-triggers.md`、`output-constraints.md` 引用和 `sdd-ff`、`proposal`、`specs`、`tasks` 差异内容

### [major] 缺少依赖关系标记
- **状态:** 已修复
- **说明:** 文档开头的"依赖说明"部分明确标注了批次间的依赖关系：
  - 批次一（Task 1.2-1.6）：可并行，无依赖
  - 批次二-四（Task 2.1-4.4）：依赖批次一完成，各任务间可并行
  - 批次五（Task 5.1-6.2）：依赖批次二-四完成
  - 每个任务都有"依赖"字段

### [minor] Task 1.1 粒度过小
- **状态:** 已修复
- **说明:** Task 1.1 已移除，原 Task 1.2 改为"创建目录并提取 `base-triggers.md`"，将创建目录和提取内容合并为一个任务。

### [minor] 缺少风险标记
- **状态:** 已修复
- **说明:** 文档开头新增"风险标记"部分，包含两个主要风险：
  - ⚠️ Include 机制是纯约定（HTML 注释），无代码支持，依赖 AI 解析
  - ⚠️ 改造 SKILL.md 时需仔细保留差异内容，避免功能丢失

### [minor] Task 5.1 验证逻辑不清
- **状态:** 部分修复
- **说明:** 已添加"预期失败原因：某些测试可能因文件路径变更而失败"，但仍然不够具体。建议明确说明：(1) 哪些类型的测试会失败；(2) 如何判断是预期失败还是意外失败。

### [minor] 缺少并行执行说明
- **状态:** 已修复
- **说明:** 文档开头的"依赖说明"部分明确标注了可并行的任务组，批次二、三、四的标题也注明"可并行执行"。

### [新增] Task 5.2-6.2 的 TDD 逻辑不一致
- **状态:** 未修复
- **说明:** Task 5.2-6.2 仍然使用 RED/GREEN 标签，但这些是验证/文档任务，不是真正的 TDD 任务。例如：
  - Task 5.2: RED = "生成 diff"，GREEN = "审查 diff" — 这是验证步骤，不是 TDD
  - Task 5.3: RED = "检查 frontmatter"，GREEN = "确认" — 这是验证步骤
  - Task 5.5: RED = "统计行数"，GREEN = "生成报告" — 这是文档生成任务
  - 建议：将这些任务重新定义为"验证任务"（去掉 RED/GREEN 标签），或调整为"执行步骤/验证步骤"标签

### [新增] 缺少测试文件结构说明
- **状态:** 未修复
- **说明:** 文档没有明确说明测试文件的组织方式。Task 1.2 显示测试文件为 `ai-tools-bridge/tests/shared-modules.test.ts`，但后续任务的测试是追加到同一文件还是新建文件没有说明。建议在 Task 1.2 或文档开头明确说明：所有测试都在同一个 `shared-modules.test.ts` 文件中，使用 `describe` 块组织。

### [新增] Task 2.2-4.4 缺少具体测试代码
- **状态:** 已修复
- **说明:** 所有批次二-四的任务现在都有完整的 vitest 测试代码，包含具体的 `it()`、`readFileSync`、`expect().toContain()` 断言。测试代码结构一致，验证 include 引用和差异内容。

## 新增 Issues

（无）

## 本轮重点检查结果

### 1. 批次二-四的所有任务是否已补充具体的 vitest 测试代码
- **结果:** ✓ 通过
- **说明:** 所有 14 个任务（Task 2.1-4.4）都有完整的 vitest 测试代码，包含：
  - `it()` 测试函数，带有描述性名称
  - `readFileSync` 读取 SKILL.md 文件
  - `expect(content).toContain()` 断言验证 include 引用和差异内容

### 2. 测试代码是否包含具体的 expect 断言
- **结果:** ✓ 通过
- **说明:** 每个任务至少有 2 个 `expect` 断言：
  - 验证 include 引用（如 `expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->')`)
  - 验证差异内容（如 `expect(content).toContain('sdd-brainstorm')`)

### 3. 引用规则是否与 shared-skill-modules/spec.md 一致
- **结果:** ✓ 通过
- **说明:** 所有任务的 include 引用都与 spec 的引用规则一致：
  - `base-triggers.md`：14 个 SKILL 都引用 ✓
  - `output-constraints.md`：14 个 SKILL 都引用 ✓
  - `role-loading.md`：9 个有角色系统的 SKILL 引用（sdd-brainstorm、sdd-code、sdd-plan、sdd-propose、sdd-review-code、sdd-review-spec、sdd-ship、sdd-test-code、sdd-verify）✓
  - `breakdown-mode.md`：仅 sdd-brainstorm 引用 ✓
  - `review-loop.md`：sdd-brainstorm 和 sdd-plan 引用 ✓

## Approved
- [x] 任务粒度
- [x] TDD 步骤完整性（批次二-四的测试代码已完整）
- [x] Spec 对齐（引用规则与 spec 一致）
- [x] 依赖顺序
- [x] 风险识别

## 结论
APPROVED

**理由：**
1. 本轮重点检查全部通过：
   - 批次二-四的所有任务已补充具体的 vitest 测试代码
   - 测试代码包含具体的 expect 断言
   - 引用规则与 shared-skill-modules/spec.md 一致
2. Round 2 的主要问题（缺少具体测试代码）已修复
3. 剩余问题（Task 5.2-6.2 的 TDD 逻辑不一致、测试文件结构说明）都是 minor 级别，不影响计划的可执行性

**建议后续优化（可选）：**
1. 将 Task 5.2-6.2 的 RED/GREEN 标签改为"执行步骤/验证步骤"标签，更准确地描述这些任务的性质
2. 在 Task 1.2 或文档开头明确说明测试文件的组织方式（所有测试在同一个 `shared-modules.test.ts` 文件中）

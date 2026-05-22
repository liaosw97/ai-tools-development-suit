# Plan: quick-limit-fallback

> 实施计划 — TDD 级别的详细步骤

---

## 批次 1/3：配置机制

<!-- 依赖：无（基础层） -->
<!-- 任务范围：1.1-1.4 -->

### Task 1.1: 修改 sdd-quick SKILL.md — 增加 limits 配置读取指令 [spec:limits-config#读取已配置的 limits 值]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 在 `review-loops.test.ts` 新增测试用例，验证 sdd-quick SKILL.md 提及读取 `openspec/config.yaml` 的 `limits` 节
  ```ts
  test('sdd-quick mentions reading limits config from config.yaml', () => {
    const body = readSkillBody('sdd-quick');
    const hasLimitsConfig = body.includes('config.yaml') && body.includes('limits');
    expect(hasLimitsConfig, 'sdd-quick missing limits config reading instruction').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 在 sdd-quick SKILL.md 的前置逻辑节（§前置校验之后）添加配置读取指令：
  - 读取 `openspec/config.yaml` 的 `limits` 节
  - 未配置时使用默认值（quick-questions: 5, quick-scenarios: 5, quick-tasks: 10）
  - 配置值为非法类型或无效值时使用默认值
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 1.2: 修改 sdd-brainstorm SKILL.md — 增加 review-rounds 配置读取指令 [spec:limits-config#读取已配置的 limits 值]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试用例，验证 sdd-brainstorm SKILL.md 提及读取 limits.review-rounds 配置
  ```ts
  test('sdd-brainstorm mentions reading limits.review-rounds from config', () => {
    const body = readSkillBody('sdd-brainstorm');
    const hasReviewRounds = body.includes('limits') && body.includes('review-rounds');
    expect(hasReviewRounds, 'sdd-brainstorm missing review-rounds config reading').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 在 sdd-brainstorm SKILL.md 的后置 review 循环节（第 102 行附近）修改：
  - 将"最多 3 轮"改为"读取 openspec/config.yaml 的 limits.review-rounds（默认 3）"
  - 保留现有 review 流程结构，仅替换硬编码数字为配置读取逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 1.3: 修改 sdd-plan SKILL.md — 增加 review-rounds 配置读取指令 [spec:limits-config#读取已配置的 limits 值]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试用例，验证 sdd-plan SKILL.md 提及读取 limits.review-rounds 配置
  ```ts
  test('sdd-plan mentions reading limits.review-rounds from config', () => {
    const body = readSkillBody('sdd-plan');
    const hasReviewRounds = body.includes('limits') && body.includes('review-rounds');
    expect(hasReviewRounds, 'sdd-plan missing review-rounds config reading').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 在 sdd-plan SKILL.md 的后置 review 循环节（第 158 行附近）修改：
  - 将"最多 3 轮"改为"读取 openspec/config.yaml 的 limits.review-rounds（默认 3）"
  - 保留现有 review 流程结构，仅替换硬编码数字为配置读取逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 1.4: 修改 sdd-doctor SKILL.md — 新增限制配置诊断节 [spec:limits-config#sdd-doctor 输出 limits 配置状态]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试用例，验证 sdd-doctor SKILL.md 提及 limits 配置诊断输出
  ```ts
  test('sdd-doctor mentions limits configuration in diagnostic output', () => {
    const body = readSkillBody('sdd-doctor');
    const hasLimits = body.includes('limits') && body.includes('默认值');
    expect(hasLimits, 'sdd-doctor missing limits diagnostic section').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 在 sdd-doctor SKILL.md 的"4. 输出诊断报告"节和"5. 路径推荐"节之间新增"4.5 限制配置"步骤：
  - 读取 openspec/config.yaml 的 limits 节
  - 输出每个配置项（quick-questions, quick-scenarios, quick-tasks, review-rounds）的当前值
  - 未配置的项标注"(默认值)"和默认数值
  - 更新诊断报告模板，新增"限制配置"节
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

--- checkpoint ---

## 批次 2/3：sdd-quick 达限兜底 + 可发现性

<!-- 依赖：批次 1（配置读取机制） -->
<!-- 任务范围：2.1-2.5, 4.1 -->

### Task 2.1: sdd-quick 需求收集提问达限 — 输出提示和选项 [spec:quick-limit-fallback#需求收集提问达限 — 用户选择继续追问]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试，验证 sdd-quick SKILL.md 包含提问达限分支逻辑
  ```ts
  test('sdd-quick has question limit fallback with user options', () => {
    const body = readSkillBody('sdd-quick');
    const hasFallback = body.includes('继续追问') && body.includes('标准路径');
    expect(hasFallback, 'sdd-quick missing question limit fallback options').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 修改 sdd-quick SKILL.md §4a 交互收集节，在"最多 5 个问题"处替换为达限分支：
  - 已提问数 = limits.quick-questions 时触发
  - 输出已达上限提示，列出已澄清和未澄清的要点
  - 提供选项：`① 继续追问（无上限）` / `② 切换到标准路径`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 2.2: sdd-quick 用户选择继续追问 — 取消次数限制 [spec:quick-limit-fallback#需求收集提问达限 — 用户选择继续追问]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 验证 SKILL.md 提及"继续追问"后取消上限（已包含在 2.1 的测试中，此任务无独立测试）
- **GREEN**: 在 Task 2.1 添加的分支逻辑中补充：用户选择"继续追问"后，继续苏格拉底式提问，不再计数，直到 AI 判断需求足够清晰
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 2.3: sdd-quick 用户选择切换标准路径 [spec:quick-limit-fallback#需求收集提问达限 — 用户选择切换标准路径]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 新增测试，验证 SKILL.md 包含切换标准路径的处理
  ```ts
  test('sdd-quick handles switch to standard path on limit', () => {
    const body = readSkillBody('sdd-quick');
    const hasSwitch = body.includes('sdd-propose') && body.includes('保留');
    expect(hasSwitch, 'sdd-quick missing standard path switch handling').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 在达限分支逻辑中补充：用户选择"切换标准路径"后，退出 quick 模式，保留已生成中间制品，推荐 `/sdd-propose` 继续，不删除任何已生成文件
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 2.4: sdd-quick 场景数量达限处理 [spec:quick-limit-fallback#场景数量达到上限]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试，验证 SKILL.md 包含场景达限处理
  ```ts
  test('sdd-quick has scenario limit handling', () => {
    const body = readSkillBody('sdd-quick');
    const hasScenarioLimit = body.includes('quick-scenarios') && body.includes('停止');
    expect(hasScenarioLimit, 'sdd-quick missing scenario limit handling').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 修改 sdd-quick SKILL.md §4b 文档生成节，将硬编码"最多 5 个场景"替换为读取 limits.quick-scenarios（默认 5）。达限时：停止生成，输出超限提示，告知制品可复用，推荐 `/sdd-propose` 或 `/sdd-ff` 继续
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 2.5: sdd-quick 任务数量达限处理 [spec:quick-limit-fallback#任务数量达到上限]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试，验证 SKILL.md 包含任务达限处理
  ```ts
  test('sdd-quick has task limit handling', () => {
    const body = readSkillBody('sdd-quick');
    const hasTaskLimit = body.includes('quick-tasks') && body.includes('停止');
    expect(hasTaskLimit, 'sdd-quick missing task limit handling').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 修改 sdd-quick SKILL.md §4b 文档生成节，将硬编码"最多 10 个任务"替换为读取 limits.quick-tasks（默认 10）。达限行为与场景达限一致
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 4.1: 所有达限提示消息附加可发现性信息 [spec:limits-config#达限提示包含可发现性信息]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试，验证所有达限相关的 SKILL.md 包含可发现性提示
  ```ts
  const discoverabilityText = '可在 openspec/config.yaml 的 limits 节中调整上限';
  test('sdd-quick limit messages include discoverability hint', () => {
    const body = readSkillBody('sdd-quick');
    expect(body, 'sdd-quick missing discoverability hint').toContain(discoverabilityText);
  });
  test('sdd-brainstorm limit messages include discoverability hint', () => {
    const body = readSkillBody('sdd-brainstorm');
    expect(body, 'sdd-brainstorm missing discoverability hint').toContain(discoverabilityText);
  });
  test('sdd-plan limit messages include discoverability hint', () => {
    const body = readSkillBody('sdd-plan');
    expect(body, 'sdd-plan missing discoverability hint').toContain(discoverabilityText);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 在 3 个 SKILL.md 的达限处理逻辑末尾，统一附加提示："可在 openspec/config.yaml 的 limits 节中调整上限"
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

--- checkpoint ---

## 批次 3/3：Review 循环达限兜底 + 全局约定与测试

<!-- 依赖：批次 1（配置读取机制） -->
<!-- 任务范围：3.1-3.6, 5.1-5.2 -->

### Task 3.1: sdd-brainstorm review 达限 — 输出提示和选项 [spec:review-limit-fallback#brainstorm review 达限 — 用户选择继续修复]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试，验证 sdd-brainstorm SKILL.md 包含 review 达限分支
  ```ts
  test('sdd-brainstorm has review limit fallback with user options', () => {
    const body = readSkillBody('sdd-brainstorm');
    const hasFallback = body.includes('继续修复') && body.includes('接受当前状态');
    expect(hasFallback, 'sdd-brainstorm missing review limit fallback').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 修改 sdd-brainstorm SKILL.md 后置 review 循环节，在达到 review-rounds 轮次时替换"最多 3 轮，通过或用户接受后停止"为达限分支：
  - 输出已达上限提示，列出剩余 issues
  - 提供选项：`① 继续修复` / `② 接受当前状态并继续`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 3.2: sdd-brainstorm 用户选择继续修复 — 取消轮次限制 [spec:review-limit-fallback#brainstorm review 达限 — 用户选择继续修复]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 验证 SKILL.md 提及继续修复后取消轮次限制（已包含在 3.1 测试中）
- **GREEN**: 在达限分支中补充：用户选择"继续修复"后，进入下一轮 review，不再有轮次限制
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 3.3: sdd-brainstorm 用户选择接受并继续 [spec:review-limit-fallback#brainstorm review 达限 — 用户选择接受并继续]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 验证 SKILL.md 提及接受后终止 review 并标注（已包含在 3.1 测试中）
- **GREEN**: 在达限分支中补充：用户选择"接受并继续"后，终止 review 循环，在 review 文件中标注"用户接受，剩余 issues 未修复"，进入后置逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 3.4: sdd-plan review 达限 — 输出提示和选项 [spec:review-limit-fallback#plan review 达限 — 用户选择继续修复]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify), `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 新增测试，验证 sdd-plan SKILL.md 包含 review 达限分支
  ```ts
  test('sdd-plan has review limit fallback with user options', () => {
    const body = readSkillBody('sdd-plan');
    const hasFallback = body.includes('继续修复') && body.includes('接受当前状态');
    expect(hasFallback, 'sdd-plan missing review limit fallback').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 修改 sdd-plan SKILL.md 后置 review 循环节，行为与 3.1 一致（替换"最多 3 轮"为达限分支）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 3.5: sdd-plan 用户选择继续修复 — 取消轮次限制 [spec:review-limit-fallback#plan review 达限 — 用户选择继续修复]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 验证已包含在 3.4 测试中
- **GREEN**: 在达限分支中补充：用户选择"继续修复"后取消轮次限制
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 3.6: sdd-plan 用户选择接受并继续 [spec:review-limit-fallback#plan review 达限 — 用户选择接受并继续]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 验证已包含在 3.4 测试中
- **GREEN**: 在达限分支中补充：用户选择"接受并继续"后终止 review 并标注
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

### Task 5.1: 修改 quality-checkpoints.md 全局约定 [spec:limits-config#读取未配置的 limits — 默认值回退]

- **文件**: `ai-tools-bridge/guidelines/quality-checkpoints.md` (Modify)
- **RED**: 无独立测试（guidelines 为参考文档，非 SKILL.md）
- **GREEN**: 修改 quality-checkpoints.md §全局约定 > Review 循环上限：
  - 将"最多 **3 轮**"改为"默认最多 **N 轮**（可在 `openspec/config.yaml` 的 `limits.review-rounds` 中配置，默认 3）"
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run`

### Task 5.2: 更新 review-loops.test.ts 适配可配置行为 [spec:limits-config#读取已配置的 limits 值]

- **文件**: `ai-tools-bridge/tests/l2-orchestration/review-loops.test.ts` (Modify)
- **RED**: 更新原有测试断言，从检查"最多 3 轮"改为检查可配置行为
  - 修改现有 test：将 `body.includes('最多 3 轮')` 改为检查 `review-rounds` 配置读取
  - 新增配置值非法回退测试
  ```ts
  test('sdd-brainstorm mentions configurable review-rounds with default', () => {
    const body = readSkillBody('sdd-brainstorm');
    const hasConfig = body.includes('review-rounds') && body.includes('默认');
    expect(hasConfig, 'sdd-brainstorm missing configurable review-rounds').toBe(true);
  });
  test('sdd-plan mentions configurable review-rounds with default', () => {
    const body = readSkillBody('sdd-plan');
    const hasConfig = body.includes('review-rounds') && body.includes('默认');
    expect(hasConfig, 'sdd-plan missing configurable review-rounds').toBe(true);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`
- **GREEN**: 更新测试用例，替换硬编码"最多 3 轮"断言为可配置行为断言
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/l2-orchestration/review-loops.test.ts`

--- checkpoint ---

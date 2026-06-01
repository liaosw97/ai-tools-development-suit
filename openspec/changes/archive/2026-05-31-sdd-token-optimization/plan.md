# Plan: SDD Token 优化

> 实施计划 — TDD 级别的详细步骤

---

## 批次 1/4：懒加载实现

<!-- 依赖：无前置依赖，可直接开始 -->
<!-- 任务范围：1.1 - 1.6 -->

### Task 1.1: 拆分 sdd-brainstorm（472行 → 3个模块）[spec:lazy-loading#sdd-brainstorm 拆分]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-brainstorm/modules/` (Create)
- **RED**: 编写结构验证测试
  - 断言 `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` 行数 ≤ 200（核心流程）
  - 断言 `ai-tools-bridge/skills/sdd-brainstorm/modules/role-system.md` 存在
  - 断言 `ai-tools-bridge/skills/sdd-brainstorm/modules/split-patterns.md` 存在
  - 断言 `modules/role-system.md` 包含 "角色系统" 或 "role" 关键词
  - 断言 `modules/split-patterns.md` 包含 "拆分模式" 或 "split" 关键词
- **运行验证失败**: `bash -c 'test $(wc -l < ai-tools-bridge/skills/sdd-brainstorm/SKILL.md) -le 200 && echo PASS || echo FAIL'`
- **GREEN**: 拆分 sdd-brainstorm
  1. 创建 `ai-tools-bridge/skills/sdd-brainstorm/modules/` 目录
  2. 从 SKILL.md 提取"角色系统"相关内容 → `modules/role-system.md`
  3. 从 SKILL.md 提取"拆分模式"相关内容 → `modules/split-patterns.md`
  4. 在 SKILL.md 中添加模块引用说明（何时加载哪个模块）
  5. 验证拆分后 SKILL.md 仍包含完整的前置逻辑、核心执行、后置逻辑框架
- **运行验证通过**: `bash -c 'test $(wc -l < ai-tools-bridge/skills/sdd-brainstorm/SKILL.md) -le 200 && test -f ai-tools-bridge/skills/sdd-brainstorm/modules/role-system.md && test -f ai-tools-bridge/skills/sdd-brainstorm/modules/split-patterns.md && echo PASS || echo FAIL'`

### Task 1.2: 拆分 sdd-plan（285行 → 核心流程 + 分批模式）[spec:lazy-loading#其他大型 skill 拆分]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-plan/modules/` (Create)
- **RED**: 编写结构验证测试
  - 断言 `ai-tools-bridge/skills/sdd-plan/SKILL.md` 行数 ≤ 200
  - 断言 `ai-tools-bridge/skills/sdd-plan/modules/batch-mode.md` 存在
  - 断言 `modules/batch-mode.md` 包含 "分批" 或 "batch" 关键词
- **运行验证失败**: `bash -c 'test $(wc -l < ai-tools-bridge/skills/sdd-plan/SKILL.md) -le 200 && echo PASS || echo FAIL'`
- **GREEN**: 拆分 sdd-plan
  1. 创建 `ai-tools-bridge/skills/sdd-plan/modules/` 目录
  2. 从 SKILL.md 提取"分批生成模式"相关内容 → `modules/batch-mode.md`
  3. 在 SKILL.md 中添加模块引用说明
  4. 验证核心流程（前置逻辑、核心执行框架、后置逻辑）保留在 SKILL.md
- **运行验证通过**: `bash -c 'test $(wc -l < ai-tools-bridge/skills/sdd-plan/SKILL.md) -le 200 && test -f ai-tools-bridge/skills/sdd-plan/modules/batch-mode.md && echo PASS || echo FAIL'`

### Task 1.3: 拆分 sdd-code（210行 → 核心流程 + worktree + 调试）[spec:lazy-loading#其他大型 skill 拆分]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-code/modules/` (Create)
- **RED**: 编写结构验证测试
  - 断言 `ai-tools-bridge/skills/sdd-code/SKILL.md` 行数 ≤ 150
  - 断言 `ai-tools-bridge/skills/sdd-code/modules/worktree.md` 存在
  - 断言 `ai-tools-bridge/skills/sdd-code/modules/debugging.md` 存在
- **运行验证失败**: `bash -c 'test $(wc -l < ai-tools-bridge/skills/sdd-code/SKILL.md) -le 150 && echo PASS || echo FAIL'`
- **GREEN**: 拆分 sdd-code
  1. 创建 `ai-tools-bridge/skills/sdd-code/modules/` 目录
  2. 从 SKILL.md 提取"worktree"相关内容 → `modules/worktree.md`
  3. 从 SKILL.md 提取"调试"相关内容 → `modules/debugging.md`
  4. 在 SKILL.md 中添加模块引用说明
- **运行验证通过**: `bash -c 'test $(wc -l < ai-tools-bridge/skills/sdd-code/SKILL.md) -le 150 && test -f ai-tools-bridge/skills/sdd-code/modules/worktree.md && test -f ai-tools-bridge/skills/sdd-code/modules/debugging.md && echo PASS || echo FAIL'`

### Task 1.4: 实现 guidelines 按需加载机制 [spec:lazy-loading#Guidelines 按需加载]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **RED**: 编写加载规则验证测试
  - 断言 `ai-tools-bridge/guidelines/token-optimization.md` 中包含"初始化时加载"或类似说明
  - 断言 sdd-ff/sdd-plan/sdd-code/sdd-verify 的 SKILL.md 中引用了 quality-checkpoints.md
  - 断言 sdd-brainstorm/sdd-propose 的 SKILL.md 中引用了 decision-strategy.md
- **运行验证失败**: `grep -l "quality-checkpoints" ai-tools-bridge/skills/sdd-{ff,plan,code,verify}/SKILL.md`
- **GREEN**: 更新各 SKILL.md 添加 guidelines 加载指令
  1. 在 sdd-brainstorm、sdd-propose 的 SKILL.md 中添加：在方案选择步骤加载 `guidelines/decision-strategy.md`
  2. 在 sdd-ff、sdd-plan、sdd-code、sdd-verify 的 SKILL.md 中添加：在质量门检查步骤加载 `guidelines/quality-checkpoints.md` 对应 action 的检查点部分
  3. 在所有 SDD action 的初始化部分添加：token-optimization.md 仅在首个 action 初始化时加载
- **运行验证通过**: `grep -l "quality-checkpoints" ai-tools-bridge/skills/sdd-{ff,plan,code,verify}/SKILL.md && grep -l "decision-strategy" ai-tools-bridge/skills/sdd-{brainstorm,propose}/SKILL.md && echo PASS || echo FAIL`

### Task 1.5: 实现 reviewer prompt 延迟加载机制 [spec:lazy-loading#Reviewer Prompt 延迟加载]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify), `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 编写延迟加载验证测试
  - 断言 sdd-brainstorm 的 SKILL.md 中包含"进入 review 循环时加载 brainstorm-reviewer-prompt.md"
  - 断言 sdd-plan 的 SKILL.md 中包含"进入 review 循环时加载 plan-reviewer-prompt.md"
  - 断言 sdd-review-code 的 SKILL.md 中包含按需加载 reviewer prompt 的说明
- **运行验证失败**: `grep -c "进入.*review.*循环.*加载" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`
- **GREEN**: 更新 SKILL.md 添加 reviewer prompt 延迟加载指令
  1. 在 sdd-brainstorm 的后置逻辑中添加：仅在进入 review 循环时加载 `brainstorm-reviewer-prompt.md`
  2. 在 sdd-plan 的后置逻辑中添加：仅在进入 review 循环时加载 `plan-reviewer-prompt.md`
  3. 在 sdd-review-code 中添加：按需加载 `spec-compliance-reviewer-prompt.md`、`scan-reviewer-prompt.md`、`code-quality-reviewer-prompt.md`
- **运行验证通过**: `grep -c "进入.*review.*循环.*加载" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md && grep -c "进入.*review.*循环.*加载" ai-tools-bridge/skills/sdd-plan/SKILL.md && echo PASS || echo FAIL`

### Task 1.6: 更新 token-optimization.md 指南 [spec:lazy-loading#token-optimization.md 指南更新]

- **文件**: `ai-tools-bridge/guidelines/token-optimization.md` (Modify)
- **RED**: 编写指南内容验证测试
  - 断言 `token-optimization.md` 包含"懒加载"章节
  - 断言包含"模块化拆分"策略说明
  - 断言包含"按需加载"策略说明
  - 断言包含"延迟加载"策略说明
  - 断言包含各 action 的加载优化规则
  - 断言包含异常降级处理说明
- **运行验证失败**: `grep -c "懒加载" ai-tools-bridge/guidelines/token-optimization.md`
- **GREEN**: 更新 token-optimization.md
  1. 添加"懒加载策略"章节，说明模块化拆分、按需加载、延迟加载三种策略
  2. 添加各 action 的加载优化规则表
  3. 添加异常降级处理说明（模块文件不存在时降级到完整加载）
- **运行验证通过**: `grep -c "懒加载" ai-tools-bridge/guidelines/token-optimization.md && grep -c "按需加载" ai-tools-bridge/guidelines/token-optimization.md && grep -c "延迟加载" ai-tools-bridge/guidelines/token-optimization.md && echo PASS || echo FAIL`

--- checkpoint ---

## 批次 2/4：上下文压缩实现

<!-- 依赖：批次 1 完成（懒加载机制已就绪） -->
<!-- 任务范围：2.1 - 2.6 -->

### Task 2.1: 设计摘要算法（关键信息提取逻辑）[spec:context-compression#关键字段保留]

- **文件**: `ai-tools-bridge/lib/summarizer.ts` (Create)
- **RED**: 编写摘要算法单元测试
  - 测试输入：包含 3 个 GIVEN/WHEN/THEN 场景的 spec 内容
  - 断言输出包含所有场景名称
  - 断言输出包含所有 GIVEN/WHEN/THEN 三元组
  - 断言关键信息覆盖率 ≥ 95%
  - 测试输入：包含 2 个 task 的 tasks.md 内容
  - 断言输出包含 task 编号和 spec 链接
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/summarizer.test.ts`
- **GREEN**: 实现摘要算法
  1. 创建 `ai-tools-bridge/lib/summarizer.ts`
  2. 实现 `summarizeSpec(content: string): SummaryResult` — 提取场景名称 + GIVEN/WHEN/THEN 三元组
  3. 实现 `summarizeTasks(content: string): SummaryResult` — 提取 task 编号 + 描述 + spec 链接
  4. 实现 `calculateCoverage(original: string, summary: string): number` — 计算关键信息覆盖率
  5. 覆盖率公式：`保留的关键字段数 / 原文关键字段总数 × 100%`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/summarizer.test.ts`

### Task 2.2: 实现 spec 摘要传递 [spec:context-compression#spec 场景列表传递]

- **文件**: `ai-tools-bridge/lib/artifact-bridge.ts` (Create/Modify)
- **RED**: 编写 spec 摘要传递测试
  - 测试输入：完整的 spec 文件路径
  - 断言传递给 subagent 的内容是摘要（场景列表），而非完整文件
  - 断言摘要包含场景名称和关键字段
  - 断言摘要大小 < 原始文件的 50%
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/artifact-bridge.test.ts`
- **GREEN**: 实现 spec 摘要传递
  1. 创建/更新 `ai-tools-bridge/lib/artifact-bridge.ts`
  2. 实现 `passSpecToSubagent(specPath: string): string` — 读取 spec → 调用 summarizeSpec → 返回摘要
  3. 集成到 SDD action 的 subagent dispatch 逻辑中
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/artifact-bridge.test.ts`

### Task 2.3: 实现 task 摘要传递 [spec:context-compression#task 摘要传递]

- **文件**: `ai-tools-bridge/lib/artifact-bridge.ts` (Modify)
- **RED**: 编写 task 摘要传递测试
  - 测试输入：完整的 tasks.md 文件路径
  - 断言传递给 subagent 的内容是摘要（task 编号 + 描述 + spec 链接）
  - 断言摘要大小 < 原始文件的 50%
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/artifact-bridge.test.ts`
- **GREEN**: 实现 task 摘要传递
  1. 在 `artifact-bridge.ts` 中添加 `passTasksToSubagent(tasksPath: string): string`
  2. 调用 summarizeTasks 生成摘要
  3. 集成到需要 tasks 上下文的 SDD action 中
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/artifact-bridge.test.ts`

### Task 2.4: 实现 review 上下文压缩 [spec:context-compression#diff + spec 场景传递]

- **文件**: `ai-tools-bridge/lib/review-context.ts` (Create)
- **RED**: 编写 review 上下文压缩测试
  - 测试输入：代码 diff + 相关 spec 场景
  - 断言输出为 JSON 格式，包含 code-changes、spec-context、quality-metrics 字段
  - 断言输出不包含无关的 spec 场景
  - 断言输出大小 < 原始上下文的 40%
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/review-context.test.ts`
- **GREEN**: 实现 review 上下文压缩
  1. 创建 `ai-tools-bridge/lib/review-context.ts`
  2. 实现 `compressReviewContext(diff: string, specScenarios: string[]): ReviewContext` — 返回结构化 JSON
  3. 定义 `ReviewContext` 接口：`{ code-changes: string, spec-context: string, quality-metrics: object }`
  4. 集成到 sdd-review-code 的 subagent dispatch 逻辑中
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/review-context.test.ts`

### Task 2.5: 设计轻量级状态文件格式（≤500 字符）[spec:context-compression#状态文件创建]

- **文件**: `ai-tools-bridge/lib/state-file.ts` (Create)
- **RED**: 编写状态文件格式测试
  - 测试创建状态文件，断言格式为 YAML
  - 断言包含 change 名称、当前阶段、关键决策列表字段
  - 断言文件大小 ≤ 500 字符（约 20 行）
  - 测试更新状态文件，断言大小仍 ≤ 500 字符
  - 测试损坏恢复：输入格式错误的 YAML，断言系统忽略并重建
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/state-file.test.ts`
- **GREEN**: 实现状态文件管理
  1. 创建 `ai-tools-bridge/lib/state-file.ts`
  2. 实现 `createStateFile(changeName: string): StateFile` — 创建初始状态文件
  3. 实现 `updateStateFile(state: StateFile, action: string, decisions: string[]): void` — 更新状态，保持 ≤500 字符
  4. 实现 `readStateFile(path: string): StateFile | null` — 读取并验证格式，损坏时返回 null
  5. 定义 YAML 格式：`{ change: string, phase: string, decisions: string[] }`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/state-file.test.ts`

### Task 2.6: 实现跨 action 状态压缩 [spec:context-compression#状态文件读取]

- **文件**: `ai-tools-bridge/lib/state-file.ts` (Modify), `ai-tools-bridge/skills/sdd-*/SKILL.md` (Modify)
- **RED**: 编写跨 action 状态传递测试
  - 测试：执行 action A 后创建状态文件 → 执行 action B 时读取状态文件 → 断言 B 获得了 A 的关键决策
  - 测试：状态文件不存在时 → 断言从 artifact 重新构建上下文
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/state-file.test.ts`
- **GREEN**: 集成状态文件到 SDD 工作流
  1. 在每个 SDD action 的初始化阶段添加：尝试读取状态文件
  2. 在每个 SDD action 的完成阶段添加：更新状态文件
  3. 在状态文件不存在时：从 artifact 重新构建上下文（降级逻辑）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/state-file.test.ts`

--- checkpoint ---

## 批次 3/4：精度验证

<!-- 依赖：批次 1 和 2 完成（懒加载 + 上下文压缩已实现） -->
<!-- 任务范围：3.1 - 3.6 -->

### Task 3.1: 准备 3 个典型变更（简单、中等、复杂）[spec:precision-verification#简单变更验证]

- **文件**: `ai-tools-bridge/tests/fixtures/precision/` (Create)
- **RED**: 编写测试夹具验证测试
  - 断言 `simple-change/` 存在，包含 proposal.md + specs/ (1-2 场景) + tasks.md (≤5 tasks)
  - 断言 `medium-change/` 存在，包含 proposal.md + specs/ (4-6 场景) + tasks.md (6-15 tasks)
  - 断言 `complex-change/` 存在，包含 proposal.md + specs/ (>8 场景) + tasks.md (>15 tasks)
- **运行验证失败**: `test -d ai-tools-bridge/tests/fixtures/precision/simple-change && echo PASS || echo FAIL`
- **GREEN**: 创建测试夹具
  1. 创建 `ai-tools-bridge/tests/fixtures/precision/simple-change/` — 简单变更（1-2 场景，≤5 tasks）
  2. 创建 `ai-tools-bridge/tests/fixtures/precision/medium-change/` — 中等变更（4-6 场景，6-15 tasks）
  3. 创建 `ai-tools-bridge/tests/fixtures/precision/complex-change/` — 复杂变更（>8 场景，>15 tasks）
  4. 每个夹具包含完整的 proposal.md + specs/ + tasks.md
- **运行验证通过**: `test -d ai-tools-bridge/tests/fixtures/precision/simple-change && test -d ai-tools-bridge/tests/fixtures/precision/medium-change && test -d ai-tools-bridge/tests/fixtures/precision/complex-change && echo PASS || echo FAIL`

### Task 3.2: 执行优化前基线测试（记录 token 消耗和输出质量）[spec:precision-verification#优化前基线]

- **文件**: `ai-tools-bridge/tests/precision/baseline.test.ts` (Create)
- **RED**: 编写基线测试框架
  - 断言基线测试能运行 3 个夹具的完整 SDD 流程
  - 断言能记录每个 action 的 token 消耗
  - 断言能记录输出质量指标（brainstorm 方案数、spec 场景覆盖度、review 问题数）
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/precision/baseline.test.ts`
- **GREEN**: 实现基线测试
  1. 创建 `ai-tools-bridge/tests/precision/baseline.test.ts`
  2. 对每个夹具执行完整 SDD 流程（使用优化前的 skill 文件）
  3. 记录每个 action 的 token 消耗（峰值 + 总量）
  4. 记录输出质量指标
  5. 输出基线数据到 `ai-tools-bridge/tests/precision/baseline-results.json`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/precision/baseline.test.ts`

### Task 3.3: 执行优化后对比测试（记录相同指标）[spec:precision-verification#优化后对比]

- **文件**: `ai-tools-bridge/tests/precision/optimized.test.ts` (Create)
- **RED**: 编写优化后测试框架
  - 断言优化后测试能运行 3 个夹具的完整 SDD 流程
  - 断言能记录与基线相同的指标
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/precision/optimized.test.ts`
- **GREEN**: 实现优化后测试
  1. 创建 `ai-tools-bridge/tests/precision/optimized.test.ts`
  2. 对每个夹具执行完整 SDD 流程（使用优化后的 skill 文件）
  3. 记录相同的指标
  4. 输出优化后数据到 `ai-tools-bridge/tests/precision/optimized-results.json`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/precision/optimized.test.ts`

### Task 3.4: 计算差异并分析结果 [spec:precision-verification#差异计算]

- **文件**: `ai-tools-bridge/tests/precision/compare.test.ts` (Create)
- **RED**: 编写对比分析测试
  - 断言对比报告包含 token 消耗差异（峰值 + 总量）
  - 断言对比报告包含输出质量差异
  - 断言差异计算正确（百分比 = (基线 - 优化) / 基线 × 100%）
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/precision/compare.test.ts`
- **GREEN**: 实现对比分析
  1. 创建 `ai-tools-bridge/tests/precision/compare.test.ts`
  2. 读取 baseline-results.json 和 optimized-results.json
  3. 计算差异百分比
  4. 生成对比报告到 `ai-tools-bridge/tests/precision/comparison-report.md`
  5. 根据阈值判定结果：PASS（≥30%/≥35%）、NEEDS_REVIEW（15%-30%/20%-35%）、FAIL（<15%/<20%）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/precision/compare.test.ts`

### Task 3.5: 人工审核输出质量 [spec:precision-verification#验证通过]

- **文件**: `ai-tools-bridge/tests/precision/comparison-report.md` (Review)
- **RED**: 编写审核检查清单
  - 清单包含：brainstorm 方案完整性、spec 场景覆盖度、review 循环充分性、TDD 步骤严格性
  - 每项有通过/未通过判定
- **运行验证失败**: `test -f ai-tools-bridge/tests/precision/comparison-report.md && echo "报告已生成，请人工审核" || echo FAIL`
- **GREEN**: 执行人工审核
  1. 审查 comparison-report.md 中的各项指标
  2. 对比优化前后的输出质量
  3. 确认无 critical 问题
  4. 在报告中标注审核结果
- **运行验证通过**: `echo "人工审核完成，请确认 comparison-report.md 中的审核结果"`

### Task 3.6: 根据验证结果调优和修复 [spec:precision-verification#验证失败]

- **文件**: 视验证结果而定
- **RED**: 编写回滚验证测试
  - 断言回滚命令能正确恢复原始文件
  - 断言分阶段回滚（懒加载回滚 → 压缩回滚 → 全量回滚）各阶段独立
- **运行验证失败**: `echo "等待验证结果，确定是否需要调优"`
- **GREEN**: 根据验证结果执行
  - **如果 PASS**：记录验证结果，跳过此任务
  - **如果 NEEDS_REVIEW**：分析对比报告，修复发现的质量问题
  - **如果 FAIL**：执行分阶段回滚（先懒加载回滚，再压缩回滚，必要时全量回滚）
- **运行验证通过**: `echo "调优/修复完成，精度验证结束"`

--- checkpoint ---

## 批次 4/4：Token 预算视图

<!-- 依赖：批次 1 和 2 完成（需要懒加载和压缩机制就绪才能准确测量） -->
<!-- 任务范围：4.1 - 4.4 -->

### Task 4.1: 统计定义层 token 消耗（SDD Skills、Superpowers Skills、Templates、Guidelines）[spec:token-budget#SDD Skills 统计]

- **文件**: `ai-tools-bridge/scripts/token-budget.ts` (Create)
- **RED**: 编写定义层统计测试
  - 断言统计 SDD skill 文件的行数和 token 数（14 个文件，2,716 行）
  - 断言统计 Superpowers skill 文件的行数和 token 数
  - 断言统计 templates（8 个）和 guidelines（4 个）的行数和 token 数
  - 断言使用 cl100k_base 编码计算 token 数
  - 断言输出按组件分类的明细表
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/token-budget.test.ts`
- **GREEN**: 实现定义层统计脚本
  1. 创建 `ai-tools-bridge/scripts/token-budget.ts`
  2. 扫描 `ai-tools-bridge/skills/sdd-*/SKILL.md` — 统计 SDD skills
  3. 扫描 `ai-tools/superpowers/skills/*/SKILL.md` — 统计 Superpowers skills
  4. 扫描 `ai-tools-bridge/schemas/sdd/templates/` — 统计 templates
  5. 扫描 `ai-tools-bridge/guidelines/` — 统计 guidelines 和 reviewer prompts
  6. 使用 cl100k_base 编码计算 token 数
  7. 输出定义层 token 预算报告
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/token-budget.test.ts`

### Task 4.2: 统计执行层 token 消耗（单个 Action、完整流程）[spec:token-budget#单个 Action 统计]

- **文件**: `ai-tools-bridge/scripts/token-budget.ts` (Modify)
- **RED**: 编写执行层统计测试
  - 断言能统计单个 action 的 token 消耗（包含 6 个组件）
  - 断言能统计完整流程的累计 token 消耗
  - 断言识别消耗超过平均值 2 倍的异常 action
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/token-budget.test.ts`
- **GREEN**: 实现执行层统计
  1. 在 token-budget.ts 中添加执行层统计功能
  2. 统计单个 action 的 6 个组件：系统 prompt、skill 定义、底层 skill、项目上下文、已有 artifacts、用户输入
  3. 统计完整流程累计消耗
  4. 标记异常消耗（>2x 平均值）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/token-budget.test.ts`

### Task 4.3: 建立 token 预算报告 [spec:token-budget#报告生成]

- **文件**: `ai-tools-bridge/reports/token-budget-report.md` (Create)
- **RED**: 编写报告生成测试
  - 断言报告包含定义层 token 消耗明细（按组件分类）
  - 断言报告包含执行层 token 消耗明细（按 action 分类）
  - 断言报告包含峰值消耗和总消耗统计
  - 断言报告包含优化建议（标记超预算组件和异常 action）
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/unit/token-budget.test.ts`
- **GREEN**: 生成 token 预算报告
  1. 运行定义层和执行层统计
  2. 生成 `ai-tools-bridge/reports/token-budget-report.md`
  3. 包含：定义层明细、执行层明细、峰值/总消耗统计、优化建议
  4. 标记超预算组件（>30% 该层总消耗）和异常 action（>2x 平均值）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/unit/token-budget.test.ts`

### Task 4.4: 更新 token-optimization.md 指南 [spec:token-budget#Token 消耗测量]

- **文件**: `ai-tools-bridge/guidelines/token-optimization.md` (Modify)
- **RED**: 编写指南更新验证测试
  - 断言 token-optimization.md 包含"Token 预算"章节
  - 断言包含定义层和执行层的 token 消耗数据
  - 断言包含峰值消耗和总消耗的测量方法
  - 断言包含优化建议和预算驱动优化规则
- **运行验证失败**: `grep -c "Token 预算" ai-tools-bridge/guidelines/token-optimization.md`
- **GREEN**: 更新 token-optimization.md
  1. 添加"Token 预算"章节，包含定义层和执行层的消耗数据
  2. 添加测量方法说明（峰值 = 单 action 最大 context 占用，总消耗 = 完整流程累计）
  3. 添加预算驱动优化规则：定义层组件 >30% 时标记为优化候选，执行层 action >2x 平均值时建议压缩
- **运行验证通过**: `grep -c "Token 预算" ai-tools-bridge/guidelines/token-optimization.md && grep -c "预算驱动" ai-tools-bridge/guidelines/token-optimization.md && echo PASS || echo FAIL`

--- checkpoint ---

<!-- 格式说明:
  - 每个任务必须有 RED/GREEN 步骤（TDD 铁律）
  - 每个步骤有具体的运行验证命令
  - 粒度: 2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
-->

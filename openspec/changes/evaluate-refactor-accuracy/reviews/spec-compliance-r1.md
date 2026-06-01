# Spec Compliance Review — Round 1

**审查对象:** specs/accuracy-evaluation/spec.md vs ai-tools-bridge f4c9410..ebd11c9
**日期:** 2026-06-01

## 场景覆盖统计
- 总场景数: 4
- ✅ 已实现: 1
- ⚠️ 部分实现: 3
- ❌ 未实现: 0
- 覆盖率: 25%（完整实现）/ 100%（含部分实现）

---

## 逐场景结果

### spec:accuracy-evaluation#静态-Diff-分析

- **状态:** ⚠️ PARTIAL
- **验证:**
  - ✅ diff 解析能力：`scripts/compress-review.mjs` 实现了 diff 文件解析，可提取变更文件列表（行 520-525: `fileRegex = /^diff --git a\/(.+?) b\/(.+)$/gm`）
  - ✅ 变更行提取：`lib/review-context.ts` 的 `extractCodeChanges()` 函数可从 diff 中提取新增和修改的行（行 213-222）
  - ✅ 关键词提取：`lib/review-context.ts` 的 `extractKeywords()` 可提取文件名、函数名、类名（行 241-268）
  - ✅ 场景匹配：`scripts/compress-review.mjs` 实现了变更文件与 spec 场景的匹配逻辑（行 549-567）
- **问题:**
  1. **缺少变更清单生成功能**：spec 要求"变更清单包含每个变更的类型（ADDED/MODIFIED/REMOVED）、影响范围、是否为功能性变更"，但代码中没有专门的变更清单生成逻辑
  2. **缺少按模块分组检查**：spec 要求"按模块分组检查：核心流程（SKILL.md 主文件）、子模块（modules/ 目录）、角色系统（roles/ 目录）"，但 `compress-review.mjs` 仅输出变更文件列表，未按模块分组
  3. **缺少 reason 字段**：spec 要求"每个 MODIFIED/REMOVED 类型变更附带 reason 字段"，代码中无此实现
- **Evidence:**
  - `scripts/compress-review.mjs` 行 520-525: 文件解析 regex
  - `lib/review-context.ts` 行 213-222: `extractCodeChanges()` 函数
  - `lib/review-context.ts` 行 241-268: `extractKeywords()` 函数

---

### spec:accuracy-evaluation#精度测试验证

- **状态:** ✅ IMPLEMENTED
- **验证:**
  - ✅ 测试套件覆盖：`tests/unit/` 目录下包含 6 个测试文件，覆盖 spec 解析、任务提取、覆盖率计算、状态管理、review 压缩等核心功能
  - ✅ 精度基准测试：`tests/precision/baseline.test.ts` 测量 token 预算基准（SDD Skills < 20000 tokens, Guidelines < 5000 tokens）
  - ✅ Fixture 验证：`tests/precision/fixtures.test.ts` 验证 simple-change、medium-change、complex-change 三类 fixture 的数据完整性
  - ✅ 覆盖率计算：`lib/summarizer.ts` 的 `calculateCoverage()` 函数实现了关键信息覆盖率计算（行 461-477）
  - ✅ 降级测试：`tests/unit/degradation.test.ts` 验证了低覆盖率触发降级、高覆盖率无需降级的逻辑
  - ✅ CLI 测试：`tests/cli/` 目录下包含 4 个 CLI 脚本测试文件
  - ✅ vitest 配置：`vitest.config.ts` 已更新支持 `.test.mjs` 文件
- **Evidence:**
  - `tests/precision/baseline.test.ts`: token 预算基准测试
  - `tests/precision/fixtures.test.ts`: fixture 数据验证
  - `tests/unit/summarizer.test.ts`: 覆盖率计算测试
  - `tests/unit/degradation.test.ts`: 降级处理测试
  - `lib/summarizer.ts` 行 461-477: `calculateCoverage()` 实现

---

### spec:accuracy-evaluation#场景走查-简单变更

- **状态:** ⚠️ PARTIAL
- **验证:**
  - ✅ Fixture 数据存在：
    - `tests/fixtures/precision/simple-change/proposal.md` ✅
    - `tests/fixtures/precision/simple-change/specs/config-validation/spec.md` ✅（2 个场景：有效配置验证、无效配置拒绝）
    - `tests/fixtures/precision/simple-change/tasks.md` ✅（3 个任务）
  - ✅ Fixture 验证测试：`tests/precision/fixtures.test.ts` 验证了 simple-change fixture 的数据完整性（场景数 = 2, 任务数 = 3）
- **问题:**
  1. **缺少 SDD 流程执行测试**：spec 要求"模拟完整 SDD 流程"（brainstorm → propose → plan），但代码中没有执行 SDD 流程的测试脚本
  2. **缺少 brainstorm.md fixture**：spec 要求验证 brainstorm 输出包含 §需求描述、§方案探索、§关键决策三个段落，但 `tests/fixtures/precision/simple-change/` 目录下没有 brainstorm.md
  3. **缺少 plan.md fixture**：spec 要求验证 plan 的每个任务步骤包含 `[spec:domain#scenario]` 链接，但 fixture 中没有 plan.md
  4. **缺少端到端验证逻辑**：spec 要求验证"brainstorm 中的每个关键决策在 proposal 中均有对应的采纳记录"，但没有实现此验证逻辑
- **Evidence:**
  - `tests/fixtures/precision/simple-change/` 目录结构
  - `tests/precision/fixtures.test.ts` 行 151-173: simple-change fixture 验证

---

### spec:accuracy-evaluation#场景走查-复杂变更

- **状态:** ⚠️ PARTIAL
- **验证:**
  - ✅ Fixture 数据存在：
    - `tests/fixtures/precision/complex-change/proposal.md` ✅
    - `tests/fixtures/precision/complex-change/specs/order-processing/spec.md` ✅（3 个场景）
    - `tests/fixtures/precision/complex-change/specs/payment/spec.md` ✅（2 个场景）
    - `tests/fixtures/precision/complex-change/specs/inventory/spec.md` ✅（3 个场景）
    - `tests/fixtures/precision/complex-change/specs/notification/spec.md` ✅（3 个场景）
    - `tests/fixtures/precision/complex-change/tasks.md` ✅（18 个任务，>15）
  - ✅ Fixture 验证测试：`tests/precision/fixtures.test.ts` 验证了 complex-change fixture 的数据完整性（场景数 > 8, 任务数 > 15）
- **问题:**
  1. **缺少 SDD 流程执行测试**：与简单变更场景相同，没有执行 SDD 流程的测试脚本
  2. **缺少 brainstorm.md fixture**：没有 brainstorm.md 文件
  3. **缺少 plan.md fixture**：没有 plan.md 文件
  4. **缺少跨模块依赖验证**：spec 要求"跨模块任务之间的依赖关系正确"，但没有实现依赖关系验证逻辑
  5. **缺少端到端验证逻辑**：与简单变更场景相同
- **Evidence:**
  - `tests/fixtures/precision/complex-change/` 目录结构
  - `tests/precision/fixtures.test.ts` 行 207-236: complex-change fixture 验证

---

## Approved

- [ ] 场景覆盖 — 3 个场景仅部分实现，缺少 SDD 流程执行测试
- [x] 行为匹配 — 已实现的部分（diff 解析、覆盖率计算、fixture 验证）行为符合 spec 描述
- [ ] 边界条件 — 边界情况 2（场景走查需要实际执行环境）未满足

## 结论

**FAILED**

### 总结

| 场景 | 状态 | 缺失项 |
|------|------|--------|
| 静态 Diff 分析 | ⚠️ PARTIAL | 变更清单生成、模块分组、reason 字段 |
| 精度测试验证 | ✅ IMPLEMENTED | 无 |
| 场景走查 - 简单变更 | ⚠️ PARTIAL | SDD 流程执行测试、brainstorm/plan fixture |
| 场景走查 - 复杂变更 | ⚠️ PARTIAL | SDD 流程执行测试、brainstorm/plan fixture、依赖验证 |

### 关键发现

1. **基础设施已就绪**：代码变更建立了完整的测试基础设施（vitest 配置、fixture 数据、单元测试、CLI 测试），覆盖率计算和降级处理逻辑已实现。

2. **场景走查未实现端到端测试**：spec 要求的"模拟完整 SDD 流程"（brainstorm → propose → plan）在代码中没有对应的测试实现。仅有静态 fixture 数据，没有执行流程的测试脚本。

3. **静态 Diff 分析缺少结构化输出**：虽然有 diff 解析能力，但缺少 spec 要求的变更清单格式（类型、影响范围、reason 字段）。

### 建议

1. 为场景走查（简单/复杂）添加端到端测试脚本，模拟 SDD 流程执行
2. 为简单/复杂变更 fixture 补充 brainstorm.md 和 plan.md 文件
3. 实现变更清单生成功能，支持 ADDED/MODIFIED/REMOVED 类型标注和 reason 字段
4. 实现按模块分组检查逻辑（核心流程、子模块、角色系统）

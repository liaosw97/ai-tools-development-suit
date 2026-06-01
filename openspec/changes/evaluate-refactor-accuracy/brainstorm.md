# Brainstorm: evaluate-refactor-accuracy

> 深度探索记录 — 评估 ai-tools-bridge 重构后的准确度损失

## 需求描述

用户需要评估 ai-tools-bridge 功能重构后与原本未重构的功能相比，准确度是否有损失。

**重构内容**（基于 git diff 4c20a61..ebd11c9）：
1. **Token Optimization** — 新增 `lib/` 目录（summarizer、artifact-bridge、review-context、state-file），实现摘要传递替代完整内容传递
2. **Role System** — 从命令改为独立 skill（`skills/sdd-role/SKILL.md`），支持三层优先级（用户级 > 项目级 > 内置）
3. **Skill 模块化** — 大型 skill 拆分为子模块（role-system、split-patterns、batch-mode、worktree、debugging），按需加载

**评估维度**：
- 信息保留率 — 摘要是否丢失关键信息
- 语义完整性 — 拆分后的模块是否保留原有逻辑
- 功能覆盖度 — 13 个 SDD action 是否完整覆盖
- 边界情况 — 摘要算法的边界处理

## 方案探索

### 方案 A: 静态 Diff 分析

对比重构前后的 SKILL.md 文件，逐行检查功能完整性。

**执行方法**：
1. 使用 `git diff 4c20a61..ebd11c9 -- skills/` 获取所有 skill 变更
2. 按模块分组检查：
   - 核心流程（SKILL.md 主文件）
   - 子模块（modules/ 目录）
   - 角色系统（roles/ 目录）
3. 检查清单：
   - 关键函数/逻辑是否保留
   - 配置项是否完整
   - 错误处理是否一致
   - 输出格式是否变更

- **优点:**
  - 快速，无副作用
  - 可精确识别丢失/变更的逻辑
  - 可重复执行

- **缺点:**
  - 无法验证运行时行为
  - 需要人工判断语义等价性

### 方案 B: 精度测试验证

利用已有的 `tests/precision/` 和 `tests/unit/` 测试套件，运行测试验证。

**执行方法**：
1. **前置验证**：检查现有测试覆盖范围
   - `tests/unit/summarizer.test.ts` — 覆盖 Token Optimization
   - `tests/unit/artifact-bridge.test.ts` — 覆盖 artifact 传递
   - `tests/unit/review-context.test.ts` — 覆盖 review 压缩
   - `tests/unit/state-file.test.ts` — 覆盖状态管理
   - `tests/precision/` — 覆盖精度基准
2. **运行测试**：`pnpm test` 执行全部测试
3. **分析结果**：检查通过率和覆盖率指标

- **优点:**
  - 自动化验证
  - 有具体的覆盖率指标
  - 可量化准确度

- **缺点:**
  - 依赖测试覆盖度
  - 无法覆盖未测试的边界情况

### 方案 C: 场景走查 + 端到端验证

选择 2-3 个典型场景（简单/中等/复杂），手动走查完整 SDD 流程。

**场景分类标准**：
- **简单变更**：单文件修改，1-3 个任务（如：配置调整、bug 修复）
- **中等变更**：多文件联动，4-10 个任务（如：新功能模块）
- **复杂变更**：跨模块重构，>10 个任务（如：架构调整）

**执行方法**：
1. 从 `tests/fixtures/precision/` 选择场景（simple-change、medium-change、complex-change）
2. 对每个场景，模拟完整 SDD 流程：sdd-brainstorm → sdd-propose → sdd-plan
3. 验证点：
   - brainstorm 输出是否保留完整需求信息
   - proposal 是否正确引用 brainstorm 决策
   - plan 是否正确链接 spec 场景

- **优点:**
  - 最接近真实使用场景
  - 可发现隐式依赖问题

- **缺点:**
  - 耗时较长
  - 需要实际执行环境

### 方案比较

选择组合方案：先用方案 A 快速识别明显问题，再用方案 B 验证算法准确度，最后用方案 C 对简单和复杂两个场景做端到端验证。

**理由**：组合方案兼顾效率和全面性，静态分析可快速定位问题，精度测试可量化指标，场景走查可验证端到端完整性。选择简单+复杂两个场景可覆盖核心流程和边界情况。

## 关键决策

### 决策 1: 评估方法选择
- **选择:** 组合方案（A + B + C）
- **理由:** 兼顾效率和全面性，静态分析快速定位，精度测试量化指标，场景走查验证端到端
- **被否决的替代:** 单独使用方案 A/B/C — 单一方法无法全面覆盖评估维度

### 决策 2: 评估范围界定
- **选择:** 覆盖所有重构内容（Token Optimization、Role System、Skill 模块化）
- **理由:** 用户明确要求全面评估，不应遗漏任何重构维度
- **被否决的替代:** 仅评估 Token Optimization — 会遗漏 Role System 和模块化的潜在问题

### 决策 3: 场景选择
- **选择:** 使用"简单变更"和"复杂变更"两个场景进行端到端走查
- **理由:** 简单场景验证核心流程，复杂场景验证边界情况和跨模块协调，两者结合可覆盖主要使用场景
- **被否决的替代:** 仅使用"简单变更"场景 — 无法验证复杂场景下的功能完整性

### 决策 4: 通过/失败标准
- **选择:** 定义量化指标判定准确度损失
- **理由:** 需要明确的标准来评估重构是否引入准确度损失
- **被否决的替代:** 无量化标准 — 无法客观评估准确度损失
- **通过标准**：
  - 信息保留率 ≥ 95%（摘要保留的关键信息比例）
  - 所有精度测试通过（`tests/precision/` 和 `tests/unit/`）
  - 场景走查无阻塞问题（简单+复杂场景均能正常走通）
  - 语义完整性：无功能丢失（通过静态 diff 确认）

## 约束识别

### 技术约束
- 需要访问重构前的代码版本（git commit 4c20a61）
- 需要运行测试环境（vitest）
- 需要对比 76 个文件的变更

### 团队约束
- 评估应产出可量化的结论
- 评估结果应明确指出是否有准确度损失

### 时间约束
- 无明确截止日期
- 评估工作预计 1-2 小时可完成

## 参考资源

- git diff 4c20a61..ebd11c9 — 重构的完整变更
- `tests/precision/` — 精度测试框架
- `tests/unit/summarizer.test.ts` — 摘要算法测试
- `guidelines/token-optimization.md` — Token 优化策略文档

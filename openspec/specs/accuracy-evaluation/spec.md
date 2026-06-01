# Spec: accuracy-evaluation

> 功能规格 — 评估 ai-tools-bridge 重构后的准确度损失

## 能力描述

评估 ai-tools-bridge 功能重构后与原本未重构的功能相比，准确度是否有损失。覆盖信息保留率、语义完整性、功能覆盖度、边界情况四个维度。

---

## 场景

### 静态 Diff 分析 `[ADDED]`

> 选择 [组合方案（A + B + C）] 而非 [单独使用方案 A/B/C]：兼顾效率和全面性，静态分析快速定位，精度测试量化指标，场景走查验证端到端（见 brainstorm.md §决策 1: 评估方法选择）

**GIVEN** 重构前的代码版本（git commit 4c20a61）和重构后的代码版本（git commit ebd11c9）
- 重构涉及 76 个文件的变更
- 包含 Token Optimization、Role System、Skill 模块化三个重构维度
- 可使用 `git diff 4c20a61..ebd11c9` 获取完整变更

**WHEN** 执行静态 Diff 分析
- 使用 `git diff 4c20a61..ebd11c9 -- skills/` 获取所有 skill 变更
- 按模块分组检查：核心流程（SKILL.md 主文件）、子模块（modules/ 目录）、角色系统（roles/ 目录）
- 逐项检查：关键函数/逻辑是否保留、配置项是否完整、错误处理是否一致、输出格式是否变更

**THEN** 产出变更清单
- 变更清单包含每个变更的类型（ADDED/MODIFIED/REMOVED）、影响范围、是否为功能性变更
- 功能性变更数量和类型清单可直接从 diff 输出验证
- 每个 MODIFIED/REMOVED 类型变更附带 reason 字段（字段存在性可检查）
- 无功能丢失：所有重构前的关键函数/逻辑在重构后均有对应实现

**失败路径**
- 如果 `git diff` 命令执行失败，记录错误信息到评估报告，终止静态分析阶段
- 如果发现功能性变更且无 reason 字段，标记为 WARNING 并纳入评估结论

---

### 精度测试验证 `[ADDED]`

> 选择 [组合方案（A + B + C）] 而非 [单独使用方案 A/B/C]：兼顾效率和全面性，静态分析快速定位，精度测试量化指标，场景走查验证端到端（见 brainstorm.md §决策 1: 评估方法选择）

**GIVEN** 现有的测试套件
- 覆盖 Token Optimization 模块的核心功能（spec 解析、任务提取、覆盖率计算）
- 覆盖 artifact 传递模块的核心功能
- 覆盖 review 压缩模块的核心功能
- 覆盖状态管理模块的核心功能
- 覆盖精度基准（baseline、fixtures）
- 测试环境已配置（vitest）

**WHEN** 运行精度测试
- 执行 `pnpm test` 运行全部测试
- 检查测试通过率
- 通过精度测试套件中的覆盖率计算验证信息保留率

**THEN** 产出精度报告
- 测试通过标准：`tests/precision/` 和 `tests/unit/` 全部通过，0 failures, 0 errors
- 信息保留率 ≥ 95%（通过精度测试套件中的覆盖率计算验证）
- 精度报告包含：测试总数、通过数、失败数、信息保留率

**失败路径**
- 如果测试执行失败（环境问题），记录错误信息到评估报告，终止精度测试阶段
- 如果测试通过率 < 100%，列出失败的测试用例和失败原因
- 如果信息保留率 < 95%，标记为 FAILED 并列出覆盖率不足的场景

---

### 场景走查 - 简单变更 `[ADDED]`

> 选择 [简单+复杂两个场景] 而非 [仅使用简单变更场景]：简单场景验证核心流程，复杂场景验证边界情况和跨模块协调（见 brainstorm.md §决策 3: 场景选择）

**GIVEN** 简单变更场景（单文件修改，1-3 个任务）
- 从 `tests/fixtures/precision/simple-change/` 获取场景数据
- 场景包含：proposal.md、specs/config-validation/spec.md（2 个场景）、tasks.md（3 个任务）
- 测试环境已配置

**WHEN** 模拟完整 SDD 流程
- sdd-brainstorm：生成 brainstorm.md
- sdd-propose：生成 proposal.md
- sdd-plan：生成 plan.md
- 验证点：
  - brainstorm 输出包含 §需求描述、§方案探索、§关键决策三个段落
  - proposal 的决策追溯段落引用了 brainstorm 的决策编号
  - plan 的每个任务步骤包含 [spec:domain#scenario] 链接

**THEN** 确认简单场景走查通过
- 无阻塞问题：所有 SDD action 正常完成
- 端到端流程正常：brainstorm → proposal → plan 链路完整
- 输出产物格式正确：符合模板要求
- 语义正确性：brainstorm 中的每个关键决策在 proposal 中均有对应的采纳记录
- 覆盖完整性：tasks.md 中的每个任务至少覆盖一个 spec 场景

**失败路径**
- 如果任一 SDD action 执行失败，记录失败原因和失败步骤到评估报告
- 如果 brainstorm 输出不完整（缺少 §需求描述、§方案探索、§关键决策），标记为 PARTIAL 并记录缺失内容
- 如果 proposal 未引用 brainstorm 决策，标记为 WARNING
- 如果 plan 任务缺少 spec 链接，标记为 WARNING
- 如果 brainstorm 决策未被 proposal 采纳，标记为 ERROR 并列出未采纳的决策
- 如果 tasks.md 中存在未覆盖 spec 场景的任务，标记为 WARNING

---

### 场景走查 - 复杂变更 `[ADDED]`

> 选择 [简单+复杂两个场景] 而非 [仅使用简单变更场景]：简单场景验证核心流程，复杂场景验证边界情况和跨模块协调（见 brainstorm.md §决策 3: 场景选择）

**GIVEN** 复杂变更场景（跨模块重构，>10 个任务）
- 从 `tests/fixtures/precision/complex-change/` 获取场景数据
- 场景包含：proposal.md、4 个 spec 文件（order-processing、payment、inventory、notification）、tasks.md（>15 个任务）
- 测试环境已配置

**WHEN** 模拟完整 SDD 流程
- sdd-brainstorm：生成 brainstorm.md
- sdd-propose：生成 proposal.md
- sdd-plan：生成 plan.md
- 验证点：
  - brainstorm 输出包含 §需求描述、§方案探索、§关键决策三个段落
  - proposal 的决策追溯段落引用了 brainstorm 的决策编号
  - plan 的每个任务步骤包含 [spec:domain#scenario] 链接
  - 跨模块任务之间的依赖关系正确

**THEN** 确认复杂场景走查通过
- 无阻塞问题：所有 SDD action 正常完成
- 端到端流程正常：brainstorm → proposal → plan 链路完整
- 跨模块协调正常：不同 spec 的任务之间依赖关系正确
- 输出产物格式正确：符合模板要求
- 语义正确性：brainstorm 中的每个关键决策在 proposal 中均有对应的采纳记录
- 覆盖完整性：tasks.md 中的每个任务至少覆盖一个 spec 场景
- 依赖正确性：跨模块任务的依赖关系与 spec 中定义的模块关系一致

**失败路径**
- 如果任一 SDD action 执行失败，记录失败原因和失败步骤到评估报告
- 如果 brainstorm 输出不完整（缺少 §需求描述、§方案探索、§关键决策），标记为 PARTIAL 并记录缺失内容
- 如果 proposal 未引用 brainstorm 决策，标记为 WARNING
- 如果 plan 任务缺少 spec 链接，标记为 WARNING
- 如果跨模块任务依赖关系错误，标记为 ERROR 并列出错误的依赖
- 如果 brainstorm 决策未被 proposal 采纳，标记为 ERROR 并列出未采纳的决策
- 如果 tasks.md 中存在未覆盖 spec 场景的任务，标记为 WARNING

---

## 边界条件

- 边界情况 1: 测试覆盖不全 — 如果现有测试未覆盖某些重构内容，需要在评估报告中注明（关联场景：精度测试验证）
- 边界情况 2: 场景走查需要实际执行环境 — 可使用现有 fixture 替代（关联场景：场景走查 - 简单变更、场景走查 - 复杂变更）
- 边界情况 3: 信息保留率计算 — 通过精度测试套件中的覆盖率计算验证（关联场景：精度测试验证）
- 边界情况 4: 测试套件可靠性 — 如果测试全部通过但场景走查发现异常，需要人工复核测试断言的严格程度（关联场景：精度测试验证）

# Spec Review -- Round 1

**审查对象:** specs/ 目录下所有 spec 文件（6 个域，38 个场景）
**日期:** 2026-05-12

## 总结

6 个 spec 文件整体质量较高，场景描述遵循 GIVEN/WHEN/THEN 格式，与 proposal 范围和 brainstorm 决策方向保持一致。存在 2 个 major 级别问题（前置校验规则表不完整、recommendation spec 中 sdd-review-code 后推荐操作与 brainstorm 推荐映射表不一致）和 5 个 minor 级别问题（测试数据/断言不够具体、边界条件覆盖缺口、表述不一致等）。无 critical 级别问题。总体结论为 NEEDS_REVISION，修复 major 问题后可重新审查。

## Issues

### [severity: major] 前置校验 spec 缺少完整校验规则映射表

- **位置:** specs/pre-validation/spec.md (全文)
- **描述:** brainstorm.md 的"前置校验"部分（第 202-214 行）明确列出了 13 个 action 的校验规则映射表（每个 action 的必需前置、警告条件、阻断条件）。但 pre-validation spec 只覆盖了其中 7 个 action 的具体场景（sdd-brainstorm、sdd-ff、sdd-propose、sdd-code、sdd-test-code、sdd-ship），缺少以下 action 的校验场景：sdd-plan、sdd-review-code、sdd-review-spec、sdd-verify、sdd-continue、sdd-quick。虽然 sdd-quick 和 sdd-brainstorm 的"无前置"已通过场景 1 覆盖，但 sdd-plan（tasks.md + spec 存在性检查）、sdd-review-code（代码变更 + spec 存在性检查）、sdd-verify（spec + 代码存在性检查）的阻断/警告条件完全未体现。
- **建议:** 补充 sdd-plan、sdd-review-code、sdd-review-spec、sdd-verify、sdd-continue 的校验场景，或至少在边界条件中声明"其余 action 的校验规则见校验规则映射表"并以显式引用方式关联 brainstorm。

### [severity: major] recommendation spec 中 sdd-review-code 推荐操作与 brainstorm 推荐映射表不一致

- **位置:** specs/recommendation/spec.md (全文) vs brainstorm.md 第 235 行
- **描述:** brainstorm 推荐映射表中明确列出了 13 个 action 的推荐操作（第 229-242 行），但 recommendation spec 只覆盖了 5 个 action 的推荐场景（sdd-code、sdd-ff、sdd-ship、sdd-quick、sdd-doctor）。缺少以下 action 的推荐场景：sdd-brainstorm（推荐 /sdd-propose）、sdd-propose（推荐 /sdd-ff）、sdd-plan（推荐 /sdd-code）、sdd-review-code（推荐 /sdd-test-code）、sdd-test-code（推荐 /sdd-verify）、sdd-verify（推荐 /sdd-ship）、sdd-review-spec（推荐 /sdd-propose）、sdd-continue（按进度推荐）。其中 sdd-review-code 的推荐操作直接关系到本次变更的核心痛点 4（review-code 后无 test-code），其推荐 ★ /sdd-test-code 是决策 6 的直接体现，不应遗漏。
- **建议:** 至少补充 sdd-review-code（★ /sdd-test-code）和 sdd-verify（★ /sdd-ship）两个关键场景。其余 action 的推荐可通过"场景 5：所有 action 推荐格式一致性"统一覆盖，但需在场景描述中明确引用 brainstorm 的推荐映射表作为权威来源。

### [severity: minor] sdd-quick spec 缺少"交互收集上限 5 个问题"的具体测试断言

- **位置:** specs/sdd-quick/spec.md 第 1 个场景"简单需求从零开始走 quick 全流程"
- **描述:** WHEN 中提到"通过内联 /grill-me 追问技巧交互收集需求（最多 5 个问题）"，但 THEN 中没有对应的断言来验证问题数量不超过 5。边界条件中提到了"苏格拉底式问题最多 5 个，超过后自动进入生成阶段"，但缺少对应的场景来覆盖这一行为。
- **建议:** 在边界条件中已有描述可接受，但建议在 THEN 中增加一条断言："交互问题不超过 5 个，达到上限后自动进入生成阶段"，使场景本身自包含。

### [severity: minor] sdd-plan spec 中"单批次刚好 10 个任务"边界条件与 sdd-doctor 评级规则存在语义歧义

- **位置:** specs/sdd-plan/spec.md 边界条件"单批次刚好 10 个任务：视为小型，正常生成" vs specs/sdd-doctor/spec.md 评级规则"简单(S)：任务数 ≤5"
- **描述:** sdd-plan 的边界条件说"10 个任务"视为小型，但 sdd-doctor 的评级规则中简单(S)对应的任务数是 ≤5，中等(M)是 6-15。这意味着 10 个任务在 sdd-doctor 中会被评为中等(M)，但在 sdd-plan 中被视为小型。虽然两者的判断目的不同（一个是复杂度评级，一个是分批策略），但"小型"一词同时出现在两处但含义不同，容易引起混淆。
- **建议:** sdd-plan 的边界条件中将"视为小型"改为"视为正常规模，跳过分批提示"，避免与 sdd-doctor 的"简单(S)"评级术语冲突。

### [severity: minor] sdd-test-code spec 中 PARTIAL 和 MISSING 场景可合并为一个场景

- **位置:** specs/sdd-test-code/spec.md 第 1 个和第 2 个场景
- **描述:** "PARTIAL 场景的 TDD 补全"和"MISSING 场景的 TDD 补全"两个场景的 WHEN/THEN 结构几乎完全相同（都是逐个读取、执行 RED-GREEN 循环、不修改实现代码、独立提交、输出统计），唯一区别是 PARTIAL 需"补充测试代码使其通过"而 MISSING 需"从零编写完整测试"。这种细微差异不足以构成两个独立场景，反而增加了维护成本和冗余。
- **建议:** 合并为一个场景"PARTIAL/MISSING 场景的 TDD 补全"，在 WHEN 中区分两种标记的处理差异即可。这符合 CLAUDE.md 中"Token 卫生"原则。

### [severity: minor] sdd-doctor spec 中复杂度评级"多维度指向不同评级时取最高"规则缺少具体示例

- **位置:** specs/sdd-doctor/spec.md 第 3 个场景"有 spec/tasks 时评估复杂度评级"
- **描述:** THEN 中提到"多维度指向不同评级时取最高（就高不就低）"但没有给出具体示例。例如：场景数 3（S 级）+ 任务数 20（L 级）+ 领域数 1（S 级）时最终评级应为 L。这个规则对测试用例设计至关重要，缺少示例可能导致实现偏差。
- **建议:** 在边界条件中补充 1-2 个跨维度取最高的具体示例。

### [severity: minor] pre-validation spec 缺少"制品包含未替换的模板占位符"的具体场景

- **位置:** specs/pre-validation/spec.md 边界条件"制品包含未替换的模板占位符：视为警告级缺失"
- **描述:** 边界条件中提到"制品包含未替换的模板占位符视为警告级缺失，提示用户填充"，但没有对应的场景描述如何检测模板占位符（HTML 注释 `<!-- ... -->` 格式）。proposal.md 的 CLAUDE.md 中明确提到"模板占位符：HTML 注释 `<!-- ... -->`"，检测逻辑应与此对齐。
- **建议:** 在场景 3（警告级缺失）中补充模板占位符检测的具体描述，或在边界条件中注明占位符格式为 HTML 注释。

## Approved

- [x] 场景完整性
- [x] 可测试性
- [ ] 一致性
- [x] 决策追溯
- [x] 范围控制

## 详细审查矩阵

### 1. 场景完整性

| 维度 | 评价 |
|------|------|
| GIVEN/WHEN/THEN 格式 | 所有 38 个场景均遵循 GIVEN/WHEN/THEN 格式，结构完整 |
| 正常路径 | 6 个 spec 均覆盖了主成功路径 |
| 错误路径 | pre-validation 覆盖了阻断和警告路径；sdd-test-code 覆盖了空操作和委托失败；sdd-quick 覆盖了超限回退。但 pre-validation 缺少 6 个 action 的校验场景（major） |
| 边界条件 | 6 个 spec 均有边界条件章节。sdd-plan 的边界值测试（恰好 11/25/26）表述清晰。sdd-doctor 的取最高规则缺示例（minor） |

**结论:** 基本通过，pre-validation 需补充缺失 action 的校验场景。

### 2. 可测试性

| 维度 | 评价 |
|------|------|
| WHEN 可转化为操作 | 所有 WHEN 描述的都是可执行的用户操作或系统行为 |
| THEN 可转化为断言 | 大部分 THEN 包含可验证的输出（文件生成、提示文本、评级结果）。部分 THEN 缺少量化断言（minor） |
| 测试数据 | sdd-plan 的边界值（10/11/25/26）提供了明确的测试数据。sdd-doctor 的评级规则有具体数值但跨维度取最高缺示例（minor） |

**结论:** 通过。

### 3. 一致性

| 维度 | 评价 |
|------|------|
| spec 间无矛盾 | sdd-plan 边界条件中的"小型"术语与 sdd-doctor 的"简单(S)"评级存在语义歧义（minor） |
| 与 proposal 范围一致 | 6 个 spec 完整覆盖了 proposal 的"包含"范围，无遗漏无扩展 |
| Delta 标记正确 | 所有新增场景标记为 `[ADDED]`，修改场景标记为 `[MODIFIED]`，与 proposal 一致 |
| 与 brainstorm 一致 | pre-validation 和 recommendation 的场景覆盖不完整，遗漏了 brainstorm 映射表中的多个 action（major） |

**结论:** 不通过，需修复 2 个 major 级别一致性问题。

### 4. 决策追溯

| 决策 | spec 体现 | 评价 |
|------|----------|------|
| 决策 1: 直接内联 | sdd-quick 和 sdd-test-code 的 capability 描述中提到了内联 reference 文件 | 完整 |
| 决策 2: 按需分批 | 只涉及 sdd-quick 和 sdd-test-code 两个新 action 的 reference | 完整 |
| 决策 3: 可拆则拆+分批 | sdd-plan 的 6 个场景完整覆盖 | 完整 |
| 决策 4: 三合一链路优化 | sdd-doctor 的路径推荐 + sdd-quick + recommendation 覆盖 | 完整 |
| 决策 5: 前置校验+智能分级 | pre-validation 的 9 个场景覆盖 | 基本完整，缺部分 action（同一致性 major） |
| 决策 6: 独立 sdd-test-code | sdd-test-code 的 6 个场景 + Override 约束明确 | 完整 |

**结论:** 通过。被否决的方案（嵌入 sdd-review-code 后置、全部手动触发、大变更跳过 plan）均未出现。

### 5. 范围控制

| 维度 | 评价 |
|------|------|
| 仅包含 proposal 范围 | 所有场景均对应 proposal "包含"列表中的条目 |
| 无隐含扩展 | 未发现超出 proposal 范围的内容 |
| 不包含的遵守 | 未涉及被否决的 skills 内联、架构重组、现有 action 核心逻辑修改 |

**结论:** 通过。

## 结论

**NEEDS_REVISION** -- 需修复 2 个 major 级别问题后重新审查：

1. **前置校验 spec 补充缺失 action 的校验场景**（sdd-plan、sdd-review-code、sdd-verify 至少需要阻断级场景）
2. **recommendation spec 补充 sdd-review-code 推荐场景**（★ /sdd-test-code 是决策 6 的核心体现，不应遗漏）

5 个 minor 级别问题建议在修复 major 时一并处理，但不阻断通过。

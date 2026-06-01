# Plan Review — Round 2

**审查对象:** plan.md
**日期:** 2026-05-31

## 总结

plan.md 在 Round 1 修订后有显著改进。Task 1.2/3.2/4.2 已成功拆分为更细粒度的子任务，任务总数从 16 个增加到 20 个，每个任务预计可在 2-5 分钟内完成。GREEN 步骤现在包含具体的可执行命令（如 `grep -c`、`test -s`）。风险标记已添加到 Task 2.2 和 Task 5.2。整体 TDD 结构完整，所有任务均包含 RED/GREEN 步骤和运行验证命令。然而，仍存在几个 minor 级别的问题需要关注。

## Round 1 问题修复确认

### ✅ [已修复] Task 1.2/3.2/4.2 粒度偏大
- **原问题:** 任务粒度超出 2-5 分钟预期
- **修复情况:**
  - Task 1.2 已拆分为：1.2 (SKILL.md)、1.3 (modules/)、1.4 (roles/) — ✅
  - Task 3.2 已拆分为：3.2 (brainstorm)、3.3 (proposal)、3.4 (plan)、3.5 (汇总) — ✅
  - Task 4.2 已拆分为：4.2 (brainstorm)、4.3 (proposal)、4.4 (plan+跨模块)、4.5 (汇总) — ✅

### ✅ [已修复] GREEN 步骤描述过于抽象
- **原问题:** GREEN 步骤未提供可执行命令
- **修复情况:**
  - Task 1.2 GREEN 包含 `grep "^diff --git.*SKILL.md"` 命令 — ✅
  - Task 3.2 GREEN 包含 `grep -c "§需求描述"` 等验证命令 — ✅
  - Task 4.4 GREEN 包含 `grep -c "\[spec:"` 和 `grep -c "依赖"` 命令 — ✅

### ✅ [已修复] 缺少风险标记
- **原问题:** 高风险步骤未标记
- **修复情况:**
  - Task 2.2 已添加 `**⚠️ 风险**` 标记（环境问题） — ✅
  - Task 5.2 已添加 `**⚠️ 风险**` 标记（主观判断） — ✅

## Issues

### [severity: minor] Task 1.2/1.3/1.4 GREEN 步骤中的"写入"操作不够具体
- **位置:** plan.md §Task 1.2, §Task 1.3, §Task 1.4
- **描述:**
  - Task 1.2 GREEN: "将变更文件列表写入 diff-analysis.md" — 未说明使用什么命令写入
  - Task 1.3 GREEN: "将变更文件列表追加到 diff-analysis.md" — 未说明追加命令
  - Task 1.4 GREEN: "将变更文件列表追加到 diff-analysis.md" — 未说明追加命令
- **建议:** 添加具体的写入命令，例如：
  ```bash
  echo "## SKILL.md 变更" >> openspec/changes/evaluate-refactor-accuracy/diff-analysis.md
  grep "^diff --git.*SKILL.md" openspec/changes/evaluate-refactor-accuracy/diff-skills.patch >> openspec/changes/evaluate-refactor-accuracy/diff-analysis.md
  ```

### [severity: minor] Task 1.5 GREEN 步骤中的检查项验证不够精确
- **位置:** plan.md §Task 1.5
- **描述:**
  - GREEN 步骤使用 `grep -c "关键函数"` 等命令验证检查清单，但这些命令只验证文本中包含关键词，无法验证检查清单是否真正执行
  - 例如：即使 diff-analysis.md 中只是提到"关键函数"这个词，grep 也会返回成功
- **建议:** 改用更精确的验证方式，例如检查是否包含"关键函数: [保留/变更/丢失]"这样的结构化格式

### [severity: minor] Task 2.4 GREEN 步骤中的 calculateCoverage 函数引用不明确
- **位置:** plan.md §Task 2.4
- **描述:
  - GREEN 步骤提到"使用 calculateCoverage 函数计算信息保留率"，但未说明：
    1. 该函数位于哪个文件
    2. 如何调用该函数
    3. 输入参数是什么
- **建议:** 添加具体的调用命令，例如：
  ```bash
  node -e "const { calculateCoverage } = require('./ai-tools-bridge/lib/coverage.js'); console.log(calculateCoverage(...))"
  ```

### [severity: minor] Task 3.2/4.2 GREEN 步骤依赖 brainstorm.md 文件存在
- **位置:** plan.md §Task 3.2, §Task 4.2
- **描述:**
  - GREEN 步骤验证 brainstorm.md 是否包含必需段落，但 brainstorm.md 是 SDD 流程的产出物
  - 当前 plan 假设 brainstorm.md 已存在，但实际上需要先执行 sdd-brainstorm 生成
- **建议:** 在 Task 3.2/4.2 之前添加前置步骤，说明需要先执行 sdd-brainstorm 生成 brainstorm.md，或者修改验证逻辑为检查 fixture 中的 brainstorm.md

### [severity: minor] Task 5.1 spec 链接指向不准确
- **位置:** plan.md §Task 5.1
- **描述:**
  - Task 5.1 的 spec 链接为 `[spec:accuracy-evaluation#静态-Diff-分析]`，但该任务是汇总所有评估结果，应链接到更通用的场景
- **建议:** 修改为 `[spec:accuracy-evaluation]` 或创建一个专门的"汇总评估"场景

### [severity: minor] 缺少 Task 1.1 的 diff-analysis.md 创建步骤
- **位置:** plan.md §Task 1.1
- **描述:**
  - Task 1.1 文件声明包含 `diff-analysis.md (Create)`，但 GREEN 步骤只创建了 patch 文件
  - diff-analysis.md 实际上在 Task 1.2 中才开始使用
- **建议:** 从 Task 1.1 的文件声明中移除 `diff-analysis.md`，或在 Task 1.1 GREEN 步骤中添加创建空文件的命令

## Approved

- [x] 任务粒度 — 20 个任务，每个预计 2-5 分钟，粒度合理
- [x] TDD 步骤完整性 — 所有任务均包含 RED/GREEN 步骤和运行验证命令
- [x] Spec 对齐 — plan 的 20 个任务覆盖了 tasks.md 的所有 14 个任务（细化拆分），均包含 [spec:domain#scenario] 链接
- [x] 依赖顺序 — 批次划分合理（1→2→3→4→5），依赖关系正确
- [x] 风险识别 — Task 2.2 和 Task 5.2 已添加风险标记

## 结论

**APPROVED** (with minor issues)

plan.md 已成功修复 Round 1 提出的所有 major 问题：
1. ✅ Task 1.2/3.2/4.2 已拆分为细粒度子任务
2. ✅ GREEN 步骤已提供具体可执行命令
3. ✅ 风险标记已添加

剩余 6 个 minor 问题不影响 TDD 实施的核心指导能力，可在实施过程中逐步改进。建议在实施前优先处理 Task 1.2/1.3/1.4 的"写入"命令具体化问题，以提高执行效率。

**总体评价:** plan.md 质量良好，可以作为 TDD 实施的指导文档。

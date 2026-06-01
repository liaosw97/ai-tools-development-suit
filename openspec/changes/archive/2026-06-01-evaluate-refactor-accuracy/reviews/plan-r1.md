# Plan Review — Round 1

**审查对象:** plan.md
**日期:** 2026-05-31

## 总结

plan.md 整体结构清晰，采用 TDD 的 RED/GREEN 模式组织任务，覆盖了 tasks.md 中的所有 16 个任务。批次划分合理（静态 Diff 分析 → 精度测试验证 → 场景走查 → 汇总），依赖顺序基本正确。然而，存在几个需要修正的问题：部分任务粒度偏大（超出 2-5 分钟预期）、GREEN 步骤描述过于抽象、缺少风险标记、某些验证命令不够精确。

## Issues

### [severity: major] Task 1.2/3.2/4.2 粒度偏大
- **位置:** plan.md §Task 1.2, §Task 3.2, §Task 4.2
- **描述:**
  - Task 1.2 要求"按模块分组检查：核心流程、子模块、角色系统"，涉及读取三个 diff 文件并分类分析，预计需要 8-10 分钟
  - Task 3.2 要求"模拟简单变更 SDD 流程"并验证 brainstorm/proposal/plan 三个产出，预计需要 8-12 分钟
  - Task 4.2 要求"模拟复杂变更 SDD 流程"并额外验证跨模块依赖，预计需要 12-15 分钟
- **建议:** 将 Task 1.2 拆分为三个子任务（分别检查 SKILL.md、modules/、roles/）；将 Task 3.2/4.2 的验证点拆分为独立的子步骤（如 3.2a 验证 brainstorm、3.2b 验证 proposal、3.2c 验证 plan）

### [severity: major] GREEN 步骤描述过于抽象
- **位置:** plan.md §Task 1.2, §Task 3.2, §Task 4.2
- **描述:**
  - Task 1.2 GREEN: "读取 diff-skills.patch，提取 SKILL.md 主文件变更" — 未说明如何"提取"、使用什么命令或工具
  - Task 3.2 GREEN: "验证 brainstorm 输出格式（检查 §需求描述、§方案探索、§关键决策）" — 未提供具体的检查命令或断言
  - Task 4.2 GREEN: "验证跨模块任务依赖关系" — 未说明如何验证依赖关系的正确性
- **建议:** 为每个 GREEN 步骤提供可执行的命令或明确的操作指令，例如：
  - `grep -c "§需求描述" brainstorm.md`
  - `grep -c "\[spec:" plan.md`

### [severity: minor] 验证命令不够精确
- **位置:** plan.md §Task 1.3, §Task 1.4, §Task 2.3
- **描述:**
  - Task 1.3: `grep -c "检查清单" diff-analysis.md` 只能验证文本中包含"检查清单"字样，无法验证检查清单是否完整执行
  - Task 1.4: `test -s change-list.md` 只验证文件非空，无法验证内容质量
  - Task 2.3: `grep -c "通过率" test-results.md` 只验证包含"通过率"文字，无法验证数值是否正确
- **建议:** 使用更精确的验证方式，例如：
  - Task 1.3: 检查是否包含四个检查项关键词（关键函数、配置项、错误处理、输出格式）
  - Task 2.3: 使用正则匹配验证通过率格式 `\d+%`

### [severity: minor] 缺少风险标记
- **位置:** plan.md 全文
- **描述:** 以下步骤存在较高风险但未标记：
  - Task 2.2（运行测试）— 可能因环境问题失败
  - Task 3.2/4.2（模拟 SDD 流程）— 依赖外部 SDD action 执行
  - Task 5.2（产出结论）— 需要主观判断
- **建议:** 在高风险任务前添加 `**⚠️ 风险**` 标记，并在描述中说明可能的失败原因和应对方案

### [severity: minor] Task 1.1 文件路径不一致
- **位置:** plan.md §Task 1.1
- **描述:** 文件声明为 `diff-analysis.md (Create)`，但 GREEN 步骤产出的是 `diff-skills.patch`、`diff-roles.patch`、`diff-lib.patch`，未创建 diff-analysis.md
- **建议:** 将文件声明修改为多个 patch 文件，或在 GREEN 步骤中添加创建 diff-analysis.md 的指令

### [severity: minor] Task 2.2 路径问题
- **位置:** plan.md §Task 2.2
- **描述:** 命令 `cd ai-tools-bridge && pnpm test` 假设当前工作目录是仓库根目录，但未明确说明前提条件
- **建议:** 添加前置说明："确保当前工作目录为仓库根目录（包含 ai-tools-bridge/ 子目录）"

## Approved

- [ ] 任务粒度 — Task 1.2/3.2/4.2 粒度偏大，需拆分
- [x] TDD 步骤完整性 — 所有任务均包含 RED/GREEN 步骤和验证命令
- [x] Spec 对齐 — plan 的 16 个任务与 tasks.md 完全对应，均包含 [spec:domain#scenario] 链接
- [x] 依赖顺序 — 批次划分合理，依赖关系正确（批次五依赖前四批次完成）
- [ ] 风险识别 — 缺少高风险步骤标记

## 结论

**NEEDS_REVISION**

plan.md 的整体框架和 TDD 结构良好，但存在两个 major 问题需要修正：
1. Task 1.2/3.2/4.2 粒度偏大，需拆分为可在 2-5 分钟内完成的子任务
2. GREEN 步骤描述过于抽象，需提供可执行的具体命令

建议修正后重新提交审查。

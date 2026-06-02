# Spec Review — Round 2

**审查对象:** specs/ 目录下所有 spec 文件（15 个）
**日期:** 2026-06-01
**前轮:** Round 1 (NEEDS_REVISION)

## Round 1 Issues 修复状态

### [major] 共享模块引用数量不一致
- **状态:** 部分修复
- **说明:** shared-skill-modules/spec.md 新增了"引用规则定义"场景（第 27-36 行），明确列出了每个共享模块的适用 SKILL 和引用数量。规则本身清晰合理。
- **遗留问题:** 引用规则与各 spec 实际引用存在不一致。规则声明 `role-loading.md` 适用于"12 个有角色系统的 SKILL（除 sdd-doctor、sdd-continue）"，但实际只有 9 个 spec 引用了 role-loading：
  - 已引用（9 个）：sdd-brainstorm、sdd-plan、sdd-code、sdd-ship、sdd-propose、sdd-verify、sdd-review-code、sdd-review-spec、sdd-test-code
  - 未引用（3 个）：sdd-role、sdd-quick、sdd-ff
  - 按规则应为 12 个（14 - sdd-doctor - sdd-continue），实际为 9 个，差距 3 个
  - 这是一个跨模块一致性问题，需要修正规则定义或补充缺失的引用

### [major] 内容完整性场景断言不具体
- **状态:** 已修复
- **说明:** 共享模块的内容场景现在列出了具体的、可验证的内容项。例如：
  - `base-triggers.md`：触发条件格式模板、至少 3 个示例触发词、不触发条件的箭头指向格式
  - `output-constraints.md`：禁止输出列表（4 项）、零结果防护规则（3 项）
  - `role-loading.md`：参数解析流程、角色优先级规则、角色查找流程、降级策略、格式错误处理
  - `breakdown-mode.md`：触发条件、L1/L2/L3 拆分流程、目录冲突检测（相似度阈值 >60%）
  - `review-loop.md`：Review 流程、轮次限制（默认 3 轮）、达限处理、用户选择"继续修复"后取消轮次限制
- 断言已足够具体，可转化为自动化测试。

### [major] 降级策略覆盖不完整
- **状态:** 已修复
- **说明:** 所有 14 个 MODIFIED spec 均新增了独立的"Include 降级策略" Requirement，包含统一的降级场景："WHEN include 路径指向的共享模块文件不存在或路径错误 THEN AI 输出警告但不阻断执行，SKILL.md 仍可独立运行（使用内联内容）"。降级策略现在在两个层面覆盖：shared-skill-modules 定义通用降级机制，各 skill spec 确认适用于自身。

### [minor] Token 减少场景过于简单
- **状态:** 未修复
- **说明:** 各 spec 的 Token 减少场景仍然是简单的行数对比（如 sdd-brainstorm "从 472 行减少至约 180 行（减少 62%）"），未增加 Round 1 建议的验证维度：
  - 改造后的 SKILL.md 是否仍然可独立理解（不依赖共享模块）
  - 共享模块的加载是否引入额外的 token 开销
  - 总 token 消耗（SKILL.md + 共享模块）是否真正减少
- **影响:** 低。行数对比作为粗粒度验证已足够，精细化验证可在实现阶段通过实际测试补充。

### [minor] 部分场景缺乏错误路径描述
- **状态:** 未修复
- **说明:** sdd-code/spec.md 的以下场景仍缺乏错误路径：
  - **Worktree 准备**（第 40-42 行）：仅描述正常路径"建议创建 worktree"，未说明创建失败或用户拒绝时的处理
  - **目录冲突检测**（第 36-38 行）：仅描述正常路径"发现冲突时暂停询问用户"，未说明检测失败时的处理
- **影响:** 低。这些属于保留的差异内容中的既有行为，实现时自然需要处理错误路径。

### [minor] 部分 spec 包含可能超出 proposal 范围的功能
- **状态:** 未修复
- **说明:** 以下场景仍存在于 spec 中：
  - sdd-plan/spec.md：任务规模检测（≤10/11-25/>25）、分批生成模式
  - sdd-code/spec.md：目录冲突检测（相似度阈值 >60%）
- **重新评估:** 经仔细审查，这些场景描述的是现有 SKILL.md 中已有的行为，属于"保留差异内容"的范畴。proposal 说"保持所有行为逻辑和细节不变"，这些场景是对现有行为的记录，不构成新功能扩展。Round 1 的担忧可以降级为"无需修复"。

### [minor] 配置读取的具体路径和降级策略未明确
- **状态:** 未修复
- **说明:** sdd-quick/spec.md 的"Limits 配置读取"场景（第 34-39 行）描述了读取 `openspec/config.yaml` 的 `limits` 节，但未说明：
  - 如果 config.yaml 不存在时如何处理
  - 如果 limits 节不存在时如何处理
  - 默认值是否在代码中硬编码（场景中列出了默认值：quick-questions=5、quick-scenarios=5、quick-tasks=10，但未明确这是硬编码还是回退行为）
- **影响:** 低。默认值已列出，实现时自然需要处理配置缺失的情况。

## 新增 Issues

### [major] 引用规则与实际引用不一致
- **位置:** shared-skill-modules/spec.md §引用规则定义 + sdd-role/spec.md、sdd-quick/spec.md、sdd-ff/spec.md
- **描述:** shared-skill-modules/spec.md 定义 role-loading 适用于"12 个有角色系统的 SKILL（除 sdd-doctor、sdd-continue）"，但 sdd-role、sdd-quick、sdd-ff 三个 spec 均未引用 role-loading，与规则矛盾。
- **分析:**
  - sdd-role：角色管理工具，本身不需要加载角色，不引用 role-loading 合理
  - sdd-quick：快速模式，无角色系统，不引用 role-loading 合理
  - sdd-ff：文档生成工具，无角色系统，不引用 role-loading 合理
  - 实际有角色系统的 SKILL 为 9 个（非 12 个）
- **建议:** 修正规则为"role-loading.md：9 个有角色系统的 SKILL（除 sdd-doctor、sdd-continue、sdd-role、sdd-quick、sdd-ff）"，或重新审视这三个 SKILL 是否应引用 role-loading

## Approved
- [x] 场景完整性 — 覆盖正常路径和边界条件，降级策略已补充
- [x] 可测试性 — 内容完整性断言已具体化，可转化为自动化测试
- [ ] 一致性 — 引用规则与实际引用存在不一致（role-loading 引用数量矛盾）
- [x] 决策追溯 — proposal 与 brainstorm 决策一致，spec 与决策方向一致
- [x] 范围控制 — 重新评估后，保留的场景属于"差异内容"范畴，不构成范围扩展
- [ ] 跨模块一致性 — role-loading 引用规则与实际引用不一致

## 结论

**NEEDS_REVISION**

Round 1 的 3 个 major 问题中：
- 2 个已修复（内容完整性断言具体化、降级策略覆盖完整）
- 1 个部分修复（引用规则已定义但与实际引用不一致）

新发现 1 个 major 问题：
- 引用规则与实际引用不一致（role-loading 声明 12 个 SKILL 引用，实际 9 个）

4 个 minor 问题未修复（Token 场景简单、错误路径缺失、配置降级未明确），但影响较低，可在实现阶段补充。

**需要修订：**
1. 修正 shared-skill-modules/spec.md 的 role-loading 引用规则，与实际引用保持一致（将"12 个"改为"9 个"，排除列表增加 sdd-role、sdd-quick、sdd-ff）

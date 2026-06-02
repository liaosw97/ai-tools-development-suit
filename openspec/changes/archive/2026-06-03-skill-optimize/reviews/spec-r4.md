# Spec Review — Round 4

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-06-01
**前轮:** Round 3 (NEEDS_REVISION)

## Round 3 Issues 修复状态

### [major] review-loop.md 引用规则与实际引用不一致
- **状态:** 已修复
- **说明:** spec 中已修正为 2 个（sdd-brainstorm、sdd-plan），与实际 SKILL.md 文件一致。经验证，仅 sdd-brainstorm 和 sdd-plan 包含完整的 review 循环逻辑（dispatch reviewer → 展示 issues → 修复 → 重新 review，最多 3 轮，达限处理等）。

## 引用规则最终验证

- base-triggers.md: [规则] 14 个, [实际] 14 个, [状态] 一致
  - 验证：所有 14 个 SKILL.md 均包含触发条件节（触发/不触发/歧义处理格式）
- output-constraints.md: [规则] 14 个, [实际] 14 个, [状态] 一致
  - 验证：所有 14 个 SKILL.md 均包含输出约束和零结果与幻觉防护节
- role-loading.md: [规则] 9 个, [实际] 9 个, [状态] 一致
  - 验证：sdd-brainstorm、sdd-code、sdd-plan、sdd-propose、sdd-review-code、sdd-review-spec、sdd-ship、sdd-test-code、sdd-verify 均包含角色加载逻辑（0.3 角色加载节）
- breakdown-mode.md: [规则] 1 个, [实际] 1 个, [状态] 一致
  - 验证：仅 sdd-brainstorm 包含拆分模式检测逻辑（0.5 拆分模式检测节）
- review-loop.md: [规则] 2 个, [实际] 2 个, [状态] 一致
  - 验证：sdd-brainstorm（Brainstorm Review 循环）和 sdd-plan（Plan Review 循环）包含完整的 review 循环逻辑

## Approved
- [x] 场景完整性
- [x] 可测试性
- [x] 一致性
- [x] 决策追溯
- [x] 范围控制
- [x] 跨模块一致性

## 结论
APPROVED

## 审查详情

### 场景完整性
- 共享模块目录结构场景完整，覆盖 5 个共享模块文件
- Include 机制场景完整，包含语法识别和路径解析
- 引用规则场景完整，明确定义了每个共享模块的引用范围
- 共享模块内容完整性场景完整，每个模块都有详细的内容要求
- 覆盖机制和降级策略场景完整

### 可测试性
- 所有场景均可通过检查文件存在性、内容验证、功能测试等方式验证
- 引用规则可通过扫描 SKILL.md 文件中的 include 引用进行验证
- 角色加载逻辑可通过模拟不同角色参数进行测试

### 一致性
- 引用规则与实际 SKILL.md 文件实现完全一致
- 角色系统定义（9 个 SKILL）与实际包含角色加载逻辑的 SKILL 数量一致
- 拆分模式定义（1 个 SKILL）与实际包含拆分模式检测的 SKILL 数量一致
- Review 循环定义（2 个 SKILL）与实际包含 review 循环的 SKILL 数量一致

### 决策追溯
- 引用规则的定义基于实际 SKILL.md 文件的功能需求
- 每个共享模块的引用范围都有明确的业务逻辑支撑

### 范围控制
- 共享模块仅包含通用功能，不包含特定 action 的业务逻辑
- 覆盖机制允许 SKILL.md 在引用共享模块后自定义差异内容

### 跨模块一致性
- 共享模块设计考虑了所有 14 个 SKILL 的需求
- 引用规则确保了模块间的功能边界清晰

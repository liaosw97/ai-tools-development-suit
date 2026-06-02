# Spec Review — Round 5

**审查对象:** specs/ 目录下所有 15 个 spec 文件
**日期:** 2026-06-02
**前轮:** Round 4 (APPROVED - 仅 shared-skill-modules)

## 总结

specs/ 目录下的 15 个 spec 文件整体结构清晰，覆盖了 proposal 中定义的所有 capability 变更。每个 spec 都遵循了 MODIFIED/ADDED 的 Delta Spec 标记规范，场景描述基本完整。但存在几个系统性问题需要修复：所有 spec 缺少 GIVEN 前置条件（只用了 WHEN/THEN），Token 减少断言使用"约"字导致不可测试，brainstorm.md 与 shared-skill-modules/spec.md 之间存在数据不一致，以及 proposal.md 缺少对 brainstorm 关键决策的追溯引用。

## Issues

### [critical] 场景缺少 GIVEN 前置条件

- **位置:** 所有 15 个 spec 文件的所有场景
- **描述:** CLAUDE.md 明确要求 spec 使用 "GIVEN/WHEN/THEN" 格式，但所有 spec 文件只使用了 WHEN/THEN，缺少 GIVEN 部分。例如 sdd-brainstorm/spec.md 中：
  ```
  #### Scenario: Include 共享模块
  - **WHEN** 加载 `skills/sdd-brainstorm/SKILL.md`
  - **THEN** 包含以下 include 引用
  ```
  应该改为：
  ```
  #### Scenario: Include 共享模块
  - **GIVEN** `skills/sdd-brainstorm/SKILL.md` 已完成改造
  - **WHEN** 加载该 SKILL.md
  - **THEN** 包含以下 include 引用
  ```
- **建议:** 为所有场景补充 GIVEN 前置条件，明确场景的初始状态

### [major] Token 减少断言不可测试

- **位置:** 所有 14 个 MODIFIED spec 的 "Token 减少" 场景
- **描述:** 所有 spec 都使用模糊的"约 X 行"描述目标行数，例如：
  ```
  - **THEN** 从 472 行减少至约 180 行（减少 62%）
  ```
  "约"字使得断言无法转化为自动化测试——测试无法判断 175 行或 185 行是否通过
- **建议:** 改为具体范围，如 `≤180 行` 或 `170-190 行`，或直接使用精确目标值

### [major] brainstorm 与 spec 数据不一致：role-loading.md 引用数量

- **位置:** brainstorm.md §方案 A vs specs/shared-skill-modules/spec.md §引用规则定义
- **描述:** brainstorm.md 第 31 行声明 role-loading.md 被 **12** 个 SKILL 引用，但 shared-skill-modules/spec.md 第 34 行列出 **9** 个 SKILL。实际验证：无角色系统的 SKILL 为 sdd-continue、sdd-doctor、sdd-ff、sdd-quick、sdd-role 共 5 个，因此有角色系统的是 9 个，spec 正确，brainstorm 有误
- **建议:** 更新 brainstorm.md 中 role-loading.md 的被引用次数从 12 改为 9，ROI 表中 `~1440 行（12×120）` 改为 `~1080 行（9×120）`

### [major] 决策追溯缺失

- **位置:** proposal.md
- **描述:** CLAUDE.md 要求决策追溯格式为 `选择 [X] 而非 [Y]：[原因]（见 brainstorm.md §<标题>）`。proposal.md 中没有引用 brainstorm.md 的任何关键决策（方案选择、双轨验证、5 模块划分等）。虽然 brainstorm.md 的"关键决策"节有详细记录，但 proposal.md 作为固化文档应包含决策追溯
- **建议:** 在 proposal.md 中增加"关键决策"节，引用 brainstorm.md 中的 4 个关键决策

### [minor] 错误路径覆盖不足

- **位置:** 大部分 spec（除 sdd-role 外）
- **描述:** 大部分 spec 只有"Include 失败降级"这一个错误场景。brainstorm.md 中提到的其他边界条件未在 spec 中覆盖：
  - 共享模块内容格式错误（缺少必填字段）
  - include 路径格式错误（非 `<!-- include: path -->` 格式）
  - 共享模块版本不匹配（内容被意外修改）
- **建议:** 在 shared-skill-modules/spec.md 中补充这些边界场景

### [minor] sdd-verify/spec.md 场景覆盖偏少

- **位置:** specs/sdd-verify/spec.md
- **描述:** sdd-verify 只有 5 个场景（Include、保留差异、Frontmatter、Token 减少、降级），是所有 spec 中最少的。缺少验证失败处理场景，例如：
  - 测试失败时的处理流程
  - Spec 覆盖率不达标时的输出
  - 验证报告的判定标准（PASSED/FAILED 的具体条件）
- **建议:** 补充验证失败和覆盖率判定的具体场景

### [minor] sdd-test-code/spec.md 场景描述中混入了执行细节

- **位置:** specs/sdd-test-code/spec.md §保留差异内容
- **描述:** 第 23 行的差异内容描述中包含了执行约束细节：
  ```
  - 场景补全（invoke `superpowers:test-driven-development`，严格约束：不修改实现代码，仅补充/修复测试）
  ```
  这更像实现细节而非 spec 级别的行为描述。spec 应该描述"做什么"而非"怎么做"
- **建议:** 简化为行为描述，如 `核心执行：场景补全和测试质量修复，严格约束不修改实现代码`

### [minor] shared-skill-modules/spec.md 缺少跨模块验证场景

- **位置:** specs/shared-skill-modules/spec.md
- **描述:** 虽然定义了引用规则（哪些 SKILL 引用哪些共享模块），但没有一个汇总场景验证所有 14 个 SKILL 的 include 配置是否正确。这在跨模块一致性检查中很重要
- **建议:** 增加一个"引用完整性验证"场景，验证所有 14 个 SKILL 的 include 配置与引用规则一致

## Approved

- [ ] 场景完整性 — 缺少 GIVEN 前置条件，部分 spec 场景偏少
- [ ] 可测试性 — Token 减少断言使用"约"字，无法自动化测试
- [ ] ⚠️ 一致性 — brainstorm 与 spec 数据不一致（role-loading.md 引用数量）
- [ ] 决策追溯 — proposal.md 未引用 brainstorm.md 的关键决策
- [x] 范围控制 — 所有 spec 内容均在 proposal 范围内，无隐含功能扩展
- [ ] 跨模块一致性 — 缺少引用完整性验证场景

## 结论

**NEEDS_REVISION**

需要修复 1 个 critical 问题（GIVEN 前置条件缺失）和 3 个 major 问题（Token 断言不可测试、数据不一致、决策追溯缺失），以及 4 个 minor 问题。建议优先修复 critical 和 major 问题后重新提交审查。

# Spec 规范扫描报告 — skill-optimize

**扫描批次**: r1
**工作类型**: skill 开发
**扫描状态**: SCANNED

## 扫描结果

### 扫描工具: skill-craft-adapter:skill-check

| 维度 | 级别 | 描述 | 修复建议 |
|------|------|------|---------|
| 结构完整性 | major | 所有 spec 缺少 GIVEN 前置条件，不符合 GIVEN/WHEN/THEN 标准格式 | 为所有场景补充 GIVEN 前置条件 |
| 可测试性 | major | Token 减少断言使用"约"字，无法自动化测试 | 改为具体范围或精确目标值 |
| 一致性 | major | brainstorm.md 与 spec 数据不一致（role-loading.md 引用数量） | 更新 brainstorm.md 中的引用数量 |
| 决策追溯 | major | proposal.md 未引用 brainstorm.md 的关键决策 | 在 proposal.md 中增加决策追溯 |
| 错误处理 | minor | 大部分 spec 只有"Include 失败降级"一个错误场景 | 补充其他边界条件场景 |
| 依赖管理 | info | 共享模块引用规则清晰，依赖关系明确 | 无需修改 |
| 文档质量 | minor | 部分 spec 场景描述混入执行细节 | 简化为行为描述 |
| 跨模块一致性 | minor | 缺少引用完整性验证场景 | 增加汇总验证场景 |

## 总结

- critical: 0 项
- major: 4 项
- minor: 3 项
- info: 1 项

## Issues 逐项列表

### [major] 场景缺少 GIVEN 前置条件
- **描述:** 所有 15 个 spec 文件的所有场景只使用 WHEN/THEN，缺少 GIVEN 部分
- **位置:** 所有 spec 文件
- **修复建议:** 为每个场景补充 GIVEN 前置条件，明确场景的初始状态

### [major] Token 减少断言不可测试
- **描述:** 所有 14 个 MODIFIED spec 的 "Token 减少" 场景使用"约 X 行"描述
- **位置:** 所有 MODIFIED spec
- **修复建议:** 改为具体范围（如 `≤180 行`）或精确目标值

### [major] brainstorm 与 spec 数据不一致
- **描述:** brainstorm.md 声明 role-loading.md 被 12 个 SKILL 引用，spec 列出 9 个
- **位置:** brainstorm.md §方案 A
- **修复建议:** 更新 brainstorm.md 中的引用数量为 9

### [major] 决策追溯缺失
- **描述:** proposal.md 未引用 brainstorm.md 的关键决策
- **位置:** proposal.md
- **修复建议:** 增加"关键决策"节，引用 brainstorm.md 中的 4 个关键决策

### [minor] 错误路径覆盖不足
- **描述:** 大部分 spec 只有"Include 失败降级"一个错误场景
- **位置:** 大部分 spec
- **修复建议:** 补充共享模块内容格式错误、路径格式错误等边界场景

### [minor] sdd-test-code/spec.md 混入执行细节
- **描述:** 差异内容描述中包含执行约束细节
- **位置:** specs/sdd-test-code/spec.md §保留差异内容
- **修复建议:** 简化为行为描述

### [minor] 缺少跨模块验证场景
- **描述:** shared-skill-modules/spec.md 缺少引用完整性验证场景
- **位置:** specs/shared-skill-modules/spec.md
- **修复建议:** 增加汇总验证场景

### [info] 共享模块引用规则清晰
- **描述:** 共享模块引用规则定义明确，依赖关系清晰
- **位置:** specs/shared-skill-modules/spec.md
- **修复建议:** 无需修改

## 建议修复方案

1. **优先修复 GIVEN 前置条件**：为所有 15 个 spec 文件的所有场景补充 GIVEN 前置条件
2. **修复 Token 断言**：将"约 X 行"改为具体范围或精确目标值
3. **修复数据不一致**：更新 brainstorm.md 中 role-loading.md 的引用数量
4. **补充决策追溯**：在 proposal.md 中增加决策追溯引用

## 结论

**SCANNED** 扫描完成，发现 4 个 major 问题和 3 个 minor 问题。建议优先修复 major 问题后重新提交审查。

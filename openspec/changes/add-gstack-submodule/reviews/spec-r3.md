# Spec Review — Round 3

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-27

## 总结

Issue-1 和 Issue-6 已正确修复，决策链（brainstorm → proposal → spec）现已一致表述"内置 < 项目级 < 用户级"优先级顺序。但发现新问题：design.md 架构图注释与正确优先级顺序相反，需修正。其余维度均通过审查。

## Issues

### MEDIUM

#### Issue-9: design.md 架构图优先级注释错误

**位置:** `design.md` 第 39-41 行

**问题:** 架构图中角色定义源的注释与正确优先级顺序相反：

```
~/.claude/roles/     ← 用户级（优先级最低）
openspec/roles/      ← 项目级
ai-tools-bridge/roles/ ← 内置（优先级最高）
```

正确顺序应为"内置 < 项目级 < 用户级"，即用户级优先级最高，内置优先级最低。

**建议:** 修正注释为：
```
ai-tools-bridge/roles/ ← 内置（优先级最低，作为基础）
openspec/roles/        ← 项目级（可覆盖内置）
~/.claude/roles/       ← 用户级（优先级最高，可覆盖项目级和内置）
```

### LOW

#### Issue-10: design.md 优先级规则图示与文字描述不一致

**位置:** `design.md` 第 56 行

**问题:** 决策追溯中声明"选择 [三层优先级] 而非 [单一配置源]：项目级配置可覆盖用户级，团队协作时项目配置优先生效"，此表述与已修正的优先级顺序存在歧义。

**建议:** 修正为"用户级配置可覆盖项目级和内置，项目级可覆盖内置"。

## 已修复 Issues 状态

| Issue | 状态 | 说明 |
|-------|------|------|
| Issue-1 | FIXED | SC-05 已修正为"内置 < 项目级 < 用户级" |
| Issue-6 | FIXED | proposal.md 已修正为"用户级配置优先级最高（可覆盖项目级和内置），项目级次之（可覆盖内置）" |

## 第一轮遗留 Issues 状态

| Issue | 状态 | 说明 |
|-------|------|------|
| Issue-2 | OPEN | 建议添加大小写不敏感场景验证（改进建议） |
| Issue-3 | OPEN | 建议补充角色来源判断逻辑（改进建议） |
| Issue-4 | OPEN | 建议补充 versions.lock 格式示例（改进建议） |
| Issue-5 | OPEN | 建议明确会话定义范围（改进建议） |
| Issue-7 | OPEN | 角色来源判断逻辑未明确（改进建议） |
| Issue-8 | OPEN | 会话定义范围模糊（改进建议） |

## Approved

- [x] 场景完整性 — 所有场景使用 GIVEN/WHEN/THEN 格式，覆盖正常路径和主要错误路径
- [x] 可测试性 — WHEN/THEN 可转化为自动化测试，边界条件覆盖关键异常场景
- [ ] 一致性 — **存在问题**：design.md 架构图注释与正确优先级顺序相反
- [x] 决策追溯 — proposal 正确引用了 brainstorm 的 6 个关键决策，spec 场景与决策对应
- [x] 范围控制 — spec 内容均在 proposal 范围内，无隐含功能扩展
- [x] 跨模块一致性 — 影响分析完整，三个 spec 之间无冲突

## 结论

**NEEDS_REVISION**

需修正 Issue-9（design.md 架构图优先级注释错误）后方可批准。Issue-10 为改进建议，可在后续迭代中处理。第一轮遗留的 Issue-2 至 Issue-8 均为改进建议，不阻碍批准。

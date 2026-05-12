# Code Quality Review — Batch 6

> 审查范围：Task 5.1-5.8（前置校验机制）
> 变更文件：8 个 SKILL.md（各 +4~6 行）, `tests/l1-structural/pre-validation.test.ts`（+134 行）

## 审查结果

| 严重性 | 数量 |
|--------|------|
| Critical | 0 |
| Major | 0 |
| Minor | 2 |

## Minor Issues

### M1: sdd-plan 批次 4 变更未提交

**发现**: `git diff HEAD~1` 显示 `skills/sdd-plan/SKILL.md` 有 68 行变更，包括批次 4 的规模检测、分批生成、后置推荐等改动。这些变更未被独立提交，目前作为未提交工作目录变更存在。
**影响**: 如果中途出现问题，这些变更可能丢失；git 历史不反映批次 4 的实际提交。
**建议**: 在下一批次提交时包含 `skills/sdd-plan/SKILL.md`，或立即单独提交。

### M2: 测试文件中 sdd-plan 前置校验测试位置

**文件**: `tests/l1-structural/sdd-plan-schema.test.ts`（已有）vs `tests/l1-structural/pre-validation.test.ts`（新增）
**现状**: sdd-plan 的前置校验测试在 `sdd-plan-schema.test.ts`（Task 3.7），而其他 8 个 action 的前置校验测试统一在 `pre-validation.test.ts`
**问题**: 同类功能的测试分布在两个文件中，未来维护时可能遗漏
**建议**: 可接受——sdd-plan 测试文件已存在且有完整上下文（规模检测 + 分批生成 + 前置校验 + 后置推荐），拆分到新文件反而割裂上下文

## 正面观察

- 8 个 action 统一使用 `### 0. 前置校验` 编号，与原有步骤 `### 1.` 自然衔接，不破坏已有编号体系
- 阻断级消息都包含具体的修复命令（如 `/sdd-propose`、`/sdd-ff`），用户可直接执行
- 测试文件使用统一的 `getBody()` helper，结构清晰
- 每个 describe 块标注 Task 编号，与 plan.md 对应
- sdd-propose 的占位符检测 `<!-- ... -->` 是超出 spec 的防御性实现，提高了健壮性

## 行动建议

M1（sdd-plan 未提交变更）建议在批次 7 提交时一并处理，无需单独修复。

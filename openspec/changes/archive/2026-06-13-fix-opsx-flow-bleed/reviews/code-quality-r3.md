# Code Quality Review — Round 3

**审查人**: Senior Code Reviewer
**日期**: 2026-06-13
**变更**: fix-opsx-flow-bleed — SDD 后置逻辑增强
**审查范围**: 已提交 (`f1539ad`) + 未提交修改（工作目录）

---

## 审查说明

用户指定的 git diff 范围 `f6a739d..f1539ad` 仅包含格式修改（添加编号）。实际的 fix-opsx-flow-bleed 变更还包括未提交的修改（`━━━` 分隔线、SDD 流程指引、OPSX 失败容错等）。本次审查覆盖完整变更。

---

## Strengths

1. **共享模板设计合理** — `skills/_shared/sdd-flow-guidance.md` 提供了统一的格式规范和各 action 的下一步建议，便于维护和一致性保障。

2. **分隔线视觉效果清晰** — 使用 `━━━` 水平线作为 SDD 流程指引的上下边框，有效区分了 SDD 指引和 OPSX 建议。

3. **OPSX 失败容错逻辑完整** — sdd-propose 添加了错误处理部分，当 OPSX 命令执行失败时提供恢复指引。

4. **文档更新全面** — CLAUDE.md 和 README.md 都添加了 SDD 流程独立性说明和误操作恢复指引。

5. **格式统一** — 所有 12 个 SKILL.md 的"推荐下一步"格式已统一为编号列表（`1. ★`、`2. ○`、`3. △`）。

6. **测试全部通过** — 295 个测试全部通过，修改未破坏现有功能。

---

## Issues

### Important (Should Fix)

#### 1. sdd-quick 流程指引未区分场景

**文件**: `skills/sdd-quick/SKILL.md:205-211`

**问题**: sdd-flow-guidance.md 区分了两种场景：
- 所有 artifact 已生成：推荐 `/sdd-ship`
- 实现不完整：推荐 `/sdd-verify`，可选 `/sdd-ship`

但 sdd-quick SKILL.md 的流程指引只显示推荐 `/sdd-ship`，没有区分场景。

**影响**: 当 sdd-quick 因达限而中断（实现不完整）时，用户看到的流程指引可能误导他们直接归档，而不是先验证实现完整性。

**建议修复**: 在 sdd-quick SKILL.md 中添加条件逻辑，根据实现完成度显示不同的流程指引。或者在流程指引中同时列出两种场景的建议。

#### 2. sdd-verify 流程指引缺少 `/sdd-test-code` 选项

**文件**: `skills/sdd-verify/SKILL.md:131-138`

**问题**: sdd-verify 的完成引导（第 125-129 行）推荐三个选项：
- `/sdd-ship` — PASSED
- `/sdd-test-code` — FAILED，测试未覆盖场景
- `/sdd-code` — FAILED，实现缺失

但流程指引部分（第 136-138 行）只推荐两个选项：
- `/sdd-ship` — 归档合并
- `/sdd-code` — 修复问题

缺少 `/sdd-test-code` 选项。

**影响**: 当验证失败原因是测试未覆盖场景时，用户可能直接跳到 `/sdd-code` 而不是先用 `/sdd-test-code` 补全测试。

**建议修复**: 在流程指引中添加 `/sdd-test-code` 选项，与完成引导保持一致。

#### 3. sdd-ship 流程指引与模板不一致

**文件**: `skills/sdd-ship/SKILL.md:201-206`

**问题**: sdd-flow-guidance.md 说明 sdd-ship 使用简化标题 `SDD 流程指引`（无"请忽略 OPSX 建议"提示），因为此时不存在 OPSX 建议干扰。

但 sdd-ship SKILL.md 的流程指引（第 202 行）使用的是 `SDD 流程指引`（无"请忽略 OPSX 建议"），这与模板一致。

**实际状态**: 无问题，符合模板设计。

### Minor (Nice to Have)

#### 4. git diff 范围与实际变更不匹配

**问题**: 用户指定的 git diff 范围 `f6a739d..f1539ad` 只包含一个提交（格式修改），但实际变更还包括未提交的修改。

**影响**: 审查时需要额外检查工作目录的未提交修改，增加了审查复杂度。

**建议**: 在提交前将所有相关修改合并到一个提交中，或者明确说明审查范围包括未提交修改。

#### 5. 共享模板文件未被引用

**文件**: `skills/_shared/sdd-flow-guidance.md`

**问题**: 模板文件建议使用 `<!-- include: ../_shared/sdd-flow-guidance.md -->` 引用，但实际的 SKILL.md 文件都是直接复制内容，没有使用 include 引用。

**影响**: 如果模板格式需要修改，需要同步修改 6 个 SKILL.md 文件，维护成本较高。

**建议**: 考虑使用 include 引用机制（如果 Claude Code 支持），或者在模板文件中明确说明"直接复制"是推荐方式。

#### 6. sdd-flow-guidance.md 中 sdd-quick 的两种场景建议重复

**文件**: `skills/_shared/sdd-flow-guidance.md:91-111`

**问题**: sdd-quick 的两种场景（完整实现和不完整实现）都推荐 `/sdd-ship`，区别在于不完整实现还推荐 `/sdd-verify`。但 sdd-quick SKILL.md 的流程指引只显示一种建议。

**建议**: 在模板中明确说明 SKILL.md 应如何处理两种场景（条件逻辑或合并显示）。

---

## Plan Alignment

| 计划要求 | 实现状态 | 备注 |
|---------|---------|------|
| 6 个 SKILL.md 添加 SDD 流程指引 | ✅ 完成 | 含 `━━━` 分隔线 |
| sdd-propose 添加 OPSX 失败容错 | ✅ 完成 | 错误处理部分已添加 |
| CLAUDE.md 添加 SDD 流程独立性说明 | ✅ 完成 | 含误操作恢复指引 |
| README.md 添加 SDD vs OPSX 使用指南 | ✅ 完成 | 对比说明已添加 |
| 创建共享模板文件 | ✅ 完成 | `skills/_shared/sdd-flow-guidance.md` |
| 格式一致性 | ⚠️ 部分完成 | sdd-quick 和 sdd-verify 有小偏差 |

---

## Recommendations

1. **修复 sdd-quick 流程指引** — 添加场景区分逻辑，确保达限中断时用户看到正确的建议。

2. **修复 sdd-verify 流程指引** — 添加 `/sdd-test-code` 选项，与完成引导保持一致。

3. **提交前统一变更** — 将所有相关修改（已提交 + 未提交）合并到一个提交中，便于审查和追溯。

4. **考虑 include 机制** — 如果 Claude Code 支持 include 引用，可以减少维护成本。

---

## Assessment

**Ready to merge?** With fixes

**Reasoning:** 实现整体质量良好，核心功能（SDD 流程指引、OPSX 失败容错、文档更新）都已完成。但 sdd-quick 和 sdd-verify 的流程指引有小偏差，建议修复后再合并。此外，git diff 范围与实际变更不匹配，建议将所有修改合并到一个提交中。

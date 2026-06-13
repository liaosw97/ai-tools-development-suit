## Why

当用户使用 ai-tools-bridge 的 SDD 流程（如 `/sdd-propose`、`/sdd-continue`、`/sdd-ff`）时，这些 action 会内部调用 OPSX 命令。OPSX 命令执行完成后会输出自己的"下一步建议"（如 `Run /opsx:apply to start implementing`），导致用户可能跟随 OPSX 的建议走 openspec 的流程，而不是继续走 SDD 的流程。

这破坏了 SDD 流程的连贯性，用户可能跳过关键步骤（如 sdd-ff → sdd-plan），直接进入实现阶段。

## What Changes

- **修改 6 个调用 OPSX 的 SDD action 后置逻辑**：在 sdd-propose、sdd-continue、sdd-ff、sdd-verify、sdd-ship、sdd-quick 的"完成引导"部分添加醒目的 SDD 流程指引
- **添加警告标识**：使用 `━━━` 分隔线和明确文字告知用户忽略可能显示的 OPSX 建议
- **统一格式**：所有受影响的 SDD action 使用一致的下一步建议格式（★○△ 标记）
- **更新文档**：在 CLAUDE.md 和 README.md 中说明 SDD 流程的独立性

**不修改 OPSX 命令文件**：保持 OPSX 作为独立工具的完整性。

**不涉及的 action**：sdd-brainstorm、sdd-plan、sdd-code、sdd-review-spec、sdd-review-code、sdd-test-code、sdd-doctor（这些 action 不调用 OPSX 命令，无需添加流程指引）

## Capabilities

### New Capabilities

- `sdd-post-logic-enhancement`: SDD 后置逻辑增强 — 在所有 SDD action 的完成引导中添加统一的流程指引，防止用户被 OPSX 建议误导

### Modified Capabilities

（无）

## Impact

**受影响的文件**（仅调用 OPSX 命令的 action）：
- `ai-tools-bridge/skills/sdd-propose/SKILL.md`
- `ai-tools-bridge/skills/sdd-continue/SKILL.md`
- `ai-tools-bridge/skills/sdd-ff/SKILL.md`
- `ai-tools-bridge/skills/sdd-verify/SKILL.md`
- `ai-tools-bridge/skills/sdd-ship/SKILL.md`
- `ai-tools-bridge/skills/sdd-quick/SKILL.md`
- `ai-tools-bridge/CLAUDE.md`
- `ai-tools-bridge/README.md`

**不涉及的 action**：sdd-brainstorm、sdd-plan、sdd-code、sdd-review-spec、sdd-review-code、sdd-test-code、sdd-doctor

**无外部依赖影响**：不修改 OPSX 命令文件，不影响其他项目。

## 决策追溯

- **选择 [方案 C + E 组合] 而非 [方案 A/B/D]**：保持 OPSX 命令的独立性，通过 SDD 后置逻辑覆盖和文档教育解决问题（见 brainstorm.md §决策 1）
- **选择 [醒目的警告格式] 而非 [纯依赖输出顺序]**：即使 OPSX 建议显示在最后，用户也能看到警告标识（见 brainstorm.md §决策 3）

## Context

ai-tools-bridge 是一个 SDD 工作流编排器，通过 13 个 SDD action 编排 OpenSpec 和 Superpowers。每个 SDD action 的核心执行阶段会调用 OPSX 命令（如 `/opsx:propose`、`/opsx:continue`、`/opsx:ff`）。

**问题**：OPSX 命令是独立的工具，执行完成后会输出自己的"下一步建议"（如 `Run /opsx:apply to start implementing`）。由于 SDD 的后置逻辑在 OPSX 输出之后执行，用户可能看到 OPSX 的建议并跟随它，跳过 SDD 流程的后续步骤。

**当前状态**：SDD 后置逻辑的"完成引导"部分没有明确区分 SDD 流程和 OPSX 流程，导致用户可能混淆。

## Goals / Non-Goals

**Goals:**
- 在所有 SDD action 的后置逻辑中添加统一的流程指引
- 使用醒目的视觉格式区分 SDD 建议和 OPSX 建议
- 更新文档说明 SDD 流程的独立性

**Non-Goals:**
- 不修改 OPSX 命令文件（保持独立性）
- 不改变 SDD 的核心编排逻辑
- 不添加新的 SDD action

## Decisions

### Decision 1: 使用视觉分隔符区分 SDD 建议

**选择**：使用 `━━━` 水平线作为视觉分隔符，包裹 SDD 流程指引部分。

**理由**：
- `━━━` 在终端中显示为连续的粗线，视觉效果醒目
- 与 OPSX 的纯文本建议形成明显对比
- 不需要特殊字符或颜色支持

**替代方案**：
- 使用 emoji（如 ⚠️）：可能在某些终端显示异常
- 使用 ASCII art：过于复杂，维护成本高

### Decision 2: 在指引中添加明确的忽略提示

**选择**：在 SDD 流程指引中添加文字"请忽略上方可能显示的 OPSX 建议"。

**理由**：
- 直接告知用户不要跟随 OPSX 建议
- 即使用户快速浏览，也能看到这个提示
- 符合"显式优于隐式"的原则

**替代方案**：
- 仅依赖输出顺序：风险较高，OPSX 建议可能仍然显示在最后
- 在文档中说明：用户可能不阅读文档

### Decision 3: 为每个 SDD action 定制下一步建议

**选择**：每个 SDD action 的后置逻辑显示该 action 完成后的推荐下一步操作。

**理由**：
- 不同 action 完成后，下一步操作不同
- 提供上下文相关的建议，减少用户认知负担
- 符合 SDD 的"行动而非阶段"理念

**替代方案**：
- 统一显示所有可能的下一步：信息过载
- 不显示下一步：用户需要记住流程

### Decision 4: 使用 ★○△ 标记区分优先级

**选择**：使用 ★（推荐）、○（可选）、△（替代）标记区分下一步操作的优先级。

**理由**：
- 与现有的 SDD 文档风格一致
- 帮助用户快速识别推荐操作
- 减少决策疲劳

## File Structure

**新增文件**：
- `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` — SDD 流程指引共享模板

**修改文件**：
- `ai-tools-bridge/skills/sdd-propose/SKILL.md`
- `ai-tools-bridge/skills/sdd-continue/SKILL.md`
- `ai-tools-bridge/skills/sdd-ff/SKILL.md`
- `ai-tools-bridge/skills/sdd-verify/SKILL.md`
- `ai-tools-bridge/skills/sdd-ship/SKILL.md`
- `ai-tools-bridge/skills/sdd-quick/SKILL.md`
- `ai-tools-bridge/CLAUDE.md`
- `ai-tools-bridge/README.md`

## Risks / Trade-offs

**Risk 1: 用户仍然可能看到 OPSX 建议**
- **可能性**：中
- **影响**：低
- **缓解措施**：视觉分隔符和明确提示降低用户跟随 OPSX 建议的概率

**Risk 2: 输出格式在某些终端可能显示异常**
- **可能性**：低
- **影响**：低
- **缓解措施**：`━━━` 是标准 Unicode 字符，在主流终端中支持良好

**Risk 3: 维护 12 个 SKILL.md 的一致性**
- **可能性**：中
- **影响**：中
- **缓解措施**：创建共享模板或参考示例，确保格式一致

## Migration Plan

**部署步骤**：
1. 修改 `ai-tools-bridge/skills/sdd-*/SKILL.md` 文件（12 个）
2. 更新 `ai-tools-bridge/CLAUDE.md`
3. 更新 `ai-tools-bridge/README.md`
4. 运行测试验证格式正确性

**回滚策略**：
- 恢复 SKILL.md 文件到修改前的版本
- 文档修改可直接 revert

## Open Questions

无。

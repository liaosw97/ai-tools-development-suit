# Proposal: ai-tools-bridge/lib/ CLI 集成

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

将 `ai-tools-bridge/lib/` 中 4 个已验证但未集成的 TypeScript 函数包装为 CLI 脚本，使 Claude 可通过 `node scripts/xxx.mjs` 调用，从源头减少 SDD 工作流的 token 消耗。

## 范围

### 包含

- 创建 4 个 CLI 脚本（`scripts/*.mjs`）：summarize-spec, summarize-tasks, compress-review, state-file
- 更新 SKILL.md 集成脚本调用（sdd-review-code, sdd-verify, sdd-brainstorm, sdd-propose, sdd-plan, sdd-code）
- 添加 CLI 脚本的集成测试
- 保留 lib/ 原有测试（验证算法正确性）

### 不包含

- 不删除 `lib/` 目录（保留作为算法参考和测试验证）
- 不修改 lib/ 的 TypeScript 代码
- 不引入新的 npm 依赖
- 不修改 Superpowers 核心 skill

## 决策追溯

- 选择 [CLI 脚本 (.mjs)] 而非 [纯 SKILL.md 指令]：纯指令方案需 Claude 先加载完整文件再摘要，token 浪费发生在加载环节，与优化目标矛盾（见 brainstorm.md §决策 1）
- 选择 [脚本独立实现] 而非 [import lib/ 文件]：lib/ 是 TypeScript 需编译步骤，脚本是纯 JS 直接 `node` 运行，零依赖（见 brainstorm.md §决策 2）
- 选择 [手动 YAML 序列化] 而非 [JSON 格式]：SKILL.md 已引用 `state.yaml`，保持一致性；状态文件格式极简，手动序列化无风险（见 brainstorm.md §决策 3）

## 影响分析

### 影响的模块

- `ai-tools-bridge/scripts/` — 新增 4 个 CLI 脚本
- `ai-tools-bridge/skills/sdd-review-code/SKILL.md` — 集成 summarize-spec + compress-review
- `ai-tools-bridge/skills/sdd-verify/SKILL.md` — 集成 summarize-spec + summarize-tasks
- `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` — 集成 state-file
- `ai-tools-bridge/skills/sdd-propose/SKILL.md` — 集成 state-file
- `ai-tools-bridge/skills/sdd-plan/SKILL.md` — 集成 state-file
- `ai-tools-bridge/skills/sdd-code/SKILL.md` — 集成 state-file
- `ai-tools-bridge/tests/` — 新增集成测试

### 风险评估

- **兼容性风险**：SKILL.md 修改可能影响现有工作流 → 缓解：仅添加可选的脚本调用指令，不删除原有逻辑
- **维护风险**：lib/ 和 scripts/ 两套代码 → 缓解：lib/ 保留作为算法参考，scripts/ 是生产路径

## 成功标准

- [ ] 4/4 CLI 脚本 `node` 直接执行无错误
- [ ] 新增集成测试全部通过
- [ ] sdd-review-code SKILL.md 引用 summarize-spec.mjs 和 compress-review.mjs
- [ ] sdd-verify SKILL.md 引用 summarize-spec.mjs 和 summarize-tasks.mjs
- [ ] 现有 331 个测试不受影响（向后兼容）

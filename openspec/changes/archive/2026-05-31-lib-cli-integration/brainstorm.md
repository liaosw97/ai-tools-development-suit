# Brainstorm: ai-tools-bridge/lib/ CLI 集成

> 将 lib/ 中的 TypeScript 函数包装为 Claude 可调用的 CLI 脚本，集成到 SDD 工作流

## 需求描述

`ai-tools-bridge/lib/` 下有 4 个 TypeScript 函数（summarizer, artifact-bridge, review-context, state-file），它们的逻辑正确（331 个测试全部通过），但从未被任何 SKILL.md 或生产代码调用。

**根本原因**：架构错位。这些函数为 TypeScript 运行时设计，但 SDD 实际运行方式是 Claude 读取 Markdown SKILL.md → 用 Bash/Read/Write 工具执行。Claude 无法直接调用 TypeScript 函数。

**目标**：通过 CLI 脚本包装，让 Claude 可以通过 `node scripts/xxx.mjs` 调用这些函数，从源头减少 token 消耗。

## 方案探索

### 方案 A: CLI 脚本（已选择）

将函数包装为 `.mjs` 脚本，Claude 通过 Bash 工具调用。

- **优点**：确定性输出、从源头省 token、可测试、零外部依赖
- **缺点**：需要维护脚本 + 测试

### 方案 B: 纯 SKILL.md 指令（已否决）

用自然语言告诉 Claude 如何压缩上下文。

- **否决原因**：Claude 需先加载完整文件再摘要，token 浪费发生在加载环节，与优化目标矛盾

## 关键决策

### 决策 1: 脚本格式选择

**选择**：`.mjs`（ES Module），纯 Node.js 内置模块，零外部依赖

**理由**：
- 项目 `"type": "module"`，`.mjs` 自动识别为 ESM
- 避免依赖 `yaml` 包（devDependency），state-file.mjs 手动序列化简单 YAML
- `node` 是 Claude Code 环境的标配，无需额外安装

### 决策 2: 脚本与 lib/ 的关系

**选择**：脚本独立实现，不 import lib/ 文件

**理由**：
- lib/ 是 TypeScript，需要编译步骤；脚本是纯 JS，直接 `node` 运行
- lib/ 的测试继续保留（验证算法正确性）；脚本有独立的集成测试
- 两套代码可独立演进，脚本是 lib/ 的"生产路径"

### 决策 3: state-file 格式

**选择**：手动 YAML 序列化（非 JSON）

**理由**：
- SKILL.md 中已引用 `state.yaml`，保持一致
- 状态文件格式极简（change/phase/decisions），手动序列化无风险
- 避免引入 `yaml` 包作为运行时依赖

## 已产出的 CLI 脚本

| 脚本 | 用途 | 状态 |
|------|------|------|
| `scripts/summarize-spec.mjs` | 从 spec 提取场景列表 + GIVEN/WHEN/THEN | ✅ 已创建，已验证 |
| `scripts/summarize-tasks.mjs` | 从 tasks.md 提取任务摘要 | ✅ 已创建，已验证 |
| `scripts/compress-review.mjs` | 压缩 review 上下文（diff + spec 场景匹配） | ✅ 已创建，已验证 |
| `scripts/state-file.mjs` | 管理跨 action 状态文件（create/read/update） | ✅ 已创建，已验证 |

## SKILL.md 集成点

### sdd-review-code（最高优先级）

- **前置逻辑 §2**：用 `summarize-spec.mjs` 获取 spec 场景摘要（而非读取完整 spec）
- **Phase 1**：将摘要传递给 spec-compliance-reviewer subagent
- **Phase 2**：用 `compress-review.mjs` 准备结构化 review 上下文

### sdd-verify

- **前置逻辑 §2**：用 `summarize-spec.mjs` + `summarize-tasks.mjs` 收集验证材料

### sdd-brainstorm / sdd-propose / sdd-plan / sdd-code

- **状态文件集成**：用 `state-file.mjs` 管理 `state.yaml`

## 成功标准

| 指标 | 目标值 | 测量方法 |
|------|--------|----------|
| CLI 脚本可运行 | 4/4 脚本 `node` 直接执行无错误 | 手动测试 |
| 测试通过 | 新增集成测试全部通过 | `pnpm test` |
| SKILL.md 集成 | sdd-review-code 引用脚本 | grep 验证 |
| 向后兼容 | 现有 331 个测试不受影响 | `pnpm test` |

# Brainstorm: ai-tools-bridge Skill 依赖审计

## 需求描述

以 `ai-tools/` 中的项目（OpenSpec、Superpowers、Skills）为基底，检查 `ai-tools-bridge` 的 14 个 Skill 的运行时依赖，找出哪些有依据、哪些缺失，并给出解决方案。

## 关键发现

### 依赖全景

ai-tools-bridge 的 14 个 Skill 共引用 **14 个外部 skill**（8 Superpowers + 6 OpenSpec）：

| 来源 | 引用数 | 可用 SKILL.md | 状态 |
|------|--------|--------------|------|
| Superpowers | 8 | 8 | ✅ 全部可用 |
| OpenSpec | 6 | 0 | ❌ 全部缺失 |

### Superpowers 依赖（8 个，全部可用）

| 引用的 skill | 使用方 | SKILL.md 路径 | 状态 |
|-------------|--------|-------------|------|
| `superpowers:brainstorming` | sdd-brainstorm | `ai-tools/superpowers/skills/brainstorming/SKILL.md` | ✅ |
| `superpowers:writing-plans` | sdd-plan | `ai-tools/superpowers/skills/writing-plans/SKILL.md` | ✅ |
| `superpowers:test-driven-development` | sdd-code, sdd-test-code, sdd-quick | `ai-tools/superpowers/skills/test-driven-development/SKILL.md` | ✅ |
| `superpowers:using-git-worktrees` | sdd-code | `ai-tools/superpowers/skills/using-git-worktrees/SKILL.md` | ✅ |
| `superpowers:systematic-debugging` | sdd-code | `ai-tools/superpowers/skills/systematic-debugging/SKILL.md` | ✅ |
| `superpowers:requesting-code-review` | sdd-review-code | `ai-tools/superpowers/skills/requesting-code-review/SKILL.md` | ✅ |
| `superpowers:finishing-a-development-branch` | sdd-ship | `ai-tools/superpowers/skills/finishing-a-development-branch/SKILL.md` | ✅ |
| `superpowers:verification-before-completion` | sdd-verify | `ai-tools/superpowers/skills/verification-before-completion/SKILL.md` | ✅ |

### OpenSpec 依赖（6 个，SKILL.md 全部缺失，但 OPSX 命令可覆盖 6/6）

| 引用的 skill | 使用方 | OPSX 命令替代 | 本地可用 |
|-------------|--------|-------------|---------|
| `openspec-propose` | sdd-propose | `/opsx:propose` | ✅ |
| `openspec-archive-change` | sdd-ship | `/opsx:archive` | ✅ |
| `openspec-continue-change` | sdd-continue, sdd-quick, sdd-propose | `/opsx:continue` + `/opsx:apply` | ⚠️ 需启用扩展 |
| `openspec-ff-change` | sdd-ff | `/opsx:ff` | ⚠️ 需启用扩展 |
| `openspec-verify-change` | sdd-verify | `/opsx:verify` | ⚠️ 需启用扩展 |
| `openspec-sync-specs` | sdd-ship | `/opsx:sync` | ⚠️ 需启用扩展 |

### 根因分析

OpenSpec 是 **TypeScript CLI 工具**（`ai-tools/OpenSpec/`），通过 `openspec` CLI 命令提供功能，而非通过 SKILL.md 文件。OPSX 命令是 OpenSpec 的斜杠命令接口，直接调用 CLI（`openspec status`、`openspec instructions` 等）。

ai-tools-bridge 将 OpenSpec 功能抽象为 skill 名称引用（如 `openspec-continue-change`），但这些 skill 从未被实现为 SKILL.md。**实际的运行时接口是 OPSX 命令**。

### OPSX 命令体系（11 个命令）

OpenSpec 文档定义了 11 个 OPSX 命令，分两组：

**核心命令（`core` profile，默认启用，本地已有 4 个）**：

| 命令 | 本地 | 功能 |
|------|------|------|
| `/opsx:propose` | ✅ | 创建变更 + 一步生成所有规划 artifact |
| `/opsx:explore` | ✅ | 苏格拉底式探索，不创建 artifact |
| `/opsx:apply` | ✅ | 按 tasks.md 实施代码 |
| `/opsx:archive` | ✅ | 归档完成的变更 |

**扩展命令（需 `openspec config profile` 启用，本地缺失 7 个）**：

| 命令 | 本地 | 功能 |
|------|------|------|
| `/opsx:new` | ❌ | 仅创建变更骨架 |
| `/opsx:continue` | ❌ | 按依赖链逐个生成 artifact |
| `/opsx:ff` | ❌ | 快进生成所有规划 artifact |
| `/opsx:verify` | ❌ | 验证实现与 artifact 一致性 |
| `/opsx:sync` | ❌ | 合并 delta specs 到主 specs |
| `/opsx:bulk-archive` | ❌ | 批量归档多个变更 |
| `/opsx:onboard` | ❌ | 引导式教程 |

**启用扩展命令**：
```bash
cd ai-tools/OpenSpec
pnpm install && pnpm run build
openspec config profile    # 选择 workflows
openspec update            # 生成扩展命令文件
```

### 运行时机制

OPSX 命令通过以下 CLI 调用链运行：
```
/opsx:continue → openspec status --change <name> --json → 获取依赖图
               → openspec instructions <artifact> --change <name> --json → 获取模板+上下文
               → 生成 artifact 文件
```

## 方案探索

### 方案 A: 启用 OPSX 扩展命令 + 修改 ai-tools-bridge 引用

1. 在 OpenSpec 中启用扩展 profile，生成全部 11 个 OPSX 命令
2. 修改 ai-tools-bridge 的 7 个 SKILL.md，将 `invoke openspec-xxx` 改为调用对应的 OPSX 命令

**优点**：
- 100% 覆盖（11 个 OPSX 命令覆盖全部 6 个缺失 skill）
- 复用 OpenSpec 原生实现，无额外维护
- OPSX 命令已封装好 CLI 调用逻辑

**缺点**：
- 需要修改 7 个 ai-tools-bridge SKILL.md 文件
- OPSX 命令是斜杠命令格式，ai-tools-bridge 的 invoke 模式需要适配

### 方案 B: 创建 6 个 OpenSpec SKILL.md 文件

在 OpenSpec 中创建 SKILL.md 文件，封装 CLI 命令为 skill 调用接口，与 ai-tools-bridge 的 invoke 模式兼容。

**优点**：
- 与 ai-tools-bridge 的三层模式完全兼容
- 统一的 skill 接口规范

**缺点**：
- 需要创建 6 个 SKILL.md + 维护两套接口（CLI + SKILL.md）
- OPSX 命令已有完整实现，SKILL.md 是重复劳动

### 方案 C: 修改 ai-tools-bridge 引用为 CLI 命令

将 `invoke openspec-xxx` 改为直接调用 OpenSpec CLI 命令（`openspec status`、`openspec instructions` 等）。

**优点**：
- 直接使用原生接口，无中间层
- 零额外文件

**缺点**：
- 需要在每个 SKILL.md 中内联 CLI 调用逻辑
- 破坏委托模式，前置/后置逻辑需要大量重写

### 方案 D: 混合方案（推荐）

1. **启用 OPSX 扩展命令**（前置条件）
2. **修改 ai-tools-bridge 引用**：
   - `openspec-propose` → 调用 `/opsx:propose` 逻辑
   - `openspec-archive-change` → 调用 `/opsx:archive` 逻辑
   - `openspec-continue-change` → 调用 `/opsx:continue` + `/opsx:apply` 逻辑
   - `openspec-ff-change` → 调用 `/opsx:ff` 逻辑
   - `openspec-verify-change` → 调用 `/opsx:verify` 逻辑
   - `openspec-sync-specs` → 调用 `/opsx:sync` 逻辑
3. **保留 ai-tools-bridge 的三层模式**（前置→核心委托→后置），仅替换核心委托的调用目标

**优点**：
- 100% 覆盖，复用 OpenSpec 原生实现
- 保持 ai-tools-bridge 架构不变
- 改动集中（7 个 SKILL.md 的 invoke 引用行）

**缺点**：
- 依赖 OPSX 扩展命令已启用

## 关键决策

### 决策 1: 选择方案 D（混合方案）

选择方案 D 而非 A/B/C/E：启用 OPSX 扩展命令 + 修改 ai-tools-bridge 引用指向 OPSX 命令。

理由：
- 覆盖率 100%（6/6 缺失 skill 均有 OPSX 命令对应）
- 改动量中等（7 个文件改引用行，不重写核心逻辑）
- 维护成本低（复用 OpenSpec 原生 OPSX 实现）
- 架构无影响（保持 ai-tools-bridge 三层模式）

### 决策 2: 启用 OPSX 扩展命令作为前置条件

OPSX 扩展命令（`/opsx:new`、`/opsx:continue`、`/opsx:ff`、`/opsx:verify`、`/opsx:sync`、`/opsx:bulk-archive`、`/opsx:onboard`）需要通过 `openspec config profile` 启用 workflows profile 后才能生成。这是整个方案的前置条件。

### 决策 3: invoke 引用映射关系

| 原引用 | 目标 OPSX 命令 | 说明 |
|--------|-------------|------|
| `openspec-propose` | `/opsx:propose` | 一步生成所有规划 artifact |
| `openspec-archive-change` | `/opsx:archive` | 归档变更 |
| `openspec-continue-change` | `/opsx:continue` + `/opsx:apply` | 逐步生成 artifact + 实施 |
| `openspec-ff-change` | `/opsx:ff` | 快进生成所有规划 artifact |
| `openspec-verify-change` | `/opsx:verify` | 验证实现一致性 |
| `openspec-sync-specs` | `/opsx:sync` | 合并 delta specs |

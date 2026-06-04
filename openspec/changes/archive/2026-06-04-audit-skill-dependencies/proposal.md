# Proposal: ai-tools-bridge Skill 依赖修复

## 变更意图

修复 ai-tools-bridge 的 6 个缺失 OpenSpec skill 依赖，通过启用 OPSX 扩展命令并修改 invoke 引用，实现 100% 依赖覆盖。

## 范围

### 包含

- 启用 OpenSpec OPSX 扩展命令（`openspec config profile` + `openspec update`）
- 修改 ai-tools-bridge 中 7 个 SKILL.md 的 invoke 引用，指向对应 OPSX 命令
- 验证所有 14 个 Skill 的外部依赖完整性

### 不包含

- 创建新的 SKILL.md 文件（方案 B，已否决）
- 修改 OpenSpec CLI 源码
- 修改 Superpowers 依赖（8 个均已可用）

## 影响分析

### 涉及文件

| 文件 | 修改类型 | 说明 |
|------|---------|------|
| `ai-tools-bridge/skills/sdd-propose/SKILL.md` | 修改 invoke 引用 | `openspec-propose` → `/opsx:propose`，`openspec-continue-change` → `/opsx:continue` |
| `ai-tools-bridge/skills/sdd-continue/SKILL.md` | 修改 invoke 引用 | `openspec-continue-change` → `/opsx:continue` |
| `ai-tools-bridge/skills/sdd-ff/SKILL.md` | 修改 invoke 引用 | `openspec-ff-change` → `/opsx:ff` |
| `ai-tools-bridge/skills/sdd-verify/SKILL.md` | 修改 invoke 引用 | `openspec-verify-change` → `/opsx:verify` |
| `ai-tools-bridge/skills/sdd-ship/SKILL.md` | 修改 invoke 引用 | `openspec-sync-specs` → `/opsx:sync`，`openspec-archive-change` → `/opsx:archive` |
| `ai-tools-bridge/skills/sdd-quick/SKILL.md` | 修改 invoke 引用 | `openspec-continue-change` → `/opsx:continue` |
| `.claude/commands/opsx/` | 新增文件 | `openspec update` 生成 7 个扩展命令 |

### 跨模块影响

- **ai-tools/OpenSpec**: 需构建 CLI 并启用扩展 profile（前置条件）
- **ai-tools/superpowers**: 无影响（8 个引用均已可用）
- **ai-tools/skills/**: 无影响

## 决策追溯

选择方案 D（混合方案）而非 A/B/C/E：启用 OPSX 扩展命令 + 修改 ai-tools-bridge 引用指向 OPSX 命令。覆盖率 100%，改动量中等，维护成本低，架构无影响。（见 brainstorm.md §关键决策）

## 实施步骤概要

1. 构建 OpenSpec CLI（`pnpm install && pnpm run build`）
2. 启用 OPSX 扩展 profile（`openspec config profile`）
3. 生成扩展命令文件（`openspec update`）
4. 修改 ai-tools-bridge 7 个 SKILL.md 的 invoke 引用
5. 验证 14 个 Skill 的依赖完整性

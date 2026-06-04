# Spec: ai-tools-bridge Skill 引用更新

## ADDED Requirements

### invoke 引用替换

GIVEN OPSX 扩展命令已可用（7 个新命令文件存在于 `.claude/commands/opsx/`）
WHEN 修改 ai-tools-bridge 的 7 个 SKILL.md 文件
THEN 所有 `invoke openspec-xxx` 引用替换为对应 OPSX 命令：

| 原引用 | 替换为 |
|--------|--------|
| `openspec-propose` | `/opsx:propose` |
| `openspec-archive-change` | `/opsx:archive` |
| `openspec-continue-change` | `/opsx:continue` |
| `openspec-ff-change` | `/opsx:ff` |
| `openspec-verify-change` | `/opsx:verify` |
| `openspec-sync-specs` | `/opsx:sync` |

### 三层模式保持

GIVEN invoke 引用已替换为 OPSX 命令
WHEN 检查每个修改后的 SKILL.md
THEN 前置逻辑（SDD 自有）和后置逻辑（SDD 自有）内容不变，仅核心执行层的委托目标改变

### Override 指令保留

GIVEN invoke 引用已替换
WHEN 检查每个修改后的 SKILL.md 的 Override 指令
THEN 原有的 Override 指令（完成后停止、输出位置等）完整保留，传递给新的 OPSX 命令

### sdd-propose 双引用处理

GIVEN sdd-propose 当前引用了 `openspec-continue-change` 和 `openspec-propose` 两个 skill
WHEN 更新引用时
THEN 根据条件选择对应 OPSX 命令：
  - change 目录已有其他 artifact → `/opsx:continue`
  - 全新变更 → `/opsx:propose`

### sdd-ship 双引用处理

GIVEN sdd-ship 当前引用了 `openspec-sync-specs` 和 `openspec-archive-change` 两个 skill
WHEN 更新引用时
THEN Step 1 (Sync Specs) 引用 `/opsx:sync`，Step 2 (Archive) 引用 `/opsx:archive`

## MODIFIED Requirements

### sdd-quick 的 openspec-continue-change 引用

GIVEN sdd-quick 的 Step 4b 引用 `openspec-continue-change` 生成 proposal/specs/tasks
WHEN 更新引用时
THEN 替换为 `/opsx:continue`，保留原有的 Override 指令和 limits 配置约束

### 完整依赖验证

GIVEN 所有 7 个 SKILL.md 的 invoke 引用已替换完成
WHEN 对 `ai-tools-bridge/skills/` 执行 `grep -r "invoke.*openspec-" .`
THEN 结果为空（无残留的 openspec- 引用）
AND 所有 14 个 Skill 的外部依赖均指向已存在的目标：
  - Superpowers 引用 → `ai-tools/superpowers/skills/*/SKILL.md`（8 个，均已存在）
  - OpenSpec 引用 → `.claude/commands/opsx/*.md`（6 个，均已生成）

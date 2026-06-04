# Design: ai-tools-bridge Skill 依赖修复

## 技术方案

### 架构概览

```
ai-tools-bridge SKILL.md (invoke 引用)
        │
        ▼
OPSX 命令 (.claude/commands/opsx/*.md)
        │
        ▼
OpenSpec CLI (openspec status / instructions / ...)
        │
        ▼
文件系统 (openspec/changes/<name>/)
```

### 前置步骤：启用 OPSX 扩展

在 `ai-tools/OpenSpec/` 目录下执行：
```bash
pnpm install && pnpm run build
openspec config profile    # 交互式选择 workflows
openspec update            # 生成扩展命令文件
```

执行后 `.claude/commands/opsx/` 目录新增 7 个文件。

### 引用替换策略

每个 SKILL.md 的修改范围限定在核心执行层的 `invoke` 引用行：

**修改前**（以 sdd-ff 为例）：
```markdown
**invoke `openspec-ff-change`**
```

**修改后**：
```markdown
**invoke `/opsx:ff`**
```

前置逻辑和后置逻辑完全不变。Override 指令保持原样传递。

### 特殊处理

**sdd-propose**：有两个 invoke 条件分支，分别替换：
- `openspec-continue-change` → `/opsx:continue`
- `openspec-propose` → `/opsx:propose`

**sdd-ship**：有两个 invoke 步骤，分别替换：
- Step 1 `openspec-sync-specs` → `/opsx:sync`
- Step 2 `openspec-archive-change` → `/opsx:archive`

## 决策追溯

选择直接替换 invoke 引用而非重写核心执行逻辑：保持 ai-tools-bridge 的三层委托模式不变，最小化改动范围。（见 brainstorm.md §方案 D）

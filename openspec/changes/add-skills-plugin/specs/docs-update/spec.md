# Spec: docs-update

> 功能规格 — 更新 CLAUDE.md 项目文档

## 能力描述

更新主仓库的 CLAUDE.md，在项目概述、架构说明等位置反映新增的 skills 子模块。

---

## 场景

### 项目概述表格新增 skills 行 `[MODIFIED]`

**GIVEN**
- CLAUDE.md 项目概述表格包含 3 个子项目行（OpenSpec, superpowers, ai-tools-bridge）

**WHEN**
- 在表格中新增 skills 行

**THEN**
- 表格包含 4 个子项目行
- skills 行内容为：`ai-tools/skills/` | Skills — AI 编码代理工程实践技能集 | Markdown skills | Git Submodule

---

### 架构关系图补充 skills `[MODIFIED]`

**GIVEN**
- CLAUDE.md 架构节有三项目关系图

**WHEN**
- 在架构图中补充 skills 的定位

**THEN**
- 架构说明明确 skills 为独立工具集，不参与 SDD 编排
- 说明 skills 与 superpowers 的关系：两者互补，功能重叠处各自独立运行

---

### 常用命令保持不变 `[MODIFIED]`

**GIVEN**
- CLAUDE.md 常用命令节已有 Submodule 管理命令

**WHEN**
- 查看 Submodule 管理命令

**THEN**
- `git submodule status` 和 `git submodule update --init --recursive` 命令无需修改（已覆盖所有子模块）
- `bash scripts/sync-upstream.sh --only skills` 命令可正常工作（依赖 sync-integration spec）

---

## 边界条件

- skills 子模块的版本号暂无正式 release tag，表格中可标注为 "latest" 或省略版本号

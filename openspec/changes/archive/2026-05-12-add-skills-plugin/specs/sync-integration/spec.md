# Spec: sync-integration

> 功能规格 — 将 skills 子模块接入同步脚本和版本锁定

## 能力描述

更新 `scripts/sync-upstream.sh` 的 SUBMODULES 数组和 `versions.lock` 文件，使 skills 子模块纳入统一的版本管理框架。

---

## 场景

### 同步脚本新增 skills 条目 `[MODIFIED]`

**GIVEN**
- `scripts/sync-upstream.sh` 的 SUBMODULES 数组包含 3 个条目（openspec, superpowers, ai-tools-bridge）
- skills 子模块已成功添加到 `ai-tools/skills/`

**WHEN**
- 在 SUBMODULES 数组中新增 `["skills"]="ai-tools/skills"` 条目

**THEN**
- `bash scripts/sync-upstream.sh --only skills` 能正确识别 skills 子项目
- 脚本进入 `ai-tools/skills/` 目录执行 `git fetch --tags`
- 如果有 release tag，checkout 到最新 tag 并更新 versions.lock
- 如果无 tag，报告"无可用 release tag"并跳过

---

### versions.lock 新增 skills 快照 `[MODIFIED]`

**GIVEN**
- `versions.lock` 包含 3 个子项目条目（openspec, superpowers, ai-tools-bridge）
- skills 子模块已初始化

**WHEN**
- 在 `versions.lock` 中新增 `skills=<hash> <tag>` 条目

**THEN**
- `versions.lock` 包含 4 个子项目条目
- skills 条目的 hash 与 `ai-tools/skills/` 的当前 HEAD 一致

---

### 同步脚本 --help 显示 skills `[MODIFIED]`

**GIVEN**
- SUBMODULES 数组已包含 skills 条目

**WHEN**
- 执行 `bash scripts/sync-upstream.sh --help`

**THEN**
- 可选子项目列表包含 `skills`

---

### 无效子项目名称报错 `[MODIFIED]`

**GIVEN**
- SUBMODULES 数组已更新

**WHEN**
- 执行 `bash scripts/sync-upstream.sh --only nonexistent`

**THEN**
- 脚本报错 "错误: 未知子项目 'nonexistent'"
- 列出可选子项目列表（包含 skills）

---

## 边界条件

- skills 仓库可能没有任何 tag（纯 Markdown 项目通常不打 tag）：脚本应正确处理空 tag 场景
- 如果 skills 仓库的 remote URL 不可达：脚本应报告"远程仓库不可达"并计入 failures 计数

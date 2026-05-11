# 代码审查 — 批次三：版本锁定与 README

**审查日期**: 2026-05-11
**审查范围**: `versions.lock`（新建）、`README.md`（新建）、`CLAUDE.md`（修改）
**背景**: 为 submodule monorepo 添加版本锁定和项目文档

---

## 1. `versions.lock`

### minor — 所有子项目均标记为 untagged

三个子项目当前 HEAD 均无 tag 指向，输出 "untagged"。这符合事实，但意味着 `scripts/sync-upstream.sh` 在首次运行时无法通过 `git describe --tags --exact-match` 获取当前版本标识。

这不是代码缺陷，而是初始状态的自然结果。建议在首次 submodule 配置稳定后，为各子项目打 tag 以便后续同步脚本正常工作。

### 无问题 — 格式

`name=hash tag` 格式简洁，与 upstream-sync spec 定义的 key=value 格式一致，便于 shell 脚本用 `grep` + `awk` 解析。

### 无问题 — 时间戳

使用 UTC ISO 8601 格式（`2026-05-11T10:04:29Z`），标准化且无歧义。

---

## 2. `README.md`

### minor — 子项目版本号与 versions.lock 不对应

表格中标注的版本（v1.3.0, v5.1.0, v0.2.0）来自 plan.md 中的已知版本信息，但 `versions.lock` 显示所有子项目为 "untagged"。如果这些版本号来自最近的 tag 而非当前 HEAD commit，表格可能产生误导。

建议：要么确认 HEAD 确实对应这些 tag，要么将表格中的版本列改为从 `versions.lock` 动态获取或移除固定版本号。

### minor — 缺少贡献指南和问题反馈链接

README 作为项目入口，缺少"如何贡献"和"问题反馈"的标准章节。当前项目为个人/小团队项目，优先级较低。

### 无问题 — 结构

章节组织清晰：简介 → 子项目表 → 快速开始 → 操作指南 → 同步脚本 → 许可证。覆盖了 spec 要求的所有章节。

### 无问题 — clone 指引

提供了 `--recursive` 克隆和事后初始化两种场景，实用性好。

### 无问题 — 同步脚本说明

用法和功能列表简洁准确，与 Batch 5 的 spec 场景对应。

---

## 3. `CLAUDE.md`（修改）

### 无问题 — 表格更新

新增"管理方式"列，三个子项目标注 "Git Submodule"，其余目录标注 "—"，区分清晰。

### 无问题 — Submodule 管理命令

新增的命令节包含状态查看、初始化更新、同步脚本三种操作，覆盖日常使用场景。

### 无问题 — 架构描述

三项目关系节新增首句说明 submodule 关系和版本锁定机制，简洁准确。

---

## 审查总结

| 严重性 | 数量 | 说明 |
|--------|------|------|
| critical | 0 | — |
| major | 0 | — |
| minor | 3 | versions.lock untagged 状态、README 版本号可能不准确、缺少贡献指南 |

**总体评价**: 批次三的三个文件/修改质量良好。`versions.lock` 格式规范，README 结构完整，CLAUDE.md 更新精准。所有 minor 问题均不影响功能正确性，建议在后续批次或项目维护中逐步完善。

**对后续批次的建议**:
1. 确认子项目 HEAD 是否确实对应 README 表格中的版本号（低优先级）
2. Batch 1 审查提到的 `pnpm-workspace.yaml` 问题仍未解决，建议在 Batch 4 或 5 中补齐

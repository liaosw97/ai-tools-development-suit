# Spec: gstack-integration — Git Submodule 集成

> 功能规格 — gstack 仓库作为 Git Submodule 集成到 ai-tools

## 能力描述

将 gstack 仓库以 Git Submodule 方式集成到 `ai-tools/gstack/` 目录，与现有的 OpenSpec、Superpowers 子模块保持一致的管理方式。

---

## 场景

### SC-01: 添加 gstack submodule `[ADDED]`

**GIVEN** 当前工作区为 ai-tools 根目录
**AND** `ai-tools/gstack/` 目录不存在

**WHEN** 执行 `git submodule add https://github.com/liaosw97/gstack.git ai-tools/gstack`

**THEN** `ai-tools/gstack/` 目录创建成功
**AND** `.gitmodules` 文件新增 gstack 条目
**AND** gstack 仓库内容可正常访问

---

### SC-02: 初始化 gstack submodule `[ADDED]`

**GIVEN** `.gitmodules` 已包含 gstack 条目
**AND** `ai-tools/gstack/` 目录为空或不存在

**WHEN** 执行 `git submodule update --init --recursive`

**THEN** gstack submodule 内容正确拉取
**AND** `ai-tools/gstack/` 目录包含完整仓库内容

---

### SC-03: 记录 gstack 版本 `[ADDED]`

**GIVEN** gstack submodule 已添加

**WHEN** 变更提交

**THEN** `versions.lock` 文件记录 gstack 的 commit hash
**AND** 版本信息包含仓库 URL 和锁定时间

---

## 边界条件

- 网络不可用时 submodule 初始化失败 → 输出错误提示，提供手动重试指引
- gstack 仓库 URL 变更 → 需更新 `.gitmodules` 和相关文档
- submodule 已存在时重复添加 → Git 输出警告，不创建重复条目

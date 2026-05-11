# Spec: 仓库初始化

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

将 AiTools 根目录初始化为 Git 主仓库，将三个子项目（OpenSpec、Superpowers、ai-tools-bridge）配置为 Git Submodule，创建包装层所需的基础文件。

---

## 场景

### 初始化主仓库 `[ADDED]`

**GIVEN**
- AiTools 根目录存在且包含三个子项目目录（`ai-tools/OpenSpec/`、`ai-tools/superpowers/`、`ai-tools-bridge/`）
- 三个子项目目录已有各自的 `.git/`（独立的 git 仓库）

**WHEN**
- 在 AiTools 根目录执行 `git init`
- 创建根级别的 `.gitignore`、`package.json`

**THEN**
- AiTools 根目录成为独立的 Git 仓库
- `.gitignore` 包含所有子项目的忽略规则（`node_modules/`、`dist/`、`.stackdump`、`log/`）
- `package.json` 定义包装层元信息，声明子项目为 workspaces

---

### 配置子项目为 Submodule `[ADDED]`

**GIVEN**
- 主仓库已初始化
- 三个子项目在本地存在且各自有独立 git 历史
- 三个子项目的 GitHub 远程地址已知：
  - `https://github.com/liaosw97/OpenSpec.git`
  - `https://github.com/liaosw97/superpowers.git`
  - `https://github.com/liaosw97/ai-tools-bridge.git`

**WHEN**
- 将三个子项目目录转为 Git Submodule：
  - 先备份子项目内容（如有本地未提交修改）
  - 移除原有子项目目录
  - 执行 `git submodule add <url> <path>` 添加每个子项目

**THEN**
- `.gitmodules` 文件包含三个子模块条目
- `git submodule status` 返回三个有效 commit hash
- 子项目目录内容与之前一致

---

### 创建版本锁定文件 `[ADDED]`

**GIVEN**
- 三个 Submodule 已配置完成

**WHEN**
- 执行版本锁定脚本或手动创建 `versions.lock`

**THEN**
- `versions.lock` 文件存在且包含每个子项目的：
  - 名称
  - 当前 commit hash
  - 对应的 tag 名称（如有）
  - 锁定时间

---

### 创建 README `[ADDED]`

**GIVEN**
- 主仓库已初始化，Submodule 已配置

**WHEN**
- 创建 `README.md`

**THEN**
- README 包含以下章节：
  - 项目简介
  - 三个子项目的概述和链接
  - 安装步骤（含 `git clone --recursive` 指引）
  - Submodule 基本操作指南（初始化、更新）
  - 同步脚本使用说明

---

### 清理临时文件 `[ADDED]`

**GIVEN**
- 主仓库已初始化

**WHEN**
- 执行清理操作

**THEN**
- 以下文件/目录从 Git 跟踪中移除：
  - `bash.exe.stackdump`（所有实例）
  - `log/` 目录（如有临时内容）
- `.gitignore` 覆盖这些文件防止再次提交

---

## 边界条件

- **子项目有未提交的本地修改**：转换为 Submodule 前必须先提交或暂存，否则修改会丢失。应在转换脚本中添加检查
- **子项目目录没有 `.git/`**：说明是复制来的而非 `git clone`，需要先 `git clone` 再添加为 Submodule
- **GitHub 远程仓库不存在或地址错误**：`git submodule add` 会失败，需要提前验证远程可达性
- **`package.json` workspaces 与子项目 `package.json` 冲突**：包装层的 `package.json` 不应覆盖子项目的配置，仅用于元信息和工作区声明

# Spec: submodule-setup

> 功能规格 — 在 ai-tools/ 目录中添加 skills Git Submodule

## 能力描述

将 liaosw97/skills 仓库作为 Git Submodule 添加到 `ai-tools/skills/` 目录，使其成为主仓库的第四个子模块。

---

## 场景

### 添加子模块 `[ADDED]`

**GIVEN**
- 主仓库位于 `D:\Code\AI\AiTools`
- `ai-tools/` 目录下已有 `OpenSpec/` 和 `superpowers/` 两个子模块
- `ai-tools/skills/` 目录不存在

**WHEN**
- 在主仓库根目录执行 `git submodule add https://github.com/liaosw97/skills.git ai-tools/skills`

**THEN**
- `ai-tools/skills/` 目录存在且包含 skills 仓库的文件
- `.gitmodules` 文件新增 `ai-tools/skills` 条目，指向 `https://github.com/liaosw97/skills.git`
- `git submodule status` 显示 `ai-tools/skills` 条目且无 `-` 前缀（已初始化）

---

### 子模块初始化验证 `[ADDED]`

**GIVEN**
- skills 子模块已添加到主仓库
- 一个新的开发者 clone 了主仓库

**WHEN**
- 执行 `git submodule update --init --recursive`

**THEN**
- `ai-tools/skills/` 目录被正确填充
- `git submodule status` 显示所有 4 个子模块均已初始化

---

### 子模块移除可逆性 `[ADDED]`

**GIVEN**
- skills 子模块已添加但有严重问题需要回退

**WHEN**
- 执行 `git submodule deinit -f ai-tools/skills` 和 `git rm -f ai-tools/skills`

**THEN**
- skills 子模块被完全移除
- `.gitmodules` 中 skills 条目被删除
- 主仓库恢复到添加前的状态

---

## 边界条件

- 网络不可达时 `git submodule add` 会失败：需要网络访问 GitHub
- 如果 `ai-tools/skills/` 路径已被占用（非空目录）：`git submodule add` 会拒绝操作
- 如果 skills 仓库无任何 tag：sync-upstream.sh 的 `get_latest_tag` 将返回空值，脚本会报告"无可用 release tag"并跳过

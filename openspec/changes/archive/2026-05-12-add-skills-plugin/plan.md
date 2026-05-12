# Plan: add-skills-plugin

> 实施计划 — TDD 级别的详细步骤

---

## 批次一：Submodule 添加

> 前置条件：主仓库工作区干净，网络可访问 GitHub

### Task 1.1: 添加 skills 子模块 [spec:submodule-setup#添加子模块]

- **文件**: `ai-tools/skills/` (Create)、`.gitmodules` (Modify)
- **RED**: 验证 skills 子模块尚未存在
  ```bash
  git submodule status | grep skills
  # 预期: 无输出（skills 不在子模块列表中）
  ls ai-tools/skills/ 2>&1
  # 预期: 目录不存在报错
  ```
- **运行验证失败**: `git submodule status | grep -q skills && echo "EXISTS" || echo "NOT_FOUND"`
- **GREEN**: 执行 submodule add
  ```bash
  git submodule add https://github.com/liaosw97/skills.git ai-tools/skills
  ```
- **运行验证通过**: `git submodule status | grep ai-tools/skills`

### Task 1.2+1.3: 验证子模块状态与内容（幂等验证） [spec:submodule-setup#子模块初始化验证]

- **文件**: 无修改（幂等验证）
- **验证**: 确认子模块已初始化且内容完整
  ```bash
  # 1. 状态验证：无 '-' 前缀表示已初始化
  git submodule status | grep ai-tools/skills | grep -v '^-'
  # 2. 内容验证：目录非空且包含 README.md
  test -f ai-tools/skills/README.md && echo "CONTENT_OK" || echo "CONTENT_MISSING"
  # 3. .git 验证：子模块 Git 元数据存在
  test -d ai-tools/skills/.git && echo "INITIALIZED" || echo "NOT_INITIALIZED"
  ```
- **运行验证通过**: 三项检查均输出预期结果

---

## 批次二：同步脚本集成

> 依赖: 批次一完成

### Task 2.1: 更新 sync-upstream.sh SUBMODULES 数组 [spec:sync-integration#同步脚本新增 skills 条目]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证当前数组不含 skills
  ```bash
  grep -c '"skills"' scripts/sync-upstream.sh
  # 预期: 0
  ```
- **运行验证失败**: `grep '"skills"' scripts/sync-upstream.sh; echo $?`（预期返回 1）
- **GREEN**: 在 SUBMODULES 数组末尾新增一行
  ```bash
  # 在 ["ai-tools-bridge"]="ai-tools-bridge" 行后新增:
  # ["skills"]="ai-tools/skills"
  ```
  使用 Edit 工具修改文件。
- **运行验证通过**: `grep '"skills"' scripts/sync-upstream.sh`

### Task 2.2: 更新 versions.lock [spec:sync-integration#versions.lock 新增 skills 快照]

- **文件**: `versions.lock` (Modify)
- **RED**: 验证当前不含 skills 条目
  ```bash
  grep '^skills=' versions.lock
  # 预期: 无输出
  ```
- **运行验证失败**: `grep '^skills=' versions.lock; echo $?`（预期返回 1）
- **GREEN**: 获取 skills 子模块 hash 并新增条目
  ```bash
  # 获取当前 hash
  cd ai-tools/skills && git rev-parse --short HEAD
  # 在 versions.lock 末尾新增:
  # skills=<hash> untagged
  ```
- **运行验证通过**: `grep '^skills=' versions.lock`

### Task 2.3: 验证 --only skills 同步 [spec:sync-integration#同步脚本新增 skills 条目]

- **文件**: 无修改（纯验证）
- **RED**: 确认脚本接受 skills 参数
  ```bash
  bash scripts/sync-upstream.sh --only skills
  # 预期: 正常执行（可能报告"无可用 release tag"并跳过，因为纯 Markdown 仓库通常无 tag）
  ```
- **GREEN**: 确认输出包含 skills 处理信息
  ```bash
  bash scripts/sync-upstream.sh --only skills 2>&1 | grep '\[skills\]'
  ```
- **运行验证通过**: 脚本退出码为 0 或 1（非 2，2 表示全部失败）

### Task 2.4: 验证 --help 显示 skills [spec:sync-integration#同步脚本 --help 显示 skills]

- **文件**: 无修改（纯验证）
- **RED**: 运行 --help 检查可选列表
  ```bash
  bash scripts/sync-upstream.sh --help
  ```
- **GREEN**: 确认输出包含 skills
  ```bash
  bash scripts/sync-upstream.sh --help | grep -o 'skills'
  ```
- **运行验证通过**: `bash scripts/sync-upstream.sh --help | grep -q skills`

### Task 2.5: 验证无效子项目报错 [spec:sync-integration#无效子项目名称报错]

- **文件**: 无修改（纯验证）
- **RED**: 执行无效名称
  ```bash
  bash scripts/sync-upstream.sh --only nonexistent 2>&1
  # 预期: 输出 "错误: 未知子项目 'nonexistent'"
  ```
- **GREEN**: 确认错误信息包含可选列表（含 skills）
  ```bash
  bash scripts/sync-upstream.sh --only nonexistent 2>&1 | grep skills
  ```
- **运行验证通过**: `bash scripts/sync-upstream.sh --only nonexistent 2>&1 | grep -q 'skills'`

---

## 批次三：文档更新

> 依赖: 批次一完成（与批次二并行）

### Task 3.1: CLAUDE.md 项目概述表格新增 skills 行 [spec:docs-update#项目概述表格新增 skills 行]

- **文件**: `CLAUDE.md` (Modify)
- **RED**: 验证当前表格不含 skills
  ```bash
  grep 'ai-tools/skills' CLAUDE.md
  # 预期: 无输出
  ```
- **运行验证失败**: `grep -c 'ai-tools/skills' CLAUDE.md`（预期 0）
- **GREEN**: 在项目概述表格 `ai-tools-bridge` 行之后新增一行
  ```
  | `ai-tools/skills/` | Skills — AI 编码代理工程实践技能集 | Markdown skills | Git Submodule |
  ```
  使用 Edit 工具修改。
- **运行验证通过**: `grep 'ai-tools/skills' CLAUDE.md`

### Task 3.2: CLAUDE.md 架构节补充 skills 定位 [spec:docs-update#架构关系图补充 skills]

- **文件**: `CLAUDE.md` (Modify)
- **RED**: 验证架构节不含 skills
  ```bash
  grep -A5 '三项目关系' CLAUDE.md | grep skills
  # 预期: 无输出
  ```
- **GREEN**: 在三项目关系图后补充 skills 说明
  ```
  在三项目关系代码块后追加:
  `ai-tools/skills/` — mattpocock/skills fork，独立工具集，不参与 SDD 编排，与 Superpowers 互补
  ```
  同时将"三项目关系"标题更新为"子项目关系"。
- **运行验证通过**: `grep 'skills' CLAUDE.md | grep -c '独立'`（预期 ≥ 1）

### Task 3.3: 确认 Submodule 管理命令无需修改 [spec:docs-update#常用命令保持不变]

- **文件**: 无修改（纯验证）
- **RED**: 读取 CLAUDE.md Submodule 管理命令节
  ```bash
  grep -A3 'Submodule 管理' CLAUDE.md
  ```
- **GREEN**: 确认现有命令已覆盖所有子模块
  - `git submodule status` — 无需修改，自动包含新增子模块
  - `git submodule update --init --recursive` — 无需修改
  - `bash scripts/sync-upstream.sh --only skills` — 新命令已在 sync-integration 中验证
- **运行验证通过**: 确认命令节无需要修改的内容

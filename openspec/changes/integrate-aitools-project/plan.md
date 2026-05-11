# Plan: integrate-aitools-project

> 实施计划 — TDD 级别的详细步骤

---

## 批次一: 仓库初始化

### Task 1.1: 在 AiTools 根目录执行 git init [spec:repo-init#初始化主仓库]

- **文件**: `.git/` (Create)
- **RED**: 验证当前目录不是 git 仓库
  ```确认根目录无 .git/，git status 应报错```
- **运行验证失败**: `cd D:/Code/AiTools && git rev-parse --git-dir 2>&1; echo "exit: $?"`
- **GREEN**: 执行 git init
  ```在根目录执行 git init，创建初始 git 仓库```
- **运行验证通过**: `cd D:/Code/AiTools && git rev-parse --git-dir`

### Task 1.2: 创建 .gitignore [spec:repo-init#初始化主仓库]

- **文件**: `.gitignore` (Create)
- **RED**: 确认 .gitignore 不存在
  ```ls .gitignore 应返回文件不存在```
- **运行验证失败**: `cd D:/Code/AiTools && test -f .gitignore && echo "exists" || echo "missing"`
- **GREEN**: 创建 .gitignore，包含以下规则：
  ```
  # 子项目构建产物
  node_modules/
  dist/
  *.tsbuildinfo

  # 临时文件
  *.stackdump
  log/

  # 系统文件
  .DS_Store
  Thumbs.db

  # IDE
  .vscode/
  .idea/

  # 版本锁备份
  versions.lock.bak
  ```
- **运行验证通过**: `cd D:/Code/AiTools && test -f .gitignore && grep -c "node_modules" .gitignore`

### Task 1.3: 创建根 package.json [spec:repo-init#初始化主仓库]

- **文件**: `package.json` (Create)
- **RED**: 确认根 package.json 不存在
  ```根目录当前无 package.json```
- **运行验证失败**: `cd D:/Code/AiTools && test -f package.json && echo "exists" || echo "missing"`
- **GREEN**: 创建 package.json：
  ```json
  {
    "name": "aitools",
    "version": "0.1.0",
    "private": true,
    "description": "AI 工具集成项目 — 整合 OpenSpec、Superpowers、ai-tools-bridge",
    "license": "MIT",
    "workspaces": [
      "ai-tools/OpenSpec",
      "ai-tools/superpowers",
      "ai-tools-bridge"
    ]
  }
  ```
- **运行验证通过**: `cd D:/Code/AiTools && node -e "const p=require('./package.json'); console.log(p.name, p.workspaces.length)"`

---

## 批次二: Submodule 转换

### Task 2.1: 检查子项目未提交修改 [spec:repo-init#配置子项目为 Submodule]

- **文件**: N/A (验证)
- **RED**: 检查三个子项目是否有未提交修改
  ```遍历三个子项目目录，执行 git status --porcelain，收集未提交文件```
- **运行验证失败**: `cd D:/Code/AiTools/ai-tools/OpenSpec && git status --porcelain; cd D:/Code/AiTools/ai-tools/superpowers && git status --porcelain; cd D:/Code/AiTools/ai-tools-bridge && git status --porcelain`
- **GREEN**: 如有未提交修改，逐一进入子项目目录执行 `git add -A && git commit -m "chore: save local changes before submodule conversion"`
  ```确保所有子项目工作区干净```
- **运行验证通过**: 重复 RED 命令，三个子项目均输出为空

### Task 2.2: 备份子项目目录 [spec:repo-init#配置子项目为 Submodule]

- **文件**: N/A (操作)
- **RED**: 确认备份目录不存在
  ```检查临时目录下无 aitools-backup```
- **运行验证失败**: `test -d "$TEMP/aitools-backup" && echo "exists" || echo "missing"`
- **GREEN**: 备份三个子项目到系统临时目录
  ```bash
  BACKUP_DIR="$TEMP/aitools-backup"
  mkdir -p "$BACKUP_DIR"
  cp -r D:/Code/AiTools/ai-tools/OpenSpec "$BACKUP_DIR/OpenSpec"
  cp -r D:/Code/AiTools/ai-tools/superpowers "$BACKUP_DIR/superpowers"
  cp -r D:/Code/AiTools/ai-tools-bridge "$BACKUP_DIR/ai-tools-bridge"
  ```
- **运行验证通过**: `test -d "$TEMP/aitools-backup/OpenSpec/.git" && test -d "$TEMP/aitools-backup/superpowers/.git" && test -d "$TEMP/aitools-backup/ai-tools-bridge/.git" && echo "backup ok"`

### Task 2.3: 移除原有子项目目录 [spec:repo-init#配置子项目为 Submodule]

- **文件**: `ai-tools/OpenSpec/`, `ai-tools/superpowers/`, `ai-tools-bridge/` (Delete)
- **RED**: 确认三个目录存在
  ```ls 确认目录存在```
- **运行验证失败**: `cd D:/Code/AiTools && ls -d ai-tools/OpenSpec ai-tools/superpowers ai-tools-bridge`
- **GREEN**: 移除三个目录（不含 .git 跟踪中的文件，因为主仓库尚未 commit）
  ```bash
  rm -rf ai-tools/OpenSpec
  rm -rf ai-tools/superpowers
  rm -rf ai-tools-bridge
  ```
- **运行验证通过**: `cd D:/Code/AiTools && ls -d ai-tools/OpenSpec 2>&1; ls -d ai-tools/superpowers 2>&1; ls -d ai-tools-bridge 2>&1`（三个均应报不存在）

### Task 2.4: 添加 Git Submodule [spec:repo-init#配置子项目为 Submodule]

- **文件**: `.gitmodules`, `ai-tools/OpenSpec/`, `ai-tools/superpowers/`, `ai-tools-bridge/` (Create)
- **RED**: 确认 .gitmodules 不存在且子项目目录不存在
  ```验证前置条件```
- **运行验证失败**: `cd D:/Code/AiTools && test -f .gitmodules && echo "exists" || echo "missing"`
- **GREEN**: 逐个添加 submodule
  ```bash
  cd D:/Code/AiTools
  git submodule add https://github.com/liaosw97/OpenSpec.git ai-tools/OpenSpec
  git submodule add https://github.com/liaosw97/superpowers.git ai-tools/superpowers
  git submodule add https://github.com/liaosw97/ai-tools-bridge.git ai-tools-bridge
  ```
- **运行验证通过**: `cd D:/Code/AiTools && git submodule status | wc -l`（应输出 3）

### Task 2.5: 验证 Submodule 配置并确认内容一致 [spec:repo-init#配置子项目为 Submodule]

- **文件**: N/A (验证)
- **RED**: 逐项检查 Submodule 配置，记录预期不满足的项
  ```
  1. test -f .gitmodules → 预期：缺少三个子模块条目
  2. git submodule status | wc -l → 预期 ≠ 3
  3. test -d ai-tools/OpenSpec/.git → 预期：不存在
  ```
- **运行验证失败**: `cd D:/Code/AiTools && echo "submodules: $(git submodule status 2>/dev/null | wc -l)" && echo "gitmodules: $(test -f .gitmodules && grep -c 'submodule' .gitmodules || echo 0)" && echo "openspec-git: $(test -d ai-tools/OpenSpec/.git && echo yes || echo no)" && echo "superpowers-git: $(test -d ai-tools/superpowers/.git && echo yes || echo no)" && echo "bridge-git: $(test -d ai-tools-bridge/.git && echo yes || echo no)"`
- **GREEN**: 逐一验证三项通过，如有问题则根据错误信息修复（重新添加 submodule 或修正 .gitmodules）
  ```确认：.gitmodules 含 3 个条目、git submodule status 输出 3 行、三个子项目目录均含 .git/```
- **运行验证通过**: `cd D:/Code/AiTools && test "$(git submodule status | wc -l)" = "3" && test "$(grep -c 'submodule' .gitmodules)" = "3" && echo "all submodules verified"`

---

## 批次三: 版本锁定与 README

### Task 3.1: 创建 versions.lock [spec:repo-init#创建版本锁定文件]

- **文件**: `versions.lock` (Create)
- **RED**: 确认 versions.lock 不存在
  ```文件尚未创建```
- **运行验证失败**: `cd D:/Code/AiTools && test -f versions.lock && echo "exists" || echo "missing"`
- **GREEN**: 生成 versions.lock
  ```bash
  cd D:/Code/AiTools
  echo "# versions.lock — AiTools 子项目版本快照" > versions.lock
  echo "# Updated: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> versions.lock
  echo "" >> versions.lock

  # 获取每个子项目的 commit hash 和 tag
  cd ai-tools/OpenSpec && HASH=$(git rev-parse --short HEAD) && TAG=$(git describe --tags --exact-match 2>/dev/null || echo "untagged") && echo "openspec=$HASH $TAG" >> ../../versions.lock && cd ../..
  cd ai-tools/superpowers && HASH=$(git rev-parse --short HEAD) && TAG=$(git describe --tags --exact-match 2>/dev/null || echo "untagged") && echo "superpowers=$HASH $TAG" >> ../../versions.lock && cd ../..
  cd ai-tools-bridge && HASH=$(git rev-parse --short HEAD) && TAG=$(git describe --tags --exact-match 2>/dev/null || echo "untagged") && echo "ai-tools-bridge=$HASH $TAG" >> ../versions.lock && cd ..
  ```
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "=" versions.lock`（应输出 3）

### Task 3.2: 创建 README.md [spec:repo-init#创建 README]

- **文件**: `README.md` (Create)
- **RED**: 确认 README.md 不存在或内容不符合要求
  ```检查 README 是否包含必要章节```
- **运行验证失败**: `cd D:/Code/AiTools && test -f README.md && echo "exists" || echo "missing"`
- **GREEN**: 创建 README.md，包含：
  - 项目简介（AiTools 是什么）
  - 子项目概述表格（名称、描述、版本、链接）
  - 快速开始（`git clone --recursive` + `git submodule update --init --recursive`）
  - Submodule 操作指南（常见命令）
  - 同步脚本使用说明
  - 许可证
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "clone --recursive\|submodule" README.md`

### Task 3.3: 更新 CLAUDE.md [spec:repo-init#初始化主仓库]

- **文件**: `CLAUDE.md` (Modify)
- **RED**: 检查当前 CLAUDE.md 中的项目结构描述
  ```当前描述为"三个相关项目"，需更新为 submodule 模式```
- **运行验证失败**: `cd D:/Code/AiTools && grep -c "submodule\|Submodule" CLAUDE.md`（应为 0）
- **GREEN**: 更新 CLAUDE.md：
  - 项目概述表格增加"管理方式"列，标注 Git Submodule
  - 常用命令增加同步脚本命令
  - 架构节说明 submodule 关系
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "submodule\|Submodule" CLAUDE.md`

---

## 批次四: 清理

### Task 4.1: 删除 stackdump 文件 [spec:repo-init#清理临时文件]

- **文件**: `*.stackdump` (Delete)
- **RED**: 查找根目录下所有 stackdump 文件
  ```find . -name "*.stackdump" -type f```
- **运行验证失败**: `cd D:/Code/AiTools && find . -name "*.stackdump" -type f | head -5`
- **GREEN**: 删除所有 stackdump 文件
  ```bash
  find D:/Code/AiTools -name "*.stackdump" -type f -delete
  ```
- **运行验证通过**: `cd D:/Code/AiTools && find . -name "*.stackdump" -type f | wc -l`（应输出 0）

### Task 4.2: 清理 log 目录 [spec:repo-init#清理临时文件]

- **文件**: `log/` (Modify)
- **RED**: 检查 log/ 目录内容
  ```ls log/ 查看是否有临时内容```
- **运行验证失败**: `cd D:/Code/AiTools && ls log/ 2>/dev/null`
- **GREEN**: 清理 log/ 中的临时文件，保留 .gitkeep
  ```bash
  cd D:/Code/AiTools
  rm -rf log/*
  touch log/.gitkeep
  ```
- **运行验证通过**: `cd D:/Code/AiTools && ls -la log/`

### Task 4.3: 提交初始版本并验证 clone [spec:repo-init#初始化主仓库]

- **文件**: N/A (操作)
- **RED**: 验证主仓库有未提交的变更
  ```git status 应显示大量未跟踪/新文件```
- **运行验证失败**: `cd D:/Code/AiTools && git status --short | head -10`
- **GREEN**: 提交所有初始文件（注意：scripts/ 在 Batch 5 创建，此处不包含）
  ```bash
  cd D:/Code/AiTools
  git add .gitignore .gitmodules package.json versions.lock README.md CLAUDE.md openspec/ .claude/ log/.gitkeep
  git commit -m "chore: initialize AiTools monorepo with git submodules"
  ```
- **运行验证通过**: `cd D:/Code/AiTools && git log --oneline -1 && git submodule status`

---

## 批次五: 同步脚本

### Task 5.1a: 创建 sync-upstream.sh 脚本骨架 [spec:upstream-sync#同步所有子项目到最新 release tag]

- **文件**: `scripts/sync-upstream.sh` (Create)
- **RED**: 确认脚本不存在且 scripts/ 目录不存在
  ```验证前置条件```
- **运行验证失败**: `cd D:/Code/AiTools && test -f scripts/sync-upstream.sh && echo "exists" || echo "missing"`
- **GREEN**: 创建脚本骨架，定义子项目列表、变量初始化、主循环结构：
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail

  # 子项目列表：名称=路径
  declare -A SUBMODULES=(
    ["openspec"]="ai-tools/OpenSpec"
    ["superpowers"]="ai-tools/superpowers"
    ["ai-tools-bridge"]="ai-tools-bridge"
  )

  success=0
  skipped=0
  failures=0

  # 主循环占位
  for name in "${!SUBMODULES[@]}"; do
    echo "[$name] processing..."
  done
  ```
- **运行验证通过**: `cd D:/Code/AiTools && bash -n scripts/sync-upstream.sh && bash scripts/sync-upstream.sh 2>&1 | grep -c "processing"`

### Task 5.1b: 实现 fetch + tag 识别逻辑 [spec:upstream-sync#同步所有子项目到最新 release tag]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证脚本当前不会执行 fetch
  ```grep 确认无 git fetch 调用```
- **运行验证失败**: `cd D:/Code/AiTools && grep -c "git fetch" scripts/sync-upstream.sh`（应输出 0）
- **GREEN**: 在主循环内实现：
  ```bash
  # 获取最新 release tag 函数
  get_latest_tag() {
    git tag -l | grep -v -E '(alpha|beta|rc|pre)' | sort -V | tail -1
  }

  # 在循环内：
  path="${SUBMODULES[$name]}"
  cd "$path"
  git fetch --tags

  latest_tag=$(get_latest_tag)
  current_tag=$(git describe --tags --exact-match 2>/dev/null || echo "")

  if [ "$latest_tag" = "$current_tag" ]; then
    echo "[$name] ($current_tag) 已是最新 ⏭️"
    skipped=$((skipped + 1))
    continue
  fi
  ```
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "git fetch\|get_latest_tag" scripts/sync-upstream.sh`

### Task 5.1c: 实现 checkout + versions.lock 更新逻辑 [spec:upstream-sync#同步所有子项目到最新 release tag]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证脚本当前不会执行 checkout
  ```grep 确认无 git checkout 调用```
- **运行验证失败**: `cd D:/Code/AiTools && grep -c "git checkout" scripts/sync-upstream.sh`（应输出 0）
- **GREEN**: 在 tag 识别后添加：
  ```bash
  git checkout "$latest_tag"

  # 运行测试（如有）
  if [ -f "package.json" ] && grep -q '"test"' package.json; then
    if ! pnpm test; then
      # 回滚逻辑在 Task 5.4 中实现
      echo "[$name] ❌ 测试失败"
      failures=$((failures + 1))
      continue
    fi
  fi

  # 更新 versions.lock
  hash=$(git rev-parse --short HEAD)
  sed -i "s/^$name=.*/$name=$hash $latest_tag/" "$ROOT_DIR/versions.lock"
  echo "[$name] $current_tag → $latest_tag ✅"
  success=$((success + 1))
  ```
- **运行验证通过**: `cd D:/Code/AiTools && bash -n scripts/sync-upstream.sh && echo "syntax ok"`

### Task 5.2: 实现 --only 参数 [spec:upstream-sync#同步指定子项目]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 测试 --only 参数解析
  ```bash scripts/sync-upstream.sh --only nonexistent 2>&1```（应报错或提示无效）
- **运行验证失败**: `cd D:/Code/AiTools && bash scripts/sync-upstream.sh --only nonexistent 2>&1; echo "exit: $?"`
- **GREEN**: 添加参数解析逻辑：
  ```bash
  # 解析 --only <name> 参数
  # 验证 name 在子项目列表中
  # 如提供 --only，则仅处理指定的子项目
  ```
- **运行验证通过**: `cd D:/Code/AiTools && bash scripts/sync-upstream.sh --help 2>&1 | grep -c "only"`

### Task 5.3: 实现同步前备份 [spec:upstream-sync#同步前自动备份当前版本]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证脚本未生成 backup 文件
  ```执行前 versions.lock.bak 不存在```
- **运行验证失败**: `cd D:/Code/AiTools && test -f versions.lock.bak && echo "exists" || echo "missing"`
- **GREEN**: 在主流程开始处添加：
  ```bash
  cp versions.lock versions.lock.bak
  ```
- **运行验证通过**: 运行脚本后 `test -f versions.lock.bak && echo "backup exists"`

### Task 5.4: 实现测试失败回滚 [spec:upstream-sync#同步后测试失败自动回滚]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 模拟测试失败场景
  ```需要验证回滚逻辑是否存在```
- **运行验证失败**: `cd D:/Code/AiTools && grep -c "rollback\|lock.bak\|revert" scripts/sync-upstream.sh`（应为 0 或低值）
- **GREEN**: 在测试步骤后添加回滚逻辑：
  ```bash
  # 运行测试
  if ! run_tests "$submodule_path"; then
    # 从 versions.lock.bak 读取旧 hash
    old_hash=$(grep "^$name=" versions.lock.bak | awk '{print $1}' | cut -d= -f2)
    # 回滚
    cd "$submodule_path" && git checkout "$old_hash"
    echo "[$name] ❌ 测试失败，已回滚"
    failures=$((failures + 1))
  fi
  ```
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "rollback\|lock.bak\|checkout.*old_hash" scripts/sync-upstream.sh`

### Task 5.5: 实现无 tag 场景处理 [spec:upstream-sync#子项目无可用 release tag]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证无 tag 处理逻辑不存在
  ```grep 检查脚本中是否有 "no.*tag" 或 "skip" 逻辑```
- **运行验证失败**: `cd D:/Code/AiTools && grep -ci "no.*tag\|no available" scripts/sync-upstream.sh`（应为 0）
- **GREEN**: 在 tag 查找后添加：
  ```bash
  if [ -z "$latest_tag" ]; then
    echo "[$name] ⚠️ 无可用 release tag，跳过"
    skipped=$((skipped + 1))
    continue
  fi
  ```
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "无可用\|no.*tag\|skip" scripts/sync-upstream.sh`

### Task 5.6: 实现远程不可达处理 [spec:upstream-sync#远程仓库不可达]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证 fetch 失败处理不存在
  ```grep 检查脚本中是否有 fetch 错误处理```
- **运行验证失败**: `cd D:/Code/AiTools && grep -c "fetch.*fail\|fetch.*error\|fetch.*2>/dev" scripts/sync-upstream.sh`（应为 0）
- **GREEN**: 在 fetch 步骤添加错误处理：
  ```bash
  if ! git fetch --tags 2>/dev/null; then
    echo "[$name] ❌ 远程仓库不可达，跳过"
    failures=$((failures + 1))
    continue
  fi
  ```
- **运行验证通过**: `cd D:/Code/AiTools && grep -c "不可达\|unreachable\|fetch.*fail" scripts/sync-upstream.sh`

### Task 5.7: 实现输出格式和退出码 [spec:upstream-sync#同步所有子项目到最新 release tag]

- **文件**: `scripts/sync-upstream.sh` (Modify)
- **RED**: 验证脚本无汇总输出和退出码逻辑
  ```grep 检查 exit code 和汇总报告```
- **运行验证失败**: `cd D:/Code/AiTools && grep -c "汇总\|exit\|success\|failure" scripts/sync-upstream.sh`（应为 0 或低值）
- **GREEN**: 添加汇总和退出码：
  ```bash
  echo "---"
  echo "汇总: $success 成功, $skipped 跳过, $failures 失败"
  if [ $failures -eq ${#SUBMODULES[@]} ]; then
    exit 2  # 全部失败
  elif [ $failures -gt 0 ]; then
    exit 1  # 部分失败
  fi
  exit 0  # 全部成功
  ```
- **运行验证通过**: `cd D:/Code/AiTools && bash scripts/sync-upstream.sh --help; echo "exit: $?"`

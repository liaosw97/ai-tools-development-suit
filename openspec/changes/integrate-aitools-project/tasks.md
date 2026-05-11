# Tasks: integrate-aitools-project

> 任务清单 — 将 spec 拆解为可执行的任务

---

## Batch 1: 仓库初始化

- [x] 1.1 在 AiTools 根目录执行 `git init`，创建初始 Git 仓库 [spec:repo-init#初始化主仓库]
- [x] 1.2 创建 `.gitignore`，包含子项目忽略规则（`node_modules/`、`dist/`、`*.stackdump`、`log/`）和系统/IDE 文件 [spec:repo-init#初始化主仓库]
- [x] 1.3 创建根 `package.json`，定义包装层元信息（项目名、版本、描述）和 workspaces 声明 [spec:repo-init#初始化主仓库]

## Batch 2: Submodule 转换

- [x] 2.1 检查三个子项目是否有未提交的本地修改，如有则先提交或暂存 [spec:repo-init#配置子项目为 Submodule]
- [x] 2.2 备份三个子项目目录内容到临时位置 [spec:repo-init#配置子项目为 Submodule]
- [x] 2.3 移除原有子项目目录（`ai-tools/OpenSpec/`、`ai-tools/superpowers/`、`ai-tools-bridge/`） [spec:repo-init#配置子项目为 Submodule]
- [x] 2.4 执行 `git submodule add` 添加三个子项目，使用 liaosw97 下的 GitHub 地址 [spec:repo-init#配置子项目为 Submodule]
- [x] 2.5 验证 `.gitmodules` 包含三个子模块条目，`git submodule status` 返回三个有效 commit hash [spec:repo-init#配置子项目为 Submodule]

## Batch 3: 版本锁定与 README

- [x] 3.1 创建 `versions.lock` 文件，记录每个子项目的名称、commit hash、tag 名称、锁定时间 [spec:repo-init#创建版本锁定文件]
- [x] 3.2 创建 `README.md`，包含项目简介、子项目概述、`git clone --recursive` 安装步骤、submodule 操作指南、同步脚本使用说明 [spec:repo-init#创建 README]
- [x] 3.3 更新 `CLAUDE.md`，反映 submodule 模式下的项目结构 [spec:repo-init#初始化主仓库]

## Batch 4: 清理

- [x] 4.1 删除根目录下所有 `bash.exe.stackdump` 文件 [spec:repo-init#清理临时文件]
- [x] 4.2 清理 `log/` 目录中的临时内容（保留目录结构或根据需要处理） [spec:repo-init#清理临时文件]
- [x] 4.3 提交主仓库初始版本，验证 `git clone --recursive` 可正常工作 [spec:repo-init#初始化主仓库]

## Batch 5: 同步脚本

- [x] 5.1 创建 `scripts/sync-upstream.sh`，实现主流程：遍历子项目 → fetch tags → 识别最新 release tag → checkout → 更新 versions.lock [spec:upstream-sync#同步所有子项目到最新 release tag]
- [x] 5.2 实现 `--only <name>` 参数，支持仅同步指定子项目 [spec:upstream-sync#同步指定子项目]
- [x] 5.3 实现同步前备份：将 `versions.lock` 复制为 `versions.lock.bak` [spec:upstream-sync#同步前自动备份当前版本]
- [x] 5.4 实现测试失败回滚：测试命令返回非零时从 `versions.lock.bak` 读取旧 hash 并 checkout 回去 [spec:upstream-sync#同步后测试失败自动回滚]
- [x] 5.5 实现无 tag 场景处理：输出警告并跳过该子项目 [spec:upstream-sync#子项目无可用 release tag]
- [x] 5.6 实现远程不可达处理：`git fetch --tags` 失败时输出错误并跳过 [spec:upstream-sync#远程仓库不可达]
- [x] 5.7 实现输出格式和退出码：汇总报告（成功/跳过/失败计数），退出码 0/1/2 [spec:upstream-sync#同步所有子项目到最新 release tag]

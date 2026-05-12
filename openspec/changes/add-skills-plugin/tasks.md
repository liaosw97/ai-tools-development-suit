# Tasks: add-skills-plugin

> 任务清单 — 将 spec 拆解为可执行的任务

---

## 任务

- [x] 1.1 在主仓库根目录执行 `git submodule add https://github.com/liaosw97/skills.git ai-tools/skills` [spec:submodule-setup#添加子模块]
- [x] 1.2 验证 `git submodule status` 显示 ai-tools/skills 且无 `-` 前缀 [spec:submodule-setup#子模块初始化验证]
- [x] 1.3 验证 `ai-tools/skills/` 目录包含仓库文件内容 [spec:submodule-setup#子模块初始化验证]
- [x] 2.1 在 `scripts/sync-upstream.sh` 的 SUBMODULES 数组中新增 `["skills"]="ai-tools/skills"` 条目 [spec:sync-integration#同步脚本新增 skills 条目]
- [x] 2.2 在 `versions.lock` 末尾新增 `skills=<hash> <tag>` 条目 [spec:sync-integration#versions.lock 新增 skills 快照]
- [x] 2.3 执行 `bash scripts/sync-upstream.sh --only skills` 验证同步功能 [spec:sync-integration#同步脚本新增 skills 条目]
- [x] 2.4 执行 `bash scripts/sync-upstream.sh --help` 确认 skills 出现在可选列表 [spec:sync-integration#同步脚本 --help 显示 skills]
- [x] 2.5 执行 `bash scripts/sync-upstream.sh --only nonexistent` 确认报错信息正确 [spec:sync-integration#无效子项目名称报错]
- [x] 3.1 在 CLAUDE.md 项目概述表格中新增 skills 行 [spec:docs-update#项目概述表格新增 skills 行]
- [x] 3.2 在 CLAUDE.md 架构节补充 skills 的独立工具集定位及与 superpowers 的关系说明 [spec:docs-update#架构关系图补充 skills]
- [x] 3.3 确认 CLAUDE.md Submodule 管理命令无需修改 [spec:docs-update#常用命令保持不变]

# Proposal: integrate-aitools-project

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

将 AiTools 从松散的文件集合转变为统一的开源项目，以 Git Submodule 包装层模式整合 OpenSpec、Superpowers、ai-tools-bridge 三个子项目，并提供 Bash 同步脚本保持与上游仓库的版本同步。

## 范围

### 包含
- 主仓库初始化（`git init`、`.gitmodules`、根 `package.json`、`.gitignore`）
- 将三个子项目配置为 Git Submodule
- Bash 同步脚本（`scripts/sync-upstream.sh`），含回滚机制
- 版本锁定文件（`versions.lock`），记录各子项目当前 commit/tag
- README，含项目说明、安装步骤、submodule 克隆指南
- 开源发布前的文件清理

### 不包含
- 统一构建系统或 monorepo 构建管道
- npm 包发布流程
- CI/CD 配置
- 跨子项目的代码重构或深度融合
- 子项目内部的修改

## 决策追溯

- 选择 [Git Submodule] 而非 [Git Subtree/脚本拉取]：核心需求是版本同步，Submodule 是唯一能同时提供精确版本锁定和便捷上游同步的方案（见 brainstorm.md §决策 1: 上游同步机制）
- 选择 [包装层松耦合] 而非 [中度/深度融合]：三个子项目各有独立的上游和发布节奏，深度融合会导致同步困难（见 brainstorm.md §决策 2: 子项目集成程度）
- 选择 [独立版本号] 而非 [统一版本号]：子项目各自有上游版本号，统一版本号会导致与上游脱节（见 brainstorm.md §决策 3: 版本策略）
- 选择 [ai-tools-bridge 作为 Submodule] 而非 [本地目录]：bridge 有独立上游仓库，需保持一致的 submodule 模式（见 brainstorm.md §决策 4: ai-tools-bridge 的归属）
- 选择 [Bash 同步脚本] 而非 [Node.js/完整 CI/CD]：聚焦核心需求，避免引入不必要的运行时依赖（见 brainstorm.md §决策 5: 管理工具范围）
- 选择 [纯 Git 仓库] 而非 [npm 包/GitHub Release]：当前阶段以源码形式提供即可（见 brainstorm.md §决策 6: 发布形式）
- 选择 [Bash] 而非 [Node.js]：同步操作本质是 git 命令组合，Bash 最直接（见 brainstorm.md §决策 7: 同步脚本语言）
- 选择 [.claude/ 由主仓库管理] 而非 [放入子项目]：配置属于 AiTools 整体，不属于任何单个子项目（见 brainstorm.md §决策 8: .claude/ 配置目录归属）
- 选择 [最新 release tag] 而非 [main 最新 commit]：release tag 代表稳定版本，同步后运行测试验证兼容性（见 brainstorm.md §决策 9: 上游同步的"成功"定义）
- 选择 [versions.lock 回滚] 而非 [git reflog]：显式的版本快照文件，利于团队协作（见 brainstorm.md §决策 10: 上游同步回滚策略）

## 影响分析

### 影响的模块

| 区域 | 变更类型 | 说明 |
|------|---------|------|
| 根目录 | 新增 | `.gitmodules`、`package.json`、`.gitignore`、`README.md`、`versions.lock` |
| `scripts/` | 新增 | `sync-upstream.sh` 同步脚本 |
| `ai-tools/OpenSpec/` | 转换 | 从普通目录转为 Git Submodule |
| `ai-tools/superpowers/` | 转换 | 从普通目录转为 Git Submodule |
| `ai-tools-bridge/` | 转换 | 从普通目录转为 Git Submodule |
| `.claude/` | 保留 | 主仓库直接管理，无变更 |
| `openspec/` | 保留 | 本地变更目录，主仓库直接管理 |
| `CLAUDE.md` | 修改 | 更新项目结构描述 |

### 风险评估

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|--------|------|---------|
| Submodule 转换过程中丢失本地修改 | 中 | 高 | 转换前确保所有本地修改已提交或备份 |
| 上游 breaking change 导致集成失败 | 中 | 中 | 同步脚本含回滚机制，指向 release tag 而非 main |
| 新贡献者不熟悉 submodule 工作流 | 高 | 低 | README 中提供详细的 submodule 操作指南 |
| 子项目 `.gitignore` 规则冲突 | 低 | 低 | 主仓库 `.gitignore` 覆盖全局规则 |

## 成功标准

- [ ] `git clone --recursive <repo>` 后项目结构完整，三个子项目代码可用
- [ ] `git submodule status` 返回三个有效 commit hash
- [ ] 各子项目 `package.json` 版本号互不依赖
- [ ] `scripts/sync-upstream.sh` 在 Git Bash 下可正常运行
- [ ] 同步脚本执行后 submodule 指向最新 release tag
- [ ] 同步脚本含回滚机制：失败时可从 `versions.lock` 恢复
- [ ] `README.md` 包含安装步骤、submodule 克隆指南
- [ ] 开源发布前临时文件已清理（`bash.exe.stackdump`、`log/` 等）

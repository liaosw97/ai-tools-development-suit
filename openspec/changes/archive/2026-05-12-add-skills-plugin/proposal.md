# Proposal: add-skills-plugin

> 变更提案 — 定义意图、范围和关键决策

## 变更意图

将 liaosw97/skills（mattpocock/skills 的 fork）作为第四个 Git Submodule 集成到 `ai-tools/` 目录，作为独立的 AI 编码代理技能工具集。

## 范围

### 包含
- 在 `ai-tools/` 下新增 `skills` Git Submodule，指向 `https://github.com/liaosw97/skills.git`
- 更新 `scripts/sync-upstream.sh` 的 SUBMODULES 数组，新增 `skills` 条目
- 更新 `versions.lock`，记录新子模块的初始版本快照
- 更新 `CLAUDE.md` 项目概述表格和架构说明，反映新增的 skills 子模块

### 不包含
- 不修改 ai-tools-bridge 的 SDD 编排逻辑（skills 不参与 SDD 工作流）
- 不运行 `npx skills@latest add` installer 将技能安装到 `.claude/commands/`
- 不处理 skills 与 superpowers 的功能重叠
- 不筛选或裁剪 skills 仓库中的技能

## 决策追溯

- 选择 [Git Submodule] 而非 [Git Subtree]：与已有子项目管理方式一致，复用 sync-upstream.sh 同步框架（见 brainstorm.md §方案探索）
- 选择 [独立工具集] 而非 [SDD 编排集成]：superpowers 已被 ai-tools-bridge 深度集成，mattpocock/skills 覆盖不同场景，两者互补（见 brainstorm.md §决策 1）
- 选择 [全量引入 18 个技能] 而非 [选择性引入]：纯 Markdown 存储成本极低，保留完整技能库供用户按需选择（见 brainstorm.md §决策 2）
- 选择 [仅 submodule 引入] 而非 [运行 installer]：避免与 SDD 斜杠命令体系冲突（见 brainstorm.md §决策 3）
- 选择 [不处理重叠] 而非 [统一技能体系]：superpowers 被 SDD 编排器专用，mattpocock/skills 用于非 SDD 场景（见 brainstorm.md §决策 4）

## 影响分析

### 影响的模块
- `.gitmodules` — 新增 skills 子模块配置
- `ai-tools/skills/` — 新目录（子模块挂载点）
- `scripts/sync-upstream.sh` — SUBMODULES 数组新增一行
- `versions.lock` — 新增 skills 版本快照条目
- `CLAUDE.md` — 项目概述表格新增一行，架构说明补充 skills 定位

### 风险评估
- **低风险**: 子模块操作为标准 Git 操作，可逆（`git submodule deinit` + `git rm`）
- **低风险**: sync-upstream.sh 修改仅增加一行配置，不改变现有逻辑
- **注意**: clone 主仓库后需要 `git submodule update --init --recursive` 才能获取 skills 内容

## 成功标准

- [ ] `git submodule status` 显示 ai-tools/skills 且无前缀 `-`（已初始化）
- [ ] `ls ai-tools/skills/` 能看到 skills 仓库的文件内容
- [ ] `bash scripts/sync-upstream.sh --only skills` 能正常运行（或正确报告无 tag）
- [ ] `versions.lock` 包含 skills 条目
- [ ] CLAUDE.md 项目概述表格包含 skills 行，架构说明包含 skills 定位

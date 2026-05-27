# Proposal: 添加 gstack 并提取角色系统

> 变更提案 — 将 gstack 作为 Git Submodule 集成，并借鉴其角色功能实现 SDD 角色系统

## 变更意图

将 gstack 仓库作为 Git Submodule 集成到 `ai-tools/gstack/`，研究其人员角色功能设计，借鉴到 ai-tools-bridge 中实现完整的角色系统，为所有 SDD action 提供专家视角增强。

## 范围

### 包含

- 添加 gstack 为 Git Submodule（`ai-tools/gstack/`）
- 在 ai-tools-bridge 中创建角色系统目录结构（`roles/`）
- 实现 10 个内置角色定义（planning、execution、review、release 四类）
- 为每个 SDD action 绑定默认角色
- 实现 `--role` 参数切换功能
- 新增 `/sdd-role` 斜杠命令
- 实现角色优先级合并（内置 < 项目级 < 用户级）
- 更新 CLAUDE.md 文档

### 不包含

- gstack 的浏览器自动化功能（/qa、/browse）
- gstack 的设计生成功能（/design-shotgun、/design-html）
- 跨 AI Agent 平台支持（仅支持 Claude Code）
- gstack 的自动更新机制
- 角色组合功能（`--role ceo+cso`）
- 角色推荐功能

## 决策追溯

- 选择 [Git Submodule] 而非 [复制文件]：保持与 OpenSpec、Superpowers 一致的管理方式，便于版本追踪和更新（见 brainstorm.md §决策 1：集成方式）
- 选择 [完整角色系统] 而非 [单一功能]：gstack 的角色功能是一个完整体系，提取后可为所有 SDD action 提供视角增强（见 brainstorm.md §决策 2：角色系统范围）
- 选择 [5 要素完整定义 + 可扩展] 而非 [简化定义]：gstack 的有效性来自结构化的角色定义，简化会丢失核心价值（见 brainstorm.md §决策 3：角色定义粒度）
- 选择 [内置 < 项目级 < 用户级] 而非 [单一配置源]：用户级配置优先级最高（可覆盖项目级和内置），项目级次之（可覆盖内置），团队协作时项目配置可生效（见 brainstorm.md §决策 4：角色优先级）
- 选择 [概念借鉴] 而非 [引用调用]：自主可控，轻量集成，不依赖外部安装（见 brainstorm.md §角色融入方式比较）
- 选择 [分类结构] 而非 [扁平结构]：清晰且可扩展，便于按阶段组织角色（见 brainstorm.md §角色目录结构比较）
- 选择 [参数 + 独立切换命令] 而非 [单一方式]：覆盖不同场景，参数用于一次性切换，命令用于会话级持久切换（见 brainstorm.md §角色切换交互方式比较）

## 影响分析

### 影响的模块

| 模块 | 影响类型 | 说明 |
|------|----------|------|
| `ai-tools/gstack/` | 新增 | Git Submodule |
| `ai-tools-bridge/roles/` | 新增 | 角色定义目录 |
| `ai-tools-bridge/skills/sdd-*/SKILL.md` | 修改 | 添加角色加载逻辑 |
| `.claude/commands/sdd-role.md` | 新增 | 角色切换斜杠命令 |
| `CLAUDE.md` | 修改 | 补充角色使用说明 |
| `versions.lock` | 修改 | 记录 gstack 版本 |

### 风险评估

| 风险 | 可能性 | 影响 | 缓解措施 |
|------|--------|------|----------|
| 角色文件格式错误 | 低 | 中 | 实现格式校验，降级到默认角色 |
| 向后兼容破坏 | 低 | 高 | 默认角色绑定，无参数时行为不变 |
| gstack submodule 初始化失败 | 低 | 中 | 提供 `git submodule update --init` 指引 |
| 角色优先级冲突 | 中 | 低 | 明确合并规则，输出提示信息 |

## 成功标准

- [ ] gstack submodule 成功添加并可访问
- [ ] `ai-tools-bridge/roles/` 目录结构创建完成，包含 10 个角色定义文件
- [ ] 每个 SDD action 的 SKILL.md 包含角色加载逻辑
- [ ] `/sdd-role` 命令可正常执行（显示/切换角色）
- [ ] `--role` 参数可正常切换角色
- [ ] CLAUDE.md 包含角色使用说明
- [ ] 现有 SDD 工作流不受影响（向后兼容）

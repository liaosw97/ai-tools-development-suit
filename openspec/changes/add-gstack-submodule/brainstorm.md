# Brainstorm: 添加 gstack 并提取角色系统

## 需求描述

将 gstack 仓库作为 Git Submodule 集成到 ai-tools 工作区，研究其人员角色功能，借鉴到 ai-tools-bridge 中实现完整的角色系统。

## 背景

gstack 是由 Garry Tan（YC CEO）开发的 AI 编码代理技能套件（v1.45.0），核心设计理念是**一人一角色，各司其职**，包含 23+ 专家角色技能，覆盖完整工作流：Think → Plan → Build → Review → Test → Ship → Reflect。

## 方案探索

### 方案比较

| 方案 | 描述 | 优劣 |
|------|------|------|
| 完整 submodule | 保留完整仓库 | ✅ 便于全面研究 ❌ 体积较大 |
| 精简 submodule | 只保留核心技能 | ✅ 轻量 ❌ 可能遗漏有价值内容 |
| **选择** | 完整 submodule | 便于深入研究 |

### 角色融入方式比较

| 方式 | 描述 | 优劣 |
|------|------|------|
| 引用调用 | SDD action 调用 gstack skill | ✅ 快速复用 ❌ 依赖外部安装 |
| 概念借鉴 | 学习方法论，重写为 SDD 原生 | ✅ 自主可控 ✅ 轻量 |
| 混合模式 | 核心重写 + 部分引用 | ✅ 灵活 ❌ 复杂度高 |
| **选择** | 概念借鉴 | 自主可控，轻量集成 |

### 角色目录结构比较

| 结构 | 描述 | 优劣 |
|------|------|------|
| 扁平结构 | 所有角色同级 | ✅ 简单 ❌ 不便管理 |
| 分类结构 | 按阶段分类组织 | ✅ 清晰 ✅ 可扩展 |
| 声明式分离 | 注册表 + 内容分离 | ✅ 灵活 ❌ 复杂 |
| **选择** | 分类结构 | 清晰且可扩展 |

### 角色切换交互方式比较

| 方式 | 示例 | 优劣 |
|------|------|------|
| 命令参数 | `/sdd-review-code --role cso` | ✅ 直观 ✅ 一次性 |
| 子命令 | `/sdd-review-code cso` | ✅ 简洁 ❌ 参数位置歧义 |
| 独立切换 | `/sdd-role cso` | ✅ 持久切换 ✅ 会话级 |
| **选择** | 参数 + 独立切换命令 | 覆盖不同场景 |

## 关键决策

### 决策 1：集成方式

**选择 [Git Submodule] 而非 [复制文件]：** 保持与 OpenSpec、Superpowers 一致的管理方式，便于版本追踪和更新。

### 决策 2：角色系统范围

**选择 [完整角色系统] 而非 [单一功能]：** gstack 的角色功能是一个完整体系，提取后可为所有 SDD action 提供视角增强。

### 决策 3：角色定义粒度

**选择 [5 要素完整定义 + 可扩展]：**
- 身份（Who）
- 专业视角（Perspective）
- 强制问题（Forcing Questions）
- 输出格式（Output Format）
- 触发条件（Trigger）

原因：gstack 的有效性来自结构化的角色定义，简化会丢失核心价值。同时支持用户自定义扩展。

### 决策 4：角色优先级

**选择 [内置 < 项目级 < 用户级]：** 用户级配置优先级最高（可覆盖项目级和内置），项目级次之（可覆盖内置）。这样个人用户可通过用户级配置定制行为，团队协作时项目级配置可覆盖内置角色。

### 决策 5：Action 默认角色绑定

| Action | 默认角色 | 可选角色 |
|--------|----------|----------|
| sdd-brainstorm | yc-office-hours | ceo, designer |
| sdd-propose | ceo | eng-manager |
| sdd-review-spec | eng-manager | ceo, designer |
| sdd-plan | eng-manager | ceo |
| sdd-code | developer | — |
| sdd-review-code | staff-engineer | cso, qa-lead |
| sdd-test-code | qa-lead | staff-engineer |
| sdd-verify | qa-lead | cso, sre |
| sdd-ship | release-engineer | sre |

## 设计规范

### 角色定义格式

```markdown
---
name: <role-name>
trigger: <sdd-action-1>, <sdd-action-2>
---

# 角色

你是一名 [角色身份]...

# 专业视角

[该角色关注的核心维度]

# 强制问题

1. [问题1]
2. [问题2]
...

# 输出格式

## [输出节1]
## [输出节2]
```

### 目录结构

```
ai-tools-bridge/roles/
  planning/
    yc-office-hours.md
    ceo.md
    eng-manager.md
    designer.md
  execution/
    developer.md
  review/
    staff-engineer.md
    qa-lead.md
    cso.md
  release/
    release-engineer.md
    sre.md

openspec/roles/           # 项目级自定义（优先级高）
  my-role.md

~/.claude/roles/          # 用户级自定义（优先级低）
  my-role.md
```

### 使用方式

```bash
# 使用默认角色
/sdd-review-code

# 切换角色执行
/sdd-review-code --role cso

# 切换当前会话角色
/sdd-role cso

# 显示当前角色
/sdd-role
```

## 约束识别

### 技术约束

| 约束 | 说明 | 应对策略 |
|------|------|----------|
| Git Submodule 路径 | Windows/macOS/Linux 路径差异 | 使用相对路径，避免硬编码 |
| 角色文件加载 | 需要修改 SDD action 的前置逻辑 | 在 action 启动时读取角色定义 |
| 角色切换命令 | 需要新增 `/sdd-role` 斜杠命令 | 在 `.claude/commands/` 中定义 |
| 优先级合并 | 内置、项目级、用户级三层合并 | 后加载覆盖先加载，项目级优先 |

### 团队约束

| 约束 | 说明 | 应对策略 |
|------|------|----------|
| 学习曲线 | 新增角色概念需要文档支持 | 在 CLAUDE.md 中补充角色使用说明 |
| 向后兼容 | 现有 SDD action 不应受影响 | 默认角色绑定，无参数时行为不变 |

### 异常处理

| 场景 | 处理策略 |
|------|----------|
| 角色文件缺失 | 降级到默认角色，输出警告 |
| 角色定义格式错误 | 输出错误提示，列出格式要求，降级到默认角色 |
| 角色名称冲突 | 项目级覆盖用户级，输出提示 |
| 无效角色名称 | 输出可用角色列表，降级到默认角色 |

## 非目标

- 不实现 gstack 的浏览器自动化功能（/qa、/browse）
- 不实现 gstack 的设计生成功能（/design-shotgun、/design-html）
- 不实现跨 AI Agent 平台支持（仅支持 Claude Code）
- 不实现 gstack 的自动更新机制

## 开放问题

1. **是否需要角色组合功能**（如 `--role ceo+cso` 同时从战略和安全视角审查）？
   - 初步倾向：暂不实现。理由：增加复杂度，可先观察单角色使用情况。

2. **角色切换是否需要记录到 review 文件中**？
   - 初步倾向：是。理由：便于追溯评审视角，在 review 文件头部添加 `**角色:** <role-name>`。

3. **是否需要角色推荐功能**（根据变更内容推荐合适的角色）？
   - 初步倾向：暂不实现。理由：需要变更内容分析能力，可在后续迭代中添加。

## 参考资源

- gstack 仓库: https://github.com/liaosw97/gstack.git
- gstack 版本: v1.45.0

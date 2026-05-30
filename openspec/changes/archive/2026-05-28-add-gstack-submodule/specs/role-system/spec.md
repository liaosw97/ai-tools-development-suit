# Spec: role-system — 角色系统核心

> 功能规格 — SDD 角色系统的定义、加载、绑定和优先级合并

## 能力描述

实现完整的角色系统，包括角色定义格式、目录结构、SDD action 绑定、角色切换和优先级合并。

---

## 场景

### SC-01: 角色定义格式 `[ADDED]`

**GIVEN** 角色定义文件位于 `ai-tools-bridge/roles/<category>/<role-name>.md`
**AND** 文件包含 YAML frontmatter（name、trigger）

**WHEN** SDD action 加载角色定义

**THEN** 角色定义包含 5 要素：
- 身份（Who）
- 专业视角（Perspective）
- 强制问题（Forcing Questions）
- 输出格式（Output Format）
- 触发条件（Trigger）

---

### SC-02: 角色目录结构 `[ADDED]`

**GIVEN** `ai-tools-bridge/roles/` 目录存在

**WHEN** 查看目录结构

**THEN** 存在以下分类目录：
- `planning/` — yc-office-hours、ceo、eng-manager、designer
- `execution/` — developer
- `review/` — staff-engineer、qa-lead、cso
- `release/` — release-engineer、sre

---

### SC-03: SDD action 默认角色绑定 `[ADDED]`

**GIVEN** SDD action 的 SKILL.md 已定义角色加载逻辑

**WHEN** 执行 SDD action（无 `--role` 参数）

**THEN** action 使用预定义的默认角色：
- sdd-brainstorm → yc-office-hours
- sdd-propose → ceo
- sdd-review-spec → eng-manager
- sdd-plan → eng-manager
- sdd-code → developer
- sdd-review-code → staff-engineer
- sdd-test-code → qa-lead
- sdd-verify → qa-lead
- sdd-ship → release-engineer

---

### SC-04: 角色参数切换 `[ADDED]`

**GIVEN** 执行 SDD action
**AND** 提供 `--role <role-name>` 参数

**WHEN** action 启动

**THEN** 加载指定的角色而非默认角色
**AND** 角色视角应用于整个 action 执行过程

---

### SC-05: 角色优先级合并 `[ADDED]`

**GIVEN** 存在三个角色配置源：
- 内置：`ai-tools-bridge/roles/`（优先级最低，作为基础）
- 项目级：`openspec/roles/`（可覆盖内置）
- 用户级：`~/.claude/roles/`（优先级最高，可覆盖项目级和内置）

**WHEN** 加载角色定义

**THEN** 按优先级合并：内置 < 项目级 < 用户级
**AND** 高优先级源覆盖低优先级源的同名角色
**AND** 项目级配置优先生效（团队协作时）
**AND** 存在冲突时输出提示信息

---

### SC-06: 角色文件缺失降级 `[ADDED]`

**GIVEN** 请求加载的角色不存在

**WHEN** 尝试加载角色

**THEN** 输出警告："角色 '<role-name>' 不存在，降级到默认角色"
**AND** 使用当前 action 的默认角色继续执行
**AND** 不阻断 action 执行

---

### SC-07: 角色定义格式错误 `[ADDED]`

**GIVEN** 角色定义文件存在格式错误（如缺少必需字段）

**WHEN** 加载角色定义

**THEN** 输出错误提示，列出格式要求
**AND** 降级到默认角色
**AND** 不阻断 action 执行

---

## 边界条件

- 角色名称大小写不敏感 → 统一转换为小写处理
- 角色定义包含未知字段 → 忽略未知字段，不报错
- 多个 action 共享同一默认角色 → 共享同一角色定义文件

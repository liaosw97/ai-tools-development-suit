# Spec: role-command — 角色切换斜杠命令

> 功能规格 — `/sdd-role` 命令显示和切换当前会话角色

## 能力描述

提供 `/sdd-role` 斜杠命令，用于显示当前角色或切换会话级角色。

---

## 场景

### SC-01: 显示当前角色 `[ADDED]`

**GIVEN** 会话已启动
**AND** 当前角色已设定

**WHEN** 执行 `/sdd-role`（无参数）

**THEN** 输出当前角色信息：
- 角色名称
- 角色来源（内置/项目级/用户级）
- 角色身份描述

---

### SC-02: 切换当前角色 `[ADDED]`

**GIVEN** 会话已启动
**AND** 目标角色存在

**WHEN** 执行 `/sdd-role <role-name>`

**THEN** 当前会话角色切换为指定角色
**AND** 输出确认："角色已切换为 <role-name>"
**AND** 后续 SDD action 使用新角色（除非被 `--role` 参数覆盖）

---

### SC-03: 切换到不存在的角色 `[ADDED]`

**GIVEN** 会话已启动
**AND** 目标角色不存在

**WHEN** 执行 `/sdd-role <invalid-role>`

**THEN** 输出错误："角色 '<invalid-role>' 不存在"
**AND** 输出可用角色列表（按分类）
**AND** 当前角色不变

---

### SC-04: 列出所有可用角色 `[ADDED]`

**GIVEN** 角色系统已初始化

**WHEN** 执行 `/sdd-role --list`

**THEN** 输出所有可用角色（按分类）：
```
Planning:
  - yc-office-hours
  - ceo
  - eng-manager
  - designer

Execution:
  - developer

Review:
  - staff-engineer
  - qa-lead
  - cso

Release:
  - release-engineer
  - sre
```

---

## 边界条件

- 角色切换不影响已完成的 action → 仅影响后续 action
- `/sdd-role` 切换可被 `--role` 参数覆盖 → 参数优先级高于会话级切换
- 会话结束后角色重置 → 下次会话使用默认角色

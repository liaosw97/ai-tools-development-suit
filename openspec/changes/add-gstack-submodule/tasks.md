# Tasks: 添加 gstack 并提取角色系统

> 任务清单 — 将 spec 拆解为可执行的任务

---

## 任务

### 1. gstack 集成

- [x] 1.1 添加 gstack Git Submodule 到 `ai-tools/gstack/` [spec:gstack-integration#SC-01]
- [x] 1.2 验证 submodule 初始化正常 [spec:gstack-integration#SC-02]
- [x] 1.3 更新 `versions.lock` 记录 gstack 版本 [spec:gstack-integration#SC-03]

### 2. 角色系统目录结构

- [x] 2.1 创建 `ai-tools-bridge/roles/planning/` 目录 [spec:role-system#SC-02]
- [x] 2.2 创建 `ai-tools-bridge/roles/execution/` 目录 [spec:role-system#SC-02]
- [x] 2.3 创建 `ai-tools-bridge/roles/review/` 目录 [spec:role-system#SC-02]
- [x] 2.4 创建 `ai-tools-bridge/roles/release/` 目录 [spec:role-system#SC-02]

### 3. 角色定义文件

- [x] 3.1 创建 `yc-office-hours.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.2 创建 `ceo.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.3 创建 `eng-manager.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.4 创建 `designer.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.5 创建 `developer.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.6 创建 `staff-engineer.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.7 创建 `qa-lead.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.8 创建 `cso.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.9 创建 `release-engineer.md` 角色定义 [spec:role-system#SC-01]
- [x] 3.10 创建 `sre.md` 角色定义 [spec:role-system#SC-01]

### 4. SDD action 角色绑定

- [x] 4.1 为 `sdd-brainstorm` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.2 为 `sdd-propose` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.3 为 `sdd-review-spec` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.4 为 `sdd-plan` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.5 为 `sdd-code` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.6 为 `sdd-review-code` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.7 为 `sdd-test-code` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.8 为 `sdd-verify` 添加角色加载逻辑 [spec:role-system#SC-03]
- [x] 4.9 为 `sdd-ship` 添加角色加载逻辑 [spec:role-system#SC-03]

### 5. 角色切换命令

- [x] 5.1 创建 `.claude/commands/sdd-role.md` 命令定义 [spec:role-command#SC-01]
- [x] 5.2 实现显示当前角色功能 [spec:role-command#SC-01]
- [x] 5.3 实现切换角色功能 [spec:role-command#SC-02]
- [x] 5.4 实现列出所有角色功能 [spec:role-command#SC-04]
- [x] 5.5 实现角色不存在时的错误处理 [spec:role-command#SC-03]

### 6. 角色参数支持

- [x] 6.1 实现 `--role` 参数解析 [spec:role-system#SC-04]
- [x] 6.2 实现参数优先级高于会话级角色 [spec:role-command#边界条件]

### 7. 角色优先级合并

- [x] 7.1 实现角色文件查找逻辑（三层源） [spec:role-system#SC-05]
- [x] 7.2 实现优先级合并规则 [spec:role-system#SC-05]
- [x] 7.3 实现角色文件缺失降级 [spec:role-system#SC-06]
- [x] 7.4 实现角色格式错误处理 [spec:role-system#SC-07]

### 8. 文档更新

- [x] 8.1 更新 `CLAUDE.md` 添加角色使用说明
- [x] 8.2 更新 `ai-tools-bridge/CLAUDE.md` 添加角色系统说明

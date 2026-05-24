# Tasks: hierarchical-requirement-breakdown

> 任务清单 — 将 spec 拆解为可执行的任务

---

## 任务

### 批次 1：sdd-brainstorm 改动

- [x] 1.1 修改 sdd-brainstorm SKILL.md，新增"拆分模式检测"前置逻辑 [spec:breakdown-mode#参数触发拆分模式]
- [x] 1.2 修改 sdd-brainstorm SKILL.md，新增自然语言触发检测（关键词匹配） [spec:breakdown-mode#自然语言触发拆分模式]
- [x] 1.3 修改 sdd-brainstorm SKILL.md，新增"L1 功能模块拆分"交互流程 [spec:breakdown-mode#L1 功能模块拆分]
- [x] 1.4 修改 sdd-brainstorm SKILL.md，新增"L2 功能单元拆分"交互流程（含即时追问） [spec:breakdown-mode#L2 功能单元拆分]
- [x] 1.5 修改 sdd-brainstorm SKILL.md，新增"L3 功能点拆分"交互流程（含用户干预） [spec:breakdown-mode#L3 功能点拆分]
- [x] 1.6 修改 sdd-brainstorm SKILL.md，新增"功能树产出"格式定义 [spec:breakdown-mode#功能树产出]
- [x] 1.7 修改 sdd-brainstorm SKILL.md，新增"用户中途取消拆分"异常流处理 [spec:breakdown-mode#用户中途取消拆分]
- [x] 1.8 修改 sdd-brainstorm SKILL.md，新增"需求矛盾或无法拆分"异常流处理 [spec:breakdown-mode#需求矛盾或无法拆分]
- [x] 1.9 修改 sdd-brainstorm SKILL.md，新增 brainstorm 阶段目录冲突检测 [spec:directory-conflict#brainstorm 阶段引用已有功能]

### 批次 2：sdd-plan 改动

- [x] 2.1 修改 sdd-plan SKILL.md，新增"功能树读取"前置逻辑 [spec:dependency-detection#数据依赖检测]
- [x] 2.2 修改 sdd-plan SKILL.md，新增"数据依赖检测"规则 [spec:dependency-detection#数据依赖检测]
- [x] 2.3 修改 sdd-plan SKILL.md，新增"API 依赖检测"规则 [spec:dependency-detection#API 依赖检测]
- [x] 2.4 修改 sdd-plan SKILL.md，新增"UI 依赖检测"规则 [spec:dependency-detection#UI 依赖检测]
- [x] 2.5 修改 sdd-plan SKILL.md，新增"循环依赖处理"流程 [spec:dependency-detection#循环依赖处理]
- [x] 2.6 修改 sdd-plan SKILL.md，新增"用户确认依赖顺序"交互 [spec:dependency-detection#用户确认依赖顺序]
- [x] 2.7 修改 sdd-plan SKILL.md，新增"用户拒绝依赖调整"处理 [spec:dependency-detection#用户拒绝依赖调整]
- [x] 2.8 修改 sdd-plan SKILL.md，新增任务组标注格式 `[unit:模块/单元/功能点]`

### 批次 3：sdd-code 改动

- [x] 3.1 修改 sdd-code SKILL.md，新增"功能单元选择"前置逻辑 [spec:breakdown-mode#功能树产出]
- [x] 3.2 修改 sdd-code SKILL.md，新增 code 阶段目录冲突检测 [spec:directory-conflict#code 阶段创建文件前扫描]
- [x] 3.3 修改 sdd-code SKILL.md，新增"相似目录判断"规则 [spec:directory-conflict#相似目录判断]
- [x] 3.4 修改 sdd-code SKILL.md，新增"用户选择现有目录"处理 [spec:directory-conflict#用户选择现有目录]
- [x] 3.5 修改 sdd-code SKILL.md，新增"用户新建目录"处理（含路径冲突检测） [spec:directory-conflict#用户新建目录]
- [x] 3.6 修改 sdd-code SKILL.md，新增功能单元独立验证逻辑 [spec:directory-conflict#用户确认目标目录后继续]
- [x] 3.7 修改 sdd-code SKILL.md，更新完成引导（推荐下一功能单元） [spec:breakdown-mode#功能树产出]

### 批次 4：配置与文档

- [x] 4.1 更新 schemas/sdd/schema.yaml，新增 breakdown 配置定义 [spec:project]
- [x] 4.2 编写 Vitest 测试用例验证功能树解析 [spec:project]
- [x] 4.3 编写 Vitest 测试用例验证依赖检测规则 [spec:project]
- [x] 4.4 编写 Vitest 测试用例验证相似目录判断 [spec:project]
- [x] 4.5 更新 ai-tools-bridge CLAUDE.md，说明拆分模式用法 [spec:project]

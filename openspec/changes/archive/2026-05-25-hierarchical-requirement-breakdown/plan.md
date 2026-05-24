# Plan: hierarchical-requirement-breakdown

> 实施计划 — TDD 级别的详细步骤

---

## 批次 1/4：sdd-brainstorm 改动

<!-- 依赖：无 -->
<!-- 任务范围：0.1, 1.1-1.9 -->

### Task 0.1: 创建测试文件骨架 [spec:project]

- **文件**: `ai-tools-bridge/tests/sdd-brainstorm.test.ts` (Create)
- **RED**: 创建空测试文件
  - 创建测试文件骨架，导入 vitest
  - 添加 describe 占位符
- **运行验证**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`（应通过空测试）
- **GREEN**: 确认文件创建成功
- **运行验证通过**: `ls ai-tools-bridge/tests/sdd-brainstorm.test.ts`

### Task 1.1: 修改 sdd-brainstorm SKILL.md，新增"拆分模式检测"前置逻辑 [spec:breakdown-mode#参数触发拆分模式]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：当命令参数包含 `--breakdown` 或 `-b` 时，应检测到拆分模式
  - 测试文件：`ai-tools-bridge/tests/sdd-brainstorm.test.ts`
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在 SKILL.md 前置逻辑节新增"拆分模式检测"小节
  - 定义参数检测规则：`--breakdown` 或 `-b`
  - 定义状态变量：`breakdown_mode = true`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.2: 修改 sdd-brainstorm SKILL.md，新增自然语言触发检测 [spec:breakdown-mode#自然语言触发拆分模式]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：当用户输入包含"拆分"、"分层"、"逐步探索"、"功能模块"关键词时，应触发拆分模式
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在"拆分模式检测"小节新增自然语言检测规则
  - 定义触发关键词列表
  - 定义关键词匹配逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.3: 修改 sdd-brainstorm SKILL.md，新增"L1 功能模块拆分"交互流程 [spec:breakdown-mode#L1 功能模块拆分]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：AI 应提议功能模块列表并询问用户确认
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"L1 拆分"交互流程
  - 定义 AI 提议格式
  - 定义用户确认交互
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.4: 修改 sdd-brainstorm SKILL.md，新增"L2 功能单元拆分"交互流程 [spec:breakdown-mode#L2 功能单元拆分]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：对每个 L1 模块，AI 应提议功能单元列表并即时追问
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"L2 拆分"交互流程
  - 定义即时追问机制
  - 定义追问内容格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.5: 修改 sdd-brainstorm SKILL.md，新增"L3 功能点拆分"交互流程 [spec:breakdown-mode#L3 功能点拆分]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：当功能单元包含 >3 个独立操作时，AI 应询问是否继续拆分
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"L3 拆分"交互流程
  - 定义拆分判断标准（>3 个独立操作）
  - 定义用户选项：继续拆分/停止拆分/跳过
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.6: 修改 sdd-brainstorm SKILL.md，新增"功能树产出"格式定义 [spec:breakdown-mode#功能树产出]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：brainstorm.md 应包含结构化的"功能拆分"节
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在后置逻辑节新增"功能树产出"格式定义
  - 定义 Markdown 嵌套列表格式
  - 定义叶子节点追问结果标注
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.7: 修改 sdd-brainstorm SKILL.md，新增"用户中途取消拆分"异常流处理 [spec:breakdown-mode#用户中途取消拆分]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：用户输入"取消"时应提供保存/丢弃选项
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"用户取消"异常处理
  - 定义选项 A：保存当前状态并退出
  - 定义选项 B：丢弃本次拆分
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.8: 修改 sdd-brainstorm SKILL.md，新增"需求矛盾或无法拆分"异常流处理 [spec:breakdown-mode#需求矛盾或无法拆分]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：检测到需求矛盾时应暂停并询问用户澄清
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"需求矛盾"异常处理
  - 定义暂停流程
  - 定义用户澄清交互
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

### Task 1.9: 修改 sdd-brainstorm SKILL.md，新增 brainstorm 阶段目录冲突检测 [spec:directory-conflict#brainstorm 阶段引用已有功能]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：发现相似目录时应暂停并询问用户
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"目录冲突检测"
  - 定义相似目录判断规则（见 design.md）
  - 定义用户确认交互
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-brainstorm.test.ts`

--- checkpoint: 批次 1 完成 ---

## 批次 2/4：sdd-plan 改动

<!-- 依赖：批次 1 完成（功能树格式定义） -->
<!-- 任务范围：0.2, 2.1-2.8 -->

### Task 0.2: 创建测试文件骨架 [spec:project]

- **文件**: `ai-tools-bridge/tests/sdd-plan.test.ts` (Create)
- **RED**: 创建空测试文件
  - 创建测试文件骨架，导入 vitest
  - 添加 describe 占位符
- **运行验证**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`（应通过空测试）
- **GREEN**: 确认文件创建成功
- **运行验证通过**: `ls ai-tools-bridge/tests/sdd-plan.test.ts`

### Task 2.1: 修改 sdd-plan SKILL.md，新增"功能树读取"前置逻辑 [spec:dependency-detection#数据依赖检测]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：当 brainstorm.md 包含"功能拆分"节时，应解析功能树
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在前置逻辑节新增"功能树读取"
  - 定义解析规则：识别"## 功能拆分"节
  - 定义提取：叶子节点列表
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.2: 修改 sdd-plan SKILL.md，新增"数据依赖检测"规则 [spec:dependency-detection#数据依赖检测]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：检测到功能 B 使用功能 A 的数据时，应输出依赖提示
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"数据依赖检测"
  - 定义检测规则：数据流分析
  - 定义输出格式："[功能单元 B] 可能依赖 [功能单元 A]"
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.3: 修改 sdd-plan SKILL.md，新增"API 依赖检测"规则 [spec:dependency-detection#API 依赖检测]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：检测到功能 B 调用功能 A 的 API 时，应输出依赖提示
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"API 依赖检测"
  - 定义检测规则：接口调用关系
  - 定义输出格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.4: 修改 sdd-plan SKILL.md，新增"UI 依赖检测"规则 [spec:dependency-detection#UI 依赖检测]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：检测到功能 B 的组件嵌入功能 A 的页面时，应输出依赖提示
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"UI 依赖检测"
  - 定义检测规则：组件嵌套关系
  - 定义输出格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.5: 修改 sdd-plan SKILL.md，新增"循环依赖处理"流程 [spec:dependency-detection#循环依赖处理]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：检测到循环依赖时应输出警告并提供解决选项
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"循环依赖处理"
  - 定义选项 A：合并为同一功能单元
  - 定义选项 B：引入中间层解耦
  - 定义选项 C：用户手动指定顺序
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.6: 修改 sdd-plan SKILL.md，新增"用户确认依赖顺序"交互 [spec:dependency-detection#用户确认依赖顺序]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：用户确认依赖时应调整 plan.md 任务顺序
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"用户确认依赖"交互
  - 定义调整顺序逻辑
  - 定义 plan.md 标注格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.7: 修改 sdd-plan SKILL.md，新增"用户拒绝依赖调整"处理 [spec:dependency-detection#用户拒绝依赖调整]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：用户拒绝依赖调整时应保持原顺序并标注
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"用户拒绝依赖"处理
  - 定义保持原顺序逻辑
  - 定义标注格式："用户确认忽略依赖风险"
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

### Task 2.8: 修改 sdd-plan SKILL.md，新增任务组标注格式 `[unit:模块/单元/功能点]`

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：plan.md 任务应有 `[unit:模块/单元/功能点]` 标注
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"任务组标注格式"
  - 定义标注语法
  - 定义 checkpoint 标记格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-plan.test.ts`

--- checkpoint: 批次 2 完成 ---

## 批次 3/4：sdd-code 改动

<!-- 依赖：批次 1-2 完成（功能树格式 + 任务组标注） -->
<!-- 任务范围：0.3, 3.1-3.7 -->

### Task 0.3: 创建测试文件骨架 [spec:project]

- **文件**: `ai-tools-bridge/tests/sdd-code.test.ts` (Create)
- **RED**: 创建空测试文件
  - 创建测试文件骨架，导入 vitest
  - 添加 describe 占位符
- **运行验证**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`（应通过空测试）
- **GREEN**: 确认文件创建成功
- **运行验证通过**: `ls ai-tools-bridge/tests/sdd-code.test.ts`

### Task 3.1: 修改 sdd-code SKILL.md，新增"功能单元选择"前置逻辑 [spec:breakdown-mode#功能树产出]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：当 plan.md 包含功能单元标记时，应列出功能单元状态
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在前置逻辑节新增"功能单元选择"
  - 定义状态检测：已完成/进行中/待开始
  - 定义用户选择交互
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

### Task 3.2: 修改 sdd-code SKILL.md，新增 code 阶段目录冲突检测 [spec:directory-conflict#code 阶段创建文件前扫描]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：创建文件前扫描项目目录，发现相似目录时应暂停
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在前置逻辑节新增"目录冲突检测"
  - 定义扫描时机：创建文件前
  - 定义暂停条件：发现多个可能目录
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

### Task 3.3: 修改 sdd-code SKILL.md，新增"相似目录判断"规则 [spec:directory-conflict#相似目录判断]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：相似度阈值 >60% 时判定为相似目录
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"相似目录判断规则"
  - 定义规则：名称关键词相同或功能语义相近
  - 定义阈值：相似度 >60%
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

### Task 3.4: 修改 sdd-code SKILL.md，新增"用户选择现有目录"处理 [spec:directory-conflict#用户选择现有目录]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：用户选择现有目录时应记录并继续
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"用户选择现有目录"处理
  - 定义记录逻辑
  - 定义继续流程
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

### Task 3.5: 修改 sdd-code SKILL.md，新增"用户新建目录"处理 [spec:directory-conflict#用户新建目录]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：用户新建目录时应检查路径冲突
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"用户新建目录"处理
  - 定义路径冲突检测
  - 定义冲突警告输出
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

### Task 3.6: 修改 sdd-code SKILL.md，新增功能单元独立验证逻辑 [spec:directory-conflict#用户确认目标目录后继续]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：功能单元完成后应仅验证相关测试（非全量）
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在核心执行节新增"功能单元独立验证"
  - 定义测试范围：相关测试文件
  - 定义验证通过条件
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

### Task 3.7: 修改 sdd-code SKILL.md，更新完成引导 [spec:breakdown-mode#功能树产出]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写失败测试
  - 测试：完成引导应推荐下一功能单元
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`
- **GREEN**: 最小实现
  - 在后置逻辑节更新"完成引导"
  - 定义推荐格式：下一功能单元名称
  - 定义备选项：审查代码、归档
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/sdd-code.test.ts`

--- checkpoint: 批次 3 完成 ---

## 批次 4/4：配置与文档

<!-- 依赖：批次 1-3 完成（所有 SKILL.md 改动） -->
<!-- 任务范围：0.4, 4.1-4.5 -->

### Task 0.4: 创建测试目录与骨架 [spec:project]

- **文件**: `ai-tools-bridge/tests/breakdown/` (Create), `ai-tools-bridge/tests/schema.test.ts` (Create)
- **RED**: 创建测试目录和文件骨架
  - 创建 `tests/breakdown/` 目录
  - 创建 `tests/schema.test.ts` 空测试文件
- **运行验证**: `ls ai-tools-bridge/tests/breakdown/ && ls ai-tools-bridge/tests/schema.test.ts`
- **GREEN**: 确认目录和文件创建成功
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/schema.test.ts`（应通过空测试）

### Task 4.1: 更新 schemas/sdd/schema.yaml，新增 breakdown 配置定义 [spec:project]

- **文件**: `ai-tools-bridge/schemas/sdd/schema.yaml` (Modify)
- **RED**: 编写失败测试
  - 测试：schema.yaml 应包含 breakdown 配置节定义
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/schema.test.ts`
- **GREEN**: 最小实现
  - 在 schema.yaml 新增 breakdown 配置节
  - 定义字段：enabled、default-depth、keywords、dependency-detection、directory-conflict-detection
  - 定义默认值
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/schema.test.ts`

### Task 4.2: 编写 Vitest 测试用例验证功能树解析 [spec:project]

- **文件**: `ai-tools-bridge/tests/breakdown/feature-tree-parse.test.ts` (Create)
- **RED**: 编写失败测试
  - 测试：解析 Markdown 功能树应正确提取 L1/L2/L3 层级
  - 测试：解析应正确识别叶子节点
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/breakdown/feature-tree-parse.test.ts`
- **GREEN**: 最小实现
  - 实现 Markdown 功能树解析函数
  - 处理嵌套列表、缩进变化
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/breakdown/feature-tree-parse.test.ts`

### Task 4.3: 编写 Vitest 测试用例验证依赖检测规则 [spec:project]

- **文件**: `ai-tools-bridge/tests/breakdown/dependency-detection.test.ts` (Create)
- **RED**: 编写失败测试
  - 测试：数据依赖检测应识别数据流关系
  - 测试：API 依赖检测应识别接口调用关系
  - 测试：UI 依赖检测应识别组件嵌套关系
  - 测试：循环依赖检测应识别 A→B→A 模式
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/breakdown/dependency-detection.test.ts`
- **GREEN**: 最小实现
  - 实现依赖检测规则函数
  - 定义检测规则逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/breakdown/dependency-detection.test.ts`

### Task 4.4: 编写 Vitest 测试用例验证相似目录判断 [spec:project]

- **文件**: `ai-tools-bridge/tests/breakdown/directory-similarity.test.ts` (Create)
- **RED**: 编写失败测试
  - 测试：关键词相同应判定为相似
  - 测试：功能语义相近应判定为相似
  - 测试：相似度阈值计算应正确
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/breakdown/directory-similarity.test.ts`
- **GREEN**: 最小实现
  - 实现相似目录判断函数
  - 定义关键词提取逻辑
  - 定义相似度计算公式
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/breakdown/directory-similarity.test.ts`

### Task 4.5: 更新 ai-tools-bridge CLAUDE.md，说明拆分模式用法 [spec:project]

- **文件**: `ai-tools-bridge/CLAUDE.md` (Modify)
- **RED**: 编写验证命令
  - 检查：CLAUDE.md 应包含"拆分模式"触发方式说明
- **运行验证失败**: `grep -q "拆分模式" ai-tools-bridge/CLAUDE.md && echo "PASS" || echo "FAIL"`
- **GREEN**: 最小实现
  - 在 CLAUDE.md 新增"拆分模式"节
  - 说明触发方式：参数 `--breakdown` 或自然语言
  - 说明配置项：breakdown.enabled、breakdown.default-depth、breakdown.keywords
- **运行验证通过**: `grep -q "拆分模式" ai-tools-bridge/CLAUDE.md && grep -q "触发方式" ai-tools-bridge/CLAUDE.md && echo "PASS" || echo "FAIL"`

--- checkpoint: 批次 4 完成 ---

---

## 实施总结

| 批次 | 任务数 | 依赖 | 状态 |
|------|--------|------|------|
| 批次 1：sdd-brainstorm 改动 | 10 | 无 | 待实施 |
| 批次 2：sdd-plan 改动 | 9 | 批次 1 | 待实施 |
| 批次 3：sdd-code 改动 | 8 | 批次 1-2 | 待实施 |
| 批次 4：配置与文档 | 6 | 批次 1-3 | 待实施 |
| **总计** | **33** | — | — |

---

<!-- 格式说明:
  - 每个任务必须有 RED/GREEN 步骤（TDD 铁律）
  - 每个步骤有具体的运行验证命令
  - 粒度: 2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
-->

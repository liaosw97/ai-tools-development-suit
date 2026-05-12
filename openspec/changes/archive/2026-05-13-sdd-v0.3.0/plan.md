# Plan: sdd-v0.3.0

> 实施计划 — TDD 级别的详细步骤（分批生成，7 个批次）

**执行提示：** 同一文件的连续修改（如 Task 1.1-1.6）可将 RED 测试合并编写一次，再逐步 GREEN 实现。

---

## 批次 1/7：基础设施 + sdd-quick 核心

<!-- 依赖：无前置依赖 -->
<!-- 任务范围：7.1, 7.2, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6 -->

### Task 7.1: schema.yaml 新增 sdd-quick 和 sdd-test-code action 定义 [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/schemas/sdd/schema.yaml` (Modify)
- **RED**: 在 `tests/` 中编写测试验证 schema 包含 sdd-quick 和 sdd-test-code 的 action 定义
  ```
  验证 schema.actions 包含 sdd-quick 和 sdd-test-code
  验证 sdd-quick 的依赖链：无必需前置（可独立触发）
  验证 sdd-test-code 的依赖链：必需 reviews/ 审查报告
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在 schema.yaml 的 actions 节中新增 sdd-quick 和 sdd-test-code 定义，包含名称、描述、依赖、产物
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 7.2: plugin.json 注册 sdd-quick 和 sdd-test-code [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/.claude-plugin/plugin.json` (Modify)
- **RED**: 编写测试验证 plugin.json skills 数组包含 sdd-quick 和 sdd-test-code 路径
  ```
  验证 plugin.json 解析成功
  验证 skills 数组包含 "./skills/sdd-quick" 和 "./skills/sdd-test-code"
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在 plugin.json 的 skills 数组中添加 `"./skills/sdd-quick"` 和 `"./skills/sdd-test-code"`
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.1: 创建 sdd-quick 目录结构 [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Create)
- **RED**: 编写测试验证 skills/sdd-quick/SKILL.md 文件存在且包含 YAML 前置元数据
  ```
  验证文件存在
  验证 YAML 前置元数据包含 name: sdd-quick
  验证 description 字段非空
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 创建目录 `skills/sdd-quick/`，创建空 SKILL.md（仅含 YAML 前置元数据占位）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.2: 编写 sdd-quick SKILL.md 完整内容 [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 编写测试验证 SKILL.md 包含前置逻辑、核心执行、后置逻辑三段
  ```
  验证包含"前置逻辑"节
  验证包含"核心执行"节，且委托 openspec-continue-change 和 superpowers:test-driven-development
  验证包含"后置逻辑"节
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 编写完整 SKILL.md 内容：前置自检（复杂度评估）→ 核心执行（交互收集 → spec → tasks → code）→ 后置推荐
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.3: 实现前置自检逻辑 [spec:sdd-quick#需求超出 quick 范围时的回退提示]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 编写测试验证 SKILL.md 前置逻辑包含复杂度评估和回退提示
  ```
  验证包含"疑似复杂"判断逻辑
  验证包含"/sdd-propose"回退建议
  验证包含"是否继续"询问
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑段落中增加自检步骤：评估复杂度 → 疑似复杂输出回退提示 → 用户选择继续或退出
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.4: 实现 proposal 存在时跳过交互收集 [spec:sdd-quick#有已有 proposal 时的 quick 流程]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 编写测试验证 SKILL.md 包含 proposal 存在性检查和跳过逻辑
  ```
  验证包含"检查 proposal.md 是否存在"步骤
  验证包含"跳过交互收集"路径描述
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在核心执行段落中增加分支：proposal 存在 → 读取并跳过收集；不存在 → 交互收集（最多 5 问）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.5: 实现场景/任务上限检测 [spec:sdd-quick#生成过程中超出上限的回退提示]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 编写测试验证 SKILL.md 包含上限检测和超限提示
  ```
  验证包含"场景 > 5"和"任务 > 10"检测
  验证包含中间产物可复用提示
  验证包含"/sdd-propose 或 /sdd-ff"回退建议
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在核心执行段落中增加生成过程检测：超限 → 停止 → 提示复用 → 建议标准路径
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.6: 实现完成后推荐操作 [spec:sdd-quick#quick 完成后的推荐操作]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 编写测试验证后置逻辑包含 ★○△ 推荐格式
  ```
  验证包含"★ 推荐下一步"
  验证推荐包含 /sdd-review-code 或 /sdd-ship
  验证可选包含 /sdd-verify
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在后置逻辑末尾增加推荐操作输出段落
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

--- checkpoint ---

## 批次 2/7：sdd-quick reference 文件

<!-- 依赖：批次 1 完成 -->
<!-- 任务范围：1.7, 1.8 -->

### Task 1.7: 提取 /grill-me 追问技巧到 reference-grill.md [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/skills/sdd-quick/reference-grill.md` (Create)
- **RED**: 编写测试验证 reference-grill.md 存在且包含来源标注
  ```
  验证文件存在
  验证包含来源标注（skills/engineering/grill-me）
  验证包含追问技巧核心内容（非空）
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 读取 `ai-tools/skills/skills/productivity/grill-me/SKILL.md`，提取核心追问技巧（苏格拉底式提问方法、多选优先、逐个分支解决），写入 reference-grill.md 并保留来源标注
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 1.8: 提取 /tdd 核心流程到 reference-tdd-compact.md [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/skills/sdd-quick/reference-tdd-compact.md` (Create)
- **RED**: 编写测试验证文件存在且包含来源标注
  ```
  验证文件存在
  验证包含来源标注（skills/engineering/tdd）
  验证包含 TDD 核心流程内容
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 读取 `ai-tools/skills/skills/engineering/tdd/SKILL.md`，提取红-绿-重构核心流程、垂直切片模式，精简为快速模式适用版本，写入 reference-tdd-compact.md
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

--- checkpoint ---

## 批次 3/7：sdd-test-code 完整新 action

<!-- 依赖：批次 1 完成（schema 注册） -->
<!-- 任务范围：2.1-2.10 -->

### Task 2.1: 创建 sdd-test-code 目录和 SKILL.md 骨架 [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Create)
- **RED**: 编写测试验证 skills/sdd-test-code/SKILL.md 存在且包含 YAML 前置元数据
  ```
  验证文件存在
  验证 YAML 前置元数据包含 name: sdd-test-code
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 创建目录 `skills/sdd-test-code/`，创建含 YAML 前置元数据的 SKILL.md 骨架
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.2: 编写 sdd-test-code SKILL.md 完整内容 [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证 SKILL.md 包含三层结构
  ```
  验证前置逻辑包含"读取 review 报告"
  验证核心执行委托 superpowers:test-driven-development
  验证 Override 包含"不修改实现代码"
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 编写完整 SKILL.md：前置（读取 review + 提取 PARTIAL/MISSING）→ 核心（委托 TDD + Override）→ 后置（推荐）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.3: 实现读取 spec-compliance 报告 [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含 spec-compliance 报告读取和 PARTIAL/MISSING 提取
  ```
  验证包含"spec-compliance"关键词
  验证包含"PARTIAL"和"MISSING"提取逻辑
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑中增加：读取 reviews/ 下最新 spec-compliance 报告 → 提取 PARTIAL/MISSING 场景列表
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.4: 实现读取 code-quality 报告 [spec:sdd-test-code#测试质量 issues 的修复]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含 code-quality 报告读取
  ```
  验证包含"code-quality"关键词
  验证包含测试质量 issues 提取逻辑
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑中增加：读取 reviews/ 下最新 code-quality 报告 → 提取测试质量 issues
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.5: 实现 RED-GREEN 循环步骤 [spec:sdd-test-code#MISSING 场景的 TDD 补全]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证核心执行包含 RED-GREEN 循环描述
  ```
  验证包含"RED"和"GREEN"步骤描述
  验证包含"每个场景独立提交"
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在核心执行段落中详细描述 RED-GREEN 循环流程和 Override 指令（不修改实现代码）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.6: 实现无缺失时空操作提示 [spec:sdd-test-code#无缺失时的空操作提示]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含无缺失时的处理路径
  ```
  验证包含"无 PARTIAL/MISSING"判断
  验证包含空操作提示描述
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑中增加分支：无 PARTIAL/MISSING 且无 issues → 输出空操作提示 → 建议跳过
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.7: 实现独立触发定位最新报告 [spec:sdd-test-code#独立触发时读取最新 review 报告]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含报告定位和时间跨度警告
  ```
  验证包含"最新"报告定位逻辑
  验证包含时间跨度警告
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑中增加报告定位策略（按时间排序取最新）和时间跨度检查
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.8: 实现完成后推荐操作 [spec:sdd-test-code#补全完成后的推荐操作]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 编写测试验证后置逻辑包含推荐操作
  ```
  验证包含 ★ /sdd-verify 和 ○ /sdd-ship
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在后置逻辑末尾增加推荐操作段落
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.9: 提取 /tdd/tests.md 到 reference-tdd-tests.md [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/reference-tdd-tests.md` (Create)
- **RED**: 编写测试验证文件存在且含来源标注
  ```
  验证文件存在
  验证包含来源标注（skills/engineering/tdd/tests.md）
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 读取 `ai-tools/skills/skills/engineering/tdd/tests.md`，提取好/坏测试判断标准，写入 reference-tdd-tests.md
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 2.10: 提取 /tdd/mocking.md 到 reference-tdd-mocking.md [spec:sdd-test-code#PARTIAL 场景的 TDD 补全]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/reference-tdd-mocking.md` (Create)
- **RED**: 编写测试验证文件存在且含来源标注
  ```
  验证文件存在
  验证包含来源标注（skills/engineering/tdd/mocking.md）
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 读取 `ai-tools/skills/skills/engineering/tdd/mocking.md`，提取仅 mock 系统边界原则，写入 reference-tdd-mocking.md
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

--- checkpoint ---

## 批次 4/7：sdd-plan 分批生成改造

<!-- 依赖：批次 1 完成（schema 注册） -->
<!-- 任务范围：3.1-3.8 -->

### Task 3.1: sdd-plan 前置逻辑增加任务规模检测 [spec:sdd-plan#小型任务正常生成完整 plan]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含规模判断（≤10/11-25/>25）
  ```
  验证包含"小型"（≤10）、"中型"（11-25）、"大型"（>25）三级判断
  验证小型 → 正常生成
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑中增加任务计数和三级规模判断
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.2: 中型任务提示选择模式 [spec:sdd-plan#中型任务提示用户选择模式]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证中型判断包含用户选择提示
  ```
  验证包含"一次性生成"和"分批生成"选项
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在中型判断分支中增加提示文字和两个选项描述
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.3: 大型任务强建议拆分或分批 [spec:sdd-plan#大型任务强制建议拆分或分批]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证大型判断包含强建议和两个选项
  ```
  验证包含"拆分为多个 change"选项
  验证包含"分批生成"选项
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在大型判断分支中增强建议文字和两个选项描述
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.4: 分批生成逻辑 + checkpoint 格式 [spec:sdd-plan#分批模式逐批生成流程]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证核心执行包含分批逻辑
  ```
  验证包含"每批 5-10 个任务"
  验证包含"按依赖关系分组"
  验证包含"checkpoint"格式
  验证包含"逐批生成"流程
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在核心执行段落中增加分批模式的详细流程描述和 plan.md 批次格式模板
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.5: 拆分 change 提示 [spec:sdd-plan#用户选择拆分 change 时的提示]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证包含拆分 change 提示
  ```
  验证包含"/sdd-propose"回退建议
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在大型分支的拆分选项中增加提示文字和 /sdd-propose 建议
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.6: 分批模式 reviewer [spec:sdd-plan#分批模式下的 reviewer 审查]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证后置逻辑包含分批审查
  ```
  验证包含"按批次独立审查"
  验证包含"跨批次依赖一致性"
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在后置逻辑的 review 段落中增加分批审查策略
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.7: sdd-plan 增加前置校验 [spec:pre-validation#阻断级缺失 — 拒绝执行并输出修复建议]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含校验
  ```
  验证包含 tasks.md 存在性检查
  验证包含 spec 存在性检查
  验证包含阻断条件描述
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑开头增加前置校验段落（阻断：tasks 或 spec 不存在）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 3.8: sdd-plan 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 编写测试验证后置逻辑包含推荐
  ```
  验证包含 ★ /sdd-code
  验证包含 ○ /sdd-review-spec
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在后置逻辑末尾增加推荐操作段落
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

--- checkpoint ---

## 批次 5/7：sdd-doctor 复杂度评估

<!-- 依赖：批次 1 完成（schema 注册） -->
<!-- 任务范围：4.1-4.7 -->

### Task 4.1: sdd-doctor 增加复杂度评估段落 [spec:sdd-doctor#有 spec/tasks 时评估复杂度评级]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证 sdd-doctor 包含复杂度评估逻辑
  ```
  验证包含五维度评估（spec 场景、tasks 数量、影响文件数、领域数、外部依赖）
  验证包含 S/M/L 评级规则
  验证包含"就高不就低"规则
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在 sdd-doctor SKILL.md 中增加复杂度评估段落，包含五维度和评级规则
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 4.2: 纯环境诊断保持原有行为 [spec:sdd-doctor#纯环境诊断保持原有行为]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证无 change 时不评估复杂度
  ```
  验证包含"无活跃变更"判断
  验证包含"跳过复杂度评估"
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 确保无 change 路径不执行复杂度评估，仅输出原有诊断
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 4.3: 无 spec/tasks 时仅输出环境状态 [spec:sdd-doctor#有 change 但无 spec/tasks 时仅输出环境状态]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证缺少制品时跳过评估
  ```
  验证包含"缺少 specs/ 和 tasks.md"判断
  验证包含根据缺失制品推荐下一步
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 增加分支：有 change 但无 specs/tasks → 跳过评估 → 推荐下一步
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 4.4: 简单(S)推荐 /sdd-quick [spec:sdd-doctor#简单(S)评级时推荐 /sdd-quick 路径]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证 S 级推荐包含 /sdd-quick
  ```
  验证简单(S)推荐包含 /sdd-quick
  验证包含标准路径作为可选
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在路径推荐段落中增加 S 级推荐内容
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 4.5: 中等(M)推荐标准路径 [spec:sdd-doctor#中等(M)评级时推荐标准路径]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证 M 级推荐标准路径
  ```
  验证中等(M)推荐包含 /sdd-propose → /sdd-ff → /sdd-plan → /sdd-code
  验证标注可跳过 brainstorm
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在路径推荐段落中增加 M 级推荐内容
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 4.6: 复杂(L)推荐完整流程 [spec:sdd-doctor#复杂(L)评级时推荐完整流程]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证 L 级推荐完整流程
  ```
  验证复杂(L)推荐包含完整流程（brainstorm → ship）
  验证包含分批生成提示
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在路径推荐段落中增加 L 级推荐内容
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 4.7: sdd-doctor 增加后置推荐 [spec:recommendation#sdd-doctor 完成后输出路径推荐]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含 ★ 按复杂度推荐
  ```
  验证包含 ★ 推荐格式
  验证包含 ○ 手动选择起点
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在后置逻辑末尾增加推荐操作段落
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

--- checkpoint ---

## 批次 6/7：前置校验（所有 action）

<!-- 依赖：批次 4、5 完成（sdd-plan 和 sdd-doctor 已改造，前置校验模式已验证） -->
<!-- 任务范围：5.1-5.8 -->

### Task 5.1: sdd-brainstorm 增加前置校验 [spec:pre-validation#校验通过 — 无前置依赖的 action]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写测试验证前置逻辑包含校验段落
  ```
  验证包含"前置校验"描述
  验证标注无前置依赖，直接通过
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑开头增加简短校验段落（无前置依赖 → 通过）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.2: sdd-propose 增加前置校验 [spec:pre-validation#警告级缺失 — 提示缺失项，用户可强制继续]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **RED**: 编写测试验证包含警告级校验
  ```
  验证包含 brainstorm 关键决策空项检查
  验证包含警告提示和强制继续选项
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加：brainstorm 存在但决策有空项 → 警告 → 可强制继续
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.3: sdd-ff 增加前置校验 [spec:pre-validation#sdd-ff 阻断 — proposal 不存在]

- **文件**: `ai-tools-bridge/skills/sdd-ff/SKILL.md` (Modify)
- **RED**: 编写测试验证包含阻断和警告级校验
  ```
  验证包含 proposal 不存在 → 阻断
  验证包含影响分析为空 → 警告
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加：proposal 不存在 → 阻断；影响分析为空 → 警告
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.4: sdd-code 增加前置校验 [spec:pre-validation#sdd-code 阻断 — tasks 不存在]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写测试验证包含阻断和警告级校验
  ```
  验证包含 tasks 不存在 → 阻断
  验证包含 >15 任务无 plan → 警告
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加：tasks 不存在 → 阻断；>15 任务无 plan → 警告
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.5: sdd-review-code 增加前置校验 [spec:pre-validation#阻断级缺失 — 拒绝执行并输出修复建议]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 编写测试验证包含阻断和警告级校验
  ```
  验证包含无代码变更或无 spec → 阻断
  验证包含场景数 < tasks 数 → 警告
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加校验段落
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.6: sdd-verify 增加前置校验 [spec:pre-validation#sdd-verify 阻断 — spec 或代码不存在]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **RED**: 编写测试验证包含阻断校验
  ```
  验证包含 spec 或代码不存在 → 阻断
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加：spec 或代码不存在 → 阻断
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.7: sdd-ship 增加前置校验 [spec:pre-validation#sdd-ship 阻断 — verify 未执行]

- **文件**: `ai-tools-bridge/skills/sdd-ship/SKILL.md` (Modify)
- **RED**: 编写测试验证包含阻断和警告级校验
  ```
  验证包含 verify 未执行 → 阻断
  验证包含未通过 review → 警告
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加：verify 未执行 → 阻断；有未通过 review → 警告
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 5.8: sdd-continue 增加前置校验 [spec:pre-validation#校验通过 — 无前置依赖的 action]

- **文件**: `ai-tools-bridge/skills/sdd-continue/SKILL.md` (Modify)
- **RED**: 编写测试验证包含校验段落
  ```
  验证包含"前置校验"描述
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在前置逻辑增加简短校验段落
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

--- checkpoint ---

## 批次 7/7：推荐操作（所有 action）+ 文档

<!-- 依赖：批次 6 完成（所有 action 已有前置校验） -->
<!-- 任务范围：6.1-6.9, 7.3-7.5 -->

### Task 6.1: sdd-brainstorm 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含推荐
  ```
  验证包含 ★ /sdd-propose
  验证包含 ○ /sdd-ff
  验证包含 △ /sdd-quick
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在后置逻辑末尾修改完成引导为包含 ★○△ 推荐的格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.2: sdd-propose 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含推荐
  ```
  验证包含 ★ /sdd-ff
  验证包含 ○ /sdd-plan
  验证包含 △ /sdd-brainstorm
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.3: sdd-ff 增加后置推荐（含复杂度动态） [spec:recommendation#sdd-ff 完成后根据复杂度动态推荐]

- **文件**: `ai-tools-bridge/skills/sdd-ff/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含动态推荐
  ```
  验证包含 ★ /sdd-plan [M/L] 或 /sdd-code [S]（根据复杂度）
  验证包含 ○ /sdd-review-spec
  验证包含 △ /sdd-quick
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导，增加复杂度判断逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.4: sdd-code 增加后置推荐 [spec:recommendation#sdd-code 完成后输出 ★○△ 推荐操作]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含动态推荐
  ```
  验证包含 ★ /sdd-review-code [M/L] 或 /sdd-ship [S]
  验证包含 ○ /sdd-verify
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导，增加复杂度判断逻辑
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.5: sdd-review-code 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含推荐
  ```
  验证包含 ★ /sdd-test-code
  验证包含 ○ /sdd-code
  验证包含 △ /sdd-ship
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.6: sdd-review-spec 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含推荐
  ```
  验证包含 ★ /sdd-propose
  验证包含 ○ /sdd-ff
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.7: sdd-verify 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含推荐
  ```
  验证包含 ★ /sdd-ship
  验证包含 ○ /sdd-code
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导格式
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.8: sdd-ship 增加后置推荐（无后续） [spec:recommendation#sdd-ship 完成后无后续推荐]

- **文件**: `ai-tools-bridge/skills/sdd-ship/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含完成提示
  ```
  验证包含"变更已完成，无后续操作"
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导为"变更已完成，无后续操作"
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 6.9: sdd-continue 增加后置推荐 [spec:recommendation#所有 action 推荐格式一致性]

- **文件**: `ai-tools-bridge/skills/sdd-continue/SKILL.md` (Modify)
- **RED**: 编写测试验证后置包含动态推荐
  ```
  验证包含按当前进度动态推荐逻辑
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 修改完成引导，根据当前 artifact 进度动态推荐
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 7.3: README 增加内联引用标注表 [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/README.md` (Modify)
- **RED**: 编写测试验证 README 包含内联引用节
  ```
  验证包含"内联引用"节
  验证包含 4 个 reference 文件的来源标注
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在 README 中增加内联引用标注表
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 7.4: README 增加路径推荐说明 [spec:sdd-doctor#简单(S)评级时推荐 /sdd-quick 路径]

- **文件**: `ai-tools-bridge/README.md` (Modify)
- **RED**: 编写测试验证 README 包含路径推荐节
  ```
  验证包含 S/M/L 三级路径表
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 在 README 中增加路径推荐说明（S/M/L 路径表）
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

### Task 7.5: README 更新 action 列表和版本号 [spec:sdd-quick#简单需求从零开始走 quick 全流程]

- **文件**: `ai-tools-bridge/README.md` (Modify)
- **文件**: `ai-tools-bridge/.claude-plugin/plugin.json` (Modify)
- **RED**: 编写测试验证版本号和 action 列表已更新
  ```
  验证 README 中 action 列表包含 sdd-quick 和 sdd-test-code（共 13 个）
  验证 plugin.json 或 README 包含版本号 v0.3.0
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm test`
- **GREEN**: 更新 README action 列表（11→13）和版本号，更新 plugin.json 版本号
- **运行验证通过**: `cd ai-tools-bridge && pnpm test`

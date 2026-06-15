# Plan: fix-skill-review-issues

> 实施计划 — TDD 级别的详细步骤

---

## 批次一

> 批次一内任务顺序执行（Task 1.2-1.5 依赖 Task 1.1 创建的 Phase 3 章节）

### Task 1.1: 在后置逻辑中添加 Phase 3 交互式修复阶段 [spec:sdd-review-code#完整审查流程]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证 Phase 3 章节不存在
  ```bash
  # 前置确认：读取后置逻辑章节，确认当前不含交互式修复
  grep -A 10 "## 后置逻辑" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证：后置逻辑中无 Phase 3 章节标题
  grep -c "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 预期：返回 0
  ```
- **运行验证失败**: `grep -c "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md`
- **GREEN**: 最小实现
  - 在后置逻辑的 `### 2. 输出审查报告` **之后**添加 `### 3. 交互式修复（条件执行）` 章节
  - 包含触发条件：`仅在 Phase 2 发现 Important 或 Minor issues 时执行`
  - 包含跳过条件：`Phase 2 未发现问题或用户选择跳过`
  - 引用 interactive-fix spec 的完整流程
- **运行验证通过**:
  ```bash
  # 验证章节存在
  grep -c "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证章节顺序正确（Phase 3 在 Phase 2 之后）
  grep -n "### [23]\." ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证触发条件
  grep -c "Important 或 Minor issues" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  ```

### Task 1.2: 添加问题解析逻辑（从 review 文件提取问题列表） [spec:interactive-fix#显示问题详情]

- **依赖**: Task 1.1
- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证问题解析逻辑不存在
  ```bash
  # 前置确认：Phase 3 章节已存在
  grep -c "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证：Phase 3 章节内无问题解析描述
  grep -A 20 "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md | grep -c "提取问题"
  # 预期：返回 0
  ```
- **运行验证失败**: `grep -A 20 "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md | grep -c "提取问题"`
- **GREEN**: 最小实现
  - 在 Phase 3 章节中添加问题解析描述：
    - 从 `reviews/code-quality-r<N>.md` 提取问题列表
    - 解析内容：问题标题、文件位置、问题描述、修复建议
    - 按 severity 排序（Important > Minor）
- **运行验证通过**:
  ```bash
  # 验证问题解析逻辑存在
  grep -A 20 "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md | grep -c "提取问题"
  # 验证解析内容完整性（4 个要素）
  grep -c "问题标题" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "文件位置" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "问题描述" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "修复建议" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  ```

### Task 1.3: 添加交互循环（逐个问题询问处理方式） [spec:interactive-fix#提供处理选项]

- **依赖**: Task 1.2
- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证交互循环逻辑不存在
  ```bash
  # 前置确认：问题解析逻辑已存在
  grep -A 20 "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md | grep -c "提取问题"
  # 验证：无交互循环描述
  grep -c "逐个问题询问" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 预期：返回 0
  ```
- **运行验证失败**: `grep -c "逐个问题询问" ai-tools-bridge/skills/sdd-review-code/SKILL.md`
- **GREEN**: 最小实现
  - 添加交互循环描述：
    - 显示问题详情（标题、文件位置、描述、建议）
    - 提供 4 个选项：自动修复、手动修复、跳过、标记为已修复
    - 记录用户选择并继续下一个问题
- **运行验证通过**:
  ```bash
  # 验证交互循环描述
  grep -c "逐个问题询问" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证 4 个选项完整（使用 -E 扩展正则）
  grep -Ec "自动修复|手动修复|跳过|标记为已修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 预期：返回 ≥4
  ```

### Task 1.4: 添加自动修复和手动修复逻辑 [spec:interactive-fix#自动修复执行]

- **依赖**: Task 1.3
- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证修复执行逻辑不存在
  ```bash
  # 前置确认：交互循环已存在
  grep -c "逐个问题询问" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证：无自动修复执行逻辑
  grep -A 30 "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md | grep -c "按建议修改"
  # 预期：返回 0
  ```
- **运行验证失败**: `grep -A 30 "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md | grep -c "按建议修改"`
- **GREEN**: 最小实现
  - **需覆盖的 Spec 场景**:
    - [spec:interactive-fix#自动修复执行] 自动修复成功 → 输出已修复，标记已处理
    - [spec:interactive-fix#自动修复执行] 自动修复失败 → 降级为手动修复
    - [spec:interactive-fix#手动修复执行] 显示修复指引 → 等待确认
    - [spec:interactive-fix#手动修复执行] 用户修改不完整 → 提示缺失项，询问忽略/重新修改
  - 自动修复逻辑：
    - 按建议修改文件（对照 `skills/_shared/sdd-flow-guidance.md` 模板）
    - 成功 → 输出"已修复"，标记已处理，继续下一个
    - 失败 → 输出错误信息，降级为手动修复选项
  - 手动修复逻辑：
    - 显示修复指引（文件路径、修改位置、预期内容）
    - 提示"修改完成后按回车继续"
    - 验证修改完成 → 标记已处理，继续下一个
    - 验证不完整 → 提示缺失项，询问忽略/重新修改
- **运行验证通过**:
  ```bash
  # 验证自动修复逻辑
  grep -Ec "自动修复|按建议修改" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证降级路径
  grep -c "降级为手动修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证手动修复逻辑
  grep -Ec "手动修复|修复指引" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证修改不完整场景
  grep -c "修改不完整\|缺失项" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  ```

### Task 1.5: 添加跳过、标记和修复完成汇总逻辑 [spec:interactive-fix#修复完成汇总]

- **依赖**: Task 1.4
- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证跳过/标记/汇总逻辑不存在
  ```bash
  # 前置确认：修复执行逻辑已存在
  grep -c "自动修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证：无修复汇总
  grep -c "修复汇总" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 预期：返回 0
  ```
- **运行验证失败**: `grep -c "修复汇总" ai-tools-bridge/skills/sdd-review-code/SKILL.md`
- **GREEN**: 最小实现
  - 跳过逻辑：记录已跳过，输出"已跳过"，继续下一个
  - 标记逻辑：记录已标记，输出"已标记（稍后处理）"，继续下一个
  - 修复完成汇总：
    - 输出总问题数、已修复数（自动+手动）、已跳过数、已标记数
    - 存在已标记问题时列出标题和文件位置，提示稍后处理
    - 输出完成引导
- **运行验证通过**:
  ```bash
  # 验证汇总逻辑
  grep -c "修复汇总" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 验证汇总内容完整性
  grep -Ec "总问题数|已修复数|已跳过数|已标记数" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  # 预期：返回 ≥4
  # 验证跳过和标记逻辑
  grep -Ec "已跳过|已标记" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  ```

---

## 批次二

> 批次二内任务顺序执行（Task 2.2 依赖 Task 2.1 创建的交互式修复章节）

### Task 2.1: 在后置逻辑中添加交互式修复阶段 [spec:sdd-review-spec#完整审查流程]

- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证交互式修复章节不存在
  ```bash
  # 前置确认：读取后置逻辑章节
  grep -A 10 "## 后置逻辑" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 验证：后置逻辑中无交互式修复章节
  grep -c "### .*交互式修复" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 预期：返回 0（排除跨 spec 引用注释）
  ```
- **运行验证失败**: `grep -c "### .*交互式修复" ai-tools-bridge/skills/sdd-review-spec/SKILL.md`
- **GREEN**: 最小实现
  - 在后置逻辑的 `### 2. 输出审查报告` **之后**添加交互式修复章节
  - 触发条件：spec 审查发现 Important 或 Minor issues
  - 跳过条件：spec 审查未发现问题或用户选择跳过
  - 引用 interactive-fix spec 的完整流程
- **运行验证通过**:
  ```bash
  # 验证章节存在
  grep -c "### .*交互式修复" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 验证章节顺序
  grep -n "### [23]\." ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 验证触发条件
  grep -c "Important 或 Minor issues" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  ```

### Task 2.2: 复用 sdd-review-code 的问题解析和修复逻辑 [spec:interactive-fix#逐个问题交互]

- **依赖**: Task 2.1
- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Modify)
- **RED**: 前置确认 + 验证问题解析逻辑不存在
  ```bash
  # 前置确认：交互式修复章节已存在
  grep -c "### .*交互式修复" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 验证：无问题解析描述
  grep -c "提取问题" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 预期：返回 0
  ```
- **运行验证失败**: `grep -c "提取问题" ai-tools-bridge/skills/sdd-review-spec/SKILL.md`
- **GREEN**: 最小实现
  - 添加问题解析描述：
    - 从 `reviews/spec-r<N>.md` 提取问题列表
    - 复用 sdd-review-code 的交互循环和修复执行逻辑
  - 验证引用了相同的 4 个选项
- **运行验证通过**:
  ```bash
  # 验证问题解析逻辑
  grep -c "提取问题" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 验证 4 个选项完整
  grep -Ec "自动修复|手动修复|跳过|标记为已修复" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  # 预期：返回 ≥4
  ```

---

## 批次三：集成验证

### Task 3.1: 运行 ai-tools-bridge 测试套件

- **文件**: `ai-tools-bridge/` (Verify)
- **验证命令**: `cd ai-tools-bridge && pnpm test`
- **预期**: 所有测试通过（schema 验证、模板验证）
- **失败处理**: 检查测试输出，修复格式或结构问题

### Task 3.2: 验证 sdd-review-code SKILL.md 结构完整性

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Verify)
- **验证命令**:
  ```bash
  # 验证 YAML 前置元数据格式正确（前 5 行应包含 ---）
  head -5 ai-tools-bridge/skills/sdd-review-code/SKILL.md

  # 验证三大章节结构
  grep -c "## 前置逻辑" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "## 核心执行" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "## 后置逻辑" ai-tools-bridge/skills/sdd-review-code/SKILL.md

  # 验证后置逻辑包含 Phase 1/2/3
  grep -c "### 1\. 汇总审查结果" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "### 3\. 交互式修复" ai-tools-bridge/skills/sdd-review-code/SKILL.md

  # 验证标题层级正确（无跳级）
  grep "^#" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  ```

### Task 3.3: 验证 sdd-review-spec SKILL.md 结构完整性

- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Verify)
- **验证命令**:
  ```bash
  head -5 ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  grep -c "## 前置逻辑" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  grep -c "## 核心执行" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  grep -c "## 后置逻辑" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  grep -c "### .*交互式修复" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  grep "^#" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  ```

### Task 3.4: 验证 spec 场景覆盖完整性

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md`, `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Verify)
- **验证命令**:
  ```bash
  # sdd-review-code 应覆盖 interactive-fix 的所有场景
  grep -Ec "自动修复|手动修复|跳过|标记" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "修复汇总" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "降级" ai-tools-bridge/skills/sdd-review-code/SKILL.md
  grep -c "修改不完整" ai-tools-bridge/skills/sdd-review-code/SKILL.md

  # sdd-review-spec 应覆盖触发/跳过条件
  grep -c "Important 或 Minor issues" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  grep -Ec "未发现问题|用户选择跳过" ai-tools-bridge/skills/sdd-review-spec/SKILL.md
  ```

---

<!-- 格式说明:
  - 批次一/二：实现任务，每个任务有 RED(前置确认)/GREEN 步骤
  - 批次三：集成验证，从测试、结构、覆盖三个维度验证
  - 粒度：2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
  - 批次内任务顺序执行（存在文件依赖）
-->

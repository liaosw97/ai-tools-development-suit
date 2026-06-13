# Plan: fix-opsx-flow-bleed

> 实施计划 — TDD 级别的详细步骤

---

## 批次一：模板设计

### Task 1.1: 设计统一的 SDD 流程指引模板格式 [spec:sdd-post-logic-enhancement#Visual separator format]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Create)
- **RED**: 验证各 SKILL.md 的流程指引格式不一致（功能失败：用户在不同 action 看到不同格式的指引）
  ```bash
  # 检查是否有共享模板文件供各 SKILL.md 引用
  ls ai-tools-bridge/skills/_shared/sdd-flow-guidance.md 2>/dev/null && echo "EXISTS" || echo "NOT EXISTS"
  ```
- **运行验证失败**: `NOT EXISTS`（导致格式不一致）
- **GREEN**: 创建共享模板文件，包含格式规范和各 action 的下一步建议
- **运行验证通过**: `ls ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

### Task 1.2: 为 6 个调用 OPSX 的 SDD action 定义下一步建议内容 [spec:sdd-post-logic-enhancement#Post-propose guidance shows document generation options]

- **文件**: `ai-tools-bridge/skills/_shared/sdd-flow-guidance.md` (Modify)
- **RED**: 验证模板中无各 action 的下一步建议（功能失败：各 SKILL.md 需要独立定义，维护成本高）
  ```bash
  grep "sdd-propose" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md || echo "NOT FOUND"
  ```
- **运行验证失败**: `NOT FOUND`（导致各 SKILL.md 需独立定义）
- **GREEN**: 在模板中添加各 action 的下一步建议（含 sdd-quick 两种场景）
- **运行验证通过**: `grep "sdd-propose" ai-tools-bridge/skills/_shared/sdd-flow-guidance.md`

---

## 批次二：修改 SDD action 后置逻辑

### Task 2.1: 修改 sdd-propose/SKILL.md — 添加 SDD 流程指引 [spec:sdd-post-logic-enhancement#User completes sdd-propose and sees SDD flow guidance]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-propose 后看不到 SDD 流程指引（功能失败）
  ```bash
  # 检查"完成引导"部分是否包含 SDD 流程指引
  grep -A 30 "### 3. 完成引导" ai-tools-bridge/skills/sdd-propose/SKILL.md | grep "SDD 流程指引" || echo "功能缺失：用户看不到 SDD 流程指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引
- **运行验证通过**: `grep -A 30 "### 3. 完成引导" ai-tools-bridge/skills/sdd-propose/SKILL.md | grep "SDD 流程指引"`

### Task 2.2: 修改 sdd-continue/SKILL.md — 添加 SDD 流程指引 [spec:sdd-post-logic-enhancement#User completes sdd-continue and sees SDD flow guidance]

- **文件**: `ai-tools-bridge/skills/sdd-continue/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-continue 后看不到 SDD 流程指引（功能失败）
  ```bash
  grep -A 30 "### 2. 完成引导" ai-tools-bridge/skills/sdd-continue/SKILL.md | grep "SDD 流程指引" || echo "功能缺失：用户看不到 SDD 流程指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引
- **运行验证通过**: `grep -A 30 "### 2. 完成引导" ai-tools-bridge/skills/sdd-continue/SKILL.md | grep "SDD 流程指引"`

### Task 2.3: 修改 sdd-ff/SKILL.md — 添加 SDD 流程指引 [spec:sdd-post-logic-enhancement#User completes sdd-ff and sees SDD flow guidance]

- **文件**: `ai-tools-bridge/skills/sdd-ff/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-ff 后看不到 SDD 流程指引（功能失败）
  ```bash
  grep -A 30 "### 2. 完成引导" ai-tools-bridge/skills/sdd-ff/SKILL.md | grep "SDD 流程指引" || echo "功能缺失：用户看不到 SDD 流程指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引
- **运行验证通过**: `grep -A 30 "### 2. 完成引导" ai-tools-bridge/skills/sdd-ff/SKILL.md | grep "SDD 流程指引"`

### Task 2.4: 修改 sdd-verify/SKILL.md — 添加 SDD 流程指引 [spec:sdd-post-logic-enhancement#User completes sdd-verify and sees SDD flow guidance]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-verify 后看不到 SDD 流程指引（功能失败）
  ```bash
  grep "SDD 流程指引" ai-tools-bridge/skills/sdd-verify/SKILL.md || echo "功能缺失：用户看不到 SDD 流程指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引
- **运行验证通过**: `grep "SDD 流程指引" ai-tools-bridge/skills/sdd-verify/SKILL.md`

### Task 2.5: 修改 sdd-ship/SKILL.md — 添加 SDD 流程指引 [spec:sdd-post-logic-enhancement#User completes sdd-ship and sees SDD flow guidance]

- **文件**: `ai-tools-bridge/skills/sdd-ship/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-ship 后看不到 SDD 流程指引（功能失败）
  ```bash
  grep "SDD 流程指引" ai-tools-bridge/skills/sdd-ship/SKILL.md || echo "功能缺失：用户看不到 SDD 流程指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引（仅显示"流程完成，变更已归档"）
- **运行验证通过**: `grep "SDD 流程指引" ai-tools-bridge/skills/sdd-ship/SKILL.md`

### Task 2.6: 修改 sdd-quick/SKILL.md — 添加 SDD 流程指引（完整实现场景） [spec:sdd-post-logic-enhancement#User completes sdd-quick with all artifacts generated]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-quick（完整实现）后看不到推荐 /sdd-ship 的指引（功能失败）
  ```bash
  grep "SDD 流程指引" ai-tools-bridge/skills/sdd-quick/SKILL.md || echo "功能缺失：用户看不到 SDD 流程指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引（完整实现场景：推荐 /sdd-ship）
- **运行验证通过**: `grep "SDD 流程指引" ai-tools-bridge/skills/sdd-quick/SKILL.md`

### Task 2.7: 修改 sdd-quick/SKILL.md — 添加 SDD 流程指引（不完整实现场景） [spec:sdd-post-logic-enhancement#User completes sdd-quick with incomplete implementation]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **RED**: 验证用户执行 /sdd-quick（不完整实现）后看不到推荐 /sdd-verify 的指引（功能失败）
  ```bash
  grep "sdd-verify" ai-tools-bridge/skills/sdd-quick/SKILL.md || echo "功能缺失：用户看不到推荐 /sdd-verify 的指引"
  ```
- **运行验证失败**: `功能缺失：用户看不到推荐 /sdd-verify 的指引`
- **GREEN**: 在"完成引导"部分添加 SDD 流程指引（不完整实现场景：推荐 /sdd-verify）
- **运行验证通过**: `grep "sdd-verify" ai-tools-bridge/skills/sdd-quick/SKILL.md`

### Task 2.8: 修改 sdd-propose/SKILL.md — 添加 OPSX 失败容错 [spec:sdd-post-logic-enhancement#OPSX command fails during sdd-propose]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **RED**: 验证当 OPSX 命令失败时，用户看不到错误恢复指引（功能失败）
  ```bash
  grep "OPSX.*失败\|openspec.*不可用\|错误处理" ai-tools-bridge/skills/sdd-propose/SKILL.md || echo "功能缺失：OPSX 失败时无恢复指引"
  ```
- **运行验证失败**: `功能缺失：OPSX 失败时无恢复指引`
- **GREEN**: 在核心执行部分添加 OPSX 失败容错逻辑
- **运行验证通过**: `grep "OPSX.*失败\|openspec.*不可用\|错误处理" ai-tools-bridge/skills/sdd-propose/SKILL.md`

---

## 批次三：更新项目文档

### Task 3.1: 更新 CLAUDE.md — 添加 SDD 流程独立性说明 [spec:sdd-post-logic-enhancement#CLAUDE.md contains SDD flow explanation]

- **文件**: `ai-tools-bridge/CLAUDE.md` (Modify)
- **RED**: 验证用户阅读 CLAUDE.md 时看不到 SDD 流程独立性说明（功能失败）
  ```bash
  grep "SDD 流程独立性" ai-tools-bridge/CLAUDE.md || echo "功能缺失：用户看不到 SDD 流程独立性说明"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD 流程独立性说明`
- **GREEN**: 在 CLAUDE.md 中添加"SDD 流程独立性"和"误操作恢复"段落
- **运行验证通过**: `grep "SDD 流程独立性" ai-tools-bridge/CLAUDE.md`

### Task 3.2: 更新 README.md — 添加 SDD vs OPSX 使用指南 [spec:sdd-post-logic-enhancement#README.md contains SDD vs OPSX usage guidance]

- **文件**: `ai-tools-bridge/README.md` (Modify)
- **RED**: 验证用户阅读 README.md 时看不到 SDD vs OPSX 对比说明（功能失败）
  ```bash
  grep "SDD 流程 vs OPSX" ai-tools-bridge/README.md || echo "功能缺失：用户看不到 SDD vs OPSX 对比说明"
  ```
- **运行验证失败**: `功能缺失：用户看不到 SDD vs OPSX 对比说明`
- **GREEN**: 在 README.md 中添加"SDD 流程 vs OPSX 命令"对比说明
- **运行验证通过**: `grep "SDD 流程 vs OPSX" ai-tools-bridge/README.md`

---

## 批次四：验证

### Task 4.1: 运行现有测试确保格式正确性 [spec:sdd-post-logic-enhancement#Visual separator format]

- **文件**: 无
- **验证步骤**: 运行测试确保修改不破坏现有功能
  ```bash
  cd ai-tools-bridge && pnpm test
  ```
- **运行验证通过**: 所有测试通过

### Task 4.2: 手动测试 /sdd-propose 流程验证 SDD 流程指引显示正确 [spec:sdd-post-logic-enhancement#User completes sdd-propose and sees SDD flow guidance]

- **文件**: 无
- **风险标记**: ⚠️ 高风险 — 手动测试，依赖人工验证
- **RED**: 验证当前 /sdd-propose 输出无 SDD 流程指引（功能失败）
  ```bash
  # 手动执行 /sdd-propose 并检查输出
  # 预期：输出末尾应包含 SDD 流程指引
  ```
- **运行验证失败**: 输出中无 SDD 流程指引
- **GREEN**: 执行 /sdd-propose 并验证输出包含 SDD 流程指引
  ```bash
  # 手动执行 /sdd-propose
  # 检查输出末尾是否包含：
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # SDD 流程指引（请忽略上方可能显示的 OPSX 建议）
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ```
- **运行验证通过**: 输出中包含 SDD 流程指引

### Task 4.3: 验证 6 个 SKILL.md 的一致性 [design:Decision 1]

- **文件**: 无
- **RED**: 验证 6 个 SKILL.md 的 SDD 流程指引格式不一致（功能失败）
  ```bash
  # 检查所有 6 个 SKILL.md 是否都包含 SDD 流程指引
  for skill in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
    grep "SDD 流程指引" ai-tools-bridge/skills/$skill/SKILL.md > /dev/null || echo "$skill: 功能缺失"
  done
  ```
- **运行验证失败**: 有 skill 缺少 SDD 流程指引
- **GREEN**: 确保所有 6 个 SKILL.md 都包含一致的 SDD 流程指引格式
  ```bash
  # 检查所有 6 个 SKILL.md 是否都包含 SDD 流程指引
  for skill in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
    grep "SDD 流程指引" ai-tools-bridge/skills/$skill/SKILL.md > /dev/null && echo "$skill: OK" || echo "$skill: MISSING"
  done
  ```
- **运行验证通过**: 所有 6 个 skill 都包含 SDD 流程指引

---

<!-- 格式说明:
  - 每个任务必须有 RED/GREEN 步骤（TDD 铁律）
  - RED 步骤验证"功能失败"（用户看不到预期行为），而非"文件不存在"
  - 每个步骤有具体的运行验证命令
  - 粒度: 2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
-->

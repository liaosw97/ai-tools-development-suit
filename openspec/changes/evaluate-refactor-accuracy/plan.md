# Plan: evaluate-refactor-accuracy

> 实施计划 — TDD 级别的详细步骤

---

## 批次一：静态 Diff 分析

### Task 1.1: 执行静态 Diff 分析，获取重构前后的 skill 变更 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-skills.patch` (Create)
- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-roles.patch` (Create)
- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-lib.patch` (Create)
- **RED**: 验证 git diff 命令可执行
  ```bash
  git diff 4c20a61..ebd11c9 --stat
  ```
- **运行验证失败**: `git diff 4c20a61..ebd11c9 --stat` 输出为空或报错
- **GREEN**: 执行 git diff 获取 skill 变更
  ```bash
  git diff 4c20a61..ebd11c9 -- skills/ > openspec/changes/evaluate-refactor-accuracy/diff-skills.patch
  git diff 4c20a61..ebd11c9 -- roles/ > openspec/changes/evaluate-refactor-accuracy/diff-roles.patch
  git diff 4c20a61..ebd11c9 -- lib/ > openspec/changes/evaluate-refactor-accuracy/diff-lib.patch
  ```
- **运行验证通过**: `ls -la openspec/changes/evaluate-refactor-accuracy/diff-*.patch` 文件存在且非空

### Task 1.2: 分析 SKILL.md 主文件变更 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` (Create)
- **RED**: 验证 diff-skills.patch 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/diff-skills.patch
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 提取 SKILL.md 主文件变更
  ```bash
  grep "^diff --git.*SKILL.md" openspec/changes/evaluate-refactor-accuracy/diff-skills.patch | wc -l
  ```
  - 将变更文件列表写入 diff-analysis.md
  - 对每个 SKILL.md 文件，记录变更类型（ADDED/MODIFIED/REMOVED）
- **运行验证通过**: `grep -c "SKILL.md" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` 输出 > 0

### Task 1.3: 分析 modules/ 子模块变更 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` (Modify)
- **RED**: 验证 diff-skills.patch 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/diff-skills.patch
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 提取 modules/ 子模块变更
  ```bash
  grep "^diff --git.*modules/" openspec/changes/evaluate-refactor-accuracy/diff-skills.patch | wc -l
  ```
  - 将变更文件列表追加到 diff-analysis.md
  - 对每个模块文件，记录变更类型（ADDED/MODIFIED/REMOVED）
- **运行验证通过**: `grep -c "modules/" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` 输出 > 0

### Task 1.4: 分析 roles/ 角色系统变更 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` (Modify)
- **RED**: 验证 diff-roles.patch 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/diff-roles.patch
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 提取 roles/ 角色系统变更
  ```bash
  grep "^diff --git" openspec/changes/evaluate-refactor-accuracy/diff-roles.patch | wc -l
  ```
  - 将变更文件列表追加到 diff-analysis.md
  - 对每个角色文件，记录变更类型（ADDED/MODIFIED/REMOVED）
- **运行验证通过**: `grep -c "roles/" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` 输出 > 0

### Task 1.5: 使用检查清单验证 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` (Modify)
- **RED**: 验证 diff-analysis.md 包含变更记录
  ```bash
  grep -c "ADDED\|MODIFIED\|REMOVED" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md
  ```
- **运行验证失败**: 输出为 0
- **GREEN**: 对每个变更执行检查清单
  - 检查关键函数/逻辑是否保留：`grep -c "关键函数" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md`
  - 检查配置项是否完整：`grep -c "配置项" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md`
  - 检查错误处理是否一致：`grep -c "错误处理" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md`
  - 检查输出格式是否变更：`grep -c "输出格式" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md`
  - 将检查结果写入 diff-analysis.md
- **运行验证通过**: `grep -c "检查清单" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md` 输出 > 0

### Task 1.6: 产出变更清单 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/change-list.md` (Create)
- **RED**: 验证 diff-analysis.md 包含检查结果
  ```bash
  grep -c "检查清单" openspec/changes/evaluate-refactor-accuracy/diff-analysis.md
  ```
- **运行验证失败**: 输出为 0
- **GREEN**: 汇总变更清单
  - 列出所有变更的类型（ADDED/MODIFIED/REMOVED）
  - 标注是否为功能性变更
  - 记录功能性变更的理由
  - 写入 change-list.md
- **运行验证通过**: `test -s openspec/changes/evaluate-refactor-accuracy/change-list.md` 文件存在且非空

---

## 批次二：精度测试验证

### Task 2.1: 前置验证：检查现有测试覆盖范围 [spec:accuracy-evaluation#精度测试验证]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/test-coverage.md` (Create)
- **RED**: 验证测试文件存在
  ```bash
  ls tests/unit/summarizer.test.ts tests/unit/artifact-bridge.test.ts tests/unit/review-context.test.ts tests/unit/state-file.test.ts tests/precision/baseline.test.ts tests/precision/fixtures.test.ts
  ```
- **运行验证失败**: 任一文件不存在
- **GREEN**: 检查测试覆盖范围
  ```bash
  grep -c "it(" tests/unit/summarizer.test.ts
  grep -c "it(" tests/unit/artifact-bridge.test.ts
  grep -c "it(" tests/unit/review-context.test.ts
  grep -c "it(" tests/unit/state-file.test.ts
  grep -c "it(" tests/precision/baseline.test.ts
  grep -c "it(" tests/precision/fixtures.test.ts
  ```
  - 读取每个测试文件，提取测试用例数量
  - 对照 lib/ 目录的模块，确认覆盖范围
  - 写入 test-coverage.md
- **运行验证通过**: `test -s openspec/changes/evaluate-refactor-accuracy/test-coverage.md` 文件存在且非空

### Task 2.2: 运行精度测试 [spec:accuracy-evaluation#精度测试验证]

- **⚠️ 风险**: 可能因环境问题（Node.js 版本、依赖缺失）导致测试失败
- **文件**: `openspec/changes/evaluate-refactor-accuracy/test-output.txt` (Create)
- **RED**: 验证测试环境可用
  ```bash
  cd ai-tools-bridge && node --version && pnpm --version
  ```
- **运行验证失败**: 命令报错（确保当前工作目录为仓库根目录，包含 ai-tools-bridge/ 子目录）
- **GREEN**: 运行全部测试
  ```bash
  cd ai-tools-bridge && pnpm test 2>&1 | tee ../openspec/changes/evaluate-refactor-accuracy/test-output.txt
  ```
- **运行验证通过**: `grep -c "Tests" openspec/changes/evaluate-refactor-accuracy/test-output.txt` 输出 > 0

### Task 2.3: 分析测试结果 [spec:accuracy-evaluation#精度测试验证]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/test-results.md` (Create)
- **RED**: 验证测试输出存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/test-output.txt
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 分析测试结果
  ```bash
  grep "Tests" openspec/changes/evaluate-refactor-accuracy/test-output.txt
  grep "passed" openspec/changes/evaluate-refactor-accuracy/test-output.txt
  grep "failed" openspec/changes/evaluate-refactor-accuracy/test-output.txt
  ```
  - 从 test-output.txt 提取测试总数、通过数、失败数
  - 计算通过率（通过数/总数 × 100%）
  - 写入 test-results.md
- **运行验证通过**: `grep -c "通过率" openspec/changes/evaluate-refactor-accuracy/test-results.md` 输出 > 0

### Task 2.4: 产出精度报告 [spec:accuracy-evaluation#精度测试验证]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/precision-report.md` (Create)
- **RED**: 验证 test-results.md 包含通过率
  ```bash
  grep -c "通过率" openspec/changes/evaluate-refactor-accuracy/test-results.md
  ```
- **运行验证失败**: 输出为 0
- **GREEN**: 产出精度报告
  - 汇总测试通过率
  - 计算信息保留率（使用 calculateCoverage 函数）
  - 判断是否满足 ≥ 95% 的标准
  - 写入 precision-report.md
- **运行验证通过**: `grep -c "信息保留率" openspec/changes/evaluate-refactor-accuracy/precision-report.md` 输出 > 0

---

## 批次三：场景走查 - 简单变更

### Task 3.1: 准备简单变更场景 [spec:accuracy-evaluation#场景走查-简单变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/` (Create)
- **RED**: 验证 fixture 文件存在
  ```bash
  ls tests/fixtures/precision/simple-change/proposal.md tests/fixtures/precision/simple-change/specs/config-validation/spec.md tests/fixtures/precision/simple-change/tasks.md
  ```
- **运行验证失败**: 任一文件不存在
- **GREEN**: 复制场景数据到工作目录
  ```bash
  mkdir -p openspec/changes/evaluate-refactor-accuracy/walkthrough-simple
  cp -r tests/fixtures/precision/simple-change/* openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/
  ```
- **运行验证通过**: `test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/proposal.md` 文件存在

### Task 3.2: 验证 brainstorm 输出格式 [spec:accuracy-evaluation#场景走查-简单变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` (Create)
- **RED**: 验证场景数据准备完成
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/proposal.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 验证 brainstorm 输出格式
  - 检查 brainstorm.md 是否包含必需段落：
    ```bash
    grep -c "§需求描述" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/brainstorm.md
    grep -c "§方案探索" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/brainstorm.md
    grep -c "§关键决策" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/brainstorm.md
    ```
  - 将验证结果写入 results.md
- **运行验证通过**: `grep -c "brainstorm" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` 输出 > 0

### Task 3.3: 验证 proposal 决策追溯 [spec:accuracy-evaluation#场景走查-简单变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` (Modify)
- **RED**: 验证 results.md 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 验证 proposal 决策追溯
  - 检查 proposal.md 是否引用 brainstorm 决策：
    ```bash
    grep -c "brainstorm.md" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/proposal.md
    ```
  - 将验证结果追加到 results.md
- **运行验证通过**: `grep -c "proposal" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` 输出 > 0

### Task 3.4: 验证 plan spec 链接 [spec:accuracy-evaluation#场景走查-简单变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` (Modify)
- **RED**: 验证 results.md 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 验证 plan spec 链接
  - 检查 plan.md 是否包含 spec 链接：
    ```bash
    grep -c "\[spec:" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/plan.md
    ```
  - 将验证结果追加到 results.md
- **运行验证通过**: `grep -c "plan" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` 输出 > 0

### Task 3.5: 汇总简单场景走查结论 [spec:accuracy-evaluation#场景走查-简单变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` (Modify)
- **RED**: 验证 results.md 包含所有验证结果
  ```bash
  grep -c "brainstorm\|proposal\|plan" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md
  ```
- **运行验证失败**: 输出 < 3
- **GREEN**: 汇总端到端验证结果
  - 检查是否有阻塞问题
  - 检查输出产物格式是否正确
  - 写入最终结论到 results.md
- **运行验证通过**: `grep -c "结论" openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md` 输出 > 0

---

## 批次四：场景走查 - 复杂变更

### Task 4.1: 准备复杂变更场景 [spec:accuracy-evaluation#场景走查-复杂变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/` (Create)
- **RED**: 验证 fixture 文件存在
  ```bash
  ls tests/fixtures/precision/complex-change/proposal.md tests/fixtures/precision/complex-change/specs/ tests/fixtures/precision/complex-change/tasks.md
  ```
- **运行验证失败**: 任一文件不存在
- **GREEN**: 复制场景数据到工作目录
  ```bash
  mkdir -p openspec/changes/evaluate-refactor-accuracy/walkthrough-complex
  cp -r tests/fixtures/precision/complex-change/* openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/
  ```
- **运行验证通过**: `test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/proposal.md` 文件存在

### Task 4.2: 验证 brainstorm 输出格式 [spec:accuracy-evaluation#场景走查-复杂变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` (Create)
- **RED**: 验证场景数据准备完成
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/proposal.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 验证 brainstorm 输出格式
  - 检查 brainstorm.md 是否包含必需段落：
    ```bash
    grep -c "§需求描述" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/brainstorm.md
    grep -c "§方案探索" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/brainstorm.md
    grep -c "§关键决策" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/brainstorm.md
    ```
  - 将验证结果写入 results.md
- **运行验证通过**: `grep -c "brainstorm" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` 输出 > 0

### Task 4.3: 验证 proposal 决策追溯 [spec:accuracy-evaluation#场景走查-复杂变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` (Modify)
- **RED**: 验证 results.md 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 验证 proposal 决策追溯
  - 检查 proposal.md 是否引用 brainstorm 决策：
    ```bash
    grep -c "brainstorm.md" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/proposal.md
    ```
  - 将验证结果追加到 results.md
- **运行验证通过**: `grep -c "proposal" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` 输出 > 0

### Task 4.4: 验证 plan spec 链接和跨模块依赖 [spec:accuracy-evaluation#场景走查-复杂变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` (Modify)
- **RED**: 验证 results.md 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 验证 plan spec 链接和跨模块依赖
  - 检查 plan.md 是否包含 spec 链接：
    ```bash
    grep -c "\[spec:" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/plan.md
    ```
  - 检查跨模块任务依赖关系：
    ```bash
    grep -c "依赖" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/plan.md
    ```
  - 将验证结果追加到 results.md
- **运行验证通过**: `grep -c "plan" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` 输出 > 0

### Task 4.5: 汇总复杂场景走查结论 [spec:accuracy-evaluation#场景走查-复杂变更]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` (Modify)
- **RED**: 验证 results.md 包含所有验证结果
  ```bash
  grep -c "brainstorm\|proposal\|plan" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md
  ```
- **运行验证失败**: 输出 < 3
- **GREEN**: 汇总端到端验证结果
  - 检查是否有阻塞问题
  - 检查跨模块协调是否正常
  - 检查输出产物格式是否正确
  - 写入最终结论到 results.md
- **运行验证通过**: `grep -c "结论" openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md` 输出 > 0

---

## 批次五：汇总评估结果

### Task 5.1: 汇总评估结果 [spec:accuracy-evaluation#静态-Diff-分析]

- **文件**: `openspec/changes/evaluate-refactor-accuracy/evaluation-summary.md` (Create)
- **RED**: 验证各阶段产出文件存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/change-list.md
  test -s openspec/changes/evaluate-refactor-accuracy/precision-report.md
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-simple/results.md
  test -s openspec/changes/evaluate-refactor-accuracy/walkthrough-complex/results.md
  ```
- **运行验证失败**: 任一文件不存在或为空
- **GREEN**: 汇总评估结果
  - 读取 change-list.md，提取变更清单
  - 读取 precision-report.md，提取精度报告
  - 读取 walkthrough-simple/results.md 和 walkthrough-complex/results.md，提取场景走查结果
  - 写入 evaluation-summary.md
- **运行验证通过**: `test -s openspec/changes/evaluate-refactor-accuracy/evaluation-summary.md` 文件存在且非空

### Task 5.2: 产出评估结论 [spec:accuracy-evaluation#精度测试验证]

- **⚠️ 风险**: 需要主观判断准确度是否有损失
- **文件**: `openspec/changes/evaluate-refactor-accuracy/evaluation-conclusion.md` (Create)
- **RED**: 验证 evaluation-summary.md 存在
  ```bash
  test -s openspec/changes/evaluate-refactor-accuracy/evaluation-summary.md
  ```
- **运行验证失败**: 文件不存在或为空
- **GREEN**: 产出评估结论
  - 根据通过/失败标准判定：
    - 信息保留率 ≥ 95%
    - 所有精度测试通过
    - 场景走查无阻塞问题
    - 语义完整性：无功能丢失
  - 写入最终结论到 evaluation-conclusion.md
- **运行验证通过**: `grep -c "结论" openspec/changes/evaluate-refactor-accuracy/evaluation-conclusion.md` 输出 > 0

---

<!-- 格式说明:
  - 每个任务必须有 RED/GREEN 步骤（TDD 铁律）
  - 每个步骤有具体的运行验证命令
  - 粒度: 2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
-->

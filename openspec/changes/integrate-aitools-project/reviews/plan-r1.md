# Plan Review: integrate-aitools-project (R1)

> 审查日期: 2026-05-11
> 审查对象: plan.md
> 对照基准: tasks.md, specs/repo-init/spec.md, specs/upstream-sync/spec.md

---

## 总体评估

plan.md 整体质量良好，20 个任务全部覆盖，TDD 红绿步骤结构清晰，验证命令基本可执行。以下是按维度的详细评估。

---

## 1. 任务粒度

**评级: ⚠️ 有建议**

大部分步骤控制在合理范围内（创建单个文件、执行单条命令），但以下步骤粒度偏大：

### Minor

- **Task 2.4 (添加 Git Submodule)**: 连续执行三次 `git submodule add`，每次涉及网络请求。如果网络慢或某个仓库地址错误，调试成本较高。建议考虑将每个 submodule 的添加拆为独立步骤，或至少在 GREEN 中为每个 `git submodule add` 添加独立的错误检查。
- **Task 3.1 (创建 versions.lock)**: GREEN 步骤包含三段长链式命令（每个子项目一条），涉及目录跳转、变量提取、文件追加。建议拆为"创建文件头"和"逐个提取版本信息"两步。
- **Task 4.3 (提交初始版本并验证 clone)**: 包含 `git add` 多个文件、`git commit`、以及隐含的 clone 验证（描述中提到但验证命令未覆盖 clone 流程）。此步骤实际工作量可达 10 分钟以上。
- **Task 5.1 (创建 sync-upstream.sh 主流程)**: 一次性创建整个脚本的核心骨架（子项目列表、遍历、fetch、tag 识别、checkout、测试、更新 versions.lock），这是 plan 中最大的单一 GREEN 步骤。实际编码可能需要 15-20 分钟。建议考虑拆分为：
  - 5.1a: 创建脚本骨架和子项目列表定义
  - 5.1b: 实现 fetch + tag 识别逻辑
  - 5.1c: 实现 checkout + versions.lock 更新逻辑

### 通过的部分

- Batch 1（三个简单文件创建）和 Batch 4（清理操作）粒度适中
- Task 5.2-5.7 逐步增量修改脚本，每步只添加一个功能点，粒度合理

---

## 2. TDD 完整性

**评级: ⚠️ 有建议**

所有任务都有 RED/GREEN 结构，但部分任务的 RED 步骤质量不足：

### Major

- **Task 2.5 (验证 Submodule 配置)**: RED 步骤描述为"设计验证检查项"和"先检查当前状态（可能部分不满足）"，这不是一个真正的 RED 验证。此任务本质上是验证性任务而非创建性任务，TDD 模式不太适用。建议重新定义为：将 Task 2.4 的验证通过命令合并为 Task 2.4 的一部分，或将 Task 2.5 的 GREEN 明确为"修复验证中发现的问题"。
- **Task 5.1 (创建 sync-upstream.sh 主流程)**: RED 步骤仅为"确认脚本不存在"（`test -f scripts/sync-upstream.sh`），这是文件存在性检查而非功能验证。GREEN 步骤创建了大量功能代码，但没有对应的 RED 阶段来验证这些功能缺失。这是 TDD 的一个结构性缺陷——对于脚本创建类任务，建议至少使用 `bash -n`（语法检查）或 `--help`（参数解析检查）作为更实质性的 RED 验证。

### Minor

- **Task 4.1 / 4.2 (清理)**: RED 步骤检查文件/目录是否存在，但如果确实不存在（已清理过），RED 和 GREEN 都会是空操作。这不是问题但值得注意——如果环境已干净，这些任务可以跳过。
- **Task 3.2 (创建 README.md)**: RED 步骤只检查文件是否存在，未验证内容。建议增加内容层面的 RED 检查，如 `grep -c "clone --recursive" README.md || echo "missing required section"`。

---

## 3. Spec 对齐

**评级: ✅ 通过**

### 覆盖度检查

tasks.md 共 20 个任务，plan.md 逐条对应，完整覆盖：

| Task | plan.md 对应 | Spec 场景 |
|------|-------------|-----------|
| 1.1 | Task 1.1 | repo-init#初始化主仓库 |
| 1.2 | Task 1.2 | repo-init#初始化主仓库 |
| 1.3 | Task 1.3 | repo-init#初始化主仓库 |
| 2.1 | Task 2.1 | repo-init#配置子项目为 Submodule |
| 2.2 | Task 2.2 | repo-init#配置子项目为 Submodule |
| 2.3 | Task 2.3 | repo-init#配置子项目为 Submodule |
| 2.4 | Task 2.4 | repo-init#配置子项目为 Submodule |
| 2.5 | Task 2.5 | repo-init#配置子项目为 Submodule |
| 3.1 | Task 3.1 | repo-init#创建版本锁定文件 |
| 3.2 | Task 3.2 | repo-init#创建 README |
| 3.3 | Task 3.3 | repo-init#初始化主仓库 |
| 4.1 | Task 4.1 | repo-init#清理临时文件 |
| 4.2 | Task 4.2 | repo-init#清理临时文件 |
| 4.3 | Task 4.3 | repo-init#初始化主仓库 |
| 5.1 | Task 5.1 | upstream-sync#同步所有子项目到最新 release tag |
| 5.2 | Task 5.2 | upstream-sync#同步指定子项目 |
| 5.3 | Task 5.3 | upstream-sync#同步前自动备份当前版本 |
| 5.4 | Task 5.4 | upstream-sync#同步后测试失败自动回滚 |
| 5.5 | Task 5.5 | upstream-sync#子项目无可用 release tag |
| 5.6 | Task 5.6 | upstream-sync#远程仓库不可达 |
| 5.7 | Task 5.7 | upstream-sync#同步所有子项目到最新 release tag |

### 边界条件覆盖

| 边界条件 (spec) | plan 中是否处理 |
|----------------|----------------|
| 子项目有未提交修改 | Task 2.1 覆盖 |
| 多个 tag 同一天发布 | Task 5.1 提到 semver 排序，但未展开排序算法细节 |
| 当前已指向最新 tag | 未显式处理 |
| Submodule detached HEAD | 未显式处理（spec 标注为正常行为，不需要特殊处理） |
| 子项目没有测试命令 | Task 5.1 提到"如有 pnpm test 命令"的条件判断，但未展开 |
| Git Bash vs WSL 兼容性 | 未显式声明 POSIX 兼容性约束 |
| versions.lock 文件格式 | Task 3.1 实现了 key=value 格式，与 spec 一致 |

**遗漏项（Minor）**: spec 中提到的"当前已指向最新 tag"边界条件在 plan 中未显式处理。建议在 Task 5.1 的 GREEN 步骤中增加：如果最新 tag 与当前指向一致，输出"已是最新"并跳过 checkout。

---

## 4. 验证命令正确性

**评级: ⚠️ 有建议**

### Major

- **Task 2.2 备份目录使用 `/tmp/aitools-backup`**: 在 Windows Git Bash 环境下，`/tmp` 映射到 Git Bash 安装目录下的临时目录（如 `C:\Program Files\Git\tmp`），不是系统临时目录。功能上可以工作，但建议改用 `mktemp -d` 或明确使用 Windows 风格路径（如 `$TEMP/aitools-backup`），以避免路径混淆。

### Minor

- **Task 1.1 `git rev-parse --git-dir`**: 当前工作目录确实不是 git 仓库（环境信息显示 "Is directory a git repo: No"），但验证命令会因执行时机而异。如果执行顺序正确（先 1.1 再后续），这没有问题。
- **Task 3.1 `$(date -u +%Y-%m-%dT%H:%M:%SZ)`**: Git Bash 的 `date` 命令支持 `-u` 和 `%Y-%m-%d` 格式，可正确执行。通过。
- **Task 4.3 `git add` 列表包含 `scripts/`**: 但 scripts/ 目录要到 Batch 5 (Task 5.1) 才会创建。如果 Batch 4 在 Batch 5 之前执行，`git add scripts/` 会因目录不存在而失败或被忽略。虽然 git add 不存在的目录不会报错（仅输出警告），但建议将 scripts/ 的 add 操作移到 Task 5.7 完成后的最终提交步骤中。
- **Task 5.1 `bash -n scripts/sync-upstream.sh`**: `bash -n` 只做语法检查，不执行。这是合理的验证命令。通过。
- **Task 5.7 `bash scripts/sync-upstream.sh --help`**: 此时脚本应该已实现 --help 输出（在 Task 5.2 中添加了 --only 参数解析，可能也包含了 --help）。但如果 --help 未显式实现，此命令会执行整个同步流程。建议确保 Task 5.2 的 GREEN 包含 --help 的实现。

---

## 问题汇总

### Critical（阻塞实施）

无。

### Major（影响质量，建议修复）

1. **Task 2.5 RED 步骤空洞**: 验证性任务的 RED 定义不清晰，缺少真正的"失败"状态。建议重新定义或合并到 Task 2.4。
2. **Task 5.1 RED 步骤不足**: 大型脚本创建任务仅验证文件不存在，缺少功能性 RED 验证。
3. **Task 4.3 git add 包含尚不存在的 scripts/ 目录**: 可能导致提交遗漏或意外行为。

### Minor（建议改进）

1. **Task 5.1 粒度过大**: 建议拆分为 2-3 个子步骤。
2. **Task 2.2 备份路径**: `/tmp` 在 Windows Git Bash 下路径不直观，建议使用 `$TEMP` 或 `mktemp`。
3. **Spec 边界条件"当前已指向最新 tag"未在 plan 中显式处理**。
4. **Task 3.1 粒度偏大**: 三段长链式命令可拆分。
5. **Task 3.2 RED 步骤**: 仅检查文件存在性，建议增加内容层面验证。
6. **Task 5.7 验证命令依赖 --help**: 需确保 Task 5.2 已实现 --help 输出。

---

## 结论

plan.md 整体结构完整，20 个任务全部覆盖且与 spec 对齐，批次划分合理。主要问题集中在：部分任务的 TDD RED 步骤流于形式（验证性任务和大型创建任务），以及 Task 5.1 的粒度偏大。建议在实施前修复 3 个 Major 级别问题，Minor 级别问题可在实施过程中灵活处理。

**审查结论: 条件通过 — 修复 Major 问题后可进入实施。**

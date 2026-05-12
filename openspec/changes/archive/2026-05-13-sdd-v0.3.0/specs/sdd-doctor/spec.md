# Spec: sdd-doctor 复杂度评估与路径推荐

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

为 `/sdd-doctor` 新增复杂度评估与路径推荐能力。当活跃变更包含 specs 或 tasks 制品时，根据五个维度评估变更复杂度（S/M/L 三级），并基于评级推荐对应工作流路径。纯环境诊断模式保持原有行为不变。

---

## 场景

### 纯环境诊断保持原有行为 `[MODIFIED]`

**GIVEN** `openspec/changes/` 下不存在任何活跃变更

**WHEN** 用户执行 `/sdd-doctor`

**THEN**
- 仅执行工具安装检测（OpenSpec、Superpowers）和目录结构检查
- 输出与 v0.2.0 一致的诊断报告
- 不执行复杂度评估
- 推荐 `/sdd-brainstorm` 或 `/sdd-propose` 开始新变更

---

### 有 change 但无 spec/tasks 时仅输出环境状态 `[ADDED]`

**GIVEN** 存在活跃变更目录，但缺少 `specs/` 和 `tasks.md`

**WHEN** 用户执行 `/sdd-doctor`

**THEN**
- 执行工具安装检测和 change 状态扫描
- 输出已有制品状态
- 跳过复杂度评估，不输出评级
- 根据缺失制品推荐下一步 action

---

### 有 spec/tasks 时评估复杂度评级 `[ADDED]`

**GIVEN** 活跃变更下存在 `specs/`（含至少一个 spec.md）或存在 `tasks.md`

**WHEN** sdd-doctor 执行到复杂度评估步骤

**THEN**
- 按五个维度采集指标：

| 指标 | 权重 | 来源 |
|------|------|------|
| spec 场景数量 | 高 | specs/*/spec.md 中 GIVEN/WHEN/THEN 计数 |
| tasks 数量 | 高 | tasks.md 中 `- [ ]` checkbox 计数 |
| 影响文件数 | 中 | proposal.md 影响分析 |
| 涉及领域数 | 中 | specs/ 下一级子目录数 |
| 外部依赖变更 | 低 | proposal.md 依赖描述 |

- 评级规则（初始经验值，待迭代调整）：

| 评级 | 场景数 | 任务数 | 领域数 |
|------|--------|--------|--------|
| 简单(S) | 1-3 | ≤5 | 1 |
| 中等(M) | 4-8 | 6-15 | 1-2 |
| 复杂(L) | >8 | >15 | ≥3 |

- 多维度指向不同评级时取最高（就高不就低）

---

### 简单(S)评级时推荐 /sdd-quick 路径 `[ADDED]`

**GIVEN** 复杂度评估结果为简单(S)

**WHEN** sdd-doctor 输出路径推荐

**THEN**
- ★ 推荐 /sdd-quick（快速模式）
- ○ 可选标准路径：/sdd-propose → /sdd-ff → /sdd-code
- 提示简单需求可跳过 brainstorm 和独立 review

---

### 中等(M)评级时推荐标准路径 `[ADDED]`

**GIVEN** 复杂度评估结果为中等(M)

**WHEN** sdd-doctor 输出路径推荐

**THEN**
- ★ 推荐标准路径：/sdd-propose → /sdd-ff → /sdd-plan → /sdd-code
- 标注可跳过 brainstorm
- △ 可跳过 /sdd-review-spec、/sdd-review-code

---

### 复杂(L)评级时推荐完整流程 `[ADDED]`

**GIVEN** 复杂度评估结果为复杂(L)

**WHEN** sdd-doctor 输出路径推荐

**THEN**
- ★ 推荐完整流程：brainstorm → propose → ff → plan → code → review-spec → review-code → verify → ship
- 提示复杂变更建议使用 /sdd-plan 分批生成
- 所有步骤均为推荐，无跳过建议

---

## 边界条件

- **部分制品缺失**：proposal 不存在时，影响文件数和依赖变更按 0 计，不阻断评估，标注"部分指标使用默认值"
- **spec 格式不规范**：未使用 GIVEN/WHEN/THEN 时，按三级标题计数作为近似值，标注"场景计数为近似值"
- **tasks 无 checkbox**：任务数按 0 计，不阻断评估
- **阈值为初始值**：报告中标注"评级阈值为初始经验值，将随使用迭代调整"
- **跨维度取最高示例**：场景数 3（S 级）+ 任务数 20（L 级）+ 领域数 1（S 级）→ 最终评级 L；场景数 5（M 级）+ 任务数 4（S 级）+ 领域数 2（M 级）→ 最终评级 M
- **多个活跃变更**：独立评估各变更复杂度，互不影响
- **指标采集失败**：失败指标按 0 计，不阻断评估，标注失败原因

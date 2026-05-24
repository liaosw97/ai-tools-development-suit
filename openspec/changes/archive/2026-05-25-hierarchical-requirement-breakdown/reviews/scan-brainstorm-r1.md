# Skill 质量评估报告 — sdd-brainstorm

> 评估日期：2026-05-25
> 评估员：Claude Code
> 目标：`ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

---

## 评分总结

| 维度 | 分数 | 权重 | 加权分 |
|------|------|------|--------|
| 8 模块 | 13/16 | 55% | 4.47 |
| 7 反模式 | 评估通过 | 20% | 1.80 |
| 完整性 | Pass | 15% | 1.50 |
| Decision Gate | Partial | 10% | 0.50 |
| **总分** | — | — | **8.27/10** |

**评级**：良好 ✅

---

## 8 模块评估详情

### 模块 1：触发条件 — 2/2 分 ✅

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 触发条件 | ✅ | SKILL.md:14 — `/sdd-brainstorm` + 关键词组合 |
| 不触发 | ✅ | SKILL.md:15 — 明确列出 → `/sdd-propose`, `/sdd-code` |
| 歧义处理 | ✅ | SKILL.md:16 — "已有 brainstorm.md 时确认是继续探索还是覆盖" |

**加分项**：拆分模式触发条件独立定义（SKILL.md:40-58）

---

### 模块 2：行为准则 + 抗衰减锚点 — 1/2 分 ⚠️

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| ❗ 标记规则 | ❌ | 无 ❗ 标记，无"每次输出前自检" |
| 规则数量控制 | N/A | 无标记规则 |
| 全程有效声明 | ❌ | 无声明 |

**问题**：输出约束节（SKILL.md:18-24）有禁止项但未标记为关键规则。

**建议**：添加 ❗ 标记到最关键的 2-3 条规则。

---

### 模块 3：工具优先级表 — 0/2 分 ❌

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 表格格式 | ❌ | 无工具优先级表 |
| 降级条件 | N/A | 无定义 |
| 禁止自行降级 | N/A | 无定义 |

**问题**：SKILL 未定义工具优先级。虽然委托给 `superpowers:brainstorming`，但应有基本工具使用指引。

**建议**：补充前置逻辑中读取文件的工具优先级（如 Read > Bash cat）。

---

### 模块 4：输出约束 — 2/2 分 ✅

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 禁止输出列表 | ✅ | SKILL.md:20-24 — 4 条具体禁止项 |
| 开场白禁止 | ✅ | SKILL.md:21 |
| 工具调用描述禁止 | ✅ | SKILL.md:22 |
| 领域约束 | ✅ | SKILL.md:23-24 — 未验证决策、已知信息复述 |

---

### 模块 5：流程步骤 + Checkpoint — 2/2 分 ✅

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 编号步骤 | ✅ | 前置逻辑 0-3，核心执行，后置逻辑 1-3 |
| 等式验收 | ✅ | SKILL.md:222-237 — Review 流程明确定义 |
| Checkpoint | ⚠️ | 有步骤但无显式 ✅ Checkpoint 输出格式 |
| 失败降级路径 | ✅ | SKILL.md:239-258 — Review 达限处理 |

**注**：Checkpoint 格式隐含在流程中，但未显式标注。

---

### 模块 6：依赖链声明 — 2/2 分 ✅

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 数据传递声明 | ✅ | SKILL.md:88-113 — Override 指令明确传递给底层 skill |
| 禁止重新生成 | ✅ | SKILL.md:110-112 — 禁止自动转场 |
| 交叉验证 | ✅ | SKILL.md:260-265 — 产物校验节 |

---

### 模块 7：子 Agent 委派规则 — 2/2 分 ✅

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 委派 prompt 复制原始约束 | ✅ | SKILL.md:94-113 — Override 指令完整 |
| 完成性约束 | ✅ | SKILL.md:216-220 — 审查维度明确 |
| 分工边界 | ✅ | SKILL.md:105-108 — "完成后停止" |
| 合并检查 | ✅ | SKILL.md:260-265 — 产物校验 |

---

### 模块 8：零结果与幻觉防护 — 2/2 分 ✅

| 检查项 | 状态 | Evidence |
|--------|------|----------|
| 来源引用要求 | ✅ | SKILL.md:28 |
| 无来源禁止输出 | ✅ | SKILL.md:29-30 |
| 零结果处理表 | ⚠️ | 有处理但非表格形式 |
| 标注分级 | ⚠️ | 未显式定义分级 |

**注**：虽非严格表格形式，但有明确的零结果处理逻辑。

---

## 7 反模式脆弱性评估

| 模式 | 风险级别 | Evidence |
|------|----------|----------|
| 模式1：完整性跳过 | Low | 流程步骤完整，有失败路径 |
| 模式2：约束衰减 | Medium | 无 ❗ 标记，可能随对话衰减 |
| 模式3：工具选择漂移 | Medium | 无工具优先级表 |
| 模式4：输出膨胀 | Low | 有 4 条禁止项 |
| 模式5：依赖链断裂 | Low | Override 指令完整 |
| 模式6：并行孤岛 | Low | 子 agent 边界清晰 |
| 模式7：触发模糊 | Low | 触发条件明确 |

---

## 3 完整性原则检查

| 原则 | 状态 | Evidence |
|------|------|----------|
| 流程步骤可识别 | Pass | 前置/核心/后置三层清晰 |
| 产物明确 | Pass | brainstorm.md + reviews/ |
| 错误路径定义 | Pass | Review 达限处理、用户取消处理 |

---

## Decision Gate 评估

**结论类型抽样**：
1. "已进入拆分模式" — 信号：用户输入 → 判断：模式触发
2. "探索未完成" — 信号：决策为空 → 判断：需要更多信息
3. Review 通过/不通过 — 信号：审查结果 → 判断：是否继续

| 类型 | Signal | Evidence | Counter-evidence | 评级 |
|------|--------|----------|------------------|------|
| 模式触发 | ✅ 参数/关键词 | 用户输入 | 配置覆盖 | Pass |
| 探索结果 | ✅ 决策列表 | 用户输入+探索过程 | 缺失决策警告 | Pass |
| Review 结果 | ⚠️ issues 列表 | 审查报告 | 用户接受选项 | Partial |

**问题**：Review 结果未显式要求 counter-evidence 检查。

---

## 行动项

### P1（建议修复）

1. **添加 ❗ 标记规则** — SKILL.md:18-24
   - 建议将"禁止输出"中最重要的 2-3 条标记为 ❗
   - 添加"每次输出前自检"提示

2. **补充工具优先级表** — 前置逻辑节
   - 添加 Read/Glob/Grep 的优先级说明
   - 定义降级条件

### P2（可选改进）

1. **显式 Checkpoint 格式** — 流程步骤
   - 添加 ✅ Checkpoint 输出示例

2. **零结果处理表格化** — SKILL.md:26-30
   - 转换为场景 | 正确输出 | 禁止输出 格式

---

## 产物契约观察

- [x] 目标 Skill 是否定义稳定输出？**OBSERVED** — brainstorm.md + reviews/
- [x] 是否有唯一真值源？**OBSERVED** — 产物路径明确
- [x] 是否区分产物类型？**OBSERVED** — human-readable (brainstorm.md) vs work artifacts (reviews/)

---

## 历史对比

首次评估，无历史记录。

---

## 审计记录（待确认写入）

```json
{"skill_path":"ai-tools-bridge/skills/sdd-brainstorm/SKILL.md","date":"2026-05-25","score":8.27,"weights_version":"1.0","modules":{"trigger":2,"behavior":1,"tools":0,"output":2,"process":2,"dependency":2,"delegation":2,"hallucination":2},"anti_patterns":{"completeness":"Low","constraint_decay":"Medium","tool_drift":"Medium","output_bloat":"Low","dependency_break":"Low","parallel_island":"Low","trigger_fuzzy":"Low"},"decision_gate":"Partial","actions":{"P1":2,"P2":2}}
```

---

✅ 检查完成

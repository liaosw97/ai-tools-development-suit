# Spec: limits-config

> Limits 配置机制 — 定义上限值的配置读取和默认值回退

## 能力描述

在 `openspec/config.yaml` 中新增 `limits` 配置节，所有含上限的 SDD action 在执行时读取配置值，未配置时使用默认值。通过 sdd-doctor 和达限提示两个触点让用户发现配置能力。

---

## 场景

### 读取已配置的 limits 值 `ADDED`

**GIVEN**
- `openspec/config.yaml` 中存在 `limits` 配置节
- 配置了 `quick-questions: 8` 和 `review-rounds: 5`

**WHEN**
- SDD action（sdd-quick、sdd-brainstorm、sdd-plan、sdd-doctor）执行并读取配置

**THEN**
- action 使用配置值（8 和 5）而非默认值
- 行为与使用默认值时一致，仅上限值不同

---

### 读取未配置的 limits — 默认值回退 `ADDED`

**GIVEN**
- `openspec/config.yaml` 不存在 `limits` 配置节
- 或 `limits` 节存在但缺少某个配置项

**WHEN**
- SDD action 执行并尝试读取配置

**THEN**
- 使用以下默认值：
  - `quick-questions`: 5
  - `quick-scenarios`: 5
  - `quick-tasks`: 10
  - `review-rounds`: 3
- 行为等同当前硬编码版本

---

### sdd-doctor 读取 limits 配置值 `ADDED`

**GIVEN**
- 用户即将执行 `/sdd-doctor`
- `openspec/config.yaml` 可能存在或不存在 `limits` 配置节

**WHEN**
- sdd-doctor 启动并读取配置

**THEN**
- 读取 `openspec/config.yaml` 的 `limits` 节
- 对于每个配置项：已配置且有效则使用配置值，否则使用默认值
- 将读取到的值传递给诊断报告生成逻辑

---

### sdd-doctor 输出 limits 配置状态 `ADDED`

**GIVEN**
- 用户执行 `/sdd-doctor`

**WHEN**
- 诊断报告生成

**THEN**
- 报告中包含"限制配置"节
- 输出每个配置项的当前值（已配置值或默认值）
- 未配置的项标注"(默认值)"
- 输出格式示例：
  ```
  限制配置:
    quick-questions: 5 (默认值)
    quick-scenarios: 8
    quick-tasks: 10 (默认值)
    review-rounds: 3 (默认值)
  ```

---

### 达限提示包含可发现性信息 `ADDED`

**GIVEN**
- 任何 SDD action 达到上限

**WHEN**
- 输出达限提示消息

**THEN**
- 提示消息末尾附加可发现性信息
- **关键信息要求**（必须包含，允许语义等价表述）：
  - 配置文件路径：`openspec/config.yaml`
  - 配置节名称：`limits`
  - 可调整上限的说明
- 示例文本："可在 openspec/config.yaml 的 limits 节中调整上限"

---

## 边界条件

- config.yaml 文件不存在：等同未配置，使用默认值
- limits 节存在但值为非数字：忽略该配置项，使用默认值，不阻断 action 执行
- limits 节中配置项值为 0 或负数：等同未配置，使用默认值

---

## 范围说明

**本次变更涉及的 action**：
- sdd-quick（需求收集提问、场景数量、任务数量上限）
- sdd-brainstorm（review 循环上限）
- sdd-plan（review 循环上限）
- sdd-doctor（配置读取与输出）

**明确排除的 action**：
- sdd-review-code：当前无硬编码上限，不在本次变更范围内
- sdd-review-spec：当前无硬编码上限，不在本次变更范围内
- 其他 SDD action：当前无硬编码上限

---

### 配置值为非法类型时回退默认值 `ADDED`

**GIVEN**
- `openspec/config.yaml` 中 `limits` 节存在
- 某配置项值为非数字类型（如字符串 `"abc"`）或无效值（0、负数）

**WHEN**
- SDD action 读取该配置项

**THEN**
- 忽略该无效配置项
- 使用对应的默认值
- 不阻断 action 执行
- sdd-doctor 输出时标注该配置项为"(默认值，配置值无效)"

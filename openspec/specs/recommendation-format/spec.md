# Spec: recommendation-format

> 功能规格 — 推荐下一步输出格式统一化

## 能力描述

定义所有 SDD skill 的"推荐下一步"输出格式标准，确保一致性、可读性和明确的修复路径。

---

## 场景

### 普通skill完成引导 `[ADDED]`

**GIVEN**
- 非"审查类"的 skill（如 sdd-propose、sdd-ff、sdd-plan 等）执行完成
- 需要输出"推荐下一步"引导用户

**WHEN**
- 输出完成引导

**THEN**
- 使用统一格式：
  ```
  ★ 推荐下一步: /sdd-[主推荐] — [说明]
    ○ /sdd-[可选] — [可选说明]
    △ /sdd-[备选] — [备选说明]
  ```
- 第一行直接给出指令（含 ★）
- 后续行用 ○ 和 △ 标识可选项和备选项
- 每行格式：`/sdd-[命令] — [说明]`

---

### 审查类skill条件驱动格式 `[ADDED]`

**GIVEN**
- 审查类 skill（sdd-review-code、sdd-review-spec、sdd-verify）执行完成
- 审查结果为 PASSED 或 FAILED

**WHEN**
- 输出完成引导

**THEN**
- 使用条件驱动格式：
  ```
  ★ 推荐下一步（按审查结果）:
    /sdd-[PASSED路径] — [通过时的说明]
    /sdd-[FAILED路径] — [失败时的修复说明]
    △ /sdd-[备选] — [备选说明]
  ```
- 多行指令按审查结果选择执行（非并列关系）
- FAILED 路径必须包含明确的修复命令

---

### 审查失败时提供修复路径 `[ADDED]`

**GIVEN**
- sdd-review-code Phase 1 发现 PARTIAL 场景（测试缺失）
- 或 sdd-review-code Phase 1 发现 MISSING 场景（实现缺失）
- 或 sdd-review-code Phase 2 发现 critical/major issues
- 或 sdd-verify 发现测试未覆盖场景
- 或 sdd-verify 发现实现缺失

**WHEN**
- 输出推荐下一步

**THEN**
- 根据问题类型提供对应修复路径：
  - PARTIAL 场景 → 推荐 `/sdd-test-code`
  - MISSING 场景 → 推荐 `/sdd-code`
  - critical/major issues → 推荐 `/sdd-code`
  - 测试未覆盖 → 推荐 `/sdd-test-code`
  - 实现缺失 → 推荐 `/sdd-code`

---

### 消除重复输出 `[ADDED]`

**GIVEN**
- sdd-verify 执行验证
- 输出验证报告（含覆盖率统计、未覆盖场景列表）

**WHEN**
- 输出验证报告

**THEN**
- 验证报告中不出现"推荐下一步"
- "推荐下一步"仅在"完成引导"节输出一次

---

## 边界条件

- **无备选项时**：仅输出 ★ 行，不强制要求 ○ 或 △
- **多个备选项时**：最多列出 3 个（避免过长）
- **条件驱动格式但无 FAILED 路径**：如 sdd-review-spec 的 Approved 情况，Issues 路径描述需准确（"修复 spec"而非"修正提案")
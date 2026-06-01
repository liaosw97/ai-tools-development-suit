# Code Quality Review — Round 3

**审查对象:** Round 3 新增代码（PARTIAL 场景补充）
**日期:** 2026-06-01

## 审查范围

- `lib/summarizer.ts`: `ChangeEntry` / `ChangeList` 接口、`generateChangeList()`、`classifyModule()`
- `tests/precision/fixtures.test.ts`: SDD 流程走查测试（simple-change + complex-change）
- `tests/unit/summarizer.test.ts`: `generateChangeList` 单元测试

## 问题统计

- critical: 0 项
- major: 1 项
- minor: 3 项
- info: 2 项

## Issues 逐项列表

### [M1] fixtures.test.ts: 循环内断言不依赖循环变量，`hasCoverage` 为死代码

**文件:** `tests/precision/fixtures.test.ts` 第 160-177 行
**严重性:** major

```typescript
for (const scenario of specResult.scenarios) {
  const hasCoverage = tasksResult.tasks.some(t =>
    t.specLink.includes(scenario) || t.description.includes(scenario)
  );
  // 至少有任务引用了该 spec domain
  expect(tasksResult.tasks.some(t => t.specLink.includes('config-validation'))).toBe(true);
}
```

问题：
1. `hasCoverage` 变量被计算但从未被断言，是死代码。
2. 循环内的 `expect` 不依赖 `scenario` 变量 — 每次迭代检查的是同一个条件（`config-validation`），循环等价于执行一次。
3. 注释声称"每个 spec 场景至少被一个任务覆盖"，但实际断言仅验证了"存在引用 config-validation 的任务"，语义弱于注释。

建议：移除循环，或改用 `expect(hasCoverage).toBe(true)` 断言实际的逐场景覆盖。对比 complex-change 同类测试（第 219-238 行）正确使用了 `domain` 变量，此处应保持一致。

---

### [m1] `classifyModule` 不覆盖 `schemas/` 和 `integrations/` 目录

**文件:** `lib/summarizer.ts` 第 155-163 行
**严重性:** minor

项目实际存在 `schemas/`、`integrations/`、`openspec/` 等顶层目录，但 `classifyModule` 仅识别 `skills/`、`lib/`、`scripts/`、`tests/`、`guidelines/`、`roles/` 六个前缀。涉及这些目录的 diff 会被归类为 `other`。

当前使用场景（内部 diff 分析）可能不涉及这些目录，但如果 `generateChangeList` 被更广泛使用，遗漏分类会导致 `byModule` 中出现意料之外的 `other` 分组。

---

### [m2] 重命名文件（similarity 100%）被分类为 MODIFIED

**文件:** `lib/summarizer.ts` 第 188-189 行
**严重性:** minor

当 `oldPath !== newPath` 且无 `new file mode` / `deleted file mode` 标记时，类型设为 `MODIFIED`。对于仅重命名（内容未变，similarity index 100%）的文件，"MODIFIED" 语义不够精确。测试用例（第 196-206 行）确认这是有意设计，但可考虑增加 `'RENAMED'` 类型或在 `reason` 中更明确地区分"重命名"和"重命名+修改"。

---

### [m3] `generateChangeList` 测试缺少边界场景

**文件:** `tests/unit/summarizer.test.ts` 第 121-214 行
**严重性:** minor

当前测试覆盖了 ADDED / MODIFIED / REMOVED / RENAME / EMPTY 五种场景，但缺少以下边界用例：
- 包含无法匹配 `a/... b/...` 头的畸形 diff 块（防御性路径未验证）
- 混合类型 diff（一次包含 ADDED + MODIFIED + REMOVED 多种文件）
- 不匹配任何已知模块前缀的文件路径（验证 `other` 分类）
- 重命名且内容变更的文件（similarity < 100%）

---

### [i1] 重命名检测依赖 diff 内容而非显式标记

**文件:** `lib/summarizer.ts` 第 188 行
**严重性:** info

重命名检测逻辑为 `oldPath !== newPath`，这依赖于 diff 头部的路径差异。Git 的 `rename from` / `rename to` 标记未被显式解析。当前实现能正确工作（因为 git diff 输出中重命名文件的 `a/` 和 `b/` 路径不同），但如果未来需要区分"纯重命名"和"重命名+修改"，解析 `similarity index` 会更可靠。

---

### [i2] `ChangeList.summary` 统计使用三次 `filter` 遍历

**文件:** `lib/summarizer.ts` 第 210-215 行
**严重性:** info

```typescript
const summary = {
  total: entries.length,
  added: entries.filter(e => e.type === 'ADDED').length,
  modified: entries.filter(e => e.type === 'MODIFIED').length,
  removed: entries.filter(e => e.type === 'REMOVED').length,
};
```

对 `entries` 进行了三次遍历。当条目数较少时（典型 diff 通常 < 100 个文件），性能完全不是问题。如果未来处理超大 diff，可改用单次 `reduce`。当前实现可读性优于性能优化，无需改动。

---

## 优点

1. **接口设计清晰** — `ChangeEntry` 和 `ChangeList` 接口职责单一，`ChangeList` 提供 `entries`（扁平列表）、`byModule`（分组视图）、`summary`（统计）三个维度，使用方可以按需取用。

2. **防御性编程** — `generateChangeList` 对畸形 diff 块使用 `continue` 跳过（第 175 行），空 diff 返回空结果（第 208-213 行验证），`classifyModule` 有 `other` 兜底。整体健壮性良好。

3. **重命名 reason 追溯** — 重命名文件附带 `reason: '重命名: oldPath -> newPath'`，为后续审查或日志提供了有价值的上下文信息。

4. **fixture 测试验证制品连贯性** — 走查测试不仅检查单个制品的存在性，还验证 brainstorm -> proposal -> spec -> tasks -> plan 的依赖链关系（如 proposal 引用 brainstorm 决策、plan tasks 包含 spec 链接），体现了 SDD 流程的整体一致性。

5. **complex-change 走查测试质量较高** — 验证了跨模块 spec 覆盖（4 个 domain 各有任务引用）、批次间依赖关系（依赖批次一/二）、场景-任务数量对应关系。相比 simple-change 走查，断言更精确。

## 结论

**PASSED**

本轮新增代码质量良好。M1 是唯一需要修复的问题（测试中的死代码和弱断言），其余为改进建议。核心实现（`generateChangeList` + `classifyModule`）设计合理、可读性好、防御性充分。

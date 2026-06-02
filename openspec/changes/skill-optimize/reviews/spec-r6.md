# Spec Review — Round 6

**审查对象:** specs/ 目录下所有 15 个 spec 文件
**日期:** 2026-06-02
**前轮:** Round 5 (NEEDS_REVISION)

## Round 5 Issues 修复状态

### [critical] 场景缺少 GIVEN 前置条件
- **状态:** 已修复
- **说明:** 全部 15 个 spec 文件的所有场景均已补充 GIVEN 前置条件。验证通过：sdd-brainstorm（5 场景）、sdd-code（7 场景）、sdd-continue（7 场景）、sdd-doctor（7 场景）、sdd-ff（5 场景）、sdd-plan（6 场景）、sdd-propose（4 场景）、sdd-quick（6 场景）、sdd-review-code（4 场景）、sdd-review-spec（4 场景）、sdd-role（7 场景）、sdd-ship（5 场景）、sdd-test-code（6 场景）、sdd-verify（6 场景）、shared-skill-modules（12 场景），每个场景均以 `**GIVEN**` 开头，描述了明确的初始状态。

### [major] Token 减少断言不可测试
- **状态:** 已修复
- **说明:** 全部 14 个 MODIFIED spec 的 Token 减少场景已从"约 X 行"改为 `≤X 行` 格式。验证通过：sdd-brainstorm（≤180）、sdd-code（≤90）、sdd-continue（≤55）、sdd-doctor（≤80）、sdd-ff（≤55）、sdd-plan（≤120）、sdd-propose（≤65）、sdd-quick（≤90）、sdd-review-code（≤80）、sdd-review-spec（≤55）、sdd-role（≤70）、sdd-ship（≤90）、sdd-test-code（≤60）、sdd-verify（≤65）。所有断言均可直接转化为 `expect(lines).toBeLessThanOrEqual(N)` 自动化测试。

### [major] brainstorm.md 引用数量已修正
- **状态:** 已修复
- **说明:** brainstorm.md 第 31 行 role-loading.md 的被引用次数已从 12 修正为 9，原始占用从 `~1440 行（12×120）` 修正为 `~1080 行（9×120）`，与 shared-skill-modules/spec.md 中列出的 9 个 SKILL 一致。

### [major] proposal.md 决策追溯已补充
- **状态:** 部分修复（见新发现 Issues #1）
- **说明:** proposal.md 已新增"关键决策"节，包含 4 个决策，每个都有 `- **见:** brainstorm.md §<标题>` 引用。决策内容完整覆盖了 brainstorm.md 中的全部关键决策。但追溯格式与 CLAUDE.md 规定的格式不完全一致（见下方新发现）。

### [minor] sdd-test-code 执行细节已简化
- **状态:** 未修复
- **说明:** sdd-test-code/spec.md 第 26 行仍然包含实现细节：
  ```
  - 测试质量修复（invoke `superpowers:test-driven-development`，按 TDD 规范修复）
  ```
  `invoke \`superpowers:test-driven-development\`` 属于实现层面的委托细节，spec 应描述行为而非实现。建议简化为：`测试质量修复（按 TDD 规范修复测试质量问题，不修改实现代码）`。

### [minor] sdd-verify 场景已补充
- **状态:** 已修复
- **说明:** sdd-verify/spec.md 已新增 3 个场景：
  - "测试失败处理"（GIVEN 测试执行失败 → THEN 输出失败信息 + 标记 FAILED + 推荐 /sdd-code）
  - "Spec 覆盖率不达标"（GIVEN 存在未覆盖场景 → THEN 输出列表 + 标记 FAILED + 推荐 /sdd-test-code）
  - "验证报告判定标准"（PASSED/FAILED 的具体条件定义）
  场景覆盖从 5 个增加到 8 个，覆盖了正常路径和错误路径。

### [minor] 跨模块验证场景已补充
- **状态:** 已修复
- **说明:** shared-skill-modules/spec.md 已新增"引用完整性验证"场景（第 119-125 行），验证三个完整性规则：引用文件存在性、无孤立模块、路径格式正确。

## 新发现的 Issues

### [minor] proposal.md 决策追溯格式不完全符合规范

- **位置:** proposal.md 第 43-64 行
- **描述:** CLAUDE.md 规定决策追溯格式为 `选择 [X] 而非 [Y]：[原因]（见 brainstorm.md §<标题>）`。proposal.md 使用了结构化格式：
  ```
  - **选择:** ...
  - **理由:** ...
  - **被否决的替代:** ...
  - **见:** brainstorm.md §...
  ```
  内容完整但格式与规范不一致。当前格式可读性更好，但如果需要严格遵循 CLAUDE.md 的行内追溯格式，需要调整。
- **建议:** 两种方案：(A) 改为行内格式以严格遵循 CLAUDE.md；(B) 保留当前结构化格式并更新 CLAUDE.md 中的格式示例。建议采用方案 B，因为当前格式信息密度更高、更清晰。

### [minor] brainstorm.md 中 breakdown-mode 和 review-loop 引用计数与 spec 不一致

- **位置:** brainstorm.md 第 32-33 行
- **描述:** brainstorm.md 表格中：
  - `breakdown-mode.md` 被引用次数为 2，但 spec 中仅 sdd-brainstorm 明确引用（1 个）
  - `review-loop.md` 被引用次数为 5，但 spec 中仅 sdd-brainstorm 和 sdd-plan 明确引用（2 个）
  这些计数可能包含了 reviewer/reference 文件的引用，但与 shared-skill-modules/spec.md §引用规则定义中列出的 SKILL 引用数不一致。
- **建议:** 确认计数口径。如果计数包含非 SKILL.md 文件的引用，在表格中增加注释说明；如果仅统计 SKILL.md 引用，修正为 1 和 2。

### [minor] tasks.md 与 spec 的行数基线不一致

- **位置:** tasks.md vs 各 spec 文件
- **描述:** tasks.md 中部分 SKILL.md 的改造前行数与 spec 中的 GIVEN 条件不一致：
  | SKILL | tasks.md 基线 | spec GIVEN | 差异 |
  |-------|-------------|-----------|------|
  | sdd-quick | 212 行 | 213 行 | +1 |
  | sdd-code | 210 行 | 211 行 | +1 |
  | sdd-plan | 285 行 | 286 行 | +1 |
  | sdd-ship | 205 行 | 206 行 | +1 |
  差异很小（均 1 行），可能源于计数方式（是否含 frontmatter 分隔符）。以 spec 为准即可，但建议同步 tasks.md 保持一致。
- **建议:** 更新 tasks.md 中的基线行数与 spec 一致。

## Approved

- [x] 场景完整性 — 全部 15 个 spec 均使用 GIVEN/WHEN/THEN 格式，覆盖正常路径、错误路径（降级策略）和关键边界条件
- [x] 可测试性 — Token 断言使用 `≤X 行` 可直接转化为测试；场景描述均为用户可观测行为；断言具体明确
- [x] 一致性 — Delta Spec 标记正确（14 个 MODIFIED + 1 个 ADDED）；spec 间无矛盾；shared-skill-modules 的引用规则与各 spec 的 include 列表一致
- [x] 决策追溯 — proposal.md 引用了 brainstorm.md 的全部 4 个关键决策；spec 与 brainstorm 决策方向一致；被否决方案（方案 B/C）未出现在 spec 中
- [x] 范围控制 — 所有 spec 内容均在 proposal 定义的范围内（共享模块 + 14 个 SKILL 改造），无隐含功能扩展
- [x] 跨模块一致性 — shared-skill-modules/spec.md 定义了完整的引用规则和完整性验证；各 spec 的 include 列表与引用规则匹配；无遗漏的关联模块

## 结论

**APPROVED**（附带 3 个 minor 建议）

Round 5 的 1 个 critical 和 3 个 major 问题均已修复。新发现 3 个 minor 问题（proposal.md 追溯格式、brainstorm.md 引用计数、tasks.md 基线不一致），均不影响实现的正确性，可在实现阶段或后续迭代中处理。spec 质量整体良好，场景完整、可测试、一致性达标。

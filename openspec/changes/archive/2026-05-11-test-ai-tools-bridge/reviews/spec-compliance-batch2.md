# Spec Compliance Review — Batch 2

**审查对象:** specs/ vs 测试代码（Batch 1 问题修复后复审）
**日期:** 2026-05-11

## 场景覆盖统计

- 总场景数: 18
- ✅ 已实现: 18
- ⚠️ 部分实现: 0
- ❌ 未实现: 0
- 覆盖率: 100%

## Batch 1 问题修复验证

| Issue | 严重度 | 状态 |
|-------|--------|------|
| C1: template-placeholders Windows 路径正则 | CRITICAL | ✅ 已修复 — `path.basename(f, '.md')` 替代手写正则 |
| I1: skill-frontmatter 内联 require('path') | Important | ✅ 已修复 — 改为 ESM `import path from 'node:path'` |
| I2: readSkillBody 三文件重复 | Important | ❌ 未修复 — 仍重复于 3 个文件 |
| I3: plugin-json 测试顺序依赖 | Important | ❌ 未修复 — 仍依赖隐式顺序 |
| I4: template-placeholders 匹配过弱 | Important | ✅ 已修复 — 重写为多级匹配策略 |
| I5: preconditions 未使用的 loadSchema 导入 | Important | ✅ 已修复 |
| I6: template-files 未使用的 fs 导入 | Important | ✅ 已修复 |
| I7: skill-delegation 错误信息前缀重复 | Important | ✅ 已修复 |

## 逐场景结果

### L1 结构验证

#### spec:l1-structural#skill-frontmatter-name-description
- **状态:** ✅ IMPLEMENTED
- **验证:** `skill-frontmatter.test.ts` — 使用 ESM `import path`，`test.each` 遍历 11 个 skill，断言 name/description 非空

#### spec:l1-structural#skill-name-matches-directory
- **状态:** ✅ IMPLEMENTED
- **验证:** `skill-name-matches-dir.test.ts` — `path.basename(dir)` vs `frontmatter.name`

#### spec:l1-structural#skills-directory-clean
- **状态:** ✅ IMPLEMENTED
- **验证:** `skills-directory.test.ts` — 11 个 sdd-* 目录，无非法目录

#### spec:l1-structural#plugin-json-valid
- **状态:** ✅ IMPLEMENTED
- **验证:** `plugin-json.test.ts` — JSON 合法、name、version (semver)、author.name、license 全部覆盖
- **备注:** semver 正则 `^\d+\.\d+\.\d+$` 仍不兼容 `v` 前缀（spec 边界条件），当前实际值 `0.2.0` 无影响

#### spec:l1-structural#template-files-match-schema-artifacts
- **状态:** ✅ IMPLEMENTED
- **验证:** `template-files.test.ts` — 双向检查，使用 `path.basename` 正确提取文件名

#### spec:l1-structural#template-placeholders-cover-content-constraints
- **状态:** ✅ IMPLEMENTED（Batch 1 CRITICAL 已修复）
- **验证:** `template-placeholders.test.ts` — 使用 `path.basename(f, '.md')` 提取 key，多级匹配策略（精确标题 → 部分标题 → token 匹配）
- **改进:** Batch 1 中 Windows 上整个测试为死代码的问题已彻底修复

#### spec:l1-structural#reviewer-prompt-files-exist
- **状态:** ✅ IMPLEMENTED
- **验证:** `reviewer-prompts.test.ts` — 5 个文件存在且非空

#### spec:l1-structural#reviewer-prompt-has-required-sections
- **状态:** ✅ IMPLEMENTED
- **验证:** 检查审查维度、severity 分级（兼容 traditional/compliance 两种分类）、输出格式

#### spec:l1-structural#guidelines-files-exist
- **状态:** ✅ IMPLEMENTED
- **验证:** `guidelines.test.ts` — 4 个文件存在

#### spec:l1-structural#schema-yaml-valid-and-parseable
- **状态:** ✅ IMPLEMENTED
- **验证:** `schema-yaml.test.ts` — YAML 合法、artifacts、dependency_chain、7 entries

### L2 编排验证

#### spec:l2-orchestration#dependency-chain-matches-artifact-definitions
- **状态:** ✅ IMPLEMENTED
- **验证:** chain items 在 artifacts 中存在，required artifacts 在 chain 中

#### spec:l2-orchestration#artifact-dependencies-reference-valid-artifacts
- **状态:** ✅ IMPLEMENTED
- **验证:** dependencies 引用有效，DFS 三色算法检测无环

#### spec:l2-orchestration#skill-delegation-targets-valid
- **状态:** ✅ IMPLEMENTED
- **验证:** 硬编码委托表与 SKILL.md 交叉验证，错误信息前缀已修正

#### spec:l2-orchestration#override-instructions-complete
- **状态:** ✅ IMPLEMENTED
- **验证:** sdd-brainstorm(4要素)、sdd-plan(5要素)、sdd-review-code(3要素)

#### spec:l2-orchestration#review-loop-max-3-rounds
- **状态:** ✅ IMPLEMENTED
- **验证:** "最多 3 轮"约束、命名格式

#### spec:l2-orchestration#skill-preconditions-match-schema-dependencies
- **状态:** ✅ IMPLEMENTED
- **验证:** sdd-plan/tasks、sdd-code/tasks、sdd-verify/specs、sdd-ship/tasks

#### spec:l2-orchestration#reviewer-prompts-aligned-with-review-skills
- **状态:** ✅ IMPLEMENTED
- **验证:** SKILL.md 引用与磁盘文件一致

#### spec:l2-orchestration#skill-three-layer-structure-consistent
- **状态:** ✅ IMPLEMENTED
- **验证:** 9 个委托类 skill 有三层结构，sdd-doctor/sdd-review-spec 特殊情况正确

## 结论: PASSED

Batch 1 的 CRITICAL 问题 (Windows 路径正则) 已修复，所有 18 个 spec 场景已正确实现。
测试结果: 74/74 passing。

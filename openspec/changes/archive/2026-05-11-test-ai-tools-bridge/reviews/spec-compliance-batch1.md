# Spec Compliance Review — Batch 1

**审查对象:** specs/ vs 测试代码
**日期:** 2026-05-11

## 场景覆盖统计

- 总场景数: 18
- ✅ 已实现: 16
- ⚠️ 部分实现: 2
- ❌ 未实现: 0
- 覆盖率: 89% 完全实现, 100% 有对应测试

## 逐场景结果

### L1 结构验证

#### spec:l1-structural#skill-frontmatter-name-description
- **状态:** ✅ IMPLEMENTED
- **验证:** `skill-frontmatter.test.ts` 使用 `getSkillDirs()` + `parseSkillFrontmatter` 遍历 11 个 skill，断言 name/description 非空字符串
- **边缘:** `parseSkillFrontmatter` 正则 `^---\n` 要求 `---` 在文件开头，不处理前导空白行（spec 提到可能有空白行）。当前所有 SKILL.md 实际无前导空白，故不影响测试结果。

#### spec:l1-structural#skill-name-matches-directory
- **状态:** ✅ IMPLEMENTED
- **验证:** `skill-name-matches-dir.test.ts` 比较 `path.basename(dir)` 与 `frontmatter.name`

#### spec:l1-structural#skills-directory-clean
- **状态:** ✅ IMPLEMENTED
- **验证:** `skills-directory.test.ts` 验证 11 个 sdd-* 目录存在，无非 sdd-* 目录

#### spec:l1-structural#plugin-json-valid
- **状态:** ⚠️ PARTIAL
- **验证:** `plugin-json.test.ts` 验证 name/version/author.name/license
- **问题:** semver 正则 `^\d+\.\d+\.\d+$` 不兼容 `v` 前缀（spec 提到可能有）。当前实际值为 `0.2.0`（无 v 前缀），不影响当前结果，但与 spec 边界条件不符。

#### spec:l1-structural#template-files-match-schema-artifacts
- **状态:** ✅ IMPLEMENTED
- **验证:** `template-files.test.ts` 用 artifact key 与模板文件名交叉验证
- **备注:** 使用 artifact key 而非 `file` 字段值做匹配。当前两者一致，不影响结果。

#### spec:l1-structural#template-placeholders-cover-content-constraints
- **状态:** ⚠️ PARTIAL — **实际为死代码，在 Windows 上不执行断言**
- **验证:** `template-placeholders.test.ts` 第 13 行正则 `/\/([^/]+)\.md$/` 使用 Unix 路径分隔符 `/`
- **问题:** 在 Windows 上 `getTemplateFiles()` 返回 `\` 分隔路径，正则匹配失败，所有 key 为 `''`，`templateMap` 仅含 1 个空键条目。循环中 `templateMap.get(artifactKey)` 对所有 artifact 返回 `undefined`，触发 `continue` 跳过所有断言。测试通过是因为**没有执行任何断言**，而非因为断言成功。
- **严重度:** CRITICAL

#### spec:l1-structural#reviewer-prompt-files-exist
- **状态:** ✅ IMPLEMENTED
- **验证:** `reviewer-prompts.test.ts` 检查 5 个文件存在且非空

#### spec:l1-structural#reviewer-prompt-has-required-sections
- **状态:** ✅ IMPLEMENTED
- **验证:** 检查"审查维度"出现、severity 分级、输出格式
- **备注:** 严重性检查同时接受 traditional (critical/major/minor) 和 compliance (IMPLEMENTED/MISSING) 分类，比 spec 更宽松。输出格式检查也放宽了匹配范围。

#### spec:l1-structural#guidelines-files-exist
- **状态:** ✅ IMPLEMENTED
- **验证:** `guidelines.test.ts` 验证 4 个文件存在
- **备注:** 未检查"总数为 4"（即可能有多余文件），影响较小

#### spec:l1-structural#schema-yaml-valid-and-parseable
- **状态:** ✅ IMPLEMENTED
- **验证:** `schema-yaml.test.ts` 验证 YAML 合法、含 artifacts/dependency_chain、7 个 entries

### L2 编排验证

#### spec:l2-orchestration#dependency-chain-matches-artifact-definitions
- **状态:** ✅ IMPLEMENTED
- **验证:** chain items 在 artifacts 中存在，required artifacts 在 chain 中

#### spec:l2-orchestration#artifact-dependencies-reference-valid-artifacts
- **状态:** ✅ IMPLEMENTED
- **验证:** dependencies 引用有效 artifact，DFS 三色算法检测无环

#### spec:l2-orchestration#skill-delegation-targets-valid
- **状态:** ✅ IMPLEMENTED
- **验证:** 硬编码委托表与 SKILL.md body 交叉验证，sdd-doctor 无委托

#### spec:l2-orchestration#override-instructions-complete
- **状态:** ✅ IMPLEMENTED
- **验证:** sdd-brainstorm(4要素)、sdd-plan(5要素)、sdd-review-code(3要素) 全部验证

#### spec:l2-orchestration#review-loop-max-3-rounds
- **状态:** ✅ IMPLEMENTED
- **验证:** "最多 3 轮"约束、命名格式 reviews/<artifact>-r<N>.md

#### spec:l2-orchestration#skill-preconditions-match-schema-dependencies
- **状态:** ✅ IMPLEMENTED
- **验证:** sdd-plan/tasks、sdd-code/tasks、sdd-verify/specs、sdd-ship/tasks 全部覆盖

#### spec:l2-orchestration#reviewer-prompts-aligned-with-review-skills
- **状态:** ✅ IMPLEMENTED
- **验证:** SKILL.md 引用与磁盘文件一致
- **备注:** `code-quality-reviewer-prompt.md` 由 Phase 2 隐式使用，未在引用检查中覆盖

#### spec:l2-orchestration#skill-three-layer-structure-consistent
- **状态:** ✅ IMPLEMENTED
- **验证:** 9 个委托类 skill 有三层结构，sdd-doctor/sdd-review-spec 特殊情况正确

## 结论: FAILED

1 个 CRITICAL issue：
- `template-placeholders.test.ts` 在 Windows 上为死代码（路径正则不兼容 Windows 路径分隔符）

1 个 MAJOR issue：
- `plugin-json.test.ts` semver 正则不兼容 `v` 前缀

推荐: 修复 `template-placeholders.test.ts` 的路径提取正则（使用 `path.basename(f, '.md')` 替代手写正则），然后重新运行验证。

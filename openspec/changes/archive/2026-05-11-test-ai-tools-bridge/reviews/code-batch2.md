# Code Review: test-ai-tools-bridge (Batch 2)

> **Reviewer**: Code Quality Review (Phase 2)
> **Date**: 2026-05-11
> **Scope**: 18 files (1 setup module, 1 setup test, 10 L1 tests, 7 L2 tests)
> **Test results**: 74/74 passing

---

## Batch 1 Issue Resolution

| ID | Severity | Description | Status | Notes |
|----|----------|-------------|--------|-------|
| C1 | Critical | `template-placeholders.test.ts` Windows path regex | **FIXED** | Now uses `path.basename(f, '.md')` (line 14). Correct and cross-platform. |
| I1 | Important | `skill-frontmatter.test.ts` inline `require('path')` | **FIXED** | Now uses top-level `import path from 'node:path'` (line 2). |
| I2 | Important | `readSkillBody` helper duplicated in 3 files | **UNFIXED** | Still duplicated in `override-instructions.test.ts:4-7`, `review-loops.test.ts:4-7`, `preconditions.test.ts:4-7`. |
| I3 | Important | `plugin-json.test.ts` test ordering dependency | **UNFIXED** | `plugin` still assigned inside first test (line 11), consumed by tests 2-3 (lines 19, 24). No `beforeAll` used. |
| I4 | Important | `template-placeholders.test.ts` matching too weak | **FIXED** | Completely rewritten with 5-level matching strategy (exact heading, partial heading prefix, desc tokens, base tokens, desc parts). Much stronger validation. |
| I5 | Important | Unused `loadSchema` import in `preconditions.test.ts` | **FIXED** | Import now only includes `resolveRoot` and `parseSkillFrontmatter` (line 2). |
| I6 | Important | Unused `fs` import in `template-files.test.ts` | **FIXED** | No `fs` import present. File only imports `path`, `loadSchema`, `getTemplateFiles`. |
| I7 | Important | Wrong error message prefix in `skill-delegation.test.ts` | **FIXED** | Error message at line 47 now uses `${name}` without redundant `sdd-` prefix. |
| M1 | Minor | `guidelines.test.ts` redundant test coverage | **UNFIXED** | Both the loop-based "all 4 exist" test (lines 13-18) and `test.each` (lines 20-22) remain. |
| M2 | Minor | `skills-directory.test.ts` repeated directory read | **UNFIXED** | Two tests each call `fs.readdirSync` independently. |
| M3 | Minor | `reviewer-prompts.test.ts` reads files 4x each | **UNFIXED** | Four tests each loop and `readFileSync` all 5 files. |
| M4 | Minor | `parseSkillFrontmatter` regex does not handle `\r\n` | **UNFIXED** | Regex at `setup.ts:79` still uses `^---\n`. |
| M5 | Minor | `schema-yaml.test.ts` and `setup.test.ts` overlap | **UNFIXED** | Both test schema validity with similar assertions. |
| M6 | Minor | Cycle detection error message could be improved | **UNFIXED** | Still reports starting node, not cycle path. |

**Summary**: 5 of 7 Important/Critical issues fixed. 2 carry over (I2, I3). All 6 Minor items carry over.

---

## Strengths

1. **Setup module (`setup.ts`) is well-designed.** The utility layer provides clean, focused abstractions: `resolveRoot` with directory-heuristic discovery and caching (lines 44-69), `parseSkillFrontmatter` with YAML frontmatter extraction (lines 77-87), `loadSchema` with single-parse caching (lines 91-103), `getSkillDirs` and `getTemplateFiles` as convenient enumerators (lines 110-131). The TypeScript interfaces (`ParsedSkill`, `SchemaArtifact`, `SchemaDef`) at lines 8-37 give strong typing to consumers. The caching strategy (`_cachedRoot`, `_cachedSchema`) avoids redundant I/O without requiring explicit lifecycle management.

2. **Template-placeholders test was significantly improved.** The Batch 1 version had a trivially satisfied single `includes()` check. The current version (`template-placeholders.test.ts`) uses a sophisticated 5-level matching strategy: exact heading match (line 34), partial prefix heading match (lines 36-42), description token extraction (lines 44-47), base name token split (line 49), and description substring split (lines 51-54). This is a meaningful improvement in validation strength.

3. **Consistent L1/L2 organization.** Each test file covers exactly one spec scenario. File names map directly to spec scenario names. The `test.each` pattern in `skill-frontmatter.test.ts:8`, `skill-name-matches-dir.test.ts:8`, and `guidelines.test.ts:20` gives per-item pass/fail visibility.

4. **DFS cycle detection is correct.** `dependency-chain.test.ts:43-66` implements the three-color (WHITE/GRAY/BLACK) algorithm properly. For a 7-node graph this is proportionate and clear.

5. **Good assertion messages throughout.** Nearly every `expect` includes a descriptive failure message with context (e.g., `Missing template for artifact "${key}"` at `template-files.test.ts:13`, `Missing: ${skill}/${file}` at `reviewer-prompts.test.ts:17`).

6. **Clean import hygiene (after Batch 1 fixes).** All test files now use consistent top-level ESM imports. No more inline `require()` calls.

---

## Issues

### Critical (Must Fix)

None. The sole Critical issue from Batch 1 (C1) is confirmed fixed.

---

### Important (Should Fix)

#### I8. `readSkillBody` still duplicated in 3 files (carried over from I2)

**Files**: `override-instructions.test.ts:4-7`, `review-loops.test.ts:4-7`, `preconditions.test.ts:4-7`

```ts
function readSkillBody(skillName: string): string {
  const filePath = resolveRoot('skills', skillName, 'SKILL.md');
  return parseSkillFrontmatter(filePath).body;
}
```

Identical function defined independently in all three files. If the skill file naming convention changes, three files need updating instead of one. This is exactly the kind of helper that belongs in `setup.ts`.

**Why it matters**: DRY violation in test infrastructure increases maintenance burden. The `setup.ts` module already provides `parseSkillFrontmatter` and `resolveRoot` -- adding `readSkillBody` as a composition of the two is natural.

**Fix**: Export `readSkillBody` from `setup.ts` and import in the three consumer files.

#### I9. `plugin-json.test.ts` test ordering dependency (carried over from I3)

**File**: `plugin-json.test.ts:7-26`

```ts
let plugin: Record<string, unknown>;    // line 7: uninitialized

test('plugin.json is valid JSON...', () => {
  plugin = JSON.parse(content);         // line 11: assigned here
});

test('version matches semver format', () => {
  const version = plugin!.version ...   // line 20: depends on test 1
});
```

The second and third tests depend on `plugin` being assigned by the first test. Vitest runs tests within a `describe` block sequentially by default, but this is an implicit contract. Running individual tests in isolation (e.g., via `vitest run --testNamePattern`) or restructuring would cause failures.

**Why it matters**: Tests should be independent. The non-null assertion `plugin!.version` will throw if the first test is skipped or run out of order.

**Fix**: Use `beforeAll`:
```ts
let plugin: Record<string, unknown>;
beforeAll(() => {
  plugin = JSON.parse(fs.readFileSync(pluginPath, 'utf-8'));
});
```

#### I10. `extractOverrideSection` / `extractPreLogic` duplication pattern

**Files**: `override-instructions.test.ts:9-13`, `preconditions.test.ts:9-12`

```ts
// override-instructions.test.ts
function extractOverrideSection(body: string): string {
  const match = body.match(/Override 指令([\s\S]*?)(?=\n##[^#]|\n---\n|$)/);
  return match ? match[0] : body;
}

// preconditions.test.ts
function extractPreLogic(body: string): string {
  const match = body.match(/前置逻辑[\s\S]*?(?=\n##[^#]|\n---\n|$)/);
  return match ? match[0] : body;
}
```

Both functions follow the identical pattern: match a heading name, extract until next `##`-level heading or `---`, fallback to full body. The only difference is the heading text. This is a generalizable "extract section by heading" utility.

**Why it matters**: Not just duplication of code, but duplication of the regex pattern. If the SKILL.md heading convention changes (e.g., from `## 前置逻辑` to `### 前置逻辑`), both regexes need independent fixes.

**Fix**: Extract a generic `extractSection(body: string, heading: string): string` to `setup.ts`, then the two files call it with their specific heading text.

#### I11. `template-placeholders.test.ts` matching, while improved, is still quite lenient

**File**: `template-placeholders.test.ts:55-57`

```ts
const hasTokens = [...descTokens, ...baseTokens, ...descParts].some(t => template.includes(t));
expect(
  exactHeading || partialHeading || hasTokens,
```

The `hasTokens` fallback at line 55 uses `.some()` -- meaning a single 2-character token match anywhere in the template body satisfies the entire constraint. Combined with the token splitting strategy that splits on punctuation and spaces (lines 45-53), many short generic tokens like "描述", "格式", "步骤" will trivially match any template.

For example, if a constraint field is "TDD 步骤", it splits into `["TDD", "步骤"]`. The token "步骤" alone appearing anywhere in the template text would satisfy the check, even without a proper structural placeholder.

**Why it matters**: The 5-level matching is a major improvement over Batch 1, but the `hasTokens` fallback is still a soft escape hatch that can mask missing structural placeholders. In practice, all current templates have proper structure so this is not a current false-negative risk, but it reduces the test's ability to catch future regressions.

**Fix**: Consider requiring at least 2 tokens to match rather than 1, or weighting the fallback lower (e.g., if only `hasTokens` matches, log a warning).

#### I12. `reviewer-prompts.test.ts:49-65` assertion criteria are overly broad

**File**: `reviewer-prompts.test.ts:49-65`

```ts
const hasSummary =
  content.includes('总结') || content.includes('场景覆盖') || content.includes('统计');
const hasIssues =
  content.includes('Issues') || content.includes('逐场景');
const hasConclusion =
  content.includes('结论') || content.includes('统计');
```

The test checks for output format by looking for any of several Chinese keywords. The OR-based matching means a reviewer prompt could pass by containing the word "统计" in any context, without actually having a structured summary section. Similarly, "Issues" as a bare English word could appear in explanatory prose.

**Why it matters**: The test verifies structural completeness of reviewer prompts (they should have summary, issues, and conclusion sections) but the assertions only verify that certain Chinese characters appear somewhere in the text.

**Fix**: Match against heading patterns like `## 总结` or `### 总结` rather than bare `includes()`.

---

### Minor (Nice to Have)

#### M7. `guidelines.test.ts` redundant test coverage (carried over from M1)

**File**: `guidelines.test.ts:13-22`

Lines 13-18 loop over all 4 files checking existence. Lines 20-22 use `test.each` to do the same thing per-file. If any file is missing, both tests fail for it.

**Fix**: Keep the `test.each` version (better per-item visibility) and remove the loop-based test.

#### M8. `skills-directory.test.ts` repeated directory read (carried over from M2)

**File**: `skills-directory.test.ts:8, 15`

`fs.readdirSync(resolveRoot('skills'), { withFileTypes: true })` is called in both tests. A module-level variable or `beforeAll` would eliminate the duplication.

#### M9. `reviewer-prompts.test.ts` reads all 5 files 4 times each (carried over from M3)

**File**: `reviewer-prompts.test.ts:14-65`

Four tests each loop over all 5 prompts and call `readFileSync`. A module-level `Map<string, string>` populated once would reduce I/O from 20 reads to 5.

#### M10. `parseSkillFrontmatter` regex does not handle `\r\n` (carried over from M4)

**File**: `setup.ts:79`

```ts
const match = content.match(/^---\n([\s\S]*?)\n---/);
```

On Windows with `\r\n` endings, the `\n---` terminator would not match `\r\n---`. Git typically normalizes, but this is a latent compatibility issue.

#### M11. `schema-yaml.test.ts` and `setup.test.ts` overlapping assertions (carried over from M5)

`schema-yaml.test.ts:5-26` and `setup.test.ts:42-59` both verify schema structure (artifacts exist, dependency_chain is an array, 7 artifact types). A schema regression triggers duplicate failures.

#### M12. `dependency-chain.test.ts:61` cycle detection error message (carried over from M6)

The error message names the DFS starting node, not the actual cycle path. For a 7-node graph this is debuggable by inspection.

#### M13. `setup.ts:53` hardcoded loop limit of 10

```ts
for (let i = 0; i < 10; i++) {
```

The `resolveRoot` function walks up at most 10 directory levels. If the project were deeply nested (more than 10 levels from filesystem root), this would silently fail and throw the generic error. In practice, 10 is more than sufficient, but the magic number has no documentation of why 10 was chosen.

#### M14. `setup.ts:79` frontmatter regex anchors to line start but not line content

```ts
const match = content.match(/^---\n([\s\S]*?)\n---/);
```

This matches `---` at the start of a line followed by a newline. If a SKILL.md has leading whitespace or a BOM, the regex would fail. The `^` anchor with the `m` flag would be more robust, though currently `m` is not used so `^` matches only the string start.

#### M15. `reviewer-prompts.test.ts:6-11` hardcoded prompt list could go stale

The `reviewerPrompts` array at lines 5-11 enumerates 5 specific prompt files. If a new skill adds a reviewer prompt, this array must be manually updated. Consider deriving the list dynamically from the filesystem (scanning for `*-reviewer-prompt.md` files under `skills/sdd-*/`).

#### M16. `skill-delegation.test.ts:6-29` hardcoded delegation map synchronization risk

The `expectedDelegations` map is a static copy of the delegation table from CLAUDE.md. If CLAUDE.md is updated with new delegation targets, this map must be manually synchronized. This is a test design tradeoff -- hardcoded expected values provide precise assertions but create a maintenance surface.

---

## New Issues (vs Batch 1)

| ID | Severity | Description |
|----|----------|-------------|
| I10 | Important | `extractOverrideSection` / `extractPreLogic` follow identical pattern with duplicated regex -- a generalizable utility is missing |
| I11 | Important | `template-placeholders.test.ts` `hasTokens` fallback uses `.some()` with 2-char minimum, allowing trivial single-token matches to satisfy constraints |
| I12 | Important | `reviewer-prompts.test.ts` output format assertions use overly broad OR-based `includes()` instead of heading pattern matching |
| M13 | Minor | `setup.ts:53` hardcoded loop limit of 10 without documentation |
| M14 | Minor | `setup.ts:79` frontmatter regex does not account for BOM or leading whitespace |
| M15 | Minor | `reviewer-prompts.test.ts` hardcoded prompt list must be manually maintained |
| M16 | Minor | `skill-delegation.test.ts` hardcoded delegation map creates synchronization risk with CLAUDE.md |

---

## Recommendations

1. **Promote shared helpers to `setup.ts`**. Three helpers are duplicated or near-duplicated:
   - `readSkillBody` (3 identical copies) -- move to `setup.ts`
   - `extractSection(body, heading)` -- generalize from `extractOverrideSection` and `extractPreLogic`
   - This addresses I8 and I10 in one change.

2. **Fix the `plugin-json.test.ts` ordering dependency**. Adding a `beforeAll` hook (I9) is a 2-line change that makes the tests independent. This is the most straightforward remaining fix.

3. **Strengthen content-matching assertions**. The improved `template-placeholders.test.ts` is much better than Batch 1, but the `hasTokens` fallback (I11) and the `reviewer-prompts.test.ts` keyword matching (I12) could be tightened. Consider requiring heading-level matches (`## heading`) as the primary assertion and treating bare text matches as supplementary evidence only.

4. **Address `\r\n` compatibility in `setup.ts`** (M10/M14). A single regex change to use `\r?\n` or the `m` flag would make the test suite robust against line-ending variations. This is a low-effort, low-risk improvement.

5. **Consider dynamic prompt/delegation discovery** (M15/M16). For a test suite that validates structural invariants, deriving expected values from the filesystem or schema rather than hardcoding them makes the tests more resilient to project evolution. This is a longer-term improvement, not blocking.

---

## Assessment

**Ready to merge?** Yes, with notes.

**Reasoning:** All Critical and previously-blocking issues from Batch 1 are fixed. The remaining Important issues (I8-I12) are code quality improvements -- duplicated helpers, test ordering assumptions, and assertion specificity -- that do not affect correctness (74/74 tests pass and validate the correct properties). The test suite is functionally sound. The Important items should be addressed in a follow-up cleanup pass but are not merge-blocking.

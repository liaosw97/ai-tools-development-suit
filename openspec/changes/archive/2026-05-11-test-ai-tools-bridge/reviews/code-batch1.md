# Code Review: test-ai-tools-bridge (Batch 1)

> **Reviewer**: Code Quality Review (Phase 2)
> **Date**: 2026-05-11
> **Scope**: 18 files (1 setup module, 1 setup test, 9 L1 tests, 7 L2 tests, package.json, vitest.config.ts)
> **Test results**: 74/74 passing (17 files, 1.04s)

---

## Strengths

1. **Well-designed setup module (`tests/setup.ts`)**. The utility layer is clean and focused -- `resolveRoot` with directory-heuristic discovery, `parseSkillFrontmatter` with regex extraction, `loadSchema` with caching. The exported TypeScript interfaces (`ParsedSkill`, `SchemaArtifact`, `SchemaDef`) give the test files good type safety without being over-engineered. The module-level caching (`_cachedRoot`, `_cachedSchema`) avoids redundant I/O across tests without requiring explicit lifecycle management.

2. **Consistent test organization**. The L1/L2 split maps directly to the spec structure. Each test file covers exactly one spec scenario, making it easy to trace failures back to requirements. Test descriptions are clear and use meaningful assertion messages (e.g., `Missing template for artifact "${key}"`).

3. **Good use of vitest patterns**. `test.each` is used appropriately in `skill-frontmatter.test.ts`, `skill-name-matches-dir.test.ts`, `guidelines.test.ts`, and `three-layer-structure.test.ts`. This gives per-item pass/fail visibility in verbose output rather than "11 things checked, one failed somewhere."

4. **The DFS cycle detection** (`dependency-chain.test.ts:43-66`) is correctly implemented with the three-color (WHITE/GRAY/BLACK) algorithm. For a 7-node graph it is proportionate and clear.

5. **Module-level data loading**. Calling `getSkillDirs()` and `loadSchema()` at module scope (outside test functions) means the data is loaded once and shared across all tests in the file. This is efficient for a static test suite.

---

## Issues

### Critical (Must Fix)

#### C1. `template-placeholders.test.ts:13` -- Windows path regex silently disables all assertions (KNOWN)

```js
const key = f.match(/\/([^/]+)\.md$/)?.[1] || '';
```

On Windows, `getTemplateFiles()` returns paths with `\` separators. The forward-slash regex never matches, so `key` is always `''`. The `templateMap` gets a single entry keyed by `''` (the last file wins, overwriting previous ones). This means:

- The test only checks the last template file in sorted order against ALL artifact constraints.
- For most artifacts, `templateMap.get(artifactKey)` returns `undefined`, hitting the `if (!template) continue` guard on line 19, silently skipping validation.

**Impact**: The entire `template-placeholders-cover-content-constraints` scenario is effectively dead code on Windows. None of the 7 artifacts' required content constraints are actually being checked.

**Fix**: Use `path.basename(f, '.md')` instead of the regex:
```js
const key = path.basename(f, '.md');
```

> Note: This issue was already identified in Phase 1 and is called out in the review instructions. Documented here for completeness and to confirm severity.

---

### Important (Should Fix)

#### I1. `skill-frontmatter.test.ts:7,10` -- Inline `require('path')` instead of ESM import

```js
test.each(skillDirs.map((d) => [require('path').basename(d), d]))(
  // ...
  const result = parseSkillFrontmatter(require('path').join(dir, 'SKILL.md'));
```

Every other test file properly imports `path` at the top with `import path from 'node:path'`. This file uses inline `require()` twice, which is inconsistent and technically incorrect for an ESM module (`"type": "module"` in package.json). It happens to work because vitest/ts-node provide CJS interop, but it is a code smell that could break under different Node configurations.

**Impact**: Style inconsistency; potential future compatibility issue if the CJS interop is removed or the module resolution changes.

**Fix**: Add `import path from 'node:path'` at the top and use `path.basename()` / `path.join()` normally.

#### I2. Duplicated `readSkillBody` helper across 3 L2 test files

The identical function is defined in:
- `override-instructions.test.ts:4-7`
- `review-loops.test.ts:4-7`
- `preconditions.test.ts:4-7`

```js
function readSkillBody(skillName: string): string {
  const filePath = resolveRoot('skills', skillName, 'SKILL.md');
  return parseSkillFrontmatter(filePath).body;
}
```

**Impact**: DRY violation. If the file path convention changes (e.g., skill files are renamed), three files need updating instead of one. This is exactly the kind of helper that belongs in `setup.ts`.

**Fix**: Move `readSkillBody` to `setup.ts` and export it. The three consumer files can then import it.

#### I3. `plugin-json.test.ts:19-22` -- Test ordering dependency via shared mutable state

```js
test('plugin.json is valid JSON with required fields', () => {
  // ...
  plugin = JSON.parse(content);  // assigns to module-level `let plugin`
});

test('version matches semver format', () => {
  const version = plugin!.version as string;  // depends on previous test
});
```

The second and third tests depend on `plugin` being set by the first test. While vitest runs tests within a `describe` block sequentially by default, this is an implicit contract. If someone restructures the tests or runs them in isolation, tests 2 and 3 will fail with `Cannot read properties of undefined`.

**Impact**: Brittle test design that breaks under minor reorganization.

**Fix**: Either (a) move the JSON parsing into a `beforeAll` hook, or (b) parse the file independently in each test. Option (a) is cleaner:
```js
let plugin: Record<string, unknown>;
beforeAll(() => {
  plugin = JSON.parse(fs.readFileSync(pluginPath, 'utf-8'));
});
```

#### I4. `template-placeholders.test.ts:28-30` -- Constraint matching is trivially satisfied

```js
const inHeading = template.includes(`## ${field}`);
const inComment = template.includes(field);
expect(inHeading || inComment, ...).toBe(true);
```

Line 30 (`inComment`) checks if the field name appears *anywhere* in the template as a bare substring match. Since field names are Chinese phrases like "需求描述" or "方案探索", they are very likely to appear in descriptive text surrounding the actual placeholder. This means the test would pass even if the template lacks a proper `## heading` or HTML comment for that field -- as long as the field name text appears somewhere in the prose.

**Impact**: The test provides weaker validation than intended. A template could pass without having proper structured placeholders for its required constraints.

**Fix**: Remove the `inComment` fallback or make it more specific (e.g., match `<!-- ... ${field} ... -->` pattern only). The `inHeading` check alone is the meaningful assertion.

#### I5. `preconditions.test.ts` imports `loadSchema` but never uses it

```js
import { resolveRoot, parseSkillFrontmatter, loadSchema } from '../setup.js';
```

`loadSchema` is imported but never referenced in the test body. The test checks skill preconditions by string-matching against SKILL.md body text, not by cross-referencing schema dependencies.

**Impact**: Dead import; minor confusion for readers who expect schema cross-validation.

**Fix**: Remove `loadSchema` from the import.

#### I6. `template-files.test.ts:4` -- Unused import of `fs`

```js
import fs from 'node:fs';
```

`fs` is imported but never used in this file. The file uses `loadSchema()` and `getTemplateFiles()` from setup.ts for all I/O.

**Impact**: Dead import; linter warning in strict configurations.

**Fix**: Remove the `import fs from 'node:fs'` line.

#### I7. `skill-delegation.test.ts:48` -- Error message prefix is wrong

```js
`sdd-${name} should delegate to "${target}" but not found in SKILL.md`
```

`name` is already `path.basename(dir)` which returns the full directory name like `sdd-brainstorm`. The template string prepends `sdd-` again, producing error messages like `"sdd-sdd-brainstorm should delegate to..."`.

**Impact**: Confusing error messages if the assertion fails. The assertion logic itself is correct, so tests pass.

**Fix**: Change to `${name} should delegate to "${target}" but not found in SKILL.md`.

---

### Minor (Nice to Have)

#### M1. `guidelines.test.ts` -- Redundant test coverage

Lines 13-18 (the "all 4 exist" test) and lines 20-22 (the `test.each` per-file test) check the same thing: whether each file exists. If any file is missing, both tests fail for that file. The combined test adds no additional coverage.

**Impact**: Slightly noisy failure output (two failures per missing file instead of one).

**Fix**: Keep the `test.each` version (better per-item visibility) and remove the loop-based "all 4 exist" test.

#### M2. `skills-directory.test.ts:8` and `skills-directory.test.ts:15` -- Repeated directory read

`fs.readdirSync(resolveRoot('skills'), ...)` is called in both tests. For a small directory this is negligible, but a `beforeAll` or module-level variable would be cleaner.

**Impact**: Negligible performance cost; minor style issue.

#### M3. `reviewer-prompts.test.ts` -- Each test reads all 5 files independently

Four tests each loop over all 5 reviewer prompts and `fs.readFileSync` each one. The files are read up to 4 times each. A module-level `Map<string, string>` populated once would reduce I/O.

**Impact**: Negligible for 5 small files; more of a best-practice point.

#### M4. `parseSkillFrontmatter` regex does not handle `\r\n` line endings

```js
const match = content.match(/^---\n([\s\S]*?)\n---/);
```

If a SKILL.md file has Windows-style line endings (`\r\n`), the `\n` in the regex would not match `\r\n` at the end of the `---` lines. The `^---` would match because `$` is not used, but `\n---` would fail against `\r\n---`.

**Impact**: Unlikely in practice (git typically normalizes line endings), but worth noting for a Windows development environment. The `body.trimStart()` on line 84 would also behave slightly differently with `\r` characters.

#### M5. `schema-yaml.test.ts` and `setup.test.ts` -- Overlapping test coverage

`schema-yaml.test.ts` tests schema validity (valid YAML, has artifacts, has dependency_chain, 7 entries). `setup.test.ts` lines 42-58 test the same schema properties (7 artifact types, chain array exists and is non-empty). These two files duplicate each other's core assertions.

**Impact**: Not harmful, but the overlap means a schema regression triggers multiple test failures saying the same thing.

#### M6. `dependency-chain.test.ts:51` -- Cycle detection could produce misleading error

```js
expect(dfs(key), `Cycle detected involving "${key}"`).toBe(false);
```

If a cycle exists, the error message names the node where DFS started, not the actual cycle members. For a 7-node graph this is debuggable by inspection, but a more helpful message would list the cycle path.

---

## Recommendations

1. **Promote `readSkillBody` to `setup.ts`**. Three files define the same helper. This is the most actionable DRY improvement. While doing so, consider also promoting `extractOverrideSection` and `extractPreLogic` (or a generalized "extract section by heading" utility), since they follow the same pattern of parsing SKILL.md body structure.

2. **Add `path.basename` usage consistently**. The known Windows regex bug in `template-placeholders.test.ts` and the inline `require('path')` in `skill-frontmatter.test.ts` both stem from the same root cause: not using the `path` module for path operations. Audit all path manipulation and ensure it uses `path.basename`, `path.join`, etc.

3. **Consider a shared test-data loading pattern**. Several test files call `loadSchema()` at module scope. While the caching in `setup.ts` prevents redundant parsing, the pattern is implicit. A `beforeAll` + shared variable pattern would be more explicit about test lifecycle dependencies, especially for files that also load skill directories.

4. **Strengthen assertion specificity in content-matching tests**. Tests like `template-placeholders`, `reviewer-prompts`, and `preconditions` use broad `toContain` / `includes` checks. These pass easily because they match substrings in prose text. Consider matching against more specific patterns (heading markers, HTML comments, code blocks) to catch structural regressions, not just text presence.

---

## Assessment

**Ready to merge?** No -- requires fixes.

**Reasoning**: The Windows path regex bug (C1) is confirmed critical: it makes the `template-placeholders-cover-content-constraints` spec scenario entirely ineffective on Windows. The wrong error message prefix in delegation tests (I7) and the dead import/require issues (I1, I5, I6) are easy fixes that should be included in the same change. The remaining Important items (I2, I3, I4) are design improvements that should be addressed before the test suite is considered production-quality but are not blocking.

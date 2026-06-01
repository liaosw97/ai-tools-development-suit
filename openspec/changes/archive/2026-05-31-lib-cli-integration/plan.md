# Plan: ai-tools-bridge/lib/ CLI 集成

> 实施计划 — TDD 级别的详细步骤

---

## 批次 1/3：CLI 脚本开发

<!-- 依赖：无前置依赖 -->
<!-- 任务范围：1.1-1.4 -->

### Task 1.1: 实现 summarize-spec.mjs [spec:cli-scripts#提取-spec-场景列表]

- **文件**: `ai-tools-bridge/scripts/summarize-spec.mjs` (Create)
- **RED**: 编写失败测试
  - 测试正常路径：spec 文件含 3 个 GIVEN/WHEN/THEN 场景，输出包含 3 个 "场景: <name>" 行
  - 测试错误路径：文件不存在时 stderr 输出错误，exit 非 0
  - 测试边界：spec 无场景时输出 "无场景"，exit 0
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs`
- **GREEN**: 最小实现
  - 读取 spec 文件（`fs.readFileSync`）
  - 正则匹配 `### 场景:` 提取场景名
  - 正则匹配 `GIVEN/WHEN/THEN` 代码块内容
  - 格式化输出：每行 "场景: <name>" 后跟 GIVEN/WHEN/THEN 缩进行
  - 文件不存在时 `process.stderr.write` + `process.exit(1)`
  - 无场景时输出 "无场景"
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs`

### Task 1.2: 实现 summarize-tasks.mjs [spec:cli-scripts#提取任务摘要]

- **文件**: `ai-tools-bridge/scripts/summarize-tasks.mjs` (Create)
- **RED**: 编写失败测试
  - 测试正常路径：含 `- [ ]` 和 `- [x]` 的 tasks.md，输出 "总数: 5, 已完成: 3, 待完成: 2"
  - 测试错误路径：文件不存在时 stderr 错误，exit 非 0
  - 测试边界：无 checkbox 文件输出 "总数: 0"；空文件输出 "总数: 0"
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs`
- **GREEN**: 最小实现
  - 读取 tasks 文件
  - 正则匹配 `- [ ]` 和 `- [x]` 行
  - 统计总数、已完成、待完成
  - 提取 `[spec:...]` 链接
  - 格式化输出
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs`

### Task 1.3: 实现 compress-review.mjs [spec:cli-scripts#压缩-review-上下文]

- **文件**: `ai-tools-bridge/scripts/compress-review.mjs` (Create)
- **RED**: 编写失败测试
  - 测试正常路径：diff + spec，输出 "变更文件: [...]" + "匹配场景: [...]"
  - 测试错误路径：spec 文件不存在时 stderr 错误，exit 非 0
  - 测试边界：空 diff 输出 "无变更"；spec 无场景输出 "无匹配场景"
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs`
- **GREEN**: 最小实现
  - 读取 diff 文件，解析变更文件列表（匹配 `^diff --git` 行）
  - 读取 spec 文件，提取场景列表
  - 匹配变更文件与场景（基于文件路径关键词）
  - 格式化输出
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs`

### Task 1.4: 实现 state-file.mjs [spec:cli-scripts#创建状态文件]

- **文件**: `ai-tools-bridge/scripts/state-file.mjs` (Create)
- **RED**: 编写失败测试
  - 测试 create：创建 state.yaml，包含 phase 字段
  - 测试 read：读取 state.yaml，输出 YAML 内容
  - 测试 update：更新 phase 字段
  - 测试错误路径：read 不存在文件时 stderr 错误，exit 非 0
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs`
- **GREEN**: 最小实现
  - 子命令解析：create/read/update
  - 手动 YAML 序列化：`change: <name>\nphase: <phase>\nupdated: <timestamp>`
  - create：`fs.writeFileSync` 写入 state.yaml
  - read：`fs.readFileSync` + `process.stdout.write`
  - update：读取 → 解析 → 更新字段 → 写回
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs`

--- checkpoint ---

<!-- 批次 1 完成后，运行全量测试确认无回归 -->
<!-- 验证命令: cd ai-tools-bridge && pnpm test -->

---

## 批次 2/3：集成测试

<!-- 依赖：批次 1 的 4 个脚本已实现（Task 2.2-2.5 依赖 Task 1.1-1.4） -->
<!-- 任务范围：2.1-2.6 -->

### Task 2.1: 创建 tests/cli/ 目录和测试基础设施 [spec:testing#使用-vitest-运行集成测试]

- **文件**: `ai-tools-bridge/tests/cli/helpers.mjs` (Create)
- **RED**: 编写失败测试
  - 测试 `createTempDir()` 返回有效临时目录路径
  - 测试 `writeTempFile(dir, name, content)` 创建文件且内容正确
  - 测试 `cleanupTempDir(dir)` 删除目录
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/helpers.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/helpers.test.mjs`
- **GREEN**: 最小实现
  - `createTempDir()`：`fs.mkdtempSync(path.join(os.tmpdir(), 'sdd-test-'))`
  - `writeTempFile(dir, name, content)`：`fs.writeFileSync(path.join(dir, name), content)`
  - `cleanupTempDir(dir)`：`fs.rmSync(dir, { recursive: true, force: true })`
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/helpers.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/helpers.test.mjs`

### Task 2.2: 编写 summarize-spec 端到端测试 [spec:testing#summarize-spec-端到端]

- **文件**: `ai-tools-bridge/tests/cli/summarize-spec.test.mjs` (Create)
- **RED**: 编写失败测试
  - 测试正常路径：3 场景 spec → 输出含 3 个 "场景: <name>" + GIVEN/WHEN/THEN
  - 测试错误路径：不存在文件 → stderr 错误，exit 非 0
  - 测试边界：无场景 spec → "无场景"，exit 0
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs`
- **GREEN**: 使用 `execFileSync` 调用脚本并断言
  - 正常：`expect(stdout).toContain("场景:")` 且出现 3 次
  - 错误：`expect(exitCode).not.toBe(0)` 且 stderr 非空
  - 边界：`expect(stdout).toContain("无场景")`
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-spec.test.mjs`

### Task 2.3: 编写 summarize-tasks 端到端测试 [spec:testing#summarize-tasks-端到端]

- **文件**: `ai-tools-bridge/tests/cli/summarize-tasks.test.mjs` (Create)
- **RED**: 编写失败测试
  - 测试正常路径：5 任务(3完成2待) → "总数: 5, 已完成: 3, 待完成: 2"
  - 测试错误路径：不存在文件 → stderr 错误，exit 非 0
  - 测试边界：无 checkbox → "总数: 0"；空文件 → "总数: 0"
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs`
- **GREEN**: 使用 `execFileSync` 调用脚本并断言
  - 正常：`expect(stdout).toContain("总数: 5")` 且包含 "已完成: 3" 和 "待完成: 2"
  - 错误：`expect(exitCode).not.toBe(0)`
  - 边界：`expect(stdout).toContain("总数: 0")`
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/summarize-tasks.test.mjs`

### Task 2.4: 编写 compress-review 端到端测试 [spec:testing#compress-review-端到端]

- **文件**: `ai-tools-bridge/tests/cli/compress-review.test.mjs` (Create)
- **RED**: 编写失败测试
  - 测试正常路径：diff + spec → "变更文件: [...]" + "匹配场景: [...]"
  - 测试错误路径：spec 不存在 → stderr 错误，exit 非 0
  - 测试边界：空 diff → "无变更"；spec 无场景 → "无匹配场景"
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs`
- **GREEN**: 使用 `execFileSync` 调用脚本并断言
  - 正常：`expect(stdout).toContain("变更文件:")` 且包含 "匹配场景:"
  - 错误：`expect(exitCode).not.toBe(0)`
  - 边界：空 diff → `expect(stdout).toContain("无变更")`；无场景 → `expect(stdout).toContain("无匹配场景")`
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/compress-review.test.mjs`

### Task 2.5: 编写 state-file 端到端测试 [spec:testing#state-file-端到端]

- **文件**: `ai-tools-bridge/tests/cli/state-file.test.mjs` (Create)
- **RED**: 编写失败测试
  - 测试 create：创建后文件存在且含 phase 字段
  - 测试 read：输出含 phase: brainstorm
  - 测试 update：phase 字段变为 propose
  - 测试错误路径：read 不存在文件 → stderr 错误，exit 非 0
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs`
- **GREEN**: 使用 `execFileSync` 调用脚本并断言
  - create：`expect(fs.existsSync(stateFile)).toBe(true)` 且内容含 `phase:`
  - read：`expect(stdout).toContain("phase: brainstorm")`
  - update：`expect(stdout).toContain("phase: propose")` 或重新 read 验证
  - 错误：`expect(exitCode).not.toBe(0)`
  ```bash
  cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/cli/state-file.test.mjs`

### Task 2.6: 验证现有 331 个测试不受影响 [spec:testing#现有测试不受影响]

- **文件**: 无（验证操作）
- **RED**: N/A（验证任务，无 RED 步骤）
- **GREEN**: 运行全量测试，确认 331 个现有测试全部通过
  ```bash
  cd ai-tools-bridge && pnpm test
  ```
- **运行验证通过**: `cd ai-tools-bridge && pnpm test` 输出 `Tests 331 passed`（或更多，含新增测试）

--- checkpoint ---

<!-- 批次 2 完成后，确认所有测试通过 -->
<!-- 验证命令: cd ai-tools-bridge && pnpm test -->

---

## 批次 3/3：SKILL.md 集成

<!-- 依赖：批次 1 脚本已实现，批次 2 测试已通过 -->
<!-- 任务范围：3.1-3.7 -->
<!-- 注意：SKILL.md 集成为文档修改，无需 TDD RED/GREEN，使用验证步骤确认脚本调用正确 -->

### Task 3.1: 集成 summarize-spec 到 sdd-review-code 前置逻辑 [spec:skill-integration#前置逻辑使用-summarize-spec-获取场景摘要]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **修改位置**: 前置逻辑 §收集审查材料
- **修改内容**: 在现有脚本引用旁添加 `compress-review.mjs` 的调用说明
- **验证**: `grep -n "summarize-spec" ai-tools-bridge/skills/sdd-review-code/SKILL.md` 确认引用存在

### Task 3.2: 集成 compress-review 到 sdd-review-code Phase 2 [spec:skill-integration#phase-2-使用-compress-review-准备上下文]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **修改位置**: Phase 2 核心执行
- **修改内容**: 添加 `node ai-tools-bridge/scripts/compress-review.mjs <diff-path> <spec-path>` 调用
- **验证**: `grep -n "compress-review" ai-tools-bridge/skills/sdd-review-code/SKILL.md` 确认引用存在

### Task 3.3: 集成 summarize-spec + summarize-tasks 到 sdd-verify [spec:skill-integration#前置逻辑使用-summarize-spec--summarize-tasks-收集验证材料]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **修改位置**: 前置逻辑 §收集验证材料
- **修改内容**: 添加两个脚本调用，使用 `<spec-path>` 和 `<tasks-path>` 参数占位符
- **验证**: `grep -n "summarize-spec\|summarize-tasks" ai-tools-bridge/skills/sdd-verify/SKILL.md` 确认引用存在

### Task 3.4: 集成 state-file 到 sdd-brainstorm [spec:skill-integration#sdd-brainstorm-创建状态文件]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **修改位置**: 后置逻辑 §状态文件更新（替换现有占位符）
- **修改内容**: 将块引用占位符替换为 `node ai-tools-bridge/scripts/state-file.mjs create <change-dir> --phase brainstorm`
- **验证**: `grep -n "state-file.mjs" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` 确认引用存在

### Task 3.5: 集成 state-file 到 sdd-propose [spec:skill-integration#sdd-propose-更新状态文件]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **修改位置**: 后置逻辑
- **修改内容**: 添加 `node ai-tools-bridge/scripts/state-file.mjs update <change-dir> --phase propose`
- **验证**: `grep -n "state-file.mjs" ai-tools-bridge/skills/sdd-propose/SKILL.md` 确认引用存在

### Task 3.6: 集成 state-file 到 sdd-plan [spec:skill-integration#sdd-plan-更新状态文件]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **修改位置**: 后置逻辑
- **修改内容**: 添加 `node ai-tools-bridge/scripts/state-file.mjs update <change-dir> --phase plan`
- **验证**: `grep -n "state-file.mjs" ai-tools-bridge/skills/sdd-plan/SKILL.md` 确认引用存在

### Task 3.7: 集成 state-file 到 sdd-code [spec:skill-integration#sdd-code-更新状态文件]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **修改位置**: 后置逻辑
- **修改内容**: 添加 `node ai-tools-bridge/scripts/state-file.mjs update <change-dir> --phase code`
- **验证**: `grep -n "state-file.mjs" ai-tools-bridge/skills/sdd-code/SKILL.md` 确认引用存在

--- checkpoint ---

<!-- 批次 3 完成后，运行全量测试 + 验证所有 SKILL.md 引用 -->
<!-- 验证命令: cd ai-tools-bridge && pnpm test -->
<!-- 验证命令: grep -rn "scripts/" ai-tools-bridge/skills/ --include="*.md" -->

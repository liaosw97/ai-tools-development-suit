# 代码审查 — 批次一：仓库初始化

**审查日期**: 2026-05-11
**审查范围**: `.gitignore`（新建）、`package.json`（新建）
**背景**: AiTools 从松散文件集合转变为 Git Submodule monorepo 的第一步

---

## 1. `.gitignore`

### minor — 缺少 `*.log` 日志文件模式

根目录和子项目可能产生 `.log` 文件（如 vitest 覆盖率报告、构建日志等），当前未排除。建议添加 `*.log` 模式，避免日志文件被意外跟踪。

### minor — 缺少环境变量文件排除

未包含 `.env`、`.env.*`、`.env.local` 等模式。虽然当前项目不涉及敏感配置，但作为 monorepo 根目录的 `.gitignore`，提前防御性排除是良好实践。建议添加：

```
# 环境变量
.env
.env.*
```

### minor — 缺少测试覆盖率目录

子项目使用 vitest，覆盖率输出目录（默认 `coverage/`）未被排除。后续运行 `pnpm run test:coverage` 时可能意外提交。建议添加 `coverage/`。

### minor — 缺少 `pnpm` 相关锁文件排除

ai-tools-bridge 已有 `package-lock.json`（npm 产物），项目声明使用 pnpm。如果后续统一到 pnpm workspace，根目录可能出现遗留的 `package-lock.json`。当前 `ai-tools-bridge` 已有自己的 `.gitignore` 处理了部分情况，但根 `.gitignore` 可考虑排除 `package-lock.json` 以防止子项目意外提交 npm 锁文件。

### minor — `log/` 目录排除可能过于宽泛

`log/` 被整目录排除，但 `log/` 目录在项目中用于导出对话记录（`log/history/`、`log/plan/`），属于有意的制品输出。全量排除意味着如果未来需要版本化某些日志（如审计记录），需要额外配置。当前排除是合理的（避免堆积），仅记录此设计决策供后续批次参考。

### 无问题 — 整体结构

分类注释清晰（子项目构建产物、临时文件、系统文件、IDE、版本锁备份），覆盖了 Windows/macOS 双平台系统文件，结构合理。

---

## 2. `package.json`

### major — `workspaces` 配置与子项目包管理器不兼容

`ai-tools/OpenSpec/package.json` 的依赖声明使用 pnpm（存在 `pnpm-lock.yaml`），但根 `package.json` 声明了 `"workspaces"` 字段，这是 npm/yarn 的 workspace 协议。pnpm 使用 `"workspaces"` 也可工作，但需要根目录存在 `pnpm-workspace.yaml` 文件才能真正激活 pnpm workspace 功能。

当前状态：
- 根 `package.json` 声明了 `workspaces`，但没有 `pnpm-workspace.yaml`
- npm 会尝试将 `node_modules` 提升到根目录（hoisting），与 pnpm 的扁平化策略冲突
- 如果用户运行 `npm install`（而非 `pnpm install`），会产生 `package-lock.json` 并破坏 pnpm 的依赖结构

**建议**: 在后续批次中添加 `pnpm-workspace.yaml`，并在根 `package.json` 中添加 `"packageManager": "pnpm@<version>"` 以锁定包管理器。当前批次作为初始化可以接受，但需注意不要在根目录运行 `npm install`。

### minor — 缺少 `packageManager` 字段

未指定 `"packageManager"` 字段（Corepack 标准）。这会导致不同开发者可能使用不同包管理器（npm/yarn/pnpm），引发依赖不一致。建议后续批次添加，例如：

```json
"packageManager": "pnpm@9.x.x"
```

### minor — 缺少 engines 字段

OpenSpec 子项目要求 `"node": ">=20.19.0"`，但根 `package.json` 未声明 Node.js 版本要求。作为 monorepo 根，应声明与最严格子项目一致的 engines 约束：

```json
"engines": {
  "node": ">=20.19.0"
}
```

### minor — `superpowers` 缺少 `private: true`

`superpowers/package.json` 没有 `"private": true`，其 `main` 指向 `.opencode/plugins/superpowers.js`，理论上可被 npm publish。虽然不在本次审查范围内（属于 superpowers 子项目自身的问题），但根 workspace 包含它时值得注意。

### minor — 缺少基础 scripts

根 `package.json` 没有任何 scripts。作为 monorepo 根，后续批次建议添加跨项目的编排脚本，例如：

```json
"scripts": {
  "test": "pnpm -r run test",
  "build": "pnpm -r run build",
  "lint": "pnpm -r run lint"
}
```

当前批次作为最小化初始化可以接受，但 `pnpm -r` 依赖 `pnpm-workspace.yaml` 的存在（见 major 问题）。

### 无问题 — 命名和描述

`name`、`description`、`private`、`license` 字段配置合理，描述准确反映了项目定位。

---

## 审查总结

| 严重性 | 数量 | 说明 |
|--------|------|------|
| critical | 0 | — |
| major | 1 | workspaces 与 pnpm 兼容性（需 pnpm-workspace.yaml） |
| minor | 8 | 缺少环境变量排除、日志模式、engines、packageManager 等 |

**总体评价**: 批次一作为仓库初始化的最小化起点是合格的。两个文件结构清晰、意图明确，没有阻塞性问题。唯一的 major 问题（pnpm workspace 配置不完整）不影响 git init 阶段，但应在后续批次中尽早补齐，避免在依赖安装时出现意外行为。

**对后续批次的建议优先级**:
1. 添加 `pnpm-workspace.yaml` + `packageManager` 字段（高）
2. 补充 `engines` 字段（中）
3. 完善 `.gitignore` 的防御性模式（低）
4. 添加根级编排 scripts（低，随功能需要逐步添加）

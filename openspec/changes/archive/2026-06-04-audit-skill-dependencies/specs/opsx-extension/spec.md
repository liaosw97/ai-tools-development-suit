# Spec: OPSX 扩展命令启用

## ADDED Requirements

### 启用扩展 Profile

GIVEN OpenSpec CLI 已构建（`pnpm install && pnpm run build` 完成）
WHEN 用户运行 `openspec config profile` 并选择 `workflows`
THEN `openspec update` 生成 7 个扩展命令文件到 `.claude/commands/opsx/`：
  - `new.md`
  - `continue.md`
  - `ff.md`
  - `verify.md`
  - `sync.md`
  - `bulk-archive.md`
  - `onboard.md`

### 扩展命令可用性

GIVEN 扩展命令文件已生成到 `.claude/commands/opsx/`（共 11 个 `.md` 文件）
WHEN 用户在 Claude Code 中输入 `/opsx:ff`、`/opsx:verify`、`/opsx:sync` 等命令
THEN 命令被正确识别并执行：
  - 调用 `openspec status --change <name> --json` 获取依赖图
  - 调用 `openspec instructions <artifact> --change <name> --json` 获取模板和上下文
  - 输出结构化的 artifact 内容或执行结果

### 构建失败处理

GIVEN OpenSpec CLI 未构建或构建失败（`pnpm run build` 返回非零退出码）
WHEN 用户尝试启用扩展 profile 或运行 `openspec update`
THEN 输出错误信息提示先修复构建，不生成部分命令文件

### 核心命令不受影响

GIVEN 扩展 profile 已启用
WHEN 用户使用核心命令（`/opsx:propose`、`/opsx:explore`、`/opsx:apply`、`/opsx:archive`）
THEN 核心命令行为与启用扩展前完全一致

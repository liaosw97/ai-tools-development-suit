# SKILL.md 质量扫描报告

> 扫描时间: 2026-05-31
> 扫描原因: lib-cli-integration 变更将修改以下 SKILL.md

## 扫描概要

- 扫描文件数: 6
- 已有脚本引用: 1/6
- 已有状态文件引用: 1/6
- 潜在问题: 4

## 逐文件报告

### 1. sdd-review-code/SKILL.md
- **结构**: PASS
- **脚本引用**: 有 — 已引用 `summarize-spec.mjs` 和 `summarize-tasks.mjs`
- **状态文件引用**: 无
- **备注**: 三阶段结构（Phase 1/1.5/2），修改时需尊重此结构

### 2. sdd-verify/SKILL.md
- **结构**: PASS
- **脚本引用**: 无
- **状态文件引用**: 无

### 3. sdd-brainstorm/SKILL.md
- **结构**: PASS
- **脚本引用**: 无
- **状态文件引用**: 有（占位符格式，第 94 行和第 199 行）
- **备注**: 状态文件引用为块引用占位符，需注意与脚本调用的衔接

### 4. sdd-propose/SKILL.md
- **结构**: PASS
- **脚本引用**: 无
- **状态文件引用**: 无

### 5. sdd-plan/SKILL.md
- **结构**: PASS
- **脚本引用**: 无
- **状态文件引用**: 无

### 6. sdd-code/SKILL.md
- **结构**: PASS
- **脚本引用**: 无
- **状态文件引用**: 无

## 潜在问题

1. **sdd-brainstorm 状态文件引用为占位符格式** — 添加 `state-file.mjs` 脚本调用时需与现有占位符衔接
2. **脚本引用格式不一致** — sdd-review-code 使用代码块格式，路径为 `ai-tools-bridge/scripts/...`
3. **Guidelines 引用格式统一** — 块引用 `>` 格式为按需加载占位符约定
4. **模块引用模式** — `modules/` 下子模块使用块引用占位符格式

## 集成建议

1. 脚本引用格式: `node ai-tools-bridge/scripts/<name>.mjs <args>`，放在"前置逻辑"节
2. 状态文件引用: 前置逻辑末尾添加"状态文件读取"子节，后置逻辑添加"状态文件更新"子节
3. 保持块引用占位符约定，不破坏模块化设计
4. sdd-review-code 三阶段结构不可打乱

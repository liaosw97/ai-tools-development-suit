## Why

ai-tools-bridge 的 14 个 SKILL.md 存在大量重复内容（触发条件、输出约束、角色加载、拆分模式、review 循环），总计 3396 行。每次加载 SKILL.md 时，AI 需要解析这些重复内容，导致不必要的 token 消耗。精简后可减少约 32% 的总行数（约 1096 行），降低上下文占用，同时提高可维护性。

## What Changes

- 创建 `skills/_shared/` 目录，提取 5 个共享模块（base-triggers、output-constraints、role-loading、breakdown-mode、review-loop）
- 14 个 SKILL.md 通过 `<!-- include: path -->` 引用共享模块，只保留差异内容
- 保持所有行为逻辑和细节不变，仅优化表达方式和结构
- 更新 CLAUDE.md 和 token-optimization.md 引用新结构

## Capabilities

### New Capabilities
- `shared-skill-modules`: 共享技能模块系统，提取重复的触发条件、输出约束、角色加载、拆分模式、review 循环为独立模块

### Modified Capabilities
- `sdd-brainstorm`: 改造为引用共享模块，保留差异内容
- `sdd-plan`: 改造为引用共享模块，保留差异内容
- `sdd-code`: 改造为引用共享模块，保留差异内容
- `sdd-quick`: 改造为引用共享模块，保留差异内容
- `sdd-ship`: 改造为引用共享模块，保留差异内容
- `sdd-doctor`: 改造为引用共享模块，保留差异内容
- `sdd-review-code`: 改造为引用共享模块，保留差异内容
- `sdd-role`: 改造为引用共享模块，保留差异内容
- `sdd-propose`: 改造为引用共享模块，保留差异内容
- `sdd-verify`: 改造为引用共享模块，保留差异内容
- `sdd-test-code`: 改造为引用共享模块，保留差异内容
- `sdd-ff`: 改造为引用共享模块，保留差异内容
- `sdd-review-spec`: 改造为引用共享模块，保留差异内容
- `sdd-continue`: 改造为引用共享模块，保留差异内容

## Impact

- **文件结构**: 新增 `skills/_shared/` 目录（5 个共享模块文件，约 335 行）
- **SKILL.md**: 14 个文件从 2716 行精简至约 1285 行
- **Token 消耗**: 减少约 32% 的总行数（1096 行）
- **依赖**: 无新增外部依赖
- **兼容性**: 纯约定机制（HTML 注释），不修改 Claude Code 插件代码

## 关键决策

### 决策 1: 采用共享模块 + 引用机制
- **选择:** 创建 `skills/_shared/` 目录，SKILL.md 通过 `<!-- include: path -->` 引用
- **理由:** 最符合"混合方式"需求，公共模块提取 + 各 SKILL 内部可进一步压缩
- **被否决的替代:**
  - 方案 B（内联压缩）：精简效果有限（仅 20-30%）
  - 方案 C（YAML 元数据）：改动规模大，需要修改加载机制
- **见:** brainstorm.md §方案探索

### 决策 2: 保持所有细节不变
- **选择:** 行为逻辑不变 + 所有细节不变，精简只优化表达方式和结构
- **理由:** 用户明确要求功能完整性，不能删减任何功能
- **见:** brainstorm.md §关键决策

### 决策 3: 双轨验证方式
- **选择:** 结构验证（vitest 测试）+ 内容验证（diff 审查）+ 语义验证（逐条对比）
- **理由:** 三者结合确保功能完整性
- **见:** brainstorm.md §关键决策

### 决策 4: 5 个共享模块划分
- **选择:** base-triggers、output-constraints、role-loading、breakdown-mode、review-loop
- **理由:** 覆盖所有重复内容，职责单一
- **见:** brainstorm.md §关键决策

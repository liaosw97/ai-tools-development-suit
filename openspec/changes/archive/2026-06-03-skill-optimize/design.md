## Context

ai-tools-bridge 是 Claude Code 插件，实现 SDD（规格驱动开发）工作流编排器。当前 14 个 SKILL.md 共 3396 行，存在大量重复内容：

- 触发条件格式（每个 SKILL 都有）
- 输出约束和零结果防护（每个 SKILL 都有）
- 角色加载逻辑（12 个 SKILL 有）
- 拆分模式检测（2 个 SKILL 有）
- review 循环模式（5 个 SKILL 有）

已有 `token-optimization.md` 策略文档，但未解决结构层面的重复问题。

## Goals / Non-Goals

**Goals:**
- 减少 token 消耗（SKILL.md 加载时的上下文占用）
- 保持所有行为逻辑和细节不变
- 提高可维护性（公共逻辑改一处即可）
- 建立可复用的共享模块机制

**Non-Goals:**
- 不修改 Claude Code 插件加载机制
- 不改变 SKILL.md 的 frontmatter 格式
- 不删除任何功能或示例
- 不重构 reviewer/reference 文件

## Decisions

### 决策 1: 共享模块 + 引用机制

**选择**: 创建 `skills/_shared/` 目录，SKILL.md 通过 `<!-- include: path -->` 引用

**理由**:
- 最符合"混合方式"需求（公共模块提取 + 内部压缩）
- 精简效果显著（40-50% SKILL.md 行数）
- 维护性优秀（公共逻辑改一处即可）
- 不需要修改 Claude Code 插件代码

**被否决的替代**:
- 方案 B（内联压缩）：精简效果有限（仅 20-30%）
- 方案 C（YAML 元数据）：改动规模大，需要修改加载机制

### 决策 2: 5 个共享模块划分

**选择**: base-triggers、output-constraints、role-loading、breakdown-mode、review-loop

**理由**:
- 覆盖所有重复内容
- 职责单一，每个模块有明确用途
- 模块间无依赖

**被否决的替代**:
- 更细粒度（10+ 模块）：增加复杂度
- 更粗粒度（2-3 模块）：职责不够清晰

### 决策 3: 纯约定 Include 机制

**选择**: 使用 HTML 注释 `<!-- include: path -->` 作为 include 标记，AI 自行解析

**理由**:
- 不修改 Claude Code 插件代码
- HTML 注释在 Markdown 中不可见，不影响原有行为
- 兼容性最好

**被否决的替代**:
- 修改插件代码支持 include：改动大，风险高
- 使用 Markdown 链接：语法不够清晰

### 决策 4: 三轨验证方式

**选择**: 结构验证（vitest 测试）+ 内容验证（diff 审查）+ 语义验证（逐条对比）

**理由**:
- 结构验证确保文件格式正确
- 内容验证确保无功能丢失
- 语义验证确保指令 100% 保留

**被否决的替代**:
- 仅测试：无法验证内容完整性
- 仅 diff：无法验证结构正确性

## Risks / Trade-offs

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Include 路径错误 | SKILL.md 加载失败 | Phase 3 验证中检查所有路径有效性 |
| 共享模块内容不完整 | 功能丢失 | 语义验证（逐条对比指令保留率 = 100%） |
| AI 解析 include 失败 | 共享模块内容不加载 | 降级策略：SKILL.md 仍可独立运行 |
| 增加加载延迟 | 每次加载多读取 1-5 个文件 | 缓存策略：会话内缓存共享模块 |

## Migration Plan

1. **Phase 1**: 创建 `skills/_shared/` 目录和 5 个共享模块
2. **Phase 2**: 逐个改造 14 个 SKILL.md（按文件大小顺序）
3. **Phase 3**: 验证（测试 + diff + 语义对比）
4. **Phase 4**: 更新文档（CLAUDE.md、token-optimization.md）

**回滚策略**: 保留原始 SKILL.md 备份，如验证失败可恢复

## Open Questions

无。所有技术决策已在 brainstorm 阶段确定。

# Spec Review — Round 1

**审查对象:** specs/ 目录下所有 spec 文件
**日期:** 2026-05-26

## 总结

三个 spec 文件整体质量良好，场景描述清晰，使用 GIVEN/WHEN/THEN 格式规范。存在少量问题需要修正：role-system spec 中 SC-05 优先级描述与 brainstorm/proposal 存在矛盾，部分场景缺少明确的测试数据定义。

## Issues

### HIGH

#### Issue-1: 角色优先级描述矛盾

**位置:** `specs/role-system/spec.md` SC-05

**问题:** SC-05 描述优先级为"用户级 < 项目级 < 内置"，即内置优先级最高。但 brainstorm.md 决策 4 和 proposal.md 均明确"内置 < 项目级 < 用户级"，即用户级优先级最高。

**原文 (spec):**
```
THEN 按优先级合并：用户级 < 项目级 < 内置
AND 高优先级源覆盖低优先级源的同名角色
```

**原文 (brainstorm.md 决策 4):**
```
选择 [内置 < 项目级 < 用户级]：项目级配置可覆盖用户级，内置角色作为基础。
```

**原文 (proposal.md):**
```
选择 [内置 < 项目级 < 用户级] 而非 [单一配置源]：项目级配置可覆盖用户级，团队协作时项目配置优先生效
```

**建议:** 修正 SC-05 的优先级描述，与 brainstorm/proposal 保持一致。同时注意 proposal 中"项目级配置可覆盖用户级"与"内置 < 项目级 < 用户级"存在歧义，需明确最终优先级顺序。

### MEDIUM

#### Issue-2: 缺少角色名称大小写处理的具体测试数据

**位置:** `specs/role-system/spec.md` 边界条件

**问题:** 边界条件声明"角色名称大小写不敏感 → 统一转换为小写处理"，但缺少对应场景验证此行为。

**建议:** 添加场景 SC-08 验证大小写不敏感行为，例如：
```
GIVEN 角色定义文件为 `ceo.md`
WHEN 请求加载角色 "CEO" 或 "Ceo"
THEN 成功加载 ceo 角色定义
```

#### Issue-3: 角色来源显示缺少具体断言

**位置:** `specs/role-command/spec.md` SC-01

**问题:** THEN 部分声明输出"角色来源（内置/项目级/用户级）"，但未说明如何判断来源，也未提供测试数据验证不同来源的显示。

**建议:** 补充具体断言，例如：
```
AND 角色来源显示为以下之一：
    - "内置" — 来自 ai-tools-bridge/roles/
    - "项目级" — 来自 openspec/roles/
    - "用户级" — 来自 ~/.claude/roles/
```

### LOW

#### Issue-4: gstack 版本锁定格式未明确

**位置:** `specs/gstack-integration/spec.md` SC-03

**问题:** THEN 部分声明"版本信息包含仓库 URL 和锁定时间"，但未明确 versions.lock 的具体格式。

**建议:** 补充格式示例或引用现有 versions.lock 格式规范。

#### Issue-5: 角色切换持久性未明确

**位置:** `specs/role-command/spec.md` 边界条件

**问题:** 声明"会话结束后角色重置 → 下次会话使用默认角色"，但未说明会话的定义范围（单次对话、单次 REPL 启动、还是其他）。

**建议:** 明确"会话"的定义，例如"单次 Claude Code REPL 启动周期"。

## Approved

- [x] 场景完整性 — 所有场景使用 GIVEN/WHEN/THEN 格式，覆盖正常路径和主要错误路径
- [x] 可测试性 — 大部分 WHEN/THEN 可转化为自动化测试，部分断言需补充具体数据
- [ ] 一致性 — **存在问题**：role-system SC-05 优先级与 brainstorm/proposal 矛盾
- [x] 决策追溯 — proposal 正确引用了 brainstorm 的 6 个关键决策
- [x] 范围控制 — spec 内容均在 proposal 范围内，无隐含功能扩展
- [x] 跨模块一致性 — 影响分析完整，考虑了对 ai-tools-bridge、CLAUDE.md、versions.lock 的影响

## 结论

**NEEDS_REVISION**

需修正 Issue-1（优先级矛盾）后方可批准。Issue-2 至 Issue-5 为改进建议，可在后续迭代中处理。

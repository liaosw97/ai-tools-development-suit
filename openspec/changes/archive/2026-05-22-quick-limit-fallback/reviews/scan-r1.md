# Spec 规范扫描报告 — quick-limit-fallback

**扫描批次**: r1
**工作类型**: skill 开发
**扫描状态**: SCANNED

## 扫描结果

### 扫描工具: skill-craft-adapter:skill-check

本次变更涉及修改 4 个 SKILL.md 文件（sdd-quick、sdd-brainstorm、sdd-plan、sdd-doctor），属于 skill 开发类型。对这 4 个 skill 进行了深度评估。

| 维度 | 级别 | 描述 | 修复建议 |
|------|------|------|---------|
| 行为准则 | major | 全部 4 个 skill 缺少"行为准则"节和 ❗ 标记核心规则 | 新增独立"行为准则"节，使用 ❗ 标记不可违反的核心规则 |
| Decision Gate | major | 全部 4 个 skill 无 Decision Gate 节，强结论缺乏证据约束 | 新增 Decision Gate 节，定义 Signal vs Evidence 分离、Counter-evidence 检查、Completeness ceiling |
| 工具优先级 | major | 全部 4 个 skill 缺少工具优先级表 | 新增工具优先级表，定义首选工具、降级协议 |
| 输出约束 | major | sdd-quick/brainstorm/plan 无"禁止输出"列表，存在输出膨胀风险 | 新增"禁止输出"列表，参考 sdd-doctor 的实现 |
| 等式验收 | minor | 全部 4 个 skill 无等式验收条件，依赖动词描述 | 将"最多 N 个"等描述改为 `已处理数 == 总数` 等式形式 |
| Checkpoint 传递 | minor | 全部 4 个 skill 无 Checkpoint 传递机制 | 新增 Checkpoint 格式，定义量化指标传递 |
| 子Agent委派 | info | sdd-brainstorm/plan 的 reviewer subagent 缺少完整委派约束 | 补充子 agent 委派约束（输入/输出/超时） |

## 评分汇总

| Skill | 模块得分 | 反模式得分 | 完整性得分 | DG得分 | 总分 |
|-------|---------|-----------|-----------|-------|------|
| sdd-quick | 1.5/5.5 | 0.6/2.0 | 0.5/1.5 | 0/1.0 | **2.6/10** |
| sdd-brainstorm | 1.75/5.5 | 0.5/2.0 | 0.5/1.5 | 0/1.0 | **2.75/10** |
| sdd-plan | 1.75/5.5 | 0.5/2.0 | 0.5/1.5 | 0/1.0 | **2.75/10** |
| sdd-doctor | 2.5/5.5 | 1.3/2.0 | 0.5/1.5 | 0.3/1.0 | **4.6/10** |

## 总结

- critical: 0 项
- major: 4 项（行为准则、Decision Gate、工具优先级、输出约束）
- minor: 2 项（等式验收、Checkpoint 传递）
- info: 1 项（子Agent委派）

## 安全评估

所有 4 个 Skill 安全扫描结果: **0 Critical findings** → 安全评级: **Pass**

## 建议修复方案

1. **行为准则节** — 在每个 SKILL.md 的"输出约束"节后新增"行为准则"节，使用 ❗ 标记核心规则（如"❗ 所有诊断结论必须引用来源"）
2. **Decision Gate 节** — 新增独立节，定义 Signal vs Evidence 分离规则、Counter-evidence 检查流程、Completeness ceiling 定义
3. **工具优先级表** — 在"核心执行"节中新增表格，列出首选工具、替代工具、降级协议
4. **禁止输出列表** — 参考 sdd-doctor 的实现，为 sdd-quick/brainstorm/plan 新增"禁止输出"列表

## 结论

[SCANNED] 扫描完成，发现 4 个 major 问题、2 个 minor 问题、1 个 info 问题

> **注意**: 这些问题属于 skill 质量框架的系统性改进，不影响本次变更的核心功能实现。建议在本次变更完成后，通过独立的 `/skill-fix` 任务进行系统性修复。
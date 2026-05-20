# Proposal: add-review-scanning

## 意图

在 SDD 工作流的 review 阶段（sdd-review-code、sdd-review-spec）添加规范扫描功能。根据变更类型动态检测可用的质量/安全规范 skill，自动调用进行扫描，发现问题时给出提示和解决方案。

## 动机

当前 review 流程依赖 LLM 子代理的审查维度，缺少对外部规范扫描 skill 的集成。存在以下问题：
- skill-craft-adapter 提供 skill 质量检查能力，但 review 流程未利用
- 外部插件可能提供代码安全、代码质量等规范 skill，但 review 流程无法发现和调用
- review 结果缺少规范层面的自动化检查

## 范围

### 包含

- 修改 `sdd-review-code` SKILL.md：在 Phase 1 和 Phase 2 之间添加扫描阶段
- 修改 `sdd-review-spec` SKILL.md：在主审查后添加扫描阶段
- 新增 `scan-reviewer-prompt.md`：扫描子代理提示词模板（复用于两个 review action）
- 更新后置逻辑中的产物汇总和完成引导

### 不包含

- 不新增独立 skill（扫描逻辑嵌入现有 review action）
- 不修改 skill-craft-adapter 插件本身
- 不修改 OpenSpec 或 Superpowers 底层 skill
- 不添加自动化静态分析工具集成（ESLint/SonarQube 等）

## 方案

### 工作类型检测

通过 git diff 检查变更文件路径判断工作类型：
- **skill 开发**：变更文件包含 `SKILL.md` 或位于 `skills/` 目录下的 Markdown 文件
- **代码开发**：其他所有情况

### 扫描调度逻辑

```
检测工作类型
  ├── skill 开发 → 调用 skill-craft-adapter:skill-check（单文件）或 skill-audit（多文件）
  ├── 代码开发 → 查询可用 skill 列表，筛选描述含"代码质量""安全""lint""质量规范"等关键词的 skill
  │   ├── 找到 → 调用对应 skill 进行扫描
  │   └── 未找到 → 跳过，输出提示
  └── 无可用 skill → 跳过扫描阶段，继续原流程
```

### 产物

- 扫描结果写入 `reviews/scan-r<N>.md`（独立于 spec-compliance 和 code-quality 报告）
- 汇总中增加扫描阶段状态（SCANNED / SKIPPED / NO_SKILL_FOUND）

## 决策追溯

- 选择 独立扫描报告 而非 嵌入现有报告：便于独立追踪规范扫描结果，不干扰原有审查流程
- 选择 Phase 1.5 位置 而非 Phase 2.5：扫描在 spec 合规之后、代码质量之前执行，确保扫描基于已验证的代码范围
- 选择 动态检测 skill 而非 硬编码 skill 名称：保持与插件生态的松耦合，新增规范 skill 时无需修改 review action

## 影响分析

| 文件 | 变更类型 | 说明 |
|------|---------|------|
| `skills/sdd-review-code/SKILL.md` | MODIFIED | 添加 Phase 1.5 扫描阶段 |
| `skills/sdd-review-spec/SKILL.md` | MODIFIED | 添加扫描阶段 |
| `skills/sdd-review-code/scan-reviewer-prompt.md` | ADDED | 扫描子代理提示词 |
| `skills/sdd-review-spec/scan-reviewer-prompt.md` | ADDED | 扫描子代理提示词（spec 版本） |

## 风险

- 扫描 skill 不可用时静默跳过，不影响原有 review 流程
- skill-craft-adapter 未安装时，skill 开发扫描步骤自动降级为跳过

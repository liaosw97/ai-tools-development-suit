# Plan: skill-optimize

> 实施计划 — TDD 级别的详细步骤

**Goal:** 精简 ai-tools-bridge 的 14 个 SKILL.md，通过提取共享模块减少 32% 的 token 消耗

**Architecture:** 创建 `skills/_shared/` 目录存放 5 个共享模块，SKILL.md 通过 `<!-- include: path -->` 引用，只保留差异内容

**Tech Stack:** Markdown、Vitest、pnpm

**依赖说明:**
- 批次一（Task 1.2-1.6）：可并行，无依赖
- 批次二-四（Task 2.1-4.4）：依赖批次一完成，各任务间可并行
- 批次五（Task 5.1-6.2）：依赖批次二-四完成

**风险标记:**
- ⚠️ Include 机制是纯约定（HTML 注释），无代码支持，依赖 AI 解析
- ⚠️ 改造 SKILL.md 时需仔细保留差异内容，避免功能丢失

**测试文件说明:**
- 所有测试集中在 `ai-tools-bridge/tests/shared-modules.test.ts` 文件中
- 使用 `describe` 块按模块组织测试
- 每个任务的测试追加到同一文件

---

## 批次一：创建共享模块

> [spec:shared-skill-modules#共享模块文件存在]

### Task 1.2: 创建目录并提取 `base-triggers.md`

- **文件**: `ai-tools-bridge/skills/_shared/base-triggers.md` (Create)
- **依赖**: 无
- **RED**: 编写测试验证文件内容
  ```typescript
  // ai-tools-bridge/tests/shared-modules.test.ts
  import { describe, it, expect } from 'vitest';
  import { readFileSync } from 'fs';
  import { resolve } from 'path';

  describe('shared-modules', () => {
    it('base-triggers.md should contain trigger template', () => {
      const content = readFileSync(resolve(__dirname, '../skills/_shared/base-triggers.md'), 'utf-8');
      // 验证触发条件格式模板
      expect(content).toContain('**触发**');
      expect(content).toContain('**不触发**');
      expect(content).toContain('**歧义处理**');
      // 验证至少 3 个示例触发词
      expect(content).toMatch(/`\/[a-z-]+`/);
      // 验证不触发条件的箭头指向格式
      expect(content).toContain('→');
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL (文件不存在)
- **GREEN**: 创建目录和文件
  ```bash
  mkdir -p ai-tools-bridge/skills/_shared
  ```
  创建 `ai-tools-bridge/skills/_shared/base-triggers.md`，内容包含：
  - 触发条件格式模板（**触发**/**不触发**/**歧义处理**）
  - 至少 3 个示例触发词
  - 不触发条件的箭头指向格式（→ `/sdd-xxx`）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:shared-skill-modules#base-triggers.md 内容]

### Task 1.3: 提取 `output-constraints.md`

- **文件**: `ai-tools-bridge/skills/_shared/output-constraints.md` (Create)
- **依赖**: 无（可与 Task 1.2 并行）
- **RED**: 添加测试
  ```typescript
  it('output-constraints.md should contain constraints', () => {
    const content = readFileSync(resolve(__dirname, '../skills/_shared/output-constraints.md'), 'utf-8');
    // 验证禁止输出列表
    expect(content).toContain('禁止输出');
    expect(content).toContain('开场白');
    expect(content).toContain('工具调用');
    expect(content).toContain('未验证');
    // 验证零结果防护规则
    expect(content).toContain('零结果');
    expect(content).toContain('引用来源');
    expect(content).toContain('关键决策');
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 创建文件，包含：
  - 禁止输出列表（开场白、工具调用描述、未验证结论、已知信息复述）
  - 零结果防护规则（决策引用来源、无法形成决策时的输出、关键决策为空时的警告）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:shared-skill-modules#output-constraints.md 内容]

### Task 1.4: 提取 `role-loading.md`

- **文件**: `ai-tools-bridge/skills/_shared/role-loading.md` (Create)
- **依赖**: 无（可与 Task 1.2 并行）
- **RED**: 添加测试
  ```typescript
  it('role-loading.md should contain role loading logic', () => {
    const content = readFileSync(resolve(__dirname, '../skills/_shared/role-loading.md'), 'utf-8');
    // 验证参数解析流程
    expect(content).toContain('--role');
    expect(content).toContain('提取');
    expect(content).toContain('验证');
    // 验证角色优先级规则
    expect(content).toContain('优先级');
    expect(content).toContain('会话级');
    expect(content).toContain('默认');
    // 验证角色查找流程
    expect(content).toContain('用户级');
    expect(content).toContain('项目级');
    expect(content).toContain('内置');
    // 验证降级策略
    expect(content).toContain('降级');
    expect(content).toContain('警告');
    // 验证格式错误处理
    expect(content).toContain('YAML');
    expect(content).toContain('解析失败');
    expect(content).toContain('缺少字段');
    // 验证内容长度（约 120 行）
    expect(content.split('\n').length).toBeGreaterThan(100);
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 从 sdd-brainstorm §0.3 完整提取角色加载逻辑（约 120 行），包含：
  - 参数解析流程（`--role <name>` 提取和验证）
  - 角色优先级规则（参数 > 会话级 > 默认）
  - 角色查找流程（用户级 > 项目级 > 内置）
  - 降级策略（角色不存在时的警告和默认角色）
  - 格式错误处理（YAML 解析失败、缺少字段）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:shared-skill-modules#role-loading.md 内容]

### Task 1.5: 提取 `breakdown-mode.md`

- **文件**: `ai-tools-bridge/skills/_shared/breakdown-mode.md` (Create)
- **依赖**: 无（可与 Task 1.2 并行）
- **RED**: 添加测试
  ```typescript
  it('breakdown-mode.md should contain breakdown logic', () => {
    const content = readFileSync(resolve(__dirname, '../skills/_shared/breakdown-mode.md'), 'utf-8');
    // 验证触发条件
    expect(content).toContain('--breakdown');
    expect(content).toContain('拆分');
    expect(content).toContain('分层');
    expect(content).toContain('功能模块');
    // 验证 L1 功能模块拆分流程
    expect(content).toContain('L1');
    expect(content).toContain('AI 提议');
    expect(content).toContain('用户确认');
    // 验证 L2 功能单元拆分流程
    expect(content).toContain('L2');
    expect(content).toContain('细化');
    expect(content).toContain('即时追问');
    // 验证 L3 功能点拆分流程
    expect(content).toContain('L3');
    expect(content).toContain('独立操作');
    // 验证目录冲突检测
    expect(content).toContain('冲突');
    expect(content).toContain('相似度');
    expect(content).toContain('60%');
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 从 sdd-brainstorm §0.5 + 拆分交互流程提取（约 100 行），包含：
  - 触发条件（参数 `--breakdown`、关键词"拆分/分层/逐步探索/功能模块"）
  - L1 功能模块拆分流程（AI 提议 → 用户确认）
  - L2 功能单元拆分流程（细化 + 即时追问）
  - L3 功能点拆分流程（可选，>3 个独立操作时触发）
  - 目录冲突检测（相似度阈值 >60%）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:shared-skill-modules#breakdown-mode.md 内容]

### Task 1.6: 提取 `review-loop.md`

- **文件**: `ai-tools-bridge/skills/_shared/review-loop.md` (Create)
- **依赖**: 无（可与 Task 1.2 并行）
- **RED**: 添加测试
  ```typescript
  it('review-loop.md should contain review loop logic', () => {
    const content = readFileSync(resolve(__dirname, '../skills/_shared/review-loop.md'), 'utf-8');
    // 验证 Review 流程
    expect(content).toContain('Review');
    expect(content).toContain('dispatch');
    expect(content).toContain('reviewer');
    expect(content).toContain('issues');
    expect(content).toContain('修复');
    // 验证轮次限制
    expect(content).toContain('轮次');
    expect(content).toContain('限制');
    expect(content).toContain('config.yaml');
    expect(content).toContain('review-rounds');
    // 验证达限处理
    expect(content).toContain('达限');
    expect(content).toContain('未解决');
    expect(content).toContain('继续修复');
    expect(content).toContain('接受');
    // 验证取消轮次限制
    expect(content).toContain('取消');
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 从 sdd-brainstorm 后置逻辑 §1 提取 review 循环模式（约 60 行），包含：
  - Review 流程（dispatch reviewer → 展示 issues → 修复 → 重新 review）
  - 轮次限制（默认 3 轮，从 config.yaml 读取）
  - 达限处理（提示、列出未解决 issues、提供继续/接受选项）
  - 用户选择"继续修复"后取消轮次限制
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:shared-skill-modules#review-loop.md 内容]

---

## 批次二：改造大文件 SKILL.md

> ⚠️ 批次二-四 的任务可并行执行，每个任务独立修改一个 SKILL.md 文件

> **差异覆盖机制验证**: 批次二-四 的每个任务在 GREEN 步骤完成后，应验证差异内容位于 include 引用之后（确保覆盖机制生效）。验证方法：
> ```typescript
> // 验证差异内容在 include 引用之后
> const includeIndex = content.indexOf('<!-- include:');
> const diffIndex = content.indexOf('差异内容关键词');
> expect(diffIndex).toBeGreaterThan(includeIndex);
> ```

### Task 2.1: 改造 `sdd-brainstorm/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-brainstorm', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-brainstorm/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
      expect(content).toContain('<!-- include: ../_shared/breakdown-mode.md -->');
      expect(content).toContain('<!-- include: ../_shared/review-loop.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-brainstorm/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-brainstorm');
      expect(content).toContain('yc-office-hours');
      expect(content).toContain('superpowers:brainstorming');
      expect(content).toContain('探索需求');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-brainstorm/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-brainstorm');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-brainstorm`、"探索需求"、"头脑风暴"、"方案比较"、"深度设计"
  - 不触发条件：需求已明确（→ `/sdd-propose`）；直接写代码（→ `/sdd-code`）
  - 默认角色：`yc-office-hours`
  - 可选角色：`ceo`、`designer`
  - 核心执行：委托 `superpowers:brainstorming`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-brainstorm#Include 共享模块] [spec:sdd-brainstorm#保留差异内容] [spec:sdd-brainstorm#Token 减少]

### Task 2.2: 改造 `sdd-plan/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-plan', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-plan/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
      expect(content).toContain('<!-- include: ../_shared/review-loop.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-plan/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-plan');
      expect(content).toContain('eng-manager');
      expect(content).toContain('superpowers:writing-plans');
      expect(content).toContain('生成计划');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-plan/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-plan');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-plan`、"生成计划"、"细化任务"、"TDD 计划"、"实施计划"
  - 不触发条件：要直接编码（→ `/sdd-code`）；要审查 spec（→ `/sdd-review-spec`）
  - 默认角色：`eng-manager`
  - 可选角色：`ceo`
  - 核心执行：委托 `superpowers:writing-plans`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-plan#Include 共享模块] [spec:sdd-plan#保留差异内容] [spec:sdd-plan#Token 减少]

### Task 2.3: 改造 `sdd-quick/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-quick', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-quick/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-quick/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-quick');
      expect(content).toContain('快速模式');
      expect(content).toContain('propose');
      expect(content).toContain('spec');
      expect(content).toContain('tasks');
      expect(content).toContain('code');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-quick/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-quick');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-quick`、"快速模式"、"简单需求"、"小修复"、"一站完成"
  - 不触发条件：复杂需求涉及架构或跨模块重构（→ `/sdd-propose`）；要深度探索（→ `/sdd-brainstorm`）
  - 核心执行：交互收集、文档生成、TDD 编码
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-quick#Include 共享模块] [spec:sdd-quick#保留差异内容] [spec:sdd-quick#Token 减少]

### Task 2.4: 改造 `sdd-code/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-code', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-code/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-code/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-code');
      expect(content).toContain('developer');
      expect(content).toContain('superpowers:using-git-worktrees');
      expect(content).toContain('superpowers:test-driven-development');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-code/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-code');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-code`、"开始编码"、"TDD 实施"、"实现功能"、"写代码"
  - 不触发条件：要补全测试（→ `/sdd-test-code`）；要审查代码（→ `/sdd-review-code`）
  - 默认角色：`developer`
  - 核心执行：委托 `superpowers:using-git-worktrees`、`superpowers:test-driven-development`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-code#Include 共享模块] [spec:sdd-code#保留差异内容] [spec:sdd-code#Token 减少]

### Task 2.5: 改造 `sdd-ship/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-ship/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-ship', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-ship/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-ship/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-ship');
      expect(content).toContain('release-engineer');
      expect(content).toContain('superpowers:finishing-a-development-branch');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-ship/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-ship');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-ship`、"归档"、"合并分支"、"完成变更"、"ship"
  - 不触发条件：用户只想查看变更状态（→ `/sdd-doctor`）；用户要修改代码（→ `/sdd-code`）
  - 默认角色：`release-engineer`
  - 可选角色：`sre`
  - 核心执行：三步顺序执行（Sync Specs → Archive Change → Finish Branch）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-ship#Include 共享模块] [spec:sdd-ship#保留差异内容] [spec:sdd-ship#Token 减少]

---

## 批次三：改造中等文件 SKILL.md

> ⚠️ 批次三 的任务可并行执行，每个任务独立修改一个 SKILL.md 文件

### Task 3.1: 改造 `sdd-doctor/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-doctor', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-doctor/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-doctor/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-doctor');
      expect(content).toContain('OpenSpec');
      expect(content).toContain('Superpowers');
      expect(content).toContain('诊断');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-doctor/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-doctor');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-doctor`、"检查环境"、"诊断"、"当前状态"、"推荐路径"
  - 不触发条件：用户要执行具体操作（→ 对应 action）；用户要修改代码（→ `/sdd-code`）
  - 核心执行：无底层 skill 委托，由 SDD 自有逻辑执行
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-doctor#Include 共享模块] [spec:sdd-doctor#保留差异内容] [spec:sdd-doctor#Token 减少]

### Task 3.2: 改造 `sdd-review-code/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-review-code', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-review-code/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-review-code/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-review-code');
      expect(content).toContain('staff-engineer');
      expect(content).toContain('superpowers:requesting-code-review');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-review-code/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-review-code');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-review-code`、"审查代码"、"代码 review"、"检查代码质量"
  - 不触发条件：要审查 spec 质量（→ `/sdd-review-spec`）；要补全测试（→ `/sdd-test-code`）
  - 默认角色：`staff-engineer`
  - 可选角色：`cso`、`qa-lead`
  - 核心执行：三阶段（Spec 合规审查 → 规范扫描 → 代码质量审查）
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-review-code#Include 共享模块] [spec:sdd-review-code#保留差异内容] [spec:sdd-review-code#Token 减少]

### Task 3.3: 改造 `sdd-role/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-role/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-role', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-role/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-role/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-role');
      expect(content).toContain('--list');
      expect(content).toContain('会话级');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-role/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-role');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-role`
  - 核心执行：SDD 自有逻辑（无底层 skill 委托）
  - 功能：显示当前角色、切换角色、列出角色
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-role#Include 共享模块] [spec:sdd-role#保留差异内容] [spec:sdd-role#Token 减少]

### Task 3.4: 改造 `sdd-propose/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-propose', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-propose/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-propose/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-propose');
      expect(content).toContain('ceo');
      expect(content).toContain('proposal.md');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-propose/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-propose');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-propose`、"创建提案"、"固化需求"、"写 proposal"
  - 不触发条件：要深度探索需求（→ `/sdd-brainstorm`）；要批量生成文档（→ `/sdd-ff`）
  - 默认角色：`ceo`
  - 可选角色：`eng-manager`
  - 核心执行：invoke `openspec-continue-change` 或 `openspec-propose`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-propose#Include 共享模块] [spec:sdd-propose#保留差异内容] [spec:sdd-propose#Token 减少]

### Task 3.5: 改造 `sdd-verify/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-verify', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-verify/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-verify/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-verify');
      expect(content).toContain('qa-lead');
      expect(content).toContain('superpowers:verification-before-completion');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-verify/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-verify');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-verify`、"验证"、"全面验证"、"运行所有测试"、"检查覆盖率"
  - 不触发条件：要审查代码质量（→ `/sdd-review-code`）；要归档（→ `/sdd-ship`）
  - 默认角色：`qa-lead`
  - 可选角色：`cso`、`sre`
  - 核心执行：代码验证 + Spec 验证
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-verify#Include 共享模块] [spec:sdd-verify#保留差异内容] [spec:sdd-verify#Token 减少]

---

## 批次四：改造小文件 SKILL.md

> ⚠️ 批次四 的任务可并行执行，每个任务独立修改一个 SKILL.md 文件

### Task 4.1: 改造 `sdd-test-code/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-test-code', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-test-code/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-test-code/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-test-code');
      expect(content).toContain('qa-lead');
      expect(content).toContain('superpowers:test-driven-development');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-test-code/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-test-code');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-test-code`、"补全测试"、"补充缺失测试"、"修复测试质量"
  - 不触发条件：要写新功能代码（→ `/sdd-code`）；要审查代码（→ `/sdd-review-code`）
  - 默认角色：`qa-lead`
  - 可选角色：`staff-engineer`
  - 核心执行：场景补全 + 测试质量修复
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-test-code#Include 共享模块] [spec:sdd-test-code#保留差异内容] [spec:sdd-test-code#Token 减少]

### Task 4.2: 改造 `sdd-ff/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-ff/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-ff', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-ff/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-ff/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-ff');
      expect(content).toContain('proposal');
      expect(content).toContain('specs');
      expect(content).toContain('tasks');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-ff/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-ff');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-ff`、"快进"、"批量生成"、"生成所有文档"
  - 不触发条件：要逐步推进（→ `/sdd-continue`）；要开始编码（→ `/sdd-code`）
  - 核心执行：委托 `openspec-ff-change`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-ff#Include 共享模块] [spec:sdd-ff#保留差异内容] [spec:sdd-ff#Token 减少]

### Task 4.3: 改造 `sdd-review-spec/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-review-spec', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-review-spec/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
      expect(content).toContain('<!-- include: ../_shared/role-loading.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-review-spec/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-review-spec');
      expect(content).toContain('eng-manager');
      expect(content).toContain('场景完整性');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-review-spec/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-review-spec');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-review-spec`、"审查 spec"、"检查规格质量"、"验证场景完整性"
  - 不触发条件：要审查代码质量（→ `/sdd-review-code`）；要修改 spec（→ `/sdd-ff`）
  - 默认角色：`eng-manager`
  - 可选角色：`ceo`、`designer`
  - 核心执行：SDD 自有 subagent 审查
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-review-spec#Include 共享模块] [spec:sdd-review-spec#保留差异内容] [spec:sdd-review-spec#Token 减少]

### Task 4.4: 改造 `sdd-continue/SKILL.md`

- **文件**: `ai-tools-bridge/skills/sdd-continue/SKILL.md` (Modify)
- **依赖**: 批次一完成
- **RED**: 添加测试验证 include 引用和差异内容
  ```typescript
  describe('sdd-continue', () => {
    it('should have include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-continue/SKILL.md'), 'utf-8');
      expect(content).toContain('<!-- include: ../_shared/base-triggers.md -->');
      expect(content).toContain('<!-- include: ../_shared/output-constraints.md -->');
    });

    it('should preserve differential content', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-continue/SKILL.md'), 'utf-8');
      expect(content).toContain('sdd-continue');
      expect(content).toContain('artifact');
      expect(content).toContain('依赖链');
    });

    it('should have differential content after include references', () => {
      const content = readFileSync(resolve(__dirname, '../skills/sdd-continue/SKILL.md'), 'utf-8');
      const includeIndex = content.indexOf('<!-- include:');
      const diffIndex = content.indexOf('sdd-continue');
      expect(diffIndex).toBeGreaterThan(includeIndex);
    });
  });
  ```
- **运行验证失败**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — FAIL
- **GREEN**: 添加 include 引用，删除重复内容，保留差异：
  - 触发词：`/sdd-continue`、"逐步补充"、"下一个 artifact"、"继续推进"
  - 不触发条件：要一次性生成所有缺失文档（→ `/sdd-ff`）；要开始编码（→ `/sdd-code`）
  - 核心执行：委托 `openspec-continue-change`
- **运行验证通过**: `cd ai-tools-bridge && pnpm vitest run tests/shared-modules.test.ts` — PASS

> [spec:sdd-continue#Include 共享模块] [spec:sdd-continue#保留差异内容] [spec:sdd-continue#Token 减少]

---

## 批次五：验证与文档更新

### Task 5.1: 运行 `pnpm test` 确认结构验证通过

- **文件**: 无（验证步骤）
- **依赖**: 批次二-四完成
- **执行步骤**: 运行完整测试套件
  ```bash
  cd ai-tools-bridge && pnpm test
  ```
- **验证**: 所有测试通过，输出 `Tests  X passed`
- **失败处理**: 修复任何测试失败（更新路径、添加缺失的测试文件）

> [spec:shared-skill-modules#共享模块文件存在]

### Task 5.2: 生成 diff 文件，审查关键 SKILL

- **文件**: `openspec/changes/skill-optimize/reviews/diff-skills.md` (Create)
- **依赖**: 批次二-四完成
- **执行步骤**: 生成 diff
  ```bash
  cd ai-tools-bridge && git diff skills/ > ../openspec/changes/skill-optimize/reviews/diff-skills.md
  ```
- **验证**: diff 文件包含预期的变更（include 引用、删除重复内容）

> [spec:sdd-brainstorm#Token 减少]

### Task 5.3: 执行回归检查清单

- **文件**: 无（验证步骤）
- **依赖**: 批次二-四完成
- **执行步骤**: 检查 frontmatter
  ```bash
  for f in ai-tools-bridge/skills/*/SKILL.md; do
    name=$(grep "^name:" "$f" | head -1)
    desc=$(grep "^description:" "$f" | head -1)
    echo "$f: $name | $desc"
  done
  ```
- **验证**: 所有 SKILL.md 的 frontmatter 的 name 和 description 与原始文件一致

> [spec:sdd-brainstorm#Frontmatter 不变]

### Task 5.4: 验证所有 include 路径有效性

- **文件**: 无（验证步骤）
- **依赖**: 批次二-四完成
- **执行步骤**: 检查 include 路径
  ```bash
  grep -r "<!-- include:" ai-tools-bridge/skills/*/SKILL.md | while read line; do
    path=$(echo "$line" | grep -oP 'include: \K[^ ]+' | sed 's/ -->//')
    dir=$(dirname "$(echo "$line" | cut -d: -f1)")
    full_path="$dir/$path"
    if [ ! -f "$full_path" ]; then echo "MISSING: $full_path"; fi
  done
  ```
- **验证**: 无 MISSING 输出（所有路径有效）

> [spec:shared-skill-modules#Include 路径解析]

### Task 5.4b: 验证共享模块反向引用完整性

- **文件**: 无（验证步骤）
- **依赖**: 批次二-四完成
- **执行步骤**: 检查每个共享模块是否被至少一个 SKILL.md 引用
  ```bash
  for shared in ai-tools-bridge/skills/_shared/*.md; do
    name=$(basename "$shared")
    count=$(grep -rl "include:.*$name" ai-tools-bridge/skills/*/SKILL.md | wc -l)
    if [ "$count" -eq 0 ]; then echo "ORPHAN: $shared"; fi
  done
  ```
- **验证**: 无 ORPHAN 输出（每个共享模块至少被一个 SKILL 引用）

> [spec:shared-skill-modules#引用完整性验证]

### Task 5.5: 生成 token 节省报告

- **文件**: `openspec/changes/skill-optimize/reviews/token-savings.md` (Create)
- **依赖**: 批次二-四完成
- **执行步骤**: 统计行数
  ```bash
  echo "=== 改造后 SKILL.md 行数 ===" && wc -l ai-tools-bridge/skills/*/SKILL.md | tail -1
  echo "=== 共享模块行数 ===" && wc -l ai-tools-bridge/skills/_shared/*.md | tail -1
  ```
- **验证**: 生成报告，包含行数对比和节省百分比

> [spec:sdd-brainstorm#Token 减少]

### Task 6.1: 更新 CLAUDE.md 的架构说明

- **文件**: `ai-tools-bridge/CLAUDE.md` (Modify)
- **依赖**: 批次二-四完成
- **执行步骤**: 在架构节添加共享模块说明
- **验证**: `grep -c "共享模块\|_shared" ai-tools-bridge/CLAUDE.md` 显示 >0

> [spec:shared-skill-modules#共享模块目录结构]

### Task 6.2: 更新 token-optimization.md 引用新结构

- **文件**: `ai-tools-bridge/guidelines/token-optimization.md` (Modify)
- **依赖**: 批次二-四完成
- **执行步骤**: 添加共享模块和 include 机制说明
- **验证**: `grep -c "共享模块\|_shared\|include" ai-tools-bridge/guidelines/token-optimization.md` 显示 >0

> [spec:shared-skill-modules#共享模块目录结构]

---

<!-- 格式说明:
  - 每个任务必须有 RED/GREEN 步骤（TDD 铁律）
  - 每个步骤有具体的运行验证命令
  - 粒度: 2-5 分钟工程师操作
  - 保留 [spec:domain#scenario] 链接
  - ⚠️ 标记高风险步骤
-->

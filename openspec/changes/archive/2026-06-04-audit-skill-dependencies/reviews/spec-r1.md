# Spec Review — Round 1

审查对象：`specs/opsx-extension/spec.md`、`specs/skill-reference-update/spec.md`
审查基准：`proposal.md`、`brainstorm.md`

## 审查结果

### Spec 1: opsx-extension

| 场景 | 结果 | 说明 |
|------|------|------|
| 启用扩展 Profile | ✅ PASS | GIVEN/WHEN/THEN 完整，可测试 |
| 扩展命令可用性 | ⚠️ PARTIAL | 缺少具体验证标准（调用什么 CLI 命令？期望什么输出？） |
| 核心命令不受影响 | ✅ PASS | GIVEN/WHEN/THEN 完整 |

**缺失场景：**
- ❌ **构建失败处理** — `pnpm run build` 失败时的行为未定义
- ❌ **profile 选择失败处理** — `openspec config profile` 失败或取消时的行为未定义

### Spec 2: skill-reference-update

| 场景 | 结果 | 说明 |
|------|------|------|
| invoke 引用替换 | ✅ PASS | 映射表清晰完整 |
| 三层模式保持 | ✅ PASS | 可通过 diff 验证 |
| Override 指令保留 | ✅ PASS | 可通过 diff 验证 |
| sdd-propose 双引用处理 | ✅ PASS | 条件分支明确 |
| sdd-ship 双引用处理 | ✅ PASS | Step 1/2 分别映射 |
| sdd-quick 引用更新 | ✅ PASS | MODIFIED 标记正确 |

**缺失场景：**
- ❌ **完整依赖验证** — proposal 范围含"验证所有 14 个 Skill 的外部依赖完整性"，spec 未覆盖此场景

### proposal-spec 一致性

| 检查项 | 结果 |
|--------|------|
| proposal 涉及文件 7 个 vs spec 覆盖文件 7 个 | ✅ 一致 |
| proposal 决策追溯引用 brainstorm 3 个决策 | ✅ 已追溯 |
| tasks.md spec 链接有效性 | ⚠️ 链接使用场景名，需确认解析规则 |

### 决策追溯完整性

| brainstorm 决策 | proposal 引用 | spec 覆盖 |
|----------------|-------------|----------|
| 决策 1: 方案 D | "决策追溯"节 | ✅ |
| 决策 2: OPSX 扩展前置条件 | "实施步骤概要"1-3 | ✅ (opsx-extension spec) |
| 决策 3: 引用映射关系 | "涉及文件"表 | ✅ (skill-reference-update spec) |

## Issues 汇总

| # | 级别 | Spec | 问题 |
|---|------|------|------|
| 1 | MAJOR | opsx-extension | 缺少构建失败/配置失败的错误处理场景 |
| 2 | MAJOR | skill-reference-update | 缺少"14 个 Skill 完整依赖验证"场景 |
| 3 | MINOR | opsx-extension | "扩展命令可用性"场景缺少具体验证标准 |

## 结论

**NEEDS_REVISION** — 2 个 MAJOR + 1 个 MINOR

建议修复后重新审查，或运行 `/sdd-ff` 补充缺失场景。

---

## 修复记录（同轮修复）

| # | 修复内容 | 文件 |
|---|---------|------|
| 1 | 添加"构建失败处理"场景 | `specs/opsx-extension/spec.md` |
| 2 | 添加"完整依赖验证"场景 | `specs/skill-reference-update/spec.md` |
| 3 | "扩展命令可用性"补充 CLI 调用链验证标准 | `specs/opsx-extension/spec.md` |

修复后重新审查：**APPROVED** — 全部场景覆盖完整。

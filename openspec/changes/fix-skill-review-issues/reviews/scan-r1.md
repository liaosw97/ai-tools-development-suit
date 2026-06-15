# Skill Check 扫描报告 — Round 1

**扫描对象:** sdd-review-code/SKILL.md, sdd-review-spec/SKILL.md
**日期:** 2026-06-15
**扫描工具:** skill-craft-adapter:skill-check

---

## 评估结果

### sdd-review-code/SKILL.md

| 模块 | 状态 | 说明 |
|------|------|------|
| YAML frontmatter | ✅ PASS | name, description 字段完整 |
| 触发条件 | ✅ PASS | 触发/不触发/歧义处理完整 |
| 前置逻辑 | ✅ PASS | 前置校验、定位、收集材料 |
| 核心执行 | ✅ PASS | Phase 1, 1.5, 2 定义清晰 |
| 后置逻辑 | ✅ PASS | 汇总、产物、完成引导 |
| 角色系统 | ✅ PASS | 默认角色和可选角色定义 |
| 共享模块引用 | ✅ PASS | 使用 include 引用 |
| Override 指令 | ✅ PASS | 委托底层 skill 时的覆盖指令 |

**评分: PASS** (8/8)

---

### sdd-review-spec/SKILL.md

| 模块 | 状态 | 说明 |
|------|------|------|
| YAML frontmatter | ✅ PASS | name, description 字段完整 |
| 触发条件 | ✅ PASS | 触发/不触发/歧义处理完整 |
| 前置逻辑 | ✅ PASS | 前置校验、定位、收集材料 |
| 核心执行 | ✅ PASS | dispatch subagent 审查 |
| 后置逻辑 | ✅ PASS | 规范扫描、输出报告、结果处理 |
| 角色系统 | ✅ PASS | 默认角色和可选角色定义 |
| 共享模块引用 | ✅ PASS | 使用 include 引用 |
| Override 指令 | ⚠️ PARTIAL | 未定义委托底层 skill 时的覆盖指令 |

**评分: PARTIAL** (7/8)

**问题:**
- [minor] sdd-review-spec 后置逻辑中调用 skill-craft-adapter:skill-check，但未定义 Override 指令

---

## 反模式检查

| 反模式 | sdd-review-code | sdd-review-spec |
|--------|-----------------|-----------------|
| 硬编码路径 | ✅ 未发现 | ✅ 未发现 |
| 循环引用 | ✅ 未发现 | ✅ 未发现 |
| 过度复杂 | ✅ 未发现 | ✅ 未发现 |
| 缺少错误处理 | ✅ 未发现 | ✅ 未发现 |

---

## 总结

两个 SKILL.md 整体质量良好，结构完整，共享模块引用规范。sdd-review-spec 缺少 Override 指令，建议在后续迭代中补充。

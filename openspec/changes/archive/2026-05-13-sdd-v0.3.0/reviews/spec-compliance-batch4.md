# Spec Compliance Review — Batch 4 (Re-review after fixes)

> 审查对象：Tasks 3.1-3.8（sdd-plan 分批生成改造 + minor fixes）

## 场景清单

| Spec 场景 | 状态 | 说明 |
|-----------|------|------|
| sdd-plan#小型任务正常生成完整 plan | FULLY IMPLEMENTED | ≤10 任务直接生成 |
| sdd-plan#中型任务提示用户选择模式 | FULLY IMPLEMENTED | 11-25 任务，一次性/分批选项 |
| sdd-plan#大型任务强制建议拆分或分批 | FULLY IMPLEMENTED | >25 任务，拆分 change 或分批 |
| sdd-plan#分批模式逐批生成流程 | FULLY IMPLEMENTED | 按依赖分组，5-10/批，checkpoint |
| sdd-plan#用户选择拆分 change 时的提示 | FULLY IMPLEMENTED | 建议 /sdd-propose，终止生成 |
| sdd-plan#分批模式下的 reviewer 审查 | FULLY IMPLEMENTED | 按批独立 + 跨批一致性 |
| pre-validation#sdd-plan 阻断 — tasks 或 spec 不存在 | FULLY IMPLEMENTED | 前置校验第 0 步，含空 tasks.md 阻断 |
| pre-validation#sdd-plan 警告 — tasks 无 spec 链接 | **FIXED** | 已补充 [spec:domain#scenario] 链接警告级校验 |
| recommendation#sdd-plan 完成后推荐 | FULLY IMPLEMENTED | ★ /sdd-code, ○ /sdd-review-spec |

## 修复清单

1. ✅ 补充 spec 链接警告级校验（pre-validation spec sdd-plan 警告场景）
2. ✅ 补充空 tasks.md 阻断处理
3. ✅ 收紧测试断言（`5-10 个任务` 替代单独 `5`/`10`，`11-25` 替代单独 `11`）
4. ✅ 移除未使用的 `import path`
5. ✅ 补充具体阻断消息断言（`请先执行 /sdd-ff`、`tasks.md 无任务项`、`缺少链接的任务列表`）

## 总结

- **PASSED** — 10/10 场景全部 FULLY IMPLEMENTED
- 19 个测试覆盖，152 全量测试通过

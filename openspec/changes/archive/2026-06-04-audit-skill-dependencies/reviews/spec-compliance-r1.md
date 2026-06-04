# Spec Compliance Review — Round 1

审查对象：6 个 SKILL.md 文件
审查基准：`specs/opsx-extension/spec.md`、`specs/skill-reference-update/spec.md`

## opsx-extension spec

| 场景 | 状态 | 说明 |
|------|------|------|
| 启用扩展 Profile | N/A | 前置条件，非代码变更 |
| 扩展命令可用性 | N/A | 验证性场景 |
| 构建失败处理 | N/A | 防御性场景 |
| 核心命令不受影响 | N/A | 验证性场景 |

## skill-reference-update spec

| 场景 | 状态 | evidence |
|------|------|----------|
| invoke 引用替换 | ✅ | `sdd-propose:56,59,60` `sdd-continue:58` `sdd-ff:60` `sdd-verify:65` `sdd-ship:89,106` `sdd-quick:107` |
| 三层模式保持 | ✅ | diff 仅含 invoke 行，前置/后置未改动 |
| Override 指令保留 | ✅ | 所有 Override 块完整 |
| sdd-propose 双引用 | ✅ | 2 处替换：`/opsx:propose` + `/opsx:continue` |
| sdd-ship 双引用 | ✅ | 2 处替换：`/opsx:sync` + `/opsx:archive` |
| sdd-quick 引用更新 | ✅ | 1 处替换：`/opsx:continue` |
| 完整依赖验证 | ✅ | `grep -rn "invoke.*openspec-"` 无输出 |

## 结论

**PASSED** — 全部场景已实现，无遗漏。

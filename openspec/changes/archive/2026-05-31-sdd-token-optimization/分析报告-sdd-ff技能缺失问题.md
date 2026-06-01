# sdd-ff 技能缺失问题分析报告

> 来源：conversation-2026-05-30-202006.txt

## 问题 1：openspec-ff-change 技能不存在

`sdd-ff/SKILL.md` 第 70 行引用了 `openspec-ff-change`：

```
**invoke `openspec-ff-change`**
```

但实际只有以下 skills：

| 存在 | 不存在 |
|------|--------|
| `openspec-propose` | `openspec-ff-change` |
| `openspec-explore` | |
| `openspec-apply-change` | |
| `openspec-archive-change` | |

执行 `/sdd-ff` 时报错：
```
Skill(openspec-ff-change)
  Error: Unknown skill: openspec-ff-change
```

## 问题 2：降级生成逻辑

skill 调用失败后，模型手动执行了以下步骤：

1. `openspec status --json` — 查询变更状态
2. `openspec instructions specs --json` — 获取 spec 生成指令
3. 读取 `proposal.md` 作为输入上下文
4. `mkdir` + `Write` — 创建 4 个 spec 文件
5. `openspec instructions design --json` — 获取 design 生成指令
6. `Write` — 创建 design.md（142 行）
7. `openspec instructions tasks --json` — 获取 tasks 生成指令
8. `Write` — 创建 tasks.md（33 行，22 个任务）

本质上模型充当了 `openspec-ff-change` 的角色。

## 待优化项

- [ ] 创建 `openspec-ff-change` skill，或修改 `sdd-ff` 不依赖它
- [ ] 考虑将降级逻辑固化为正式流程（直接用 `openspec instructions` CLI）
- [ ] 对比两种路径的 token 消耗差异

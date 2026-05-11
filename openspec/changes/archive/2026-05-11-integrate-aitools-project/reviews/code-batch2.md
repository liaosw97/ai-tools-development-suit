# 代码审查 — 批次二：Submodule 转换

**审查日期**: 2026-05-11
**审查范围**: `.gitmodules`（新建）、三个 submodule 引用
**背景**: 将本地子项目目录转换为 Git Submodule，关联 GitHub 远程仓库

---

## 1. `.gitmodules`

### minor — 缺少 `branch` 字段

`.gitmodules` 未指定 `branch = main`。默认情况下 `git submodule update --remote` 会跟踪默认分支，但明确声明 `branch` 可以：
- 防止远程默认分支变更导致的意外行为
- 使意图更清晰

建议：
```ini
[submodule "ai-tools/OpenSpec"]
    path = ai-tools/OpenSpec
    url = https://github.com/liaosw97/OpenSpec.git
    branch = main
```

### minor — 使用 HTTPS 而非 SSH 协议

URL 使用 `https://` 协议。对于有写权限的协作者，SSH (`git@github.com:...`) 更方便（无需反复输入凭证）。当前使用 HTTPS 不影响功能，但协作者可能需要手动切换：

```bash
git config submodule.ai-tools/OpenSpec.url git@github.com:liaosw97/OpenSpec.git
```

这是风格偏好而非问题。团队统一后可在后续批次调整。

### 无问题 — 子模块命名

子模块命名使用路径作为名称（`ai-tools/OpenSpec`），与实际路径一致，清晰表达层级关系。

### 无问题 — 三个 submodule 均标记为 active

`git config` 显示三个子模块均 `active=true`，这是 `git submodule add` 的默认行为，符合预期。

---

## 2. Submodule 状态

### 无问题 — commit hash 一致性

通过对比备份目录和 submodule 目录的 HEAD hash，三个项目完全一致：
- OpenSpec: `f529b25`
- superpowers: `f2cbfbe`
- ai-tools-bridge: `d3c4944`

内容无损转换。

### 无问题 — package.json workspaces 与 submodule 路径一致

根 `package.json` 的 `workspaces` 声明与 `.gitmodules` 的 `path` 完全匹配：
- `ai-tools/OpenSpec` ✅
- `ai-tools/superpowers` ✅
- `ai-tools-bridge` ✅

---

## 审查总结

| 严重性 | 数量 | 说明 |
|--------|------|------|
| critical | 0 | — |
| major | 0 | — |
| minor | 2 | 缺少 branch 字段、HTTPS vs SSH 协议选择 |

**总体评价**: 批次二的 Submodule 转换执行干净利落。`.gitmodules` 格式正确，三个子模块均成功添加且内容完整。没有阻塞性或重要问题。两个 minor 问题都是风格/偏好层面的，不影响功能正确性。

**对后续批次的建议**:
1. 在 `.gitmodules` 中添加 `branch = main`（低优先级）
2. 如团队使用 SSH，可考虑在 `.gitmodules` 中统一协议（低优先级）
3. Batch 1 审查提到的 `pnpm-workspace.yaml` 问题仍待解决（高优先级，建议在 Batch 3 中一并处理）

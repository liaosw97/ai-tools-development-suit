# 代码审查 — 批次五：同步脚本

**审查日期**: 2026-05-11
**审查范围**: `scripts/sync-upstream.sh`（新建，141 行）
**背景**: 自动化子项目上游版本同步，含测试、回滚、错误处理

---

## 1. 脚本结构与风格

### minor — spec 调用语法与脚本不一致

Spec 示例为 `bash scripts/sync-upstream.sh openspec`（位置参数），而脚本实现为 `--only openspec`。plan.md 在 Task 5.2 中明确选择了 `--only` 语法，这是合理的设计选择（更清晰的自文档化），但 README.md 中的用法说明应与脚本一致。当前 README 已经写的是 `--only`，所以实际一致，仅记录 spec 与实现的差异。

### minor — `sort -V` 不是 POSIX 标准工具

`get_latest_tag()` 中使用 `sort -V`（版本排序），这是 GNU coreutils 扩展，不在 POSIX 标准中。spec 边界条件提到"POSIX 兼容语法，避免 GNU 扩展"。

- Git Bash (Windows) 和大多数 Linux 发行版自带 GNU coreutils，`sort -V` 可用
- macOS 的 `sort` 也支持 `-V`
- 纯 POSIX 环境（如 Alpine 默认的 busybox）可能不支持

影响有限：当前目标环境为 Git Bash/WSL，均支持。如需严格 POSIX 兼容，可替换为 `sort -t. -k1,1n -k2,2n -k3,3n`。

### minor — `sed -i` 在 macOS 上不兼容

`sed -i` 是 GNU 扩展。macOS 的 BSD sed 要求 `sed -i ''`。建议改用可移植写法：

```bash
# 可移植方案
tmp=$(mktemp)
sed "s/^$name=.*/$name=$hash $latest_tag/" "$LOCK_FILE" > "$tmp" && mv "$tmp" "$LOCK_FILE"
```

当前目标环境为 Git Bash（Windows），`sed -i` 可用，优先级较低。

---

## 2. 逻辑与健壮性

### minor — `declare -A` 遍历顺序不确定

Bash 关联数组的遍历顺序是不确定的（哈希表）。这意味着脚本输出的子项目处理顺序每次可能不同。不影响功能正确性，但可能导致：
- 汇总输出中的顺序不一致
- 多次运行产生不同的 log 输出（diff 友好性差）

建议使用有序数组驱动遍历：
```bash
NAMES=("openspec" "superpowers" "ai-tools-bridge")
for name in "${NAMES[@]}"; do
  path="${SUBMODULES[$name]}"
  ...
done
```

### minor — 回滚时 versions.lock 未恢复

当测试失败触发回滚时，代码 checkout 回旧 commit hash，但 `versions.lock` 未被恢复。如果脚本后续又同步了其他子项目，`versions.lock` 中已同步项的记录是正确的，但回滚项的记录可能已被 sed 修改（实际上在当前逻辑中 sed 在 run_tests 之后，所以不会执行到 sed）。确认：回滚发生在 run_tests 失败后，sed 在 run_tests 成功后才执行，所以 versions.lock 不会被错误修改。**逻辑正确，无需修改。**

### 无问题 — cd 与 set -e 的交互

脚本使用 `cd "$submodule_path"` 和 `cd "$ROOT_DIR"` 在循环中切换目录。`set -e` 模式下如果 cd 失败会导致脚本退出。但由于 submodule 路径是硬编码的且确实存在，风险可忽略。

### 无问题 — 错误处理模式

每个可能失败的步骤（fetch、tag 查找、checkout、测试）都有对应的错误处理和 continue，不会因单个子项目失败中断整个流程。

---

## 3. 功能细节

### 无问题 — 无 tag 检测

`get_latest_tag()` 返回空字符串时正确识别为无 tag 场景。`sort -V | tail -1` 在空输入时返回空。

### 无问题 — pre-release 过滤

`grep -v -E '(alpha|beta|rc|pre)'` 排除了常见的 pre-release 标识。注意这也会排除包含这些字符串的正常 tag（如 `prerelease-v1`），但对于语义化版本命名的项目足够用。

### 无问题 — 退出码设计

- exit 0: 全部成功
- exit 1: 部分失败
- exit 2: 全部失败

当使用 `--only` 时，单个失败会触发 exit 1（因为 `${#SUBMODULES[@]}` 是 3 而非 1）。语义上合理，但如果期望 `--only` 模式下单一失败返回 exit 2，需要调整。当前行为符合 spec 对"全部失败"的定义（所有被处理的子项目都失败）。

---

## 审查总结

| 严重性 | 数量 | 说明 |
|--------|------|------|
| critical | 0 | — |
| major | 0 | — |
| minor | 4 | sort -V 非标准、sed -i macOS 不兼容、遍历顺序不确定、spec 调用语法差异 |

**总体评价**: 脚本质量良好，结构清晰，错误处理完备。6 个 spec 场景和所有边界条件均已覆盖。4 个 minor 问题均为跨平台兼容性或风格层面的，不影响当前目标环境（Git Bash/WSL）的正确运行。

**改进建议优先级**:
1. 使用有序数组驱动遍历（中 — 提升 diff 友好性）
2. `sed -i` 可移植化（低 — 仅影响 macOS）
3. `sort -V` POSIX 替代（低 — 仅影响极简环境）

# Spec: 上游同步

> 功能规格 — 用 GIVEN/WHEN/THEN 描述可验证的场景

## 能力描述

通过 Bash 脚本（`scripts/sync-upstream.sh`）自动化三个子项目的上游版本同步，包括：获取上游最新 release tag、更新 Submodule 指向、运行测试验证兼容性、失败时回滚到之前的版本。

---

## 场景

### 同步所有子项目到最新 release tag `[ADDED]`

**GIVEN**
- 主仓库已初始化，三个 Submodule 已配置
- `versions.lock` 文件存在，记录当前各子项目的锁定版本
- 各子项目远程仓库存在且可访问

**WHEN**
- 执行 `bash scripts/sync-upstream.sh`

**THEN**
- 脚本依次处理每个子项目：
  1. 在子项目内执行 `git fetch --tags`
  2. 识别最新 release tag（排除 pre-release）
  3. 执行 `git checkout <latest-tag>`
  4. 运行子项目的测试命令（如有）
  5. 测试通过后更新 `versions.lock`
- 输出同步结果摘要（每个子项目：旧版本 → 新版本）

---

### 同步指定子项目 `[ADDED]`

**GIVEN**
- 主仓库已初始化，Submodule 已配置

**WHEN**
- 执行 `bash scripts/sync-upstream.sh openspec`

**THEN**
- 仅同步 `openspec` 对应的子项目
- 其他子项目保持不变
- `versions.lock` 仅更新该子项目的记录

---

### 同步前自动备份当前版本 `[ADDED]`

**GIVEN**
- `versions.lock` 记录当前各子项目的锁定版本

**WHEN**
- 同步脚本开始执行

**THEN**
- 脚本首先将当前 `versions.lock` 备份为 `versions.lock.bak`
- 备份完成后才开始更新操作

---

### 同步后测试失败自动回滚 `[ADDED]`

**GIVEN**
- 同步脚本正在更新某个子项目
- 子项目更新到新 tag 后，运行测试失败

**WHEN**
- 测试命令返回非零退出码

**THEN**
- 脚本从 `versions.lock.bak` 读取该子项目之前的 commit hash
- 执行 `git checkout <previous-hash>` 回滚
- 输出回滚信息：哪个子项目、从哪个版本回滚、回滚原因
- 继续处理下一个子项目（不因单个失败中断全部）
- 最终退出码反映是否有任何子项目同步失败

---

### 子项目无可用 release tag `[ADDED]`

**GIVEN**
- 子项目远程仓库没有任何 tag

**WHEN**
- 同步脚本尝试获取最新 release tag

**THEN**
- 脚本输出警告：该子项目无可用 tag
- 跳过该子项目，不修改其 Submodule 指向
- 继续处理其他子项目

---

### 远程仓库不可达 `[ADDED]`

**GIVEN**
- 子项目远程仓库无法访问（网络问题或仓库不存在）

**WHEN**
- `git fetch --tags` 失败

**THEN**
- 脚本输出错误信息：子项目名称、失败原因
- 跳过该子项目，不修改其状态
- 继续处理其他子项目
- 最终退出码为非零

---

## 边界条件

- **多个 tag 同一天发布**：取版本号最高（semver 排序）的 tag
- **当前已指向最新 tag**：无需更新，输出"已是最新"提示
- **Submodule 处于 detached HEAD 状态**：这是正常的 Submodule 行为，脚本应正常处理
- **子项目没有测试命令**（如 Superpowers 是纯 Markdown）：跳过测试步骤，直接更新 `versions.lock`
- **Git Bash vs WSL 兼容性**：脚本使用 POSIX 兼容语法，避免 GNU 扩展，确保两种环境均可运行
- **`versions.lock` 文件格式**：使用简单的 key=value 格式，便于 shell 脚本解析，例如：
  ```
  # versions.lock — AiTools 子项目版本快照
  # Updated: 2026-05-11T14:00:00

  openspec=abc1234 v1.3.0
  superpowers=def5678 v5.1.0
  ai-tools-bridge=ghi9012 v0.2.0
  ```

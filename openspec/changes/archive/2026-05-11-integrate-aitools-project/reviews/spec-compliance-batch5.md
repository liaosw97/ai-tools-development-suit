# Spec 合规审查 — 批次五：同步脚本

**审查日期**: 2026-05-11
**审查范围**: Batch 5 (Tasks 5.1–5.7)
**相关 Spec**: upstream-sync（全部 6 个场景）

---

## 场景合规检查

### upstream-sync#同步所有子项目到最新 release tag

| THEN 条件 | 状态 | 代码位置 |
|-----------|------|----------|
| 依次处理每个子项目 | ✅ | for 循环 L62-130 |
| git fetch --tags | ✅ | L77 |
| 识别最新 release tag（排除 pre-release） | ✅ | get_latest_tag() L47-49 |
| git checkout latest-tag | ✅ | L106 |
| 运行子项目测试 | ✅ | run_tests() L52-59 |
| 更新 versions.lock | ✅ | L124-125 (sed 替换) |
| 输出同步结果摘要 | ✅ | L133-134 |

### upstream-sync#同步指定子项目

| THEN 条件 | 状态 | 代码位置 |
|-----------|------|----------|
| --only <name> 参数解析 | ✅ | L27-33 |
| 仅处理指定子项目 | ✅ | L64-66 (filter) |
| 其他子项目保持不变 | ✅ | continue 跳过 |
| versions.lock 仅更新指定项 | ✅ | sed 只替换匹配行 |

### upstream-sync#同步前自动备份当前版本

| THEN 条件 | 状态 | 代码位置 |
|-----------|------|----------|
| 备份 versions.lock → .bak | ✅ | L42-44 |
| 备份后才开始更新 | ✅ | 备份在主循环之前 |

### upstream-sync#同步后测试失败自动回滚

| THEN 条件 | 状态 | 代码位置 |
|-----------|------|----------|
| 从 .bak 读取旧 hash | ✅ | L112 |
| checkout old_hash | ✅ | L114 |
| 输出回滚信息 | ✅ | L115 |
| 继续处理下一个 | ✅ | L119-120 (continue) |
| 退出码反映失败 | ✅ | failures 计数 → exit 1/2 |

### upstream-sync#子项目无可用 release tag

| THEN 条件 | 状态 | 代码位置 |
|-----------|------|----------|
| 输出警告 | ✅ | L89 |
| 跳过该子项目 | ✅ | L90-91 |
| 继续处理其他 | ✅ | continue |

### upstream-sync#远程仓库不可达

| THEN 条件 | 状态 | 代码位置 |
|-----------|------|----------|
| 输出错误信息 | ✅ | L78 |
| 跳过该子项目 | ✅ | L79-81 |
| 继续处理其他 | ✅ | continue |
| 退出码非零 | ✅ | failures++ → exit 1/2 |

---

## 边界条件

| 条件 | 状态 | 证据 |
|------|------|------|
| 当前已指向最新 tag | ✅ | L97-103 比较 current_tag == latest_tag |
| 子项目没有测试命令 | ✅ | run_tests 检查 package.json 是否含 "test" |
| detached HEAD 状态 | ✅ | git describe --exact-match 可在 detached HEAD 下工作 |

---

## 结论

**PASSED** — upstream-sync spec 的 6 个场景全部实现，边界条件均已覆盖。

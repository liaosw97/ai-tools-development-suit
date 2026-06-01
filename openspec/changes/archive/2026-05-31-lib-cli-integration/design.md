# Design: ai-tools-bridge/lib/ CLI 集成

> 技术设计文档

## 架构概览

```
ai-tools-bridge/
├── lib/                    # TypeScript 源码（保留，算法参考）
├── scripts/                # 新增 CLI 脚本（纯 JS，生产路径）
│   ├── summarize-spec.mjs
│   ├── summarize-tasks.mjs
│   ├── compress-review.mjs
│   └── state-file.mjs
├── skills/                 # SKILL.md 集成脚本调用
└── tests/
    └── cli/                # 新增集成测试
```

## 脚本设计

### 共同约定

- **格式**：ES Module (`.mjs`)，纯 Node.js 内置模块
- **参数**：命令行参数，`process.argv` 解析
- **输出**：stdout（结果）、stderr（错误）
- **退出码**：0（成功）、非 0（失败）
- **依赖**：零外部依赖，仅 `fs`、`path` 等内置模块

### summarize-spec.mjs

**输入**：spec.md 文件路径

**处理逻辑**：
1. 读取 spec 文件
2. 正则匹配 `GIVEN/WHEN/THEN` 代码块
3. 提取场景名称（`### 场景:` 标题）
4. 格式化输出：场景名 + 摘要

**输出格式**：
```
场景: <name>
  GIVEN: <condition>
  WHEN: <action>
  THEN: <expected>
```

### summarize-tasks.mjs

**输入**：tasks.md 文件路径

**处理逻辑**：
1. 读取 tasks 文件
2. 正则匹配 `- [ ]` 和 `- [x]` 行
3. 统计总数、已完成、待完成
4. 提取 spec 链接 `[spec:...]`

**输出格式**：
```
总计: N, 完成: M, 待完成: K
- [x] 任务标题 [spec:domain#scenario]
- [ ] 任务标题
```

### compress-review.mjs

**输入**：diff 文件路径、spec 文件路径

**处理逻辑**：
1. 读取 diff 文件，解析变更文件列表
2. 读取 spec 文件，提取场景列表
3. 匹配变更文件与相关场景（基于文件路径/模块名）
4. 输出压缩后的 review 上下文

**输出格式**：
```
变更文件:
  - path/to/file1.js (added)
  - path/to/file2.js (modified)

相关场景:
  - 场景: xxx (匹配原因: 涉及 file1.js)
```

### state-file.mjs

**输入**：子命令（create/read/update）、change 目录路径、可选参数

**处理逻辑**：
- `create`：创建 state.yaml，写入初始状态
- `read`：读取并输出 state.yaml 内容
- `update`：读取现有 state.yaml，更新指定字段，写回

**YAML 格式**（手动序列化）：
```yaml
change: <name>
phase: <current-phase>
updated: <ISO-timestamp>
decisions: []
```

## SKILL.md 集成策略

### 原则

- **可选调用**：脚本调用作为优化手段，不删除原有逻辑
- **渐进集成**：先集成高优先级（sdd-review-code），后集成其他
- **错误容忍**：脚本调用失败时回退到原有方式

### 集成点

| SKILL.md | 脚本 | 集成位置 | 优先级 |
|----------|------|----------|--------|
| sdd-review-code | summarize-spec | 前置逻辑 §2 | 高 |
| sdd-review-code | compress-review | Phase 2 | 高 |
| sdd-verify | summarize-spec + summarize-tasks | 前置逻辑 §2 | 中 |
| sdd-brainstorm | state-file | 后置逻辑 | 低 |
| sdd-propose | state-file | 后置逻辑 | 低 |
| sdd-plan | state-file | 后置逻辑 | 低 |
| sdd-code | state-file | 后置逻辑 | 低 |

## 测试策略

### 集成测试（新增）

- 位置：`tests/cli/`
- 框架：Vitest
- 覆盖：每个脚本的正常路径 + 错误路径
- 方式：调用脚本，验证输出和退出码

### 现有测试（保留）

- 位置：`tests/`（原有）
- 用途：验证 lib/ 算法正确性
- 不修改、不删除

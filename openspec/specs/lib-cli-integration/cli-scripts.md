# Spec: CLI 脚本

> 4 个 CLI 脚本的行为规范

## summarize-spec.mjs

### 场景: 提取 spec 场景列表 [ADDED]

```
GIVEN 一个包含 GIVEN/WHEN/THEN 场景的 spec.md 文件
WHEN 运行 `node scripts/summarize-spec.mjs <spec-path>`
THEN 输出格式为每行 "场景: <name>" 后跟 GIVEN/WHEN/THEN 缩进行
AND 退出码为 0
```

### 场景: spec 文件不存在 [ADDED]

```
GIVEN 一个不存在的文件路径
WHEN 运行 `node scripts/summarize-spec.mjs <invalid-path>`
THEN 输出错误信息到 stderr
AND 退出码为非 0
```

### 场景: spec 无场景 [ADDED]

```
GIVEN 一个不包含 GIVEN/WHEN/THEN 的 spec.md 文件
WHEN 运行 `node scripts/summarize-spec.mjs <spec-path>`
THEN 输出"无场景"提示
AND 退出码为 0
```

## summarize-tasks.mjs

### 场景: 提取任务摘要 [ADDED]

```
GIVEN 一个包含 `- [ ]` 和 `- [x]` checkbox 的 tasks.md 文件
WHEN 运行 `node scripts/summarize-tasks.mjs <tasks-path>`
THEN 输出任务总数、已完成数、待完成数
AND 输出每个任务的标题和 spec 链接（如有）
AND 退出码为 0
```

### 场景: tasks 文件不存在 [ADDED]

```
GIVEN 一个不存在的文件路径
WHEN 运行 `node scripts/summarize-tasks.mjs <invalid-path>`
THEN 输出错误信息到 stderr
AND 退出码为非 0
```

### 场景: tasks 文件无 checkbox [ADDED]

```
GIVEN 一个不包含 `- [ ]` 或 `- [x]` 的 tasks.md 文件
WHEN 运行 `node scripts/summarize-tasks.mjs <tasks-path>`
THEN 输出任务总数 0
AND 退出码为 0
```

### 场景: tasks 文件为空 [ADDED]

```
GIVEN 一个空的 tasks.md 文件
WHEN 运行 `node scripts/summarize-tasks.mjs <tasks-path>`
THEN 输出任务总数 0
AND 退出码为 0
```

## compress-review.mjs

### 场景: 压缩 review 上下文 [ADDED]

```
GIVEN 一个 diff 文件路径和一个 spec 文件路径
WHEN 运行 `node scripts/compress-review.mjs <diff-path> <spec-path>`
THEN 输出结构化 review 上下文（变更文件列表 + 匹配的 spec 场景）
AND 退出码为 0
```

### 场景: diff 文件为空 [ADDED]

```
GIVEN 一个空的 diff 文件
WHEN 运行 `node scripts/compress-review.mjs <empty-diff> <spec-path>`
THEN 输出"无变更"提示
AND 退出码为 0
```

### 场景: spec 文件不存在 [ADDED]

```
GIVEN 一个有效的 diff 文件路径和一个不存在的 spec 文件路径
WHEN 运行 `node scripts/compress-review.mjs <diff-path> <invalid-spec-path>`
THEN 输出错误信息到 stderr
AND 退出码为非 0
```

### 场景: spec 无场景 [ADDED]

```
GIVEN 一个 diff 文件路径和一个不包含 GIVEN/WHEN/THEN 的 spec 文件路径
WHEN 运行 `node scripts/compress-review.mjs <diff-path> <spec-path>`
THEN 输出"无匹配场景"提示
AND 退出码为 0
```

## state-file.mjs

### 场景: 创建状态文件 [ADDED]

```
GIVEN 一个 change 目录路径和初始状态数据
WHEN 运行 `node scripts/state-file.mjs create <change-dir> --phase brainstorm`
THEN 在 change 目录下创建 state.yaml
AND 文件包含 phase: brainstorm
AND 退出码为 0
```

### 场景: 读取状态文件 [ADDED]

```
GIVEN 一个包含 state.yaml 的 change 目录
WHEN 运行 `node scripts/state-file.mjs read <change-dir>`
THEN 输出 state.yaml 内容为 YAML 格式
AND 退出码为 0
```

### 场景: 更新状态文件 [ADDED]

```
GIVEN 一个包含 state.yaml 的 change 目录
WHEN 运行 `node scripts/state-file.mjs update <change-dir> --phase propose`
THEN state.yaml 的 phase 字段更新为 propose
AND 退出码为 0
```

### 场景: 状态文件不存在时读取 [ADDED]

```
GIVEN 一个不包含 state.yaml 的 change 目录
WHEN 运行 `node scripts/state-file.mjs read <change-dir>`
THEN 输出错误信息到 stderr
AND 退出码为非 0
```

# Spec: SKILL.md 集成

> 将 CLI 脚本集成到 SDD 工作流 SKILL.md

## sdd-review-code 集成

### 场景: 前置逻辑使用 summarize-spec 获取场景摘要 [ADDED]

```
GIVEN sdd-review-code 被触发
AND openspec/changes/<name>/specs/ 下存在 spec 文件
WHEN 执行前置逻辑
THEN 调用 `node scripts/summarize-spec.mjs <spec-path>` 获取场景摘要
AND 将摘要传递给后续 review 阶段
AND 不直接读取完整 spec 文件内容
```

### 场景: Phase 2 使用 compress-review 准备上下文 [ADDED]

```
GIVEN sdd-review-code 进入 Phase 2（代码质量审查）
AND 存在 diff 文件和 spec 文件
WHEN 准备 review 上下文
THEN 调用 `node scripts/compress-review.mjs <diff-path> <spec-path>`
AND 将压缩后的上下文传递给 reviewer
```

## sdd-verify 集成

### 场景: 前置逻辑使用 summarize-spec + summarize-tasks 收集验证材料 [ADDED]

```
GIVEN sdd-verify 被触发
AND openspec/changes/<name>/ 下存在 specs/ 和 tasks.md
WHEN 执行前置逻辑
THEN 调用 `node scripts/summarize-spec.mjs <spec-path>` 获取所有 spec 场景摘要
AND 调用 `node scripts/summarize-tasks.mjs <tasks-path>` 获取任务完成状态
AND 将摘要和状态用于验证比对
```

## 状态文件集成

### 场景: sdd-brainstorm 创建状态文件 [ADDED]

```
GIVEN sdd-brainstorm 被触发
AND change 目录已定位
WHEN brainstorm 阶段完成
THEN 调用 `node scripts/state-file.mjs create <change-dir> --phase brainstorm`
AND 创建 state.yaml 记录当前阶段
```

### 场景: sdd-propose 更新状态文件 [ADDED]

```
GIVEN sdd-propose 被触发
AND change 目录下已存在 state.yaml
WHEN propose 阶段完成
THEN 调用 `node scripts/state-file.mjs update <change-dir> --phase propose`
AND 更新 state.yaml 的 phase 字段
```

### 场景: sdd-plan 更新状态文件 [ADDED]

```
GIVEN sdd-plan 被触发
AND change 目录下已存在 state.yaml
WHEN plan 阶段完成
THEN 调用 `node scripts/state-file.mjs update <change-dir> --phase plan`
AND 更新 state.yaml 的 phase 字段
```

### 场景: sdd-code 更新状态文件 [ADDED]

```
GIVEN sdd-code 被触发
AND change 目录下已存在 state.yaml
WHEN code 阶段完成
THEN 调用 `node scripts/state-file.mjs update <change-dir> --phase code`
AND 更新 state.yaml 的 phase 字段
```

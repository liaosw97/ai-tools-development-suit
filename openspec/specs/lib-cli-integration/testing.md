# Spec: 集成测试

> CLI 脚本的集成测试规范

## 测试框架

### 场景: 使用 Vitest 运行集成测试 [ADDED]

```
GIVEN 项目使用 Vitest 作为测试框架
WHEN 运行 `pnpm test`
THEN 集成测试与现有测试一起执行
AND 测试结果包含新增集成测试的通过/失败状态
```

## 脚本可执行性测试

### 场景: 所有脚本 node 直接执行无错误 [ADDED]

```
GIVEN 4 个 CLI 脚本已创建
WHEN 对每个脚本运行 `node scripts/<name>.mjs` 无参数调用
THEN 所有脚本不抛出未捕获异常
AND 脚本输出帮助信息或用法说明
```

## 端到端测试

### 场景: summarize-spec 端到端 [ADDED]

```
GIVEN 一个包含 3 个 GIVEN/WHEN/THEN 场景的测试 spec 文件
WHEN 运行 `node scripts/summarize-spec.mjs <test-spec-path>`
THEN 输出包含 3 个场景的摘要
AND 输出格式为每行 "场景: <name>" 后跟 GIVEN/WHEN/THEN 缩进行
```

### 场景: summarize-tasks 端到端 [ADDED]

```
GIVEN 一个包含 5 个任务（3 完成、2 待完成）的测试 tasks.md
WHEN 运行 `node scripts/summarize-tasks.mjs <test-tasks-path>`
THEN 输出格式为 "总数: 5, 已完成: 3, 待完成: 2"
```

### 场景: compress-review 端到端 [ADDED]

```
GIVEN 一个测试 diff 文件和一个测试 spec 文件
WHEN 运行 `node scripts/compress-review.mjs <diff-path> <spec-path>`
THEN 输出格式为 "变更文件: [文件列表]" 后跟 "匹配场景: [场景列表]"
```

### 场景: state-file 端到端 [ADDED]

```
GIVEN 一个临时目录
WHEN 依次运行 create、read、update 操作
THEN create 后文件存在且包含 phase 字段
AND read 输出包含 phase: brainstorm
AND update 后 phase 字段变为 propose
AND 所有操作退出码为 0
```

## 向后兼容

### 场景: 现有测试不受影响 [ADDED]

```
GIVEN 新增集成测试已添加
WHEN 运行 `pnpm test`
THEN 现有 331 个测试全部通过
AND 无新增失败
```

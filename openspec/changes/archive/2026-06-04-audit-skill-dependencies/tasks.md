# Tasks: ai-tools-bridge Skill 依赖修复

## 前置：启用 OPSX 扩展命令

- [x] 1.1 构建 OpenSpec CLI [spec:opsx-extension#启用扩展-profile]
  - `cd ai-tools/OpenSpec && pnpm install && pnpm run build`
- [x] 1.2 启用 workflows profile [spec:opsx-extension#启用扩展-profile]
  - `openspec config profile` → 选择 workflows
- [x] 1.3 生成扩展命令文件 [spec:opsx-extension#启用扩展-profile]
  - `openspec update`
- [x] 1.4 验证扩展命令已生成 [spec:opsx-extension#扩展命令可用性]
  - 确认 `.claude/commands/opsx/` 下有 11 个 `.md` 文件

## 修改 ai-tools-bridge 引用

- [x] 2.1 修改 sdd-propose [spec:skill-reference-update#sdd-propose-双引用处理]
  - `openspec-propose` → `/opsx:propose`
  - `openspec-continue-change` → `/opsx:continue`
- [x] 2.2 修改 sdd-continue [spec:skill-reference-update#invoke-引用替换]
  - `openspec-continue-change` → `/opsx:continue`
- [x] 2.3 修改 sdd-ff [spec:skill-reference-update#invoke-引用替换]
  - `openspec-ff-change` → `/opsx:ff`
- [x] 2.4 修改 sdd-verify [spec:skill-reference-update#invoke-引用替换]
  - `openspec-verify-change` → `/opsx:verify`
- [x] 2.5 修改 sdd-ship [spec:skill-reference-update#sdd-ship-双引用处理]
  - Step 1: `openspec-sync-specs` → `/opsx:sync`
  - Step 2: `openspec-archive-change` → `/opsx:archive`
- [x] 2.6 修改 sdd-quick [spec:skill-reference-update#sdd-quick-的-openspec-continue-change-引用]
  - `openspec-continue-change` → `/opsx:continue`

## 验证

- [x] 3.1 验证三层模式保持 [spec:skill-reference-update#三层模式保持]
  - 检查 7 个文件的前置/后置逻辑未被修改
- [x] 3.2 验证 Override 指令保留 [spec:skill-reference-update#override-指令保留]
  - 检查所有 Override 指令完整传递
- [x] 3.3 验证无残留 openspec- 引用 [spec:skill-reference-update#完整依赖验证]
  - grep 确认无 `invoke.*openspec-` 残留
  - 确认 14 个 Skill 的外部依赖均指向已存在目标
- [x] 3.4 验证核心命令不受影响 [spec:opsx-extension#核心命令不受影响]
  - 确认 `/opsx:propose`、`/opsx:apply`、`/opsx:archive` 行为不变

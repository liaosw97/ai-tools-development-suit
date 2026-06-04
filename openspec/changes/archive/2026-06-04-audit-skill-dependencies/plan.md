# Plan: ai-tools-bridge Skill 依赖修复

## 批次 1/1：完整实施

<!-- 依赖：无前置依赖 -->
<!-- 任务范围：1.1-3.4 -->

### Task 1.1: 构建 OpenSpec CLI [spec:opsx-extension#启用扩展-profile]

**RED**
```bash
cd ai-tools/OpenSpec
ls bin/openspec 2>/dev/null || echo "CLI 未构建"
```
预期：CLI 不存在或为旧版本

**GREEN**
```bash
cd ai-tools/OpenSpec
pnpm install && pnpm run build
```
预期：构建成功，无错误输出

**验证**
```bash
cd ai-tools/OpenSpec
node bin/openspec --version
```
预期：输出版本号

---

### Task 1.2: 启用 workflows profile [spec:opsx-extension#启用扩展-profile]

**RED**
```bash
ls .claude/commands/opsx/continue.md 2>/dev/null || echo "扩展命令不存在"
```
预期：扩展命令文件不存在

**GREEN**
```bash
cd ai-tools/OpenSpec
openspec config profile
# 交互式选择 workflows
```
预期：profile 设置为 workflows

**验证**
```bash
cat ai-tools/OpenSpec/openspec/config.yaml | grep -i profile || echo "无 profile 配置"
```
预期：包含 workflows profile 配置

---

### Task 1.3: 生成扩展命令文件 [spec:opsx-extension#启用扩展-profile]

**RED**
```bash
ls .claude/commands/opsx/ | wc -l
```
预期：文件数 < 11

**GREEN**
```bash
cd ai-tools/OpenSpec
openspec update
```
预期：成功生成扩展命令文件

**验证**
```bash
ls .claude/commands/opsx/*.md | wc -l
```
预期：文件数 = 11

---

### Task 1.4: 验证扩展命令已生成 [spec:opsx-extension#扩展命令可用性]

**RED**
```bash
for cmd in new continue ff verify sync bulk-archive onboard; do
  test -f ".claude/commands/opsx/${cmd}.md" || echo "缺失: ${cmd}.md"
done
```
预期：列出所有缺失的扩展命令

**GREEN**（Task 1.3 已完成）

**验证**
```bash
ls -la .claude/commands/opsx/
```
预期：包含 11 个 `.md` 文件（4 核心 + 7 扩展）

---

### Task 2.1: 修改 sdd-propose [spec:skill-reference-update#sdd-propose-双引用处理]

**RED**
```bash
grep -n "invoke.*openspec-propose\|invoke.*openspec-continue-change" ai-tools-bridge/skills/sdd-propose/SKILL.md
```
预期：找到 `openspec-propose` 和 `openspec-continue-change` 引用

**GREEN**
```bash
# 替换引用（在 ai-tools-bridge/skills/sdd-propose/SKILL.md 中）：
# openspec-propose → /opsx:propose
# openspec-continue-change → /opsx:continue
```

**验证**
```bash
grep -n "invoke.*openspec-" ai-tools-bridge/skills/sdd-propose/SKILL.md
```
预期：无输出（无残留 openspec- 引用）

---

### Task 2.2: 修改 sdd-continue [spec:skill-reference-update#invoke-引用替换]

**RED**
```bash
grep -n "invoke.*openspec-continue-change" ai-tools-bridge/skills/sdd-continue/SKILL.md
```
预期：找到 `openspec-continue-change` 引用

**GREEN**
```bash
# 替换：openspec-continue-change → /opsx:continue
```

**验证**
```bash
grep -n "invoke.*openspec-" ai-tools-bridge/skills/sdd-continue/SKILL.md
```
预期：无输出

---

### Task 2.3: 修改 sdd-ff [spec:skill-reference-update#invoke-引用替换]

**RED**
```bash
grep -n "invoke.*openspec-ff-change" ai-tools-bridge/skills/sdd-ff/SKILL.md
```
预期：找到 `openspec-ff-change` 引用

**GREEN**
```bash
# 替换：openspec-ff-change → /opsx:ff
```

**验证**
```bash
grep -n "invoke.*openspec-" ai-tools-bridge/skills/sdd-ff/SKILL.md
```
预期：无输出

---

### Task 2.4: 修改 sdd-verify [spec:skill-reference-update#invoke-引用替换]

**RED**
```bash
grep -n "invoke.*openspec-verify-change" ai-tools-bridge/skills/sdd-verify/SKILL.md
```
预期：找到 `openspec-verify-change` 引用

**GREEN**
```bash
# 替换：openspec-verify-change → /opsx:verify
```

**验证**
```bash
grep -n "invoke.*openspec-" ai-tools-bridge/skills/sdd-verify/SKILL.md
```
预期：无输出

---

### Task 2.5: 修改 sdd-ship [spec:skill-reference-update#sdd-ship-双引用处理]

**RED**
```bash
grep -n "invoke.*openspec-sync-specs\|invoke.*openspec-archive-change" ai-tools-bridge/skills/sdd-ship/SKILL.md
```
预期：找到 `openspec-sync-specs` 和 `openspec-archive-change` 引用

**GREEN**
```bash
# Step 1 替换：openspec-sync-specs → /opsx:sync
# Step 2 替换：openspec-archive-change → /opsx:archive
```

**验证**
```bash
grep -n "invoke.*openspec-" ai-tools-bridge/skills/sdd-ship/SKILL.md
```
预期：无输出

---

### Task 2.6: 修改 sdd-quick [spec:skill-reference-update#sdd-quick-的-openspec-continue-change-引用]

**RED**
```bash
grep -n "invoke.*openspec-continue-change" ai-tools-bridge/skills/sdd-quick/SKILL.md
```
预期：找到 `openspec-continue-change` 引用

**GREEN**
```bash
# 替换：openspec-continue-change → /opsx:continue
```

**验证**
```bash
grep -n "invoke.*openspec-" ai-tools-bridge/skills/sdd-quick/SKILL.md
```
预期：无输出

---

### Task 3.1: 验证三层模式保持 [spec:skill-reference-update#三层模式保持]

**GREEN**（无 RED，验证性任务）

**验证**
```bash
# 对 7 个修改文件执行 git diff，确认仅 invoke 行变更
cd ai-tools-bridge
git diff skills/sdd-propose/SKILL.md skills/sdd-continue/SKILL.md skills/sdd-ff/SKILL.md skills/sdd-verify/SKILL.md skills/sdd-ship/SKILL.md skills/sdd-quick/SKILL.md
```
预期：diff 仅包含 `invoke` 引用行的变更，前置/后置逻辑无变化

---

### Task 3.2: 验证 Override 指令保留 [spec:skill-reference-update#override-指令保留]

**GREEN**（无 RED，验证性任务）

**验证**
```bash
# 检查每个文件的 Override 指令块是否完整
for f in sdd-propose sdd-continue sdd-ff sdd-verify sdd-ship sdd-quick; do
  echo "=== $f ==="
  grep -A5 "Override" ai-tools-bridge/skills/$f/SKILL.md
done
```
预期：每个文件的 Override 指令内容与修改前一致

---

### Task 3.3: 验证无残留 openspec- 引用 [spec:skill-reference-update#完整依赖验证]

**GREEN**（无 RED，验证性任务）

**验证**
```bash
grep -rn "invoke.*openspec-" ai-tools-bridge/skills/
```
预期：无输出（所有 openspec- 引用已替换）

---

### Task 3.4: 验证核心命令不受影响 [spec:opsx-extension#核心命令不受影响]

**GREEN**（无 RED，验证性任务）

**验证**
```bash
# 确认 4 个核心命令文件未被修改
for cmd in propose explore apply archive; do
  test -f ".claude/commands/opsx/${cmd}.md" && echo "✅ ${cmd}.md 存在" || echo "❌ ${cmd}.md 缺失"
done
```
预期：4 个核心命令文件均存在且未被修改

--- checkpoint ---

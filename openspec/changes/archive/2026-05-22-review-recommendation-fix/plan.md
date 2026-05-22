# Plan: review-recommendation-fix

> 实施计划 — 修改 SKILL.md 完成引导格式

---

## 批次一：审查类 skill 修复

### Task 1.1: 修复 sdd-review-code 完成引导格式 [spec:recommendation-format#审查类skill条件驱动格式]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **修改位置**: 第 172-177 行（后置逻辑 > 推荐下一步）
- **修改内容**:
  - 删除当前"推荐下一步:"列表格式
  - 替换为条件驱动格式：
    ```
    ★ 推荐下一步（按审查结果）:
      /sdd-verify — 全部 PASSED，进入验证阶段
      /sdd-test-code — 有 PARTIAL 场景，补全缺失测试
      /sdd-code — 有 MISSING 场景或 critical issues，补充实现
      △ /sdd-code — 继续下一批次实施
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 1.2: 修复 sdd-review-spec 完成引导格式 [spec:recommendation-format#审查类skill条件驱动格式]

- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Modify)
- **修改位置**: 第 116-120 行
- **修改内容**:
  - 修正 Issues 路径描述：`/sdd-propose — 修正提案后重新生成` 改为 `/sdd-ff — 重新生成 spec`
  - 调整格式为统一条件驱动格式：
    ```
    ★ 推荐下一步（按审查结果）:
      /sdd-plan — Approved，生成实施计划
      /sdd-ff — Issues，重新生成 spec
      △ /sdd-propose — 回退修改提案
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 1.3: 修复 sdd-verify 验证报告，消除重复输出 [spec:recommendation-format#消除重复输出]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **修改位置**: 第 109-125 行（验证报告节）
- **修改内容**:
  - 删除验证报告中的"推荐下一步:"（第 122-125 行）
  - 验证报告仅输出：覆盖率统计、测试结果、未覆盖场景列表
  - "推荐下一步"仅在完成引导中输出一次
- **验证**: 读取修改后文件，确认验证报告中无"推荐下一步"

### Task 1.4: 修复 sdd-verify 完成引导格式 [spec:recommendation-format#审查失败时提供修复路径]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **修改位置**: 第 136-142 行（完成引导 > 推荐下一步）
- **修改内容**:
  - 删除当前"推荐下一步:"列表（第 136-139 行）
  - 替换为条件驱动格式：
    ```
    ★ 推荐下一步（按审查结果）:
      /sdd-ship — PASSED，归档合并
      /sdd-test-code — FAILED，测试未覆盖场景
      /sdd-code — FAILED，实现缺失
    ```
- **验证**: 读取修改后文件，确认格式符合规范

---

## 批次二：其他 skill 格式统一

### Task 2.1: 修复 sdd-test-code 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **修改位置**: 第 113-116 行
- **修改内容**:
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-verify — 全面验证 Spec 场景覆盖
      △ /sdd-ship — 归档合并（sdd-ship 会提示 verify 检查）
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.2: 修复 sdd-plan 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **修改位置**: 第 213-215 行
- **修改内容**:
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-code — 开始 TDD 实施
      ○ /sdd-review-spec — 先审查 spec 质量
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.3: 修复 sdd-code 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **修改位置**: 第 116-122 行
- **修改内容**:
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-review-code — 审查本批次代码
      ○ /sdd-code — 继续下一批次
      △ /sdd-ship — 简单变更可直接归档
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.4: 修复 sdd-quick 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-quick/SKILL.md` (Modify)
- **修改位置**: 第 196-200 行
- **修改内容**:
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-review-code — 审查代码质量和 Spec 合规
      △ /sdd-ship — 快速变更可直接归档
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.5: 修复 sdd-ff 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-ff/SKILL.md` (Modify)
- **修改位置**: 第 110-116 行
- **修改内容**:
  - 删除"推荐下一步:"列表（第 110-113 行）
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-plan — 生成实施计划
      ○ /sdd-review-spec — 先审查 spec 质量
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.6: 修复 sdd-propose 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **修改位置**: 第 125-132 行
- **修改内容**:
  - 删除"推荐下一步:"列表（第 125-128 行）
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-ff — 快进生成所有文档
      ○ /sdd-continue — 逐步确认细节
      △ /sdd-brainstorm — 回退补充探索
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.7: 修复 sdd-continue 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-continue/SKILL.md` (Modify)
- **修改位置**: 第 102-111 行
- **修改内容**:
  - 删除当前"推荐下一步:"列表和重复的"当前进度"
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-continue — 继续下一个 artifact
      ○ /sdd-ff — 快进生成所有剩余
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.8: 修复 sdd-brainstorm 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **修改位置**: 第 159-167 行
- **修改内容**:
  - 删除"推荐下一步:"列表（第 159-162 行）
  - 调整格式为：
    ```
    ★ 推荐下一步: /sdd-propose — 固化提案
      ○ /sdd-ff — 需求已充分明确时跳过 propose 直接快进
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.9: 修复 sdd-doctor 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-doctor/SKILL.md` (Modify)
- **修改位置**: 第 161-167 行
- **修改内容**:
  - 调整格式为：
    ```
    ★ 推荐下一步: 根据复杂度评级选择路径（见上方推荐）
      ○ /sdd-brainstorm — 手动从头脑风暴开始
      ○ /sdd-propose — 手动从提案开始
    ```
- **验证**: 读取修改后文件，确认格式符合规范

### Task 2.10: 修复 sdd-ship 完成引导格式 [spec:recommendation-format#普通skill完成引导]

- **文件**: `ai-tools-bridge/skills/sdd-ship/SKILL.md` (Modify)
- **修改位置**: 第 166-178 行
- **修改内容**:
  - 检查是否需要调整（当前格式可能已正确）
  - 如需调整，统一为标准格式
- **验证**: 读取修改后文件，确认格式符合规范

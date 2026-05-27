# Plan: 添加 gstack 并提取角色系统

> 实施计划 — TDD 级别的详细步骤

---

## 批次 1/5：基础设施搭建

<!-- 依赖：无 -->
<!-- 任务范围：1.1-1.3, 2.1-2.4, 8.1-8.2 -->

### Task 1.1: 添加 gstack Git Submodule [spec:gstack-integration#SC-01]

- **文件**: `ai-tools/gstack/` (Create), `.gitmodules` (Modify)
- **RED**: 验证 gstack 目录不存在
  ```bash
  test ! -d ai-tools/gstack && echo "PASS: gstack 目录不存在" || echo "FAIL: gstack 目录已存在"
  ```
- **运行验证失败**: `test -d ai-tools/gstack`
- **GREEN**: 添加 submodule
  ```bash
  git submodule add https://github.com/liaosw97/gstack.git ai-tools/gstack
  ```
- **运行验证通过**: `test -d ai-tools/gstack && cat .gitmodules | grep gstack`

### Task 1.2: 验证 submodule 初始化正常 [spec:gstack-integration#SC-02]

- **文件**: `ai-tools/gstack/` (Verify)
- **RED**: 验证 submodule 可初始化
  ```bash
  git submodule update --init --recursive ai-tools/gstack
  ```
- **运行验证**: `test -f ai-tools/gstack/README.md`

### Task 1.3: 更新 versions.lock 记录 gstack 版本 [spec:gstack-integration#SC-03]

- **文件**: `versions.lock` (Modify)
- **RED**: 验证 versions.lock 不包含 gstack 条目
  ```bash
  test ! $(grep -q "gstack" versions.lock 2>/dev/null) && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 添加 gstack 版本记录
  ```
  在 versions.lock 中添加:
  gstack|https://github.com/liaosw97/gstack.git|<commit-hash>|<date>
  ```
- **运行验证通过**: `grep "gstack" versions.lock`

### Task 2.1: 创建 `ai-tools-bridge/roles/planning/` 目录 [spec:role-system#SC-02]

- **文件**: `ai-tools-bridge/roles/planning/` (Create)
- **RED**: 验证目录不存在
  ```bash
  test ! -d ai-tools-bridge/roles/planning && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 创建目录
  ```bash
  mkdir -p ai-tools-bridge/roles/planning
  ```
- **运行验证通过**: `test -d ai-tools-bridge/roles/planning`

### Task 2.2: 创建 `ai-tools-bridge/roles/execution/` 目录 [spec:role-system#SC-02]

- **文件**: `ai-tools-bridge/roles/execution/` (Create)
- **RED**: 验证目录不存在
- **GREEN**: 创建目录
  ```bash
  mkdir -p ai-tools-bridge/roles/execution
  ```
- **运行验证通过**: `test -d ai-tools-bridge/roles/execution`

### Task 2.3: 创建 `ai-tools-bridge/roles/review/` 目录 [spec:role-system#SC-02]

- **文件**: `ai-tools-bridge/roles/review/` (Create)
- **RED**: 验证目录不存在
- **GREEN**: 创建目录
  ```bash
  mkdir -p ai-tools-bridge/roles/review
  ```
- **运行验证通过**: `test -d ai-tools-bridge/roles/review`

### Task 2.4: 创建 `ai-tools-bridge/roles/release/` 目录 [spec:role-system#SC-02]

- **文件**: `ai-tools-bridge/roles/release/` (Create)
- **RED**: 验证目录不存在
- **GREEN**: 创建目录
  ```bash
  mkdir -p ai-tools-bridge/roles/release
  ```
- **运行验证通过**: `test -d ai-tools-bridge/roles/release`

### Task 8.1: 更新 `CLAUDE.md` 添加角色使用说明 [spec:role-system#SC-03]

- **文件**: `CLAUDE.md` (Modify)
- **RED**: 验证 CLAUDE.md 不包含角色系统说明
  ```bash
  ! grep -q "角色系统" CLAUDE.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 添加角色系统说明节
  ```markdown
  ## 角色系统

  SDD action 支持角色视角切换：

  ### 使用方式

  ```bash
  /sdd-review-code              # 默认 staff-engineer 角色
  /sdd-review-code --role cso   # 切换为安全官角色
  /sdd-role cso                 # 切换当前会话角色
  /sdd-role                     # 显示当前角色
  /sdd-role --list              # 列出所有可用角色
  ```

  ### 内置角色

  | 分类 | 角色 | 适用 action |
  |------|------|-------------|
  | Planning | yc-office-hours, ceo, eng-manager, designer | sdd-brainstorm, sdd-propose, sdd-plan |
  | Execution | developer | sdd-code |
  | Review | staff-engineer, qa-lead, cso | sdd-review-*, sdd-test-code, sdd-verify |
  | Release | release-engineer, sre | sdd-ship |

  ### 角色优先级

  用户级 (`~/.claude/roles/`) > 项目级 (`openspec/roles/`) > 内置 (`ai-tools-bridge/roles/`)
  ```
- **运行验证通过**: `grep "角色系统" CLAUDE.md`

### Task 8.2: 更新 `ai-tools-bridge/CLAUDE.md` 添加角色系统说明 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/CLAUDE.md` (Modify)
- **RED**: 验证文件不包含角色系统说明
  ```bash
  ! grep -q "角色系统" ai-tools-bridge/CLAUDE.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 添加角色系统详细说明
  ```markdown
  ## 角色系统

  ### 目录结构

  ```
  ai-tools-bridge/roles/
    planning/
      yc-office-hours.md
      ceo.md
      eng-manager.md
      designer.md
    execution/
      developer.md
    review/
      staff-engineer.md
      qa-lead.md
      cso.md
    release/
      release-engineer.md
      sre.md
  ```

  ### 角色定义格式

  每个 role 文件包含 5 要素：
  - 身份（Who）
  - 专业视角（Perspective）
  - 强制问题（Forcing Questions）
  - 输出格式（Output Format）
  - 触发条件（Trigger）— YAML frontmatter

  ### 加载流程

  1. 检查 `--role` 参数
  2. 检查会话级角色 (`/sdd-role` 设置)
  3. 使用 action 默认角色
  4. 按优先级合并：用户级 > 项目级 > 内置
  ```
- **运行验证通过**: `grep "角色系统" ai-tools-bridge/CLAUDE.md`

--- checkpoint ---

**批次 1 完成。包含 9 个任务。**

依赖说明：
- 后续批次依赖本批次的目录结构
- 角色定义文件将写入本批次创建的目录

---

## 批次 2/5：角色定义文件

<!-- 依赖：批次 1 的目录结构 -->
<!-- 任务范围：3.1-3.10 -->

### Task 3.1: 创建 `yc-office-hours.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/planning/yc-office-hours.md` (Create)
- **RED**: 验证文件不存在
  ```bash
  test ! -f ai-tools-bridge/roles/planning/yc-office-hours.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: yc-office-hours
  trigger: sdd-brainstorm
  ---

  # 角色

  你是一名 YC 合伙人，正在进行 Office Hours。你的职责是帮助创始人澄清产品方向，挑战他们的假设，推动他们思考更深层次的问题。

  # 专业视角

  - 产品市场匹配（PMF）验证
  - 用户痛点的真实性
  - 解决方案的差异化
  - 商业模式的可行性
  - 执行优先级的合理性

  # 强制问题

  1. 你正在解决的具体痛点是什么？请举 3 个真实用户案例。
  2. 如果只能做一件事，应该是什么？为什么？
  3. 你的解决方案和其他方案的本质区别是什么？
  4. 用户愿意为此付费吗？为什么？
  5. 接下来 30 天的关键里程碑是什么？

  # 输出格式

  ## 痛点澄清
  [重构后的核心痛点]

  ## 假设挑战
  [被挑战的假设及调整]

  ## 方向建议
  [推荐的下一步行动]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/planning/yc-office-hours.md && grep "name: yc-office-hours" ai-tools-bridge/roles/planning/yc-office-hours.md`

### Task 3.2: 创建 `ceo.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/planning/ceo.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: ceo
  trigger: sdd-propose, sdd-brainstorm
  ---

  # 角色

  你是一名 CEO / Founder，负责从战略视角审视产品决策。你关注商业价值、市场机会和执行效率。

  # 专业视角

  - 战略价值与商业影响
  - 市场机会与竞争格局
  - 资源投入与 ROI
  - 风险评估与缓解
  - 执行优先级

  # 强制问题

  1. 这个功能如何支持公司的核心目标？
  2. 不做这个功能的代价是什么？
  3. 有没有更简单的方式达到同样的目标？
  4. 这个决策的可逆性如何？
  5. 如果成功，下一步是什么？如果失败，退出策略是什么？

  # 输出格式

  ## 战略评估
  [与公司目标的对齐程度]

  ## 商业影响
  [预期收益与成本]

  ## 风险提示
  [主要风险及缓解措施]

  ## 决策建议
  [批准/修改/拒绝的建议]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/planning/ceo.md`

### Task 3.3: 创建 `eng-manager.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/planning/eng-manager.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: eng-manager
  trigger: sdd-plan, sdd-review-spec, sdd-propose
  ---

  # 角色

  你是一名工程经理，负责技术决策、架构设计和工程执行。你关注实现可行性、技术债务和团队效率。

  # 专业视角

  - 架构设计与系统边界
  - 技术债务与代码质量
  - 性能与可扩展性
  - 安全与合规
  - 团队技能与工作量

  # 强制问题

  1. 这个设计的核心假设是什么？如果假设错误会怎样？
  2. 有哪些边缘情况需要处理？
  3. 如何验证这个实现是正确的？
  4. 这个变更会影响哪些现有功能？
  5. 技术债务如何管理？

  # 输出格式

  ## 架构评估
  [设计合理性分析]

  ## 边缘案例
  [需要处理的边界条件]

  ## 测试策略
  [验证方案]

  ## 风险项
  [技术风险及缓解]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/planning/eng-manager.md`

### Task 3.4: 创建 `designer.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/planning/designer.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: designer
  trigger: sdd-brainstorm, sdd-review-spec
  ---

  # 角色

  你是一名资深设计师，负责用户体验和产品设计的质量把关。你关注用户旅程、交互设计和视觉一致性。

  # 专业视角

  - 用户旅程与体验流畅性
  - 交互模式与可用性
  - 视觉一致性与品牌对齐
  - 无障碍设计与包容性
  - AI 输出质量（AI Slop 检测）

  # 强制问题

  1. 用户完成这个任务需要几步？能否更简单？
  2. 这个设计是否符合用户心智模型？
  3. 错误状态如何处理？
  4. 是否有 AI 生成的"通用"内容需要个性化？
  5. 设计评分（0-10）：当前设计的不足是什么？

  # 输出格式

  ## 体验评估
  [用户旅程分析]

  ## 设计评分
  [各维度 0-10 评分及改进建议]

  ## AI Slop 检测
  [需要个性化的通用内容]

  ## 改进建议
  [具体优化方向]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/planning/designer.md`

### Task 3.5: 创建 `developer.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/execution/developer.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: developer
  trigger: sdd-code
  ---

  # 角色

  你是一名软件工程师，负责将设计转化为可工作的代码。你关注代码质量、测试覆盖和工程最佳实践。

  # 专业视角

  - 代码可读性与可维护性
  - 测试驱动开发（TDD）
  - 错误处理与边界条件
  - 性能与资源效率
  - 安全编码实践

  # 强制问题

  1. 测试是否覆盖了主要场景和边缘情况？
  2. 代码是否易于理解和修改？
  3. 错误处理是否完整？
  4. 是否引入了安全风险？
  5. 代码是否符合项目规范？

  # 输出格式

  ## 实现说明
  [关键实现决策]

  ## 测试覆盖
  [已实现的测试场景]

  ## 注意事项
  [后续维护要点]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/execution/developer.md`

### Task 3.6: 创建 `staff-engineer.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/review/staff-engineer.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: staff-engineer
  trigger: sdd-review-code, sdd-test-code
  ---

  # 角色

  你是一名 Staff Engineer，负责代码审查和质量把关。你关注生产级问题、架构一致性和工程卓越。

  # 专业视角

  - 生产级 Bug 发现
  - 架构一致性与模块边界
  - 代码质量与可维护性
  - 性能与可扩展性
  - 知识分享与团队成长

  # 强制问题

  1. 这段代码在生产环境可能出现什么问题？
  2. 是否与现有架构一致？
  3. 是否有更简洁的实现方式？
  4. 错误处理是否完整？
  5. 代码是否易于测试？

  # 输出格式

  ## 审查发现
  [问题列表，按严重性排序]

  ## 自动修复
  [可自动修复的问题及修复内容]

  ## 待确认
  [需要作者确认的问题]

  ## 建议改进
  [非阻塞性的改进建议]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/review/staff-engineer.md`

### Task 3.7: 创建 `qa-lead.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/review/qa-lead.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: qa-lead
  trigger: sdd-test-code, sdd-verify, sdd-review-code
  ---

  # 角色

  你是一名 QA Lead，负责测试策略和质量保证。你关注测试覆盖、回归风险和验收标准。

  # 专业视角

  - 测试覆盖率与场景完整性
  - 回归测试与变更影响
  - 边界条件与异常处理
  - 验收标准与交付质量
  - 自动化测试效率

  # 强制问题

  1. 测试是否覆盖了所有 spec 场景？
  2. 有哪些边缘情况可能被遗漏？
  3. 回归测试是否充分？
  4. 验收标准是否明确可验证？
  5. 测试数据是否真实有效？

  # 输出格式

  ## 场景覆盖
  [spec 场景与测试用例映射]

  ## 遗漏发现
  [未覆盖的场景或边缘情况]

  ## 回归分析
  [变更影响的测试范围]

  ## 质量评估
  [整体质量评分与建议]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/review/qa-lead.md`

### Task 3.8: 创建 `cso.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/review/cso.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: cso
  trigger: sdd-review-code, sdd-verify
  ---

  # 角色

  你是一名首席安全官（Chief Security Officer），负责安全审计和风险评估。你关注 OWASP Top 10、STRIDE 威胁模型和安全最佳实践。

  # 专业视角

  - OWASP Top 10 漏洞检测
  - STRIDE 威胁建模
  - 认证与授权安全
  - 数据保护与隐私
  - 安全配置与依赖

  # 强制问题

  1. 是否存在注入漏洞（SQL、XSS、命令注入）？
  2. 认证和授权是否正确实现？
  3. 敏感数据是否安全存储和传输？
  4. 是否有已知的依赖漏洞？
  5. 安全配置是否正确？

  # 输出格式

  ## 安全发现
  [漏洞列表，按风险等级排序]

  ## 威胁模型
  [STRIDE 分析结果]

  ## 修复建议
  [每个发现的具体修复方案]

  ## 风险评估
  [整体安全风险评级]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/review/cso.md`

### Task 3.9: 创建 `release-engineer.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/release/release-engineer.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: release-engineer
  trigger: sdd-ship
  ---

  # 角色

  你是一名发布工程师，负责代码发布和部署流程。你关注 CI/CD、版本管理和发布质量。

  # 专业视角

  - CI/CD 流程与自动化
  - 版本管理与变更日志
  - 发布检查与回滚策略
  - 监控与告警
  - 文档与知识传递

  # 强制问题

  1. CI 是否通过？测试覆盖率是否达标？
  2. 变更日志是否更新？
  3. 是否有破坏性变更需要迁移指南？
  4. 回滚策略是否明确？
  5. 监控告警是否配置？

  # 输出格式

  ## 发布检查
  [发布前检查清单状态]

  ## 变更摘要
  [本次发布的主要内容]

  ## 风险提示
  [发布风险及应对措施]

  ## 发布建议
  [批准/延迟/拒绝发布]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/release/release-engineer.md`

### Task 3.10: 创建 `sre.md` 角色定义 [spec:role-system#SC-01]

- **文件**: `ai-tools-bridge/roles/release/sre.md` (Create)
- **RED**: 验证文件不存在
- **GREEN**: 创建角色定义
  ```markdown
  ---
  name: sre
  trigger: sdd-ship, sdd-verify
  ---

  # 角色

  你是一名站点可靠性工程师（SRE），负责系统可靠性和运维效率。你关注监控、告警、容量规划和故障恢复。

  # 专业视角

  - 服务可用性与 SLO
  - 监控与告警配置
  - 容量规划与性能优化
  - 故障检测与恢复
  - 运维自动化

  # 强制问题

  1. 服务 SLO 是否定义？当前状态如何？
  2. 关键指标是否有监控和告警？
  3. 是否有容量瓶颈？
  4. 故障恢复流程是否测试过？
  5. 是否有运维手册？

  # 输出格式

  ## 可用性评估
  [当前服务状态与 SLO 对比]

  ## 监控检查
  [关键指标和告警状态]

  ## 容量分析
  [资源使用与增长预测]

  ## 运维建议
  [可靠性改进措施]
  ```
- **运行验证通过**: `test -f ai-tools-bridge/roles/release/sre.md`

--- checkpoint ---

**批次 2 完成。包含 10 个任务。**

依赖说明：
- 依赖批次 1 创建的目录结构
- 批次 3、4 将引用这些角色定义

---

## 批次 3/5：SDD action 角色绑定

<!-- 依赖：批次 2 的角色定义文件 -->
<!-- 任务范围：4.1-4.9 -->

### Task 4.1: 为 `sdd-brainstorm` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 验证 SKILL.md 不包含角色加载逻辑
  ```bash
  ! grep -q "角色加载" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 在前置逻辑节添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  在执行核心逻辑前，加载并应用角色视角：

  1. 检查命令参数是否包含 `--role <name>`
  2. 检查会话级角色（由 `/sdd-role` 设置）
  3. 使用默认角色：`yc-office-hours`
  4. 按优先级合并角色定义：用户级 > 项目级 > 内置
  5. 将角色的专业视角和强制问题注入执行上下文

  **默认角色**: `yc-office-hours`
  **可选角色**: `ceo`, `designer`
  ```
- **运行验证通过**: `grep "角色加载" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md && grep "yc-office-hours" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

### Task 4.2: 为 `sdd-propose` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-propose/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `ceo`
  **可选角色**: `eng-manager`
  ```
- **运行验证通过**: `grep "默认角色.*ceo" ai-tools-bridge/skills/sdd-propose/SKILL.md`

### Task 4.3: 为 `sdd-review-spec` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-review-spec/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `eng-manager`
  **可选角色**: `ceo`, `designer`
  ```
- **运行验证通过**: `grep "默认角色.*eng-manager" ai-tools-bridge/skills/sdd-review-spec/SKILL.md`

### Task 4.4: 为 `sdd-plan` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-plan/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `eng-manager`
  **可选角色**: `ceo`
  ```
- **运行验证通过**: `grep "默认角色.*eng-manager" ai-tools-bridge/skills/sdd-plan/SKILL.md`

### Task 4.5: 为 `sdd-code` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-code/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `developer`
  **可选角色**: 无

  注：sdd-code 执行阶段角色固定为 developer，确保 TDD 纪律执行。
  ```
- **运行验证通过**: `grep "默认角色.*developer" ai-tools-bridge/skills/sdd-code/SKILL.md`

### Task 4.6: 为 `sdd-review-code` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-review-code/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `staff-engineer`
  **可选角色**: `cso`, `qa-lead`

  注：切换为 `cso` 角色可执行安全审计；切换为 `qa-lead` 角色可执行测试覆盖审查。
  ```
- **运行验证通过**: `grep "默认角色.*staff-engineer" ai-tools-bridge/skills/sdd-review-code/SKILL.md`

### Task 4.7: 为 `sdd-test-code` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-test-code/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `qa-lead`
  **可选角色**: `staff-engineer`
  ```
- **运行验证通过**: `grep "默认角色.*qa-lead" ai-tools-bridge/skills/sdd-test-code/SKILL.md`

### Task 4.8: 为 `sdd-verify` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-verify/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `qa-lead`
  **可选角色**: `cso`, `sre`
  ```
- **运行验证通过**: `grep "默认角色.*qa-lead" ai-tools-bridge/skills/sdd-verify/SKILL.md`

### Task 4.9: 为 `sdd-ship` 添加角色加载逻辑 [spec:role-system#SC-03]

- **文件**: `ai-tools-bridge/skills/sdd-ship/SKILL.md` (Modify)
- **RED**: 验证不包含角色加载逻辑
- **GREEN**: 添加角色加载步骤
  ```markdown
  ### 0.5 角色加载

  **默认角色**: `release-engineer`
  **可选角色**: `sre`
  ```
- **运行验证通过**: `grep "默认角色.*release-engineer" ai-tools-bridge/skills/sdd-ship/SKILL.md`

--- checkpoint ---

**批次 3 完成。包含 9 个任务。**

依赖说明：
- 依赖批次 2 的角色定义文件
- 批次 5 的优先级合并逻辑需要在 action 中集成

---

## 批次 4/5：角色切换命令与参数支持

<!-- 依赖：批次 2 的角色定义文件 -->
<!-- 任务范围：5.1-5.5, 6.1-6.2 -->

### Task 5.1: 创建 `.claude/commands/sdd-role.md` 命令定义 [spec:role-command#SC-01]

- **文件**: `.claude/commands/sdd-role.md` (Create)
- **RED**: 验证文件不存在
  ```bash
  test ! -f .claude/commands/sdd-role.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 创建命令定义
  ```markdown
  # sdd-role — 角色显示与切换

  显示当前角色或切换会话级角色。

  ## 使用方式

  - `/sdd-role` — 显示当前角色信息
  - `/sdd-role <name>` — 切换当前会话角色
  - `/sdd-role --list` — 列出所有可用角色

  ## 执行逻辑

  ### 显示当前角色（无参数）

  1. 获取当前会话角色（默认为上次切换的角色或系统默认）
  2. 加载角色定义
  3. 输出：
     ```
     当前角色: <name>
     来源: <builtin|project|user>
     身份: <角色身份描述摘要>
     ```

  ### 切换角色（有参数）

  1. 解析角色名称，转换为小写
  2. 查找角色定义（按优先级：用户级 > 项目级 > 内置）
  3. 如果找到：设置会话级角色，输出确认
  4. 如果未找到：输出错误，列出可用角色

  ### 列出角色（--list）

  1. 扫描所有角色定义源
  2. 按分类输出角色列表
  ```
- **运行验证通过**: `test -f .claude/commands/sdd-role.md`

### Task 5.2: 实现显示当前角色功能 [spec:role-command#SC-01]

- **文件**: `.claude/commands/sdd-role.md` (Modify)
- **RED**: 验证命令不包含显示逻辑
  ```bash
  ! grep -q "显示当前角色" .claude/commands/sdd-role.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 完善显示逻辑细节
  ```markdown
  ### 显示当前角色（无参数）实现细节

  输出格式：

  ```
  当前角色: <name>
  来源: builtin / project / user
  身份: <角色身份的第一句话>

  可用 action: <trigger 列表>
  ```

  示例输出：

  ```
  当前角色: staff-engineer
  来源: builtin
  身份: 你是一名 Staff Engineer，负责代码审查和质量把关

  可用 action: sdd-review-code, sdd-test-code
  ```
  ```
- **运行验证通过**: `grep "当前角色:" .claude/commands/sdd-role.md`

### Task 5.3: 实现切换角色功能 [spec:role-command#SC-02]

- **文件**: `.claude/commands/sdd-role.md` (Modify)
- **RED**: 验证命令不包含切换逻辑
- **GREEN**: 完善切换逻辑细节
  ```markdown
  ### 切换角色（有参数）实现细节

  流程：

  1. 参数解析：
     - 将角色名称转换为小写
     - 验证格式：仅允许小写字母、数字、连字符

  2. 角色查找：
     - 优先级顺序：`~/.claude/roles/` > `openspec/roles/` > `ai-tools-bridge/roles/`
     - 在各目录下查找 `<name>.md` 文件

  3. 成功处理：
     - 设置环境变量或内存状态记录当前角色
     - 输出：`角色已切换为 <name>（来源: <source>）`

  4. 失败处理：
     - 输出：`角色 '<name>' 不存在`
     - 输出可用角色列表
     - 当前角色不变

  示例：

  ```
  /sdd-role ceo
  → 角色已切换为 ceo（来源: builtin）

  /sdd-role invalid-role
  → 角色 'invalid-role' 不存在
  → 可用角色：yc-office-hours, ceo, eng-manager, designer, developer, staff-engineer, qa-lead, cso, release-engineer, sre
  ```
  ```
- **运行验证通过**: `grep "角色已切换为" .claude/commands/sdd-role.md`

### Task 5.4: 实现列出所有角色功能 [spec:role-command#SC-04]

- **文件**: `.claude/commands/sdd-role.md` (Modify)
- **RED**: 验证命令不包含列表逻辑
- **GREEN**: 完善列表逻辑细节
  ```markdown
  ### 列出角色（--list）实现细节

  扫描路径：
  - 内置：`ai-tools-bridge/roles/planning/`, `execution/`, `review/`, `release/`
  - 项目级：`openspec/roles/`（如存在）
  - 用户级：`~/.claude/roles/`（如存在）

  输出格式（按分类）：

  ```
  === 内置角色 ===

  Planning:
    - yc-office-hours
    - ceo
    - eng-manager
    - designer

  Execution:
    - developer

  Review:
    - staff-engineer
    - qa-lead
    - cso

  Release:
    - release-engineer
    - sre

  === 项目级角色 ===（如有）
    - <角色列表>

  === 用户级角色 ===（如有）
    - <角色列表>
  ```
  ```
- **运行验证通过**: `grep "\-\-list" .claude/commands/sdd-role.md`

### Task 5.5: 实现角色不存在时的错误处理 [spec:role-command#SC-03]

- **文件**: `.claude/commands/sdd-role.md` (Modify)
- **RED**: 验证命令不包含错误处理逻辑
- **GREEN**: 完善错误处理细节
  ```markdown
  ### 错误处理

  | 场景 | 处理 |
  |------|------|
  | 角色不存在 | 输出错误信息 + 可用角色列表 |
  | 角色名称格式错误 | 提示：仅允许小写字母、数字、连字符 |
  | 角色定义文件损坏 | 提示格式要求，降级到默认角色 |

  输出模板：

  ```
  ⚠️ 角色 '<name>' 不存在

  可用角色（按分类）：
  Planning: yc-office-hours, ceo, eng-manager, designer
  Execution: developer
  Review: staff-engineer, qa-lead, cso
  Release: release-engineer, sre

  使用方式: /sdd-role <name>
  ```
  ```
- **运行验证通过**: `grep "角色不存在" .claude/commands/sdd-role.md`

### Task 6.1: 实现 `--role` 参数解析 [spec:role-system#SC-04]

- **文件**: `ai-tools-bridge/skills/sdd-*/SKILL.md` (Modify — 多文件)
- **RED**: 验证 SKILL.md 不包含参数解析逻辑
  ```bash
  ! grep -q "\-\-role" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 在所有 SDD action 的前置逻辑中添加参数解析
  ```markdown
  ### 0.3 参数解析

  检查命令是否包含 `--role <name>` 参数：

  - 如果存在：
    1. 提取角色名称
    2. 转换为小写
    3. 验证格式（小写字母、数字、连字符）
    4. 设置参数级角色覆盖

  - 如果不存在：
    - 继续检查会话级角色

  参数优先级高于会话级角色。
  ```
- **运行验证通过**: `grep "\-\-role" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

### Task 6.2: 实现参数优先级高于会话级角色 [spec:role-command#边界条件]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify — 作为示例)
- **RED**: 验证不包含优先级说明
- **GREEN**: 明确优先级规则
  ```markdown
  ### 角色优先级规则

  优先级顺序（从高到低）：

  1. `--role` 参数（一次性，仅当前 action）
  2. `/sdd-role` 设置的会话级角色（会话级，持续到切换或会话结束）
  3. action 默认角色

  示例：

  ```
  /sdd-role ceo           # 会话级切换为 ceo
  /sdd-review-code --role cso  # 本次 action 使用 cso，下次仍为 ceo
  /sdd-review-code        # 使用会话级角色 ceo
  ```
  ```
- **运行验证通过**: `grep "优先级顺序" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

--- checkpoint ---

**批次 4 完成。包含 7 个任务。**

依赖说明：
- 依赖批次 2 的角色定义文件
- 批次 5 将实现角色查找和合并的具体逻辑

---

## 批次 5/5：角色优先级合并（核心逻辑）

<!-- 依赖：批次 2 的角色定义，批次 3、4 的集成点 -->
<!-- 任务范围：7.1-7.4 -->

### Task 7.1: 实现角色文件查找逻辑（三层源） [spec:role-system#SC-05]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify — 作为主实现参考)
- **RED**: 验证不包含三层查找逻辑
  ```bash
  ! grep -q "三层源" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md && echo "PASS" || echo "FAIL"
  ```
- **GREEN**: 添加角色查找逻辑
  ```markdown
  ### 角色文件查找

  按以下顺序查找角色定义文件：

  1. **用户级**：`~/.claude/roles/<name>.md`
  2. **项目级**：`openspec/roles/<name>.md`
  3. **内置**：`ai-tools-bridge/roles/{planning,execution,review,release}/<name>.md`

  查找流程：

  ```
  function findRole(name):
    sources = [
      ("user", "~/.claude/roles/"),
      ("project", "openspec/roles/"),
      ("builtin", "ai-tools-bridge/roles/")
    ]

    for (sourceType, path) in sources:
      files = glob("${path}/**/*.md")
      for file in files:
        if file.endsWith("/${name}.md"):
          return { source: sourceType, path: file }

    return null  # 角色不存在
  ```

  返回第一个匹配的角色文件，同时记录来源类型。
  ```
- **运行验证通过**: `grep "三层源" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

### Task 7.2: 实现优先级合并规则 [spec:role-system#SC-05]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 验证不包含合并规则
- **GREEN**: 添加合并规则说明
  ```markdown
  ### 优先级合并规则

  **优先级**：用户级 > 项目级 > 内置

  **合并策略**：

  - 找到第一个匹配即停止查找（不合并多个源）
  - 高优先级源的角色完全覆盖低优先级源的同名角色
  - 不同名角色可共存（用户可添加自定义角色）

  **冲突处理**：

  当检测到同一角色在多个源中存在时：

  ```
  ⚠️ 角色 'ceo' 存在于多个源：
    - 用户级：~/.claude/roles/ceo.md
    - 内置：ai-tools-bridge/roles/planning/ceo.md

  使用优先级最高的源：用户级
  ```

  **实现要点**：

  - 查找时按优先级顺序遍历
  - 找到后立即返回，不继续查找低优先级源
  - 记录角色来源用于显示和审计
  ```
- **运行验证通过**: `grep "优先级合并规则" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

### Task 7.3: 实现角色文件缺失降级 [spec:role-system#SC-06]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 验证不包含降级逻辑
- **GREEN**: 添加降级处理逻辑
  ```markdown
  ### 角色文件缺失降级

  当请求的角色在所有源中都不存在时：

  **处理流程**：

  1. 输出警告：
     ```
     ⚠️ 角色 '<name>' 不存在，降级到默认角色 '<default-role>'
     ```

  2. 获取当前 action 的默认角色

  3. 使用默认角色继续执行

  4. 不阻断 action 执行

  **降级记录**：

  在 review 文件头部添加：

  ```markdown
  > ⚠️ 角色降级: '<requested-role>' 不存在，已使用默认角色 '<default-role>'
  ```

  **示例**：

  ```
  /sdd-review-code --role invalid

  → ⚠️ 角色 'invalid' 不存在，降级到默认角色 'staff-engineer'
  → 可用角色：yc-office-hours, ceo, eng-manager, designer, developer, staff-engineer, qa-lead, cso, release-engineer, sre
  → 继续执行 sdd-review-code（使用 staff-engineer 角色）
  ```
  ```
- **运行验证通过**: `grep "降级到默认角色" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

### Task 7.4: 实现角色格式错误处理 [spec:role-system#SC-07]

- **文件**: `ai-tools-bridge/skills/sdd-brainstorm/SKILL.md` (Modify)
- **RED**: 验证不包含格式错误处理
- **GREEN**: 添加格式错误处理逻辑
  ```markdown
  ### 角色定义格式错误处理

  角色定义文件必须包含以下要素：

  **必需字段**：
  - YAML frontmatter 中的 `name` 字段
  - `# 角色` 节

  **可选字段**：
  - YAML frontmatter 中的 `trigger` 字段
  - `# 专业视角`、`# 强制问题`、`# 输出格式` 节

  **格式校验流程**：

  1. 解析 YAML frontmatter
  2. 验证 `name` 字段存在且非空
  3. 验证文档包含 `# 角色` 节

  **错误处理**：

  | 错误类型 | 处理 |
  |----------|------|
  | YAML 解析失败 | 输出错误位置，降级到默认角色 |
  | 缺少 `name` 字段 | 提示"角色定义缺少 name 字段"，降级 |
  | 缺少 `# 角色` 节 | 提示"角色定义缺少身份描述"，降级 |
  | 未知字段 | 忽略，不报错 |

  **错误输出示例**：

  ```
  ⚠️ 角色定义格式错误：~/.claude/roles/my-role.md

  错误：缺少必需字段 'name'

  格式要求：
  ---
  name: <角色名称>
  trigger: <可选，action 列表>
  ---

  # 角色
  <角色身份描述>

  # 专业视角
  <视角列表>

  # 强制问题
  1. <问题>
  ...

  # 输出格式
  ## <输出节>
  ---

  降级到默认角色 '<default-role>'
  ```
  ```
- **运行验证通过**: `grep "格式错误处理" ai-tools-bridge/skills/sdd-brainstorm/SKILL.md`

--- checkpoint ---

**批次 5 完成。包含 4 个任务。**

---

## 完成总结

**计划统计**：
- 总批次数：5
- 总任务数：37
- 预估总工时：约 2-3 小时

**执行顺序**：
1. 批次 1 → 批次 2 → 批次 3 → 批次 4 → 批次 5
2. 批次 3 和 4 可并行执行（均只依赖批次 2）

**风险点**：
- 角色定义文件需要手动编写，确保格式正确
- SDD action 修改需保持一致性
- 测试验证命令需根据实际环境调整

**验证命令汇总**：
```bash
# 验证所有角色定义文件存在
ls ai-tools-bridge/roles/planning/*.md ai-tools-bridge/roles/execution/*.md ai-tools-bridge/roles/review/*.md ai-tools-bridge/roles/release/*.md

# 验证 SKILL.md 包含角色加载逻辑
grep -l "角色加载" ai-tools-bridge/skills/sdd-*/SKILL.md

# 验证 sdd-role 命令存在
test -f .claude/commands/sdd-role.md
```

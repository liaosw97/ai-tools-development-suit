## ADDED Requirements

### Requirement: SDD post-logic displays flow guidance after OPSX command execution

After any SDD action that invokes an OPSX command completes, the SDD post-logic SHALL display a clear flow guidance section that directs users to the next SDD action.

**Affected actions**（调用 OPSX 命令的 6 个 action）：
- sdd-propose（调用 `/opsx:propose` 或 `/opsx:continue`）
- sdd-continue（调用 `/opsx:continue`）
- sdd-ff（调用 `/opsx:ff`）
- sdd-verify（调用 `/opsx:verify`）
- sdd-ship（调用 `/opsx:sync` + `/opsx:archive`）
- sdd-quick（调用 `/opsx:continue`）

**不涉及的 action**（不调用 OPSX，无需添加流程指引）：
- sdd-brainstorm、sdd-plan、sdd-code、sdd-review-spec、sdd-review-code、sdd-test-code、sdd-doctor

**与 brainstorm 验收标准的映射**：
- 验收标准 1（主流程无泄露）→ 本 Requirement 所有场景
- 验收标准 2（SDD 引导可见）→ Requirement 2 的 Visual separator format 场景
- 验收标准 3（误操作可恢复）→ Requirement 5 的错误路径场景

#### Scenario: User completes sdd-propose and sees SDD flow guidance

- **GIVEN** 用户执行 `/sdd-propose` 命令
- **WHEN** sdd-propose 调用 `/opsx:propose` 或 `/opsx:continue` 完成，proposal.md 已生成
- **THEN** 系统在输出末尾显示 SDD 流程指引，格式如下：
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SDD 流程指引（请忽略上方可能显示的 OPSX 建议）
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  推荐下一步:
    1. ★ /sdd-ff — 快进生成所有文档
    2. ○ /sdd-continue — 逐步确认细节
    3. △ /sdd-brainstorm — 回退补充探索
  ```

#### Scenario: User completes sdd-ff and sees SDD flow guidance

- **GIVEN** 用户执行 `/sdd-ff` 命令
- **WHEN** sdd-ff 调用 `/opsx:ff` 完成，specs/、design.md、tasks.md 已生成
- **THEN** 系统在输出末尾显示 SDD 流程指引，格式如下：
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SDD 流程指引（请忽略上方可能显示的 OPSX 建议）
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  推荐下一步:
    1. ★ /sdd-plan — 生成实施计划
    2. ○ /sdd-review-spec — 先审查 spec 质量
  ```

#### Scenario: User completes sdd-continue and sees SDD flow guidance

- **GIVEN** 用户执行 `/sdd-continue` 命令
- **WHEN** sdd-continue 调用 `/opsx:continue` 完成，下一个 artifact 已生成
- **THEN** 系统在输出末尾显示 SDD 流程指引，格式如下：
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SDD 流程指引（请忽略上方可能显示的 OPSX 建议）
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  推荐下一步:
    1. ★ /sdd-continue — 继续下一个 artifact
    2. ○ /sdd-ff — 快进生成所有剩余
  ```

#### Scenario: User completes sdd-verify and sees SDD flow guidance

- **GIVEN** 用户执行 `/sdd-verify` 命令
- **WHEN** sdd-verify 调用 `/opsx:verify` 完成，验证报告已生成
- **THEN** 系统在输出末尾显示 SDD 流程指引，格式如下：
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SDD 流程指引（请忽略上方可能显示的 OPSX 建议）
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  推荐下一步:
    1. ★ /sdd-ship — 归档合并
    2. ○ /sdd-code — 修复问题
  ```

#### Scenario: User completes sdd-ship and sees SDD flow guidance

- **GIVEN** 用户执行 `/sdd-ship` 命令
- **WHEN** sdd-ship 调用 `/opsx:sync` 和 `/opsx:archive` 完成，变更已归档
- **THEN** 系统在输出末尾显示 SDD 流程指引，格式如下：
  ```
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SDD 流程指引
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  流程完成，变更已归档。
  ```

#### Scenario: User completes sdd-quick with all artifacts generated

- **GIVEN** 用户执行 `/sdd-quick` 命令
- **WHEN** sdd-quick 调用 `/opsx:continue` 完成，所有 artifact 和代码已生成
- **THEN** 系统在输出末尾显示 SDD 流程指引，推荐下一步为 `/sdd-ship`

#### Scenario: User completes sdd-quick with incomplete implementation

- **GIVEN** 用户执行 `/sdd-quick` 命令
- **WHEN** sdd-quick 调用 `/opsx:continue` 完成，但代码实现不完整
- **THEN** 系统在输出末尾显示 SDD 流程指引，提示流程完成但建议执行 `/sdd-ship` 前先验证实现

### Requirement: SDD flow guidance uses consistent format with visual separators

The SDD flow guidance section SHALL use a consistent format across all 6 affected SDD actions with visual separators to distinguish it from OPSX output.

#### Scenario: Visual separator format

- **GIVEN** SDD 后置逻辑需要显示流程指引
- **WHEN** 系统输出 SDD 流程指引
- **THEN** 指引使用 `━━━` 水平线作为上下边框
- **AND** 指引包含明确文字"请忽略上方可能显示的 OPSX 建议"
- **AND** 指引使用 ★○△ 标记区分操作优先级：
  - ★ = 推荐操作（流程中的下一步）
  - ○ = 可选操作（替代路径）
  - △ = 回退操作（回到之前的步骤）

### Requirement: SDD flow guidance adapts to current action context

Each SDD action SHALL display context-appropriate next actions based on the current position in the SDD workflow.

#### Scenario: Post-propose guidance shows document generation options

- **GIVEN** sdd-propose 刚刚完成
- **WHEN** 系统显示流程指引
- **THEN** 推荐下一步聚焦于文档生成（sdd-ff、sdd-continue）

#### Scenario: Post-ship guidance shows completion message

- **GIVEN** sdd-ship 刚刚完成
- **WHEN** 系统显示流程指引
- **THEN** 指引提示流程完成，不推荐后续操作

### Requirement: SDD post-logic handles OPSX command failures gracefully

When an OPSX command fails or produces an error, the SDD post-logic SHALL still display flow guidance to help users recover.

#### Scenario: OPSX command fails during sdd-propose

- **GIVEN** 用户执行 `/sdd-propose` 命令
- **WHEN** sdd-propose 调用 `/opsx:propose` 失败（如 openspec 命令不可用）
- **THEN** 系统显示错误信息
- **AND** 系统在输出末尾显示 SDD 流程指引，建议用户检查环境后重试

#### Scenario: User accidentally executed OPSX command directly

- **GIVEN** 用户直接执行了 `/opsx:apply`（跳过了 SDD 流程）
- **WHEN** 用户意识到误操作
- **THEN** 用户可以通过执行 `/sdd-continue` 或 `/sdd-ff` 回到 SDD 流程
- **AND** OPSX 生成的 artifact 与 SDD 兼容（都使用 openspec/changes/<name>/ 目录）

### Requirement: Documentation explains SDD flow independence

The project documentation (CLAUDE.md and README.md) SHALL explain that SDD flow is an independent orchestration layer and OPSX suggestions should be ignored when using SDD.

#### Scenario: CLAUDE.md contains SDD flow explanation

- **GIVEN** 用户阅读 CLAUDE.md
- **WHEN** 查看 SDD 流程相关章节
- **THEN** 文档包含标题为"SDD 流程独立性"的段落
- **AND** 该段落说明"SDD 流程是独立的编排层，使用 SDD 时应忽略 OPSX 的建议"
- **AND** 文档包含标题为"误操作恢复"的段落，说明用户误执行 OPSX 命令后如何通过 `/sdd-continue` 回到 SDD 流程

#### Scenario: README.md contains SDD vs OPSX usage guidance

- **GIVEN** 用户阅读 README.md
- **WHEN** 查看使用指南章节
- **THEN** 文档包含"SDD 流程 vs OPSX 命令"的对比说明
- **AND** 说明"SDD 流程适合完整的开发周期，OPSX 命令适合独立使用 OpenSpec"

## ADDED Requirements

### Requirement: 精度验证测试范围

系统 SHALL 选择 3 个典型变更进行精度验证。

#### Scenario: 简单变更验证
- **GIVEN** 需要执行精度验证
- **WHEN** 选择测试变更
- **THEN** 系统选择 1-2 个 spec 场景、≤5 个 tasks 的简单变更

#### Scenario: 中等变更验证
- **GIVEN** 需要执行精度验证
- **WHEN** 选择测试变更
- **THEN** 系统选择 4-6 个 spec 场景、6-15 个 tasks 的中等变更

#### Scenario: 复杂变更验证
- **GIVEN** 需要执行精度验证
- **WHEN** 选择测试变更
- **THEN** 系统选择 >8 个 spec 场景、>15 个 tasks 的复杂变更

### Requirement: 精度对比方法

系统 SHALL 对比优化前后的输出质量。

#### Scenario: 优化前基线
- **GIVEN** 已选择 3 个典型变更
- **WHEN** 执行精度验证
- **THEN** 系统使用当前版本执行变更，记录以下指标：
  - Token 消耗（峰值 + 总量）
  - brainstorm 方案数量和质量评分
  - spec 场景覆盖度
  - review 发现的问题数量
  - 代码质量和测试覆盖率

#### Scenario: 优化后对比
- **GIVEN** 已完成优化前基线测试
- **WHEN** 执行精度验证
- **THEN** 系统使用优化版本执行变更，记录相同指标

#### Scenario: 差异计算
- **GIVEN** 已完成优化前后测试
- **WHEN** 完成优化前后测试
- **THEN** 系统计算 token 消耗和输出质量的差异，生成对比报告

### Requirement: 精度验证通过标准

系统 SHALL 定义明确的精度验证通过标准。

#### Scenario: 验证通过
- **GIVEN** 精度验证已完成所有测试用例执行
- **WHEN** 峰值 token 消耗降低 ≥30% 且总消耗降低 ≥35% 且无 critical 问题
- **THEN** 系统标记精度验证通过，输出验证报告

#### Scenario: 验证需人工评估
- **GIVEN** 精度验证已完成所有测试用例执行
- **WHEN** 峰值 token 消耗降低在 15%-30% 之间 或 总消耗降低在 20%-35% 之间（且无关键信息丢失）
- **THEN** 系统标记精度验证为 NEEDS_REVIEW，输出详细对比报告（含各指标明细和趋势分析），供人工决策是否通过

#### Scenario: 验证失败
- **GIVEN** 精度验证已完成所有测试用例执行
- **WHEN** 峰值 token 消耗降低 <15% 或总消耗降低 <20% 或发现关键信息丢失
- **THEN** 系统标记精度验证失败，输出回滚建议（含回滚范围和命令），等待用户确认后执行

### Requirement: 回滚策略

系统 SHALL 提供分阶段回滚机制。

#### Scenario: 懒加载回滚
- **GIVEN** 精度验证失败，需要回滚懒加载
- **WHEN** 用户确认回滚懒加载
- **THEN** 系统恢复原始 skill 文件结构，删除拆分后的模块文件

#### Scenario: 上下文压缩回滚
- **GIVEN** 精度验证失败，需要回滚上下文压缩
- **WHEN** 用户确认回滚上下文压缩
- **THEN** 系统恢复完整 artifact 传递，删除摘要生成逻辑

#### Scenario: 全量回滚
- **GIVEN** 精度验证失败，需要全量回滚
- **WHEN** 用户确认全量回滚
- **THEN** 系统执行 git revert 到优化前的 commit

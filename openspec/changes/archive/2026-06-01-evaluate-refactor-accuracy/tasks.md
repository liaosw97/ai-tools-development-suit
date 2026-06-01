# Tasks: evaluate-refactor-accuracy

> 任务清单 — 评估 ai-tools-bridge 重构后的准确度损失

---

## 任务

- [x] 1.1 执行静态 Diff 分析，获取重构前后的 skill 变更 [spec:accuracy-evaluation#静态-Diff-分析]
- [x] 1.2 按模块分组检查：核心流程、子模块、角色系统 [spec:accuracy-evaluation#静态-Diff-分析]
- [x] 1.3 使用检查清单验证：关键函数、配置项、错误处理、输出格式 [spec:accuracy-evaluation#静态-Diff-分析]
- [x] 1.4 产出变更清单：识别丢失/变更的逻辑 [spec:accuracy-evaluation#静态-Diff-分析]
- [x] 2.1 前置验证：检查现有测试覆盖范围 [spec:accuracy-evaluation#精度测试验证]
- [x] 2.2 运行精度测试：执行 `pnpm test` [spec:accuracy-evaluation#精度测试验证]
- [x] 2.3 分析测试结果：检查通过率和覆盖率指标 [spec:accuracy-evaluation#精度测试验证]
- [x] 2.4 产出精度报告：信息保留率 ≥ 95% [spec:accuracy-evaluation#精度测试验证]
- [x] 3.1 准备简单变更场景：从 `tests/fixtures/precision/simple-change/` 获取数据 [spec:accuracy-evaluation#场景走查-简单变更]
- [x] 3.2 模拟简单变更 SDD 流程：sdd-brainstorm → sdd-propose → sdd-plan [spec:accuracy-evaluation#场景走查-简单变更]
- [x] 3.3 验证简单变更端到端流程：无阻塞问题 [spec:accuracy-evaluation#场景走查-简单变更]
- [x] 4.1 准备复杂变更场景：从 `tests/fixtures/precision/complex-change/` 获取数据 [spec:accuracy-evaluation#场景走查-复杂变更]
- [x] 4.2 模拟复杂变更 SDD 流程：sdd-brainstorm → sdd-propose → sdd-plan [spec:accuracy-evaluation#场景走查-复杂变更]
- [x] 4.3 验证复杂变更端到端流程：无阻塞问题，跨模块协调正常 [spec:accuracy-evaluation#场景走查-复杂变更]
- [x] 5.1 汇总评估结果：变更清单、精度报告、场景走查结果 [spec:accuracy-evaluation#静态-Diff-分析]
- [x] 5.2 产出评估结论：准确度是否有损失 [spec:accuracy-evaluation#精度测试验证]

<!-- 格式说明:
  - checkbox 格式（- [ ] 待完成，- [x] 已完成）
  - 每个任务必须链接到 spec 场景: [spec:domain#scenario]
  - 任务粒度: spec requirement 级（比 plan 更粗）
-->

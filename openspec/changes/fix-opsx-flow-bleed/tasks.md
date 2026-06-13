## 1. SDD 后置逻辑模板设计

- [x] 1.1 设计统一的 SDD 流程指引模板格式（含 `━━━` 分隔线和 ★○△ 标记）
- [x] 1.2 为 6 个调用 OPSX 的 SDD action 定义下一步建议内容

## 2. 修改调用 OPSX 的 SDD action 后置逻辑

- [x] 2.1 修改 `sdd-propose/SKILL.md` — 添加 SDD 流程指引
- [x] 2.2 修改 `sdd-continue/SKILL.md` — 添加 SDD 流程指引
- [x] 2.3 修改 `sdd-ff/SKILL.md` — 添加 SDD 流程指引
- [x] 2.4 修改 `sdd-verify/SKILL.md` — 添加 SDD 流程指引
- [x] 2.5 修改 `sdd-ship/SKILL.md` — 添加 SDD 流程指引
- [x] 2.6 修改 `sdd-quick/SKILL.md` — 添加 SDD 流程指引
- [x] 2.7 修改 `sdd-propose/SKILL.md` — 添加 OPSX 失败容错

## 3. 更新项目文档

- [x] 3.1 更新 `CLAUDE.md` — 添加 SDD 流程独立性说明和误操作恢复指南
- [x] 3.2 更新 `README.md` — 添加 SDD vs OPSX 使用指南

## 4. 验证

- [x] 4.1 运行现有测试确保格式正确性
- [x] 4.2 手动测试 `/sdd-propose` 流程验证 SDD 流程指引显示正确
- [x] 4.3 验证 6 个 SKILL.md 的一致性

## 5. 代码审查修复

- [x] 5.1 修复 sdd-quick 流程指引 — 区分"完整实现"和"达限中断"两种场景
- [x] 5.2 修复 sdd-verify 流程指引 — 添加 `/sdd-test-code` 选项

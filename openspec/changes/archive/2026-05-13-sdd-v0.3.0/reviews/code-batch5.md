# Code Quality Review — Batch 5

> 审查范围：Task 4.1-4.7（sdd-doctor 复杂度评估与路径推荐）
> 变更文件：`skills/sdd-doctor/SKILL.md`（+81/-9 行）, `tests/l1-structural/sdd-doctor-schema.test.ts`（+117 行）

## 审查结果

| 严重性 | 数量 |
|--------|------|
| Critical | 0 |
| Major | 0 |
| Minor | 3 |

## Minor Issues

### M1: YAML description 未同步更新

**文件**: `skills/sdd-doctor/SKILL.md` L4
**现状**: description 仍为 `"环境诊断 — 检查 OpenSpec、Superpowers 安装状态和 change 进度，输出诊断报告"`
**问题**: 新增了复杂度评估和路径推荐能力，但 description 未反映
**建议**: 更新为 `"环境诊断 — 检查工具状态、评估变更复杂度、推荐工作流路径"`

### M2: 报告模板缺少"无 spec/tasks"示例

**文件**: `skills/sdd-doctor/SKILL.md` L73-97
**现状**: 步骤 4 报告模板仅展示了"有评级"和"无活跃变更"两种情况
**问题**: 缺少"有 change 但无 spec/tasks"的报告示例，AI 执行时可能不确定输出格式
**建议**: 在报告模板中增加第三种示例：
```
  early-stage-wip/
    ✅ brainstorm.md  ❌ proposal.md
    ❌ specs/         ❌ tasks.md
    → 建议: 运行 /sdd-propose 创建提案
```

### M3: 测试字符串匹配粒度偏粗

**文件**: `tests/l1-structural/sdd-doctor-schema.test.ts` L103-107
**现状**: 复杂(L)推荐测试检查 `brainstorm`, `propose`, `review`, `verify`, `ship` 等通用词
**问题**: 这些词在文档其他位置也出现（如步骤 3a、步骤 6），测试实际验证的是"文档包含这些词"而非"复杂(L)推荐段包含这些词"
**建议**: 当前对结构验证可接受，如需增强可使用正则匹配 `复杂.*brainstorm.*propose.*ship` 等上下文相关断言

## 正面观察

- SKILL.md 结构清晰，3a/3b/3c 子段落层次分明
- 五维度表格和评级表格直接对应 spec，无歧义
- 路径推荐三级区分明确，每级有独特的 ★○△ 内容
- 测试文件遵循项目约定（一个 describe 块对应一个 task，注释标注 task 编号）
- 完成引导遵循 ★○△ 统一格式

## 行动建议

3 个 Minor issue 均为改善性建议，不阻断继续实施下一批次。可在批次 7（文档/推荐操作）集中修复。

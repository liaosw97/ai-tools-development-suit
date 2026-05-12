# Brainstorm Review — Round 1

**审查对象:** brainstorm.md
**日期:** 2026-05-12

## 总结

brainstorm.md 对 "在 ai-tools/ 目录新增 skills 子模块" 这一需求进行了清晰的方案探索和决策记录。文档结构完整，方案比较合理，关键决策均有明确的结论和被否决的替代方案。但存在一个事实性错误（技能计数）、一处与现有代码不符的假设（sync-upstream.sh 的复用方式），以及约束识别部分遗漏了影响实施的关键约束。

## Issues

### [severity: major] 技能计数不准确
- **位置:** brainstorm.md §需求描述
- **描述:** 文档声称 skills 仓库 "包含 17 个面向 AI 编码代理的工程实践技能"，分类为 Engineering（10 个）、Productivity（4 个）、Misc（4 个）。但根据上游 mattpocock/skills 仓库 README，Engineering 类别实际包含 10 个技能（diagnose, grill-with-docs, triage, improve-codebase-architecture, setup-matt-pocock-skills, tdd, to-issues, to-prd, zoom-out, prototype），Productivity 包含 4 个，Misc 包含 4 个，总计应为 18 个。如果 liaosw97 的 fork 有所删减，应说明具体删减了哪些技能及原因；如果未删减，则计数有误。
- **建议:** 核实 liaosw97/skills fork 的实际内容，更新准确的技能计数和分类。如果 fork 中确实只有 17 个，需注明与上游的差异。

### [severity: major] sync-upstream.sh 复用声明不准确
- **位置:** brainstorm.md §方案 A 优点 & §约束识别
- **描述:** 方案 A 声称 "可通过 `scripts/sync-upstream.sh` 统一同步"，约束识别中提到 "需要更新 `scripts/sync-upstream.sh` 以支持同步新子模块"。实际上 sync-upstream.sh 中的 `SUBMODULES` 数组是硬编码的，仅包含 openspec、superpowers、ai-tools-bridge 三个子项目。新增 skills 后确实需要修改该脚本，但这意味着并非简单的"统一同步"，而是需要代码变更。文档对此的表述前后矛盾——先说可以"复用"，后说需要"更新"。
- **建议:** 将方案 A 优点中的 "可通过 `scripts/sync-upstream.sh` 统一同步" 改为 "sync-upstream.sh 已有子模块同步框架，新增 skills 只需在 SUBMODULES 数组中添加一行配置"。同时将 sync-upstream.sh 的修改从"约束"移到具体实施任务中。

### [severity: minor] 缺少 .gitmodules 文件变更的约束说明
- **位置:** brainstorm.md §约束识别
- **描述:** 新增 Git Submodule 会修改 `.gitmodules` 文件和 `.git/config`，且 git submodule add 命令需要在主仓库根目录执行。这些是基本的技术操作约束，但文档未提及。
- **建议:** 在技术约束中补充：".gitmodules 文件将被修改，需确保 submodule add 在主仓库根目录执行"。

### [severity: minor] 未识别 skills 与 superpowers 的功能重叠清单
- **位置:** brainstorm.md §决策 4 技能重叠处理
- **描述:** 决策 4 选择"不处理重叠，两套技能系统独立运行"，理由中提到了 "superpowers 的 TDD/brainstorming" 和 "mattpocock 的 tdd/grill-me"，但未给出完整的重叠清单。上游 skills 中的 `tdd`、`grill-me`/`grill-with-docs`（对应 superpowers 的 brainstorming）、`diagnose`（对应 superpowers 的 systematic-debugging）、`write-a-skill`（对应 superpowers 的 writing-skills）等多个技能与 superpowers 存在功能重叠。缺少完整的重叠映射会导致后续使用者困惑。
- **建议:** 补充一个简要的重叠技能对照表，列出 mattpocock skills 中与 superpowers 功能相近的技能及其对应关系，方便用户选择。

### [severity: minor] 决策 3 中 installer 命令格式需核实
- **位置:** brainstorm.md §决策 3 技能安装方式
- **描述:** 文档提到 "不运行 `npx skills@latest add` installer"。但上游仓库的实际安装命令是 `npx skills@latest add mattpocock/skills`，需要指定仓库路径。如果 liaosw97/skills 是 fork，命令应为 `npx skills@latest add liaosw97/skills`。
- **建议:** 确认 installer 命令的准确格式，或简化为 "不运行 skills.sh installer" 以避免命令格式的精确性问题。

### [severity: minor] 缺少 CLAUDE.md 更新的具体范围说明
- **位置:** brainstorm.md §约束识别 > 团队约束
- **描述:** 提到 "需要更新 CLAUDE.md 项目文档以反映新增的子模块"，但未说明具体更新哪些部分。根据现有 CLAUDE.md 的结构，至少涉及：项目概述表格新增一行、架构说明中补充 skills 的定位、常用命令中补充 skills 相关说明（如果有）。
- **建议:** 补充 CLAUDE.md 更新的具体范围，至少列出项目概述表格和架构关系图两处需要变更的位置。

## Approved
- [x] 方案完整性
- [x] 决策清晰度
- [x] YAGNI
- [x] 可测试性
- [ ] 约束识别

## 结论
NEEDS_REVISION

主要修改项：
1. 核实并修正技能计数（当前 17 vs 上游 18）
2. 修正 sync-upstream.sh 的复用描述，消除前后矛盾
3. 补充 skills 与 superpowers 的功能重叠对照表

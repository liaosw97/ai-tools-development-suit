# Brainstorm: 文档更新 — OpenSpec 命令和 Skill 获取方式

## 需求描述

更新 ai-tools-bridge 的 README.md 和 CLAUDE.md，添加如何使用 OpenSpec 获取全部 OPSX 命令和 skill 的说明。

## 关键发现

### 当前文档缺失

README.md 和 CLAUDE.md 均未说明：
1. OPSX 扩展命令需要通过 `openspec config profile` 启用
2. OpenSpec 生成的 skill 定义需要 `openspec update` 命令
3. 核心命令 vs 扩展命令的区别
4. ai-tools-bridge SDD actions 与 OPSX 命令的映射关系

### 需要补充的内容

**README.md** 需要新增：
- 前置依赖部分：补充 OpenSpec 安装后的配置步骤（`openspec config profile` + `openspec update`）
- 委托关系表：更新为 OPSX 命令（已完成引用替换）
- 新增"OPSX 命令"节：说明 11 个命令的分组和启用方式

**CLAUDE.md** 需要更新：
- 13 个行动及其委托表：更新为 OPSX 命令
- 新增"OPSX 命令体系"节：说明命令分组、启用方式、与 SDD 的映射

## 关键决策

### 决策 1: 文档范围

仅更新 README.md 和 CLAUDE.md，不创建新文档文件。信息集中在现有文档中，避免文档分散。

### 决策 2: 更新策略

在现有文档结构中插入新内容，不重写已有部分。具体：
- README.md "前置依赖"节扩展
- README.md "委托关系"表更新
- CLAUDE.md "13 个行动及其委托"表更新
- 两个文件各新增一个"OPSX 命令"节

### 决策 3: 映射关系

SDD action → OPSX 命令的映射（基于已完成的引用替换）：

| SDD Action | OPSX 命令 |
|------------|----------|
| sdd-propose | `/opsx:propose` / `/opsx:continue` |
| sdd-continue | `/opsx:continue` |
| sdd-ff | `/opsx:ff` |
| sdd-verify | `/opsx:verify` |
| sdd-ship | `/opsx:sync` + `/opsx:archive` |
| sdd-quick | `/opsx:continue` |

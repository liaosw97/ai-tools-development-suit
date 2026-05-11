# AiTools

AI 工具集成项目 — 整合 OpenSpec、Superpowers、ai-tools-bridge，提供统一的规格驱动开发（SDD）工作流。

## 子项目

| 项目 | 描述 | 版本 | 管理方式 |
|------|------|------|----------|
| [OpenSpec](ai-tools/OpenSpec/) | 规格管理框架 CLI | v1.3.0 | Git Submodule |
| [Superpowers](ai-tools/superpowers/) | AI 编码代理技能系统 | v5.1.0 | Git Submodule |
| [ai-tools-bridge](ai-tools-bridge/) | SDD 工作流编排器 | v0.2.0 | Git Submodule |

## 快速开始

```bash
# 克隆项目（含子模块）
git clone --recursive https://github.com/liaosw97/AiTools.git

# 如果已经克隆但忘记 --recursive
git submodule update --init --recursive
```

## Submodule 操作

```bash
# 查看子模块状态
git submodule status

# 更新所有子模块到远程最新提交
git submodule update --remote

# 更新单个子模块
git submodule update --remote ai-tools/OpenSpec

# 在子模块内工作（先进入子模块目录）
cd ai-tools/OpenSpec
git checkout main
git pull
```

## 同步脚本

使用 `scripts/sync-upstream.sh` 自动将所有子项目同步到最新的 release tag：

```bash
# 同步所有子项目
bash scripts/sync-upstream.sh

# 仅同步指定子项目
bash scripts/sync-upstream.sh --only openspec
```

脚本功能：
- 自动 fetch 最新 tag
- 运行子项目测试验证兼容性
- 测试失败自动回滚
- 更新 `versions.lock` 版本快照

## 许可证

MIT

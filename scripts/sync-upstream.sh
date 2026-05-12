#!/usr/bin/env bash
set -euo pipefail

# sync-upstream.sh — 同步所有子项目到最新 release tag
# 用法:
#   bash scripts/sync-upstream.sh              # 同步所有
#   bash scripts/sync-upstream.sh --only openspec  # 仅同步指定子项目

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCK_FILE="$ROOT_DIR/versions.lock"
LOCK_BAK="$ROOT_DIR/versions.lock.bak"

# 子项目列表：名称=路径
declare -A SUBMODULES=(
  ["openspec"]="ai-tools/OpenSpec"
  ["superpowers"]="ai-tools/superpowers"
  ["ai-tools-bridge"]="ai-tools-bridge"
  ["skills"]="ai-tools/skills"
)

# 统计计数
success=0
skipped=0
failures=0

# 解析 --only 参数
filter_name=""
if [ "${1:-}" = "--only" ] && [ -n "${2:-}" ]; then
  filter_name="$2"
  if [ -z "${SUBMODULES[$filter_name]+x}" ]; then
    echo "错误: 未知子项目 '$filter_name'"
    echo "可选: ${!SUBMODULES[*]}"
    exit 1
  fi
elif [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  echo "用法: bash scripts/sync-upstream.sh [--only <name>]"
  echo ""
  echo "可选子项目: ${!SUBMODULES[*]}"
  exit 0
fi

# 同步前备份 versions.lock
if [ -f "$LOCK_FILE" ]; then
  cp "$LOCK_FILE" "$LOCK_BAK"
fi

# 获取最新 release tag（排除 pre-release）
get_latest_tag() {
  git tag -l | grep -v -E '(alpha|beta|rc|pre)' | sort -V | tail -1
}

# 运行子项目测试（如有）
run_tests() {
  local submodule_path="$1"
  if [ -f "$submodule_path/package.json" ] && grep -q '"test"' "$submodule_path/package.json"; then
    (cd "$submodule_path" && pnpm test) >/dev/null 2>&1
    return $?
  fi
  return 0
}

# 主循环
for name in "${!SUBMODULES[@]}"; do
  # --only 过滤
  if [ -n "$filter_name" ] && [ "$name" != "$filter_name" ]; then
    continue
  fi

  path="${SUBMODULES[$name]}"
  submodule_path="$ROOT_DIR/$path"

  echo "[$name] 正在处理..."

  # 进入子项目目录
  cd "$submodule_path"

  # 远程不可达处理
  if ! git fetch --tags 2>/dev/null; then
    echo "[$name] 远程仓库不可达，跳过"
    failures=$((failures + 1))
    cd "$ROOT_DIR"
    continue
  fi

  # 获取最新 release tag
  latest_tag=$(get_latest_tag)

  # 无 tag 场景
  if [ -z "$latest_tag" ]; then
    echo "[$name] 无可用 release tag，跳过"
    skipped=$((skipped + 1))
    cd "$ROOT_DIR"
    continue
  fi

  current_tag=$(git describe --tags --exact-match 2>/dev/null || echo "")

  # 已是最新
  if [ "$latest_tag" = "$current_tag" ]; then
    echo "[$name] ($current_tag) 已是最新"
    skipped=$((skipped + 1))
    cd "$ROOT_DIR"
    continue
  fi

  # checkout 最新 tag
  git checkout "$latest_tag" >/dev/null 2>&1

  # 运行测试
  if ! run_tests "$submodule_path"; then
    # 测试失败，回滚
    if [ -f "$LOCK_BAK" ]; then
      old_hash=$(grep "^$name=" "$LOCK_BAK" | awk -F= '{print $2}' | awk '{print $1}')
      if [ -n "$old_hash" ]; then
        git checkout "$old_hash" >/dev/null 2>&1
        echo "[$name] 测试失败，已回滚到 $old_hash"
      fi
    fi
    failures=$((failures + 1))
    cd "$ROOT_DIR"
    continue
  fi

  # 更新 versions.lock
  hash=$(git rev-parse --short HEAD)
  sed -i "s/^$name=.*/$name=$hash $latest_tag/" "$LOCK_FILE"
  echo "[$name] $current_tag → $latest_tag"
  success=$((success + 1))

  cd "$ROOT_DIR"
done

# 汇总报告
echo "---"
echo "汇总: $success 成功, $skipped 跳过, $failures 失败"

if [ $failures -eq ${#SUBMODULES[@]} ]; then
  exit 2  # 全部失败
elif [ $failures -gt 0 ]; then
  exit 1  # 部分失败
fi
exit 0  # 全部成功

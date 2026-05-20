# Spec: review-scanning

## 概述

review 阶段的规范扫描功能，根据变更类型动态检测并调用可用的质量/安全规范 skill。

---

## Scenario: skill 开发变更的代码审查扫描

GIVEN sdd-review-code 被执行
  AND Phase 1 spec 合规审查已通过
  AND git diff 中的变更文件包含 SKILL.md 或 skills/ 目录下的文件
WHEN 进入扫描阶段
THEN 标记工作类型为 "skill 开发"
  AND 调用 skill-craft-adapter:skill-check 对变更中的 skill 文件进行质量扫描
  AND 扫描结果写入 reviews/scan-r<N>.md
  AND 汇总中显示 "Phase 1.5 (规范扫描): SCANNED — skill 质量扫描完成"
  AND 如果发现问题，在报告中列出问题描述和建议修复方案
  AND 继续进入 Phase 2

## Scenario: 代码开发变更且存在可用规范 skill 的代码审查扫描

GIVEN sdd-review-code 被执行
  AND Phase 1 spec 合规审查已通过
  AND git diff 中的变更文件不包含 skill 相关文件
  AND 可用 skill 列表中存在描述含"代码质量""安全""质量规范"等关键词的 skill
WHEN 进入扫描阶段
THEN 标记工作类型为 "代码开发"
  AND 调用找到的规范 skill 对代码变更进行扫描
  AND 扫描结果写入 reviews/scan-r<N>.md
  AND 汇总中显示 "Phase 1.5 (规范扫描): SCANNED — 已调用 <skill-name>"
  AND 如果发现问题，在报告中列出问题描述和建议修复方案
  AND 继续进入 Phase 2

## Scenario: 代码开发变更且无可用规范 skill 的代码审查扫描

GIVEN sdd-review-code 被执行
  AND Phase 1 spec 合规审查已通过
  AND git diff 中的变更文件不包含 skill 相关文件
  AND 可用 skill 列表中不存在代码质量/安全相关的规范 skill
WHEN 进入扫描阶段
THEN 汇总中显示 "Phase 1.5 (规范扫描): SKIPPED — 无可用规范扫描 skill"
  AND 不生成 scan 报告文件
  AND 直接进入 Phase 2

## Scenario: skill 开发变更的 spec 审查扫描

GIVEN sdd-review-spec 被执行
  AND spec 文件存在
  AND 当前变更涉及 skill 开发（proposal 或 brainstorm 中包含 skill 相关内容）
  AND skill-craft-adapter 可用
WHEN 主 spec 审查完成后进入扫描阶段
THEN 调用 skill-craft-adapter:skill-check 对 spec 质量进行规范扫描
  AND 扫描结果写入 reviews/scan-r<N>.md
  AND 审查结果中增加扫描阶段状态 "SCANNED"
  AND 如果发现问题，给出提示和建议修复方案

## Scenario: 无可用扫描 skill 的 spec 审查

GIVEN sdd-review-spec 被执行
  AND spec 文件存在
  AND 当前变更不涉及 skill 开发，或 skill-craft-adapter 不可用
WHEN 主 spec 审查完成后进入扫描阶段
THEN 汇总中显示 "规范扫描: SKIPPED — 无可用规范扫描 skill"
  AND 不生成 scan 报告文件
  AND 继续原有完成引导

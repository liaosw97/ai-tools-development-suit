diff --git a/skills/sdd-brainstorm/SKILL.md b/skills/sdd-brainstorm/SKILL.md
index bce0eb4..0748bce 100644
--- a/skills/sdd-brainstorm/SKILL.md
+++ b/skills/sdd-brainstorm/SKILL.md
@@ -98,8 +98,26 @@ SDD Override 指令（必须遵循，优先于 brainstorming skill 的默认行
 
 ## 后置逻辑（SDD 自有）
 
+### 1. Brainstorm Review 循环
+
+读取 `brainstorm-reviewer-prompt.md`，dispatch subagent 进行审查。
+
 <!-- include: ../_shared/review-loop.md -->
 
+**Review 流程（最多 3 轮）：**
+
+读取 `openspec/config.yaml` 的 `limits.review-rounds` 配置值（默认 3），作为 review 循环上限。
+
+**Review 达限处理**：
+
+当 review 循环达到 `limits.review-rounds`（默认 3）轮次时：
+1. 输出已达 review 上限的提示
+2. 列出剩余未解决的 issues
+3. 提供选项：
+   - `① 继续修复` — 进入下一轮 review，不再有轮次限制
+   - `② 接受当前状态并继续` — 终止 review 循环，在 review 文件中标注"用户接受，剩余 issues 未修复"，进入后置逻辑
+4. 提示消息包含可发现性信息："可在 openspec/config.yaml 的 limits 节中调整上限"
+
 ### 2. 产物校验
 
 确认 `brainstorm.md` 存在且包含：
diff --git a/skills/sdd-plan/SKILL.md b/skills/sdd-plan/SKILL.md
index c3e6261..0440091 100644
--- a/skills/sdd-plan/SKILL.md
+++ b/skills/sdd-plan/SKILL.md
@@ -199,8 +199,30 @@ SDD Override 指令（必须遵循，优先于 writing-plans skill 的默认行
 
 ## 后置逻辑（SDD 自有）
 
+### 1. Plan Review 循环
+
+读取 `plan-reviewer-prompt.md`，dispatch subagent 进行审查。
+
 <!-- include: ../_shared/review-loop.md -->
 
+**Review 流程（最多 3 轮）：**
+
+读取 `openspec/config.yaml` 的 `limits.review-rounds` 配置值（默认 3），作为 review 循环上限。
+
+**分批模式审查：**
+- 按批次独立审查，每批检查 TDD 步骤完整性、Spec 对齐、依赖顺序
+- 跨批次依赖关系的一致性在最后一批审查时检查
+
+**Review 达限处理**：
+
+当 review 循环达到 `limits.review-rounds`（默认 3）轮次时：
+1. 输出已达 review 上限的提示
+2. 列出剩余未解决的 issues
+3. 提供选项：
+   - `① 继续修复` — 进入下一轮 review，不再有轮次限制
+   - `② 接受当前状态并继续` — 终止 review 循环，在 review 文件中标注"用户接受，剩余 issues 未修复"，进入后置逻辑
+4. 提示消息包含可发现性信息："可在 openspec/config.yaml 的 limits 节中调整上限"
+
 ### 2. 产物校验
 
 确认 `plan.md` 存在且：

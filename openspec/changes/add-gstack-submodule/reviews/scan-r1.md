# Spec 规范扫描报告 — add-gstack-submodule

**扫描批次**: r1
**工作类型**: skill 开发
**扫描状态**: SCANNED

## 扫描结果

| 维度 | 级别 | 描述 | 修复建议 |
|------|------|------|---------|
| 结构完整性 | info | role-system spec 的 SC-01 定义了角色 5 要素，但未明确每个要素的必需/可选属性 | 建议在 spec 中标注哪些要素是必需的（如 name、trigger） |
| 触发条件定义 | minor | role-command spec 的 SC-02/SC-03 未定义角色名称的格式约束（如允许的字符集、长度限制） | 添加边界条件：角色名称仅允许小写字母、数字和连字符，长度 1-32 字符 |
| 输出约束 | minor | role-command spec 的 SC-01 输出"角色信息"但未定义具体格式 | 建议定义输出模板，如：`角色: <name> (来源: <source>)` |
| 输出约束 | info | role-system spec 的 SC-05 提到"存在冲突时输出提示信息"但未定义提示格式 | 建议定义冲突提示模板 |
| 错误处理 | info | gstack-integration spec 的边界条件提到"网络不可用时 submodule 初始化失败"，但无对应场景覆盖 | 建议添加 SC-04: 网络不可用时的错误处理场景 |
| 错误处理 | minor | role-system spec 的 SC-06/SC-07 定义了降级行为，但未说明降级后是否记录到日志或 review 文件 | 建议明确降级行为的记录方式 |
| 与现有系统集成 | major | role-system spec 的 SC-03 定义了 SDD action 默认角色绑定，但未说明角色加载逻辑如何注入到现有 SKILL.md 的前置逻辑中 | 需要在 design.md 或 tasks.md 中明确 SKILL.md 的修改模式（如：在前置逻辑前添加"角色加载"步骤） |
| 与现有系统集成 | minor | role-system spec 未定义角色系统与 sdd-doctor 的集成（sdd-doctor 是否需要检查角色配置状态） | 建议在 sdd-doctor 的诊断项中添加角色系统状态检查 |
| 触发条件定义 | info | role-system spec 的 SC-04 定义了 `--role` 参数，但未说明参数解析失败时的行为 | 建议添加边界条件：参数格式错误时的提示 |
| 结构完整性 | info | gstack-integration spec 缺少版本锁定后的验证场景（如何确认 versions.lock 记录正确） | 建议添加 SC-04: 验证版本锁定记录 |

## 总结

- critical: 0 项
- major: 1 项
- minor: 4 项
- info: 5 项

## 详细分析

### Major 问题

**M1: 角色加载逻辑注入方式未明确**

role-system spec 的 SC-03 定义了 9 个 SDD action 的默认角色绑定，但 spec 中未描述角色加载逻辑如何集成到现有 SKILL.md 的前置逻辑中。

当前 SKILL.md 结构（以 sdd-review-code 为例）：
```
前置逻辑（SDD 自有）
  0. 前置校验
  1. 定位 Change 目录
  2. 收集审查材料
```

角色加载应作为新的步骤插入，但插入位置（前置校验之前还是之后）和具体逻辑（读取角色文件、合并优先级、注入视角）未在 spec 中定义。

**影响**: 实施时可能产生不一致的集成方式，影响可维护性。

**修复建议**: 在 role-system spec 中添加新场景 SC-08: "角色加载逻辑集成到 SKILL.md"，明确定义：
1. 角色加载在前置逻辑中的位置（建议在"前置校验"之后、"定位 Change 目录"之前）
2. 角色加载的具体步骤（检查参数 → 检查会话级 → 使用默认 → 合并优先级）
3. 角色注入的方式（将角色定义内容追加到系统提示或作为上下文传递）

### Minor 问题

**m1: 角色名称格式约束缺失**

role-command spec 的 SC-02/SC-03 涉及角色名称输入，但未定义合法的角色名称格式。这可能导致：
- 用户输入包含特殊字符的角色名
- 大小写处理不一致（spec 提到"大小写不敏感"但未定义转换规则）

**修复建议**: 在 role-command spec 的边界条件中添加：
```
- 角色名称格式：仅允许小写字母、数字和连字符，长度 1-32 字符
- 输入时自动转换为小写
- 无效格式时提示："角色名称格式错误，仅允许小写字母、数字和连字符"
```

**m2: 角色信息输出格式未定义**

role-command spec 的 SC-01 定义输出"角色名称、角色来源、角色身份描述"，但未定义具体格式。

**修复建议**: 定义输出模板：
```
当前角色: <name>
来源: <builtin|project|user>
身份: <身份描述摘要>
```

**m3: 降级行为记录方式未明确**

role-system spec 的 SC-06/SC-07 定义了降级到默认角色的行为，但未说明是否需要记录降级事件。

**修复建议**: 在 spec 中明确：
```
降级时输出警告到控制台，并在 review 文件头部添加：
> ⚠️ 角色降级: '<role-name>' 不存在，已使用默认角色 '<default-role>'
```

**m4: sdd-doctor 集成缺失**

role-system spec 未定义与 sdd-doctor 的集成。sdd-doctor 负责环境诊断，应检查角色系统状态。

**修复建议**: 在 role-system spec 中添加边界条件：
```
sdd-doctor 诊断项应包含：
- 角色目录是否存在
- 内置角色文件数量
- 项目级/用户级角色覆盖情况
```

### Info 问题

**i1-i5**: 这些是建议性改进，不影响功能正确性，但能提升 spec 的完整性和可测试性。

## 结论

[SCANNED] 扫描完成，发现 10 个问题（0 critical, 1 major, 4 minor, 5 info）

**主要风险**: 角色加载逻辑的集成方式未明确，可能导致实施不一致。建议在实施前补充 design.md 或在 role-system spec 中添加 SC-08 明确集成细节。

**建议优先级**:
1. 先修复 M1（角色加载集成方式）
2. 再处理 minor 问题
3. info 问题可在实施过程中逐步完善

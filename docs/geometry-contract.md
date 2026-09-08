# Geometry Contract（Things 复刻 · HarmonyOS）

> 说明见 `H00 Visual Acceptance Harness` / `H03 TodoRow` / `H04 TodoMetadata` / `07.3 Golden/Geometry`。
> 所有数值均为 **PROVISIONAL**（来自真机录屏 C 级样本），必须经模拟器 Golden + Inspector Geometry 校准后才可升级为 VERIFIED。

## 目的

验收不靠"看起来像"，而是对**命名的 Geometry Anchor**输出可比较的误差。失败报告形如 `checkbox.center +3vp`，而非"感觉偏右"。

## 全局约定

- 布局单位 `vp`；Typography `fp`；录屏像素为 `epx`（仅作比例/Seed）。
- 视觉尺寸与点击热区分离（如 Checkbox 视觉 18vp / 热区 48vp）。
- 组件禁止散落 literal color/size/radius，全部走 Token。
- 页面系统栏/安全区/键盘由 Page 处理，普通组件不硬编码设备高度。

## TodoRow Anchor（H03 + H04）

| Anchor | 语义 | 期望（PROVISIONAL） |
|---|---|---|
| `A1` | row.left | 屏幕内容左缘（对齐页面 padding） |
| `A2` | checkbox.center | 视觉圆 18vp 圆心；热区 48vp 分离 |
| `A3` | title.baseline | 与 Checkbox 垂直对齐；首行 baseline |
| `A4` | metadata.baseline | SecondaryLine 左对齐 title；权重弱于 title |
| `A5` | trailing.right | Deadline 右缘，长标题不得挤出 trailing |

### 事件隔离硬约束（H03）
- 点 Checkbox → `onToggleCompletion`（**不得**触发 `onOpen`）；交互脚本断言 `onOpen 计数 == 0`。
- 点 Row 内容 → `onOpen`（原地展开，非详情路由）。

### 长标题/完成态（H03-B）
- 高度由内容测量决定（`minHeight`，非固定值）。
- completed：Checkbox 完成态 + title 弱化；**禁止**擅自加删除线。
- `checked=true` 后 Row **不得自行移除**；由 Domain Command + Projection 更新决定。

## TodoCheckbox Anchor（H02）

| Anchor | 语义 | 期望 |
|---|---|---|
| `C1` | 视觉圆 | 直径 18vp，stroke/fill 用 Token |
| `C2` | hit target | 48vp，与视觉圆分离 |
| `C3` | checkmark | 自定义 Path，非 Unicode ✓ |

## ExpandedTodo Anchor（H05-A Object Continuity 硬约束）

```
checkbox.x(collapsed) == checkbox.x(expanded)  ±1vp
title.x(collapsed)    == titleSlot.x(expanded) ±1vp
notesSlot.x           == titleSlot.x           ±1vp
```

## 校验顺序（P0→P4）

P0 Structure → P1 Geometry → P2 Typography → P3 Color → P4 Motion。

## 当前状态

- `IMPLEMENTED`：TodoCheckbox/TodoRow/ExpandedTodo/Checklist/组织/Overlay 已实现并编译。
- `VERIFIED`：**未达成**——需模拟器截图 + Inspector Geometry + Golden diff 校准；当前因 HAP 未签名/无真机 A 级视觉证据而阻塞。

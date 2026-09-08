# Things 高保真复刻（HarmonyOS）

Things 3（iPhone Light）在 HarmonyOS 上的高保真复刻应用。**规格与证据来源见 nox 仓库**：

- GitHub: https://github.com/beartimer-afk/nox
- 本地研究书：`D:\bear\code\no.X\doc\fty1\things-gao-bao-zhen-fu-ke-yan-jiu`（01–10 章 + H00–H08 规格）

本仓库只存放实现（ArkTS/ArkUI 工程）；一切都是按文档做，不理解处查上述文档。

## 目标与纪律

遵循 spec 文档的冻结顺序与验收闭环：

```
Evidence → Token → Spec → Fixture → Implement → Simulator Capture → Inspector Geometry → Diff → Fix → VERIFIED
```

实现顺序（per 09.4 / 06 README）：

**H00 Visual Acceptance Harness → H01 Foundation Tokens → H02 TodoCheckbox → H03 TodoRow → H04 TodoMetadata → H05 ExpandedTodo → H06 Checklist → H07 Organization → H08 Overlay/Pickers → Interaction → Page Composition**

- `IMPLEMENTED ≠ VERIFIED`：需过 Geometry / Token / Golden / Interaction / Regression。
- 禁用 literal color/size/radius；全走 Token；`PENDING/PROVISIONAL/VERIFIED` 按证据等级标注。
- 遵守 09.5 核心不变量与每份规格的"禁止事项"。

## 工程

- IDE：DevEco Studio 26.0（`D:\Program Files\Huawei\DevEco Studio`）
- SDK：`D:\Program Files\Huawei\DevEco Studio\sdk`
- 目标：HarmonyOS `6.1.0(23)`（compatibleSdkVersion），runtimeOS `HarmonyOS`
- 模拟器：`D:\Users\bear\AppData\Local\Huawei\Emulator\deployed`

## 构建（命令行）

```powershell
$env:JAVA_HOME = "D:\Program Files\Huawei\DevEco Studio\jbr"
$env:DEVECO_SDK_HOME = "D:\Program Files\Huawei\DevEco Studio\sdk"
$env:PATH = "D:\Program Files\Huawei\DevEco Studio\jbr\bin;$env:PATH"
cd D:\Users\bear\DevEcoStudioProjects\things-hongmeng
& "D:\Program Files\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.bat" assembleHap --mode module -p product=default -p buildMode=debug --no-daemon
```

输出：`entry/build/default/outputs/default/entry-default-unsigned.hap`

## 进度

| 阶段 | 状态 |
|---|---|
| 工程骨架（可编译） | ✅ 完成 |
| H00 Harness + H01 Tokens + H02 TodoCheckbox + H03 TodoRow + H04 Metadata | ✅ 完成（实现） |
| 领域模型 + Projection（today/upcoming/anytime/someday/inbox/logbook/search） | ✅ 完成 |
| H05 ExpandedTodo + 标题/备注编辑器 + H06 Checklist + H07 组织(Project/Area/Heading) | ✅ 完成（实现） |
| H08 Overlay：When / Deadline / Tags 弹层 | ✅ 完成（实现） |
| 交互：多选/批量、Magic Plus、QuickFind、选中行 | ✅ 完成（实现） |
| 页面组合：MainLists/Today/Project/Area/Inbox/Upcoming/Anytime/Someday/Logbook | ✅ 完成（可导航） |
| 拖拽重排、偏好持久化 | ⏳ 待做 |
| 上模拟器 + Geometry/Inspector/Golden 验收 | ⏳ 依赖 DevEco 自动签名（用户侧） |

> 状态如实区分 `实现完成` / `待做`。精确视觉值均为 `PROVISIONAL`（需真机 A 级证据 + 模拟器 Golden 校准，未冒充 VERIFIED）。

> 说明：node/npm 若遇到 `npm.ps1` 执行策略问题，用 `npm.cmd`；GitHub 直连被墙，已走系统代理（v2rayN 127.0.0.1:10808）。

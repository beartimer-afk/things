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
| 工程骨架（可编译） | 进行中 |
| H00–H02（Harness / Tokens / TodoCheckbox） | 待实现 |
| H03–H04 | 未开始 |
| 其余（H05–Pages） | 未开始 |

> 说明：node/npm 若遇到 `npm.ps1` 执行策略问题，用 `npm.cmd`；GitHub 直连被墙，已走系统代理（v2rayN 127.0.0.1:10808）。

# DIY Quick Look

为 macOS 访达提供配置文件的快速查看预览。选中文件后按空格键即可查看原文。

| 扩展名 | 预览内容 |
| --- | --- |
| `.yaml`、`.yml` | YAML 原文，保留缩进 |
| `.list` | 纯文本列表，保留换行 |
| `.ovpn` | OpenVPN 配置原文，包含内嵌配置段 |

预览支持浅色和深色外观、长行自动换行，以及 UTF-8 和带 BOM 的 UTF-16、UTF-32。超过 1 MiB 的文件仅预览开头，并显示截断提示。

## 构建和使用

需要 macOS 13 或更新版本以及 Xcode 14 或更新版本。使用 Xcode 打开 `DIYQuickLook.xcodeproj`，选择 `DIYQuickLook` 方案并运行，或在项目根目录执行：

```sh
xcodebuild -project DIYQuickLook.xcodeproj -scheme DIYQuickLook \
  -configuration Release -destination 'generic/platform=macOS' \
  -derivedDataPath build build
open "build/Build/Products/Release/DIY Quick Look.app"
```

本地构建使用临时签名，无需配置开发者团队。有需要时，可将构建出的 App 移到「应用程序」文件夹并打开一次。

在访达打开 [Examples](Examples)，逐一选中示例文件并按空格键，确认内容和缩进正常显示。如果扩展未生效，在「系统设置」中搜索「快速查看」，检查 DIY Quick Look 是否已启用。[Apple 扩展设置说明](https://support.apple.com/zh-hans/guide/mac-help/mtusr003/mac)

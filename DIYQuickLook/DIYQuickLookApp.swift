import SwiftUI

@main
struct DIYQuickLookApp: App {
    var body: some Scene {
        WindowGroup("DIY Quick Look") {
            VStack(alignment: .leading, spacing: 12) {
                Label("DIY Quick Look", systemImage: "eye")
                    .font(.title2.weight(.semibold))

                Text("在 Finder 中选中文件，按空格键预览。")
                Text(".yaml  ·  .yml  ·  .list  ·  .ovpn")
                    .font(.system(.body, design: .monospaced))

                Divider()

                Text("如果预览未显示，请在系统设置中搜索「快速查看」，并启用 DIY Quick Look。")
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(width: 390, alignment: .leading)
        }
        .windowResizability(.contentSize)
    }
}

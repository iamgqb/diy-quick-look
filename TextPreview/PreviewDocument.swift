import Foundation

struct PreviewDocument {
    private static let byteLimit = 1024 * 1024

    let html: Data

    init(fileURL: URL) throws {
        let file = try FileHandle(forReadingFrom: fileURL)
        defer { try? file.close() }

        let data = try file.read(upToCount: Self.byteLimit + 1) ?? Data()
        let isTruncated = data.count > Self.byteLimit
        let text = try Self.decode(Data(data.prefix(Self.byteLimit)), isTruncated: isTruncated)
        let body = text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        let notice = isTruncated ? "<p>仅显示文件开头的 1 MiB。</p>" : ""

        html = Data("""
        <!doctype html>
        <html lang="zh-CN">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            :root { color-scheme: light dark; }
            body { margin: 8px; color: CanvasText; background-color: Canvas; }
            pre { margin: 0; }
            code {
                font: 13px/1.55 ui-monospace, monospace;
                white-space: pre-wrap;
                overflow-wrap: anywhere;
                tab-size: 4;
            }
            p { color: GrayText; font: 13px system-ui, sans-serif; }
        </style>
        <pre><code>\(body)</code></pre>
        \(notice)
        </html>
        """.utf8)
    }

    private static func decode(_ data: Data, isTruncated: Bool) throws -> String {
        let encoding: String.Encoding
        let bomLength: Int
        switch Array(data.prefix(4)) {
        case let bytes where bytes.starts(with: [0x00, 0x00, 0xFE, 0xFF]):
            (encoding, bomLength) = (.utf32BigEndian, 4)
        case let bytes where bytes.starts(with: [0xFF, 0xFE, 0x00, 0x00]):
            (encoding, bomLength) = (.utf32LittleEndian, 4)
        case let bytes where bytes.starts(with: [0xFE, 0xFF]):
            (encoding, bomLength) = (.utf16BigEndian, 2)
        case let bytes where bytes.starts(with: [0xFF, 0xFE]):
            (encoding, bomLength) = (.utf16LittleEndian, 2)
        case let bytes where bytes.starts(with: [0xEF, 0xBB, 0xBF]):
            (encoding, bomLength) = (.utf8, 3)
        default:
            (encoding, bomLength) = (.utf8, 0)
        }

        let content = data.dropFirst(bomLength)
        if let text = String(data: content, encoding: encoding) {
            return text
        }

        if isTruncated {
            // 文件预览的字节边界可能落在一个 Unicode 字符中间。
            let trimCounts = encoding == .utf8 ? [1, 2, 3] : [2]
            for count in trimCounts {
                if let text = String(data: content.dropLast(count), encoding: encoding) {
                    return text
                }
            }
        }

        throw CocoaError(.fileReadInapplicableStringEncoding)
    }
}

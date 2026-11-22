import QuickLookUI
import UniformTypeIdentifiers

final class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let document = try PreviewDocument(fileURL: request.fileURL)

        return QLPreviewReply(
            dataOfContentType: .html,
            contentSize: CGSize(width: 820, height: 640)
        ) { reply in
            reply.stringEncoding = .utf8
            return document.html
        }
    }
}

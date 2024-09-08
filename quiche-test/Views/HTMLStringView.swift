import SwiftUI
import WebKit

// https://medium.com/@edabdallamo/discover-hidden-gems-rendering-html-content-in-swiftui-24d73a3d2cdd

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

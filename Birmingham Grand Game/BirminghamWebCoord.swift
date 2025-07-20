import WebKit
import Foundation

class BirminghamWebCoordinator: NSObject, WKNavigationDelegate {
    private let birminghamCallback: (BirminghamWebStatus) -> Void
    private var birminghamDidStart = false

    init(onBirminghamStatus: @escaping (BirminghamWebStatus) -> Void) {
        self.birminghamCallback = onBirminghamStatus
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if !birminghamDidStart { birminghamCallback(.progressing(birminghamProgress: 0.0)) }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        birminghamDidStart = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        birminghamCallback(.finished)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        birminghamCallback(.failure(birminghamReason: error.localizedDescription))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        birminghamCallback(.failure(birminghamReason: error.localizedDescription))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other && webView.url != nil {
            birminghamDidStart = true
        }
        decisionHandler(.allow)
    }
}

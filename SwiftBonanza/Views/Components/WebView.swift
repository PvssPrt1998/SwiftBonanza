import Foundation
import SwiftUI
import Combine
import WebKit
import UIKit

struct WebView: UIViewRepresentable {
    
    enum URLType {
        case local, `public`
    }
    
    @ObservedObject var viewModel: WebViewModel
    
    var dataManager: DataManager?
    var type: URLType
    var url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let urlValue = url  {
            if let requestUrl = URL(string: urlValue) {
                webView.load(URLRequest(url: requestUrl))
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var webViewNavigationSubscriber: AnyCancellable? = nil
        
        init(_ webView: WebView) {
            self.parent = webView
        }
        
        deinit {
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.viewModel.isLoaderVisible.send(false)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.viewModel.isLoaderVisible.send(true)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            self.parent.viewModel.isLoaderVisible.send(false)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            self.parent.viewModel.isLoaderVisible.send(true)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.parent.viewModel.isLoaderVisible.send(false)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if let urlStr = navigationAction.request.url?.absoluteString {
                if let dataManager = parent.dataManager {
                    //dataManager.urlForWebView = urlStr
                }
            }
            decisionHandler(.allow, preferences)
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            self.parent.viewModel.isLoaderVisible.send(false)
        }
    }
}


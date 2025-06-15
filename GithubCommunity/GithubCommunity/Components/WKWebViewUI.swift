//
//  WKWebViewUI.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//
import SwiftUI
import WebKit


public struct WKWebViewUI: UIViewRepresentable {
    
    let url: URL

    public init(url: URL) {
        self.url = url
        
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        load(webView: view)
        return view
    }

    private func load(webView: WKWebView) {
        webView.load(URLRequest(url: url))
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        load(webView: webView)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    // MARK: - State Object
    public class State: ObservableObject {
        @Published var isLoading: Bool
        @Published var error: Error?

        public init(isLoading: Bool = false, error: Error? = nil) {
            self.isLoading = isLoading
            self.error = error
        }
    }

    
    
    // MARK: - Coordinator
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WKWebViewUI

        init(_ parent: WKWebViewUI) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            debugPrint("WebView", "Page is loading.")
        }

        public func webView(_ webView: WKWebView,
                            didFailProvisionalNavigation navigation: WKNavigation!,
                            withError error: Error) {
            debugPrint("WebView", "loading error: \(error.localizedDescription)")
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            debugPrint("WebView", "Page is finished loading.")
        }

        public func webView(_ webView: WKWebView,
                            decidePolicyFor navigationAction: WKNavigationAction,
                            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            debugPrint("WebView", "navigationAction: \(navigationAction.request.url?.absoluteString ?? "")")
            decisionHandler(.allow)
        }

        public func webView(_ webView: WKWebView,
                            decidePolicyFor navigationResponse: WKNavigationResponse,
                            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            debugPrint("WebView", "navigationResponse: \(navigationResponse.response.url?.absoluteString ?? "")")
            decisionHandler(.allow)
        }
    }
}



//
//  SwiftUIWebView.swift
//  Banking
//
//  Created by Karen Mirakyan on 25.04.23.
//

import Foundation
import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    var url: String
    @Binding var active: Bool
    @EnvironmentObject var cardsVM: CardsViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url ) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let webView = WKWebView()
        
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.load(request)

        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var webView: SwiftUIWebView
        
        init(_ webView: SwiftUIWebView) {
            self.webView = webView
        }
        
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            completionHandler( true )
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            completionHandler()
        }
        
        
        @MainActor func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            if webView.url?.absoluteString.hasPrefix("https://neominty.com/?orderId") == true {
                decisionHandler(.cancel)
                if let url = webView.url, let _ = url.valueOf("orderId") {
                    self.webView.cardsVM.getAttachmentStatus()
                }
                self.webView.active = false
            } else {
                decisionHandler(.allow)
            }
        }
    }
}

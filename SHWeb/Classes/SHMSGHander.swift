//
//  SHMSGHander.swift
//  KumuWeb_Example
//
//  Created by Ray on 2023/5/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


import UIKit
import WebKit

public protocol SHMSGHanderDelegate: NSObjectProtocol {
    func msgHander(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}
open class SHMSGHander : NSObject, WKScriptMessageHandler {
    
    
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.msgHander(userContentController, didReceive: message)
    }
    
    open var methods: [String] = []
    weak var delegate: SHMSGHanderDelegate?
    func removeAllHander(webView: WKWebView) {
        methods.forEach { item in
            webView.configuration.userContentController.removeScriptMessageHandler(forName: item)
        }
    }
    
    func addHander(method: String, webView: WKWebView) {
        methods.append(method)
        webView.configuration.userContentController.add(self, name: method)
    }
}

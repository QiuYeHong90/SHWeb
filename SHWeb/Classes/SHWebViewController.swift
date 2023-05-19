//
//  KumuWebViewController.swift
//  KumuWeb_Example
//
//  Created by Ray on 2023/5/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import WebKit
import UIKit

open class SHWebViewController: UIViewController,SHMSGHanderDelegate {
    open var showWebPageTitle: Bool = true
    lazy var progressView: WebProgressView = WebProgressView.init()
    open lazy var backItem: UIBarButtonItem = {
//        nav_back
        let bundle = Bundle.init(for: SHWebViewController.self)
        let img = UIImage.init(named: "nav_back", in: bundle, compatibleWith: nil)
        let newImg = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let backItem = UIBarButtonItem.init(image: newImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back))
        backItem.imageInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        return backItem
    }()
    
    open lazy var closeItem: UIBarButtonItem = {
        let bundle = Bundle.init(for: SHWebViewController.self)
        let img = UIImage.init(named: "close", in: bundle, compatibleWith: nil)
        let newImg = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let backItem = UIBarButtonItem.init(image: newImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.close))
        backItem.imageInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
        backItem.width = 0
        return backItem
    }()
    
    open lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration.init()
        let web = WKWebView.init(frame: CGRect.zero, configuration: config)
        return web
    }()
    open var urlStr: String = "https://www.baidu.com/"
    
    public init(urlStr: String) {
        super.init(nibName: nil, bundle: nil)
        self.urlStr = urlStr
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        
    }
    open var msgHander: SHMSGHander = .init()
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        addWebObserver()
        loadRequest()
        
        msgHander.delegate = self
        self.addHander(method: "close")
    }
    open func removeAllHander() {
        msgHander.removeAllHander(webView: self.webView)
    }
    open func addHander(method: String) {
        msgHander.addHander(method: method, webView: self.webView)
    }
    /// 注入js
    /// ```
    /// let  rootHeader = """
    /// var coverSupport = 'CSS' in window && typeof CSS.supports === 'function' && (CSS.supports('top: env(a)') ||
    ///        CSS.supports('top: constant(a)'))
    ///      document.write(
    ///     '<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0' +
    ///     (coverSupport ? ', viewport-fit=cover' : '') + '" />')
    /// """
    /// self.addScriptHander( javaScript: rootHeader)
    /// ```
    func addScriptHander(javaScript: String) {
        
        if !javaScript.isEmpty {
            let userScript = WKUserScript.init(source: javaScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
            
            self.webView.configuration.userContentController.addUserScript(userScript)
        }
    }
    /// 添加监听事件
    func addWebObserver() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    // Implement the observer method to handle changes in loading progress
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // Update the UI or perform any relevant action with the loading progress value
            let progress = webView.estimatedProgress
            print("Loading progress: \(progress)")
            self.progressView.updateProgress(progress: CGFloat(progress))
        }
        
        if keyPath == #keyPath(WKWebView.title) {
            // Update the UI or perform any relevant action with the loading progress value
            let title = webView.title
            print("webView title: \(String(describing: title))")
            
            if self.showWebPageTitle {
                self.title = title
            }
            self.reloadLeftItem()
        }
    }
    
    
    open func loadRequest() {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        guard let url = URL.init(string: self.urlStr) else {
            return
        }
        self.webView.load(URLRequest.init(url: url))
        showLoadingTitle()
    }
    /**
     *  当网页加载的时候，是否显示loading或URL
     */
    open func showLoadingTitle() {
        if self.showWebPageTitle {
            self.title = "Loading..."
        }
        
    }
    open func setupViews() {
        self.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: self.webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0),
                                 ])
        
//        MARK: 进度条 =====
        guard let navBar = self.view else {
            return
        }
        navBar.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navBar.addConstraints([
            NSLayoutConstraint.init(item: progressView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: navBar, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: progressView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: navBar, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: progressView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: navBar.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: progressView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 1),
        ])
        
//        MARK: 返回和关闭按钮
        self.reloadLeftItem();
    }
    open func reloadLeftItem() {
        if self.webView.canGoBack {
            let fixedSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            fixedSpace.width = 0
            
            self.navigationItem.leftBarButtonItems = [backItem,fixedSpace,closeItem];
        } else {
            self.navigationItem.leftBarButtonItems = [backItem];
        }
    }
    
    
     @objc open func back() {
        
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            close()
        }
    }
    
     @objc open func close() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true)
        } else {
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                print("未知错误")
            }
        }
        
        
    }
    
    
    deinit {
        self.removeAllHander()
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        print("deinit == \(self)")
    }
//   MARK: SHMSGHanderDelegate
    open func msgHander(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message== \(message.name)")
    }
}

extension SHWebViewController: WKUIDelegate {
    public func webViewDidClose(_ webView: WKWebView) {
        print("===webViewDidClose")
    }
}

extension SHWebViewController: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        
        self.reloadLeftItem()
        return .allow
    }
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        self.reloadLeftItem()
        return .allow
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("---==didStartProvisionalNavigation")
    }
    
    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("---==didReceiveServerRedirectForProvisionalNavigation")
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}




//
//  TSWebViewController.swift
//  TSWebViewController
//
//  Created by huangyuchen on 2018/6/20.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import WebKit

public class TSWebViewController: UIViewController {

    /// JS call Native 方法名
    public let ts_webCallShare = "webCallShare"
    public let ts_webCallLoginStatus = "webCallLoginStatus"
    public let ts_webCallPayment = "webCallPayment"
    public let ts_webCallNativeRouter = "webCallNativeRouter"
    public let ts_webCallClosePage = "webCallClosePage"
    public let ts_webCallCopyText = "webCallCopyText"
    public let ts_webCallError = "webCallError"
    public let ts_webCallScreenCapture = "webCallScreenCapture"
    /// Native call JS 方法名
    public let ts_nativeCallLoginInfo = "nativeCallLoginInfo"
    public let ts_nativeCallRefresh = "nativeCallRefresh"
    public let ts_nativeCallShareSuccess = "nativeCallShareSuccess"
    public let ts_nativeCallClearCache = "nativeCallClearCache"
    
    
    /// web url
    public var htmlString: String?
    /// 进度条的颜色
    public var progressBackgroundColor: UIColor! = .red
    //配置cookie
    public var cookieStr: String?
    
    public var webView: WKWebView!
    
    private var progressView: UIProgressView!
    
    private var configuretion: WKWebViewConfiguration!
    
    private let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    private let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    private var registerFuncName: [String] = [String]()
    
    deinit {
        
        self.webView.stopLoading()
        
        for funcName in self.registerFuncName {
            self.configuretion.userContentController.removeScriptMessageHandler(forName: funcName)
        }
        
        self.webView.removeObserver(self, forKeyPath: "loading")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // 隐藏导航栏底部黑线
        self.hiddenNavShadowLine()
        //添加导航栏返回和关闭按钮
        self.setNavBackButton()
        // 加载webView
        self.setConfiguretion()
        webView = WKWebView(frame: self.view.bounds, configuration: configuretion)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        let navBarHeight = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.bounds.height ?? 0)
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: navBarHeight, width: self.view.bounds.width, height: 10))
        self.progressView.progressViewStyle = .default
        self.progressView.tintColor = progressBackgroundColor
        self.view.addSubview(self.progressView)
        if let str = self.htmlString {
            let myURL = URL(string: str)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
        }else {
            debugPrint("TSWebViewController: htmlString is nil")
        }
        
        // 监听支持KVO的属性
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    // 配置进度条 和 title
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            self.progressView.alpha = 1.0
        } else if keyPath == "estimatedProgress" {
            print(webView.estimatedProgress)
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
        // 已经完成加载时，我们就可以做我们的事了
        if !webView.isLoading {
            UIView.animate(withDuration: 0.55, animations: {
                self.progressView.alpha = 0.0
            }) { (finish) in
                if finish {
                    self.progressView.setProgress(0, animated: true)
                }
            }
        }
    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TSWebViewController: WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        self.jsCallNative(name: message.name, body: message.body)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let hostname = navigationAction.request.url?.host?.lowercased() //navigationAction.request.URL?.host?.lowercaseString
        
        // 处理跨域问题
        if navigationAction.navigationType == .linkActivated && !(hostname?.contains(".baidu.com"))! {
            // 手动跳转
            webView.load(navigationAction.request)
        }
        self.progressView.alpha = 1.0
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let title: NSString = NSString(string: self.webView.title ?? "")
        if title.length > 8 {
            self.title = title.substring(to: 7)
        }else{
            self.title = self.webView.title
        }
        
        //网页加载完成时判断是否有前一页，没有则只显示返回按钮，有则显示关闭按钮
        if webView.canGoBack {
            self.closeButton.isHidden = false
        }else {
            self.closeButton.isHidden = true
        }
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        //网页加载完成时判断是否有前一页，没有则只显示返回按钮，有则显示关闭按钮
        if webView.canGoBack {
            self.closeButton.isHidden = false
        }else {
            self.closeButton.isHidden = true
        }
    }
}

//防止内存泄露 添加了一个弱引用的delegate
public class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    
    weak var scriptDelegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        
        self.scriptDelegate = delegate
        super.init()
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
    
}

//webview的相关配置
extension TSWebViewController  {
    // 配置 导航栏 返回按钮
    private func setNavBackButton() {
        
        let path = Bundle.init(for: TSWebViewController.self).path(forResource: "TSWebviewController", ofType: "bundle")
        let bundle = Bundle.init(path: path!)
        //左侧占位
        let nagetiveSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        nagetiveSpacer.width = -8
        
        // 返回按钮 （返回前一网页）
        let image = UIImage.init(named: "ts_navigitionBackArrow", in: bundle, compatibleWith: nil)
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
        backButton.contentHorizontalAlignment = .left
        backButton.adjustsImageWhenHighlighted = false
        let barButtonItem1 = UIBarButtonItem(customView: backButton)
        
        // 关闭按钮 （关闭网页）
        let closeImage = UIImage.init(named: "ts_webViewClose", in: bundle, compatibleWith: nil)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self, action: #selector(backVC), for: .touchUpInside)
        closeButton.contentHorizontalAlignment = .left
        closeButton.adjustsImageWhenHighlighted = false
        closeButton.isHidden = true
        let barButtonItem2 = UIBarButtonItem(customView: closeButton)
        
        self.navigationItem.leftBarButtonItems = [nagetiveSpacer, barButtonItem1, barButtonItem2]
        
    }
    
    //隐藏导航栏底部的横线
    private func hiddenNavShadowLine() {
        
        self.navigationController?.navigationBar.backgroundColor = .blue
        if let barBackgroundView = navigationController?.navigationBar.subviews[0] {
            let valueForKey = barBackgroundView.value(forKey:)
            
            if let shadowView = valueForKey("_shadowView") as? UIView {
                shadowView.isHidden = true
            }
        }
    }
    //配置webConfiguration
    private func setConfiguretion() {
        
        configuretion = WKWebViewConfiguration()
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        //配置cookie
        if let cookie = self.cookieStr {
         
            let script = WKUserScript(source: cookie, injectionTime: .atDocumentStart,// 在载入时就添加JS
                forMainFrameOnly: true) // 只添加到mainFrame中
            configuretion.userContentController.addUserScript(script)
        }
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        self.registerFuncName.append(contentsOf: [ts_webCallShare, ts_webCallLoginStatus, ts_webCallPayment, ts_webCallNativeRouter, ts_webCallClosePage, ts_webCallCopyText, ts_webCallError, ts_webCallScreenCapture])
        if let array = self.registerJSCallNativeName() {
            self.registerFuncName.append(contentsOf: array)
        }
        
        for funcName in self.registerFuncName {
            configuretion.userContentController.add(WeakScriptMessageDelegate.init(delegate: self), name: funcName)
        }
        
    }
    
    // web 关闭
    @objc private func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // web 返回前一页
    @objc private func previousPage() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.backVC()
        }
    }
}

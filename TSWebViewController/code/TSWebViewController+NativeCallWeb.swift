//
//  TSWebViewController+NativeCallWeb.swift
//  TSWebViewController
//
//  Created by huangyuchen on 2018/6/22.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
/// Native 调用 JS
public extension TSWebViewController {

    /// 登录成功 同步信息
    public func nativeCallLoginInfo(body: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        
        self.nativeCallWeb(funcName: ts_nativeCallLoginInfo, body: body, completionHandler: completionHandler)
    }
    
    /// 本地调用H5页面刷新
    public func nativeCallRefresh(body: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        
        self.nativeCallWeb(funcName: ts_nativeCallRefresh, body: body, completionHandler: completionHandler)
    }
    
    /// 分享完成通知H5页面
    public func nativeCallShareSuccess(body: String?, completionHandler: ((Any?, Error?) -> Void)?) {
     
        self.nativeCallWeb(funcName: ts_nativeCallShareSuccess, body: body, completionHandler: completionHandler)
    }
    
    /// 清除H5缓存
    public func nativeCallClearCache(body: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        
        self.nativeCallWeb(funcName: ts_nativeCallClearCache, body: body, completionHandler: completionHandler)
    }
    
    /// 调用JS方法
    public func nativeCallWeb(funcName: String, body: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        
        var funcName = funcName
        if let bodyStr = body {
            funcName = funcName + "('" + bodyStr + "')"
        }
        self.webView.evaluateJavaScript(funcName, completionHandler: completionHandler)
    }
}

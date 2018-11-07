//
//  TSWebViewController+WebCallNative.swift
//  TSWebViewController
//
//  Created by huangyuchen on 2018/6/22.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

/// JS 调用 Native

public extension TSWebViewController {
    
    /// JS 调用 Native方法
    @objc public func jsCallNative(name: String, body: Any) {
        
        switch name {
        case ts_webCallShare:
            self.webCallShare(body: body)
        case ts_webCallLoginStatus:
            self.webCallLoginStatus(body: body)
        case ts_webCallPayment:
            self.webCallPayment(body: body)
        case ts_webCallNativeRouter:
            self.webCallNativeRouter(body: body)
        case ts_webCallClosePage:
            self.webCallClosePage(body: body)
        case ts_webCallCopyText:
            self.webCallCopyText(body: body)
        case ts_webCallError:
            self.webCallError(body: body)
        case ts_webCallScreenCapture:
            self.webCallScreenCapture(body: body)
        default:
            break
        }
        
    }
    
    /// 分享
    @objc public func webCallShare(body: Any) {}
    
    /// 登录状态
    @objc public func webCallLoginStatus(body: Any) {}
    
    /// 调用支付
    @objc public func webCallPayment(body: Any) {}
    
    /// 跳转本地router
    @objc public func webCallNativeRouter(body: Any) {}
    
    /// 关闭页面
    @objc public func webCallClosePage(body: Any) {}
    
    /// 复制文本
    @objc public func webCallCopyText(body: Any) {}
    
    /// 异常交互
    @objc public func webCallError(body: Any) {}
    
    /// 截取屏幕
    @objc public func webCallScreenCapture(body: Any) {}
    
    /// 注册jS call native 的方法名
    @objc public func registerJSCallNativeName() -> [String]? {
        
        return nil
    }
    
}


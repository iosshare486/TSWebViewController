# TSWebViewController 文档接口

### webViewController 配置
`htmlString`  webViewController的URL地址

`progressBackgroundColor` 进度条的颜色

## **Native和H5的常用交互**
### H5 调用 Native
#### 对应功能的方法名
1. 调用分享功能： `webCallShare`
2. 同步登录状态 (即h5登录成功后，传递token，同步登录状态)：`webCallLoginStatus`
3. 调用支付功能: `webCallPayment`
4. 统跳（包括跳转任意其他native页面，以及其他App、AppStore、或跳转手机设置等）: `webCallNativeRouter`
5. 关闭H5页面: `webCallClosePage`
6. 复制文字（主要用于复制微信号、QQ号等功能）: `webCallCopyText`
7. 异常交互（主要是H5页面刷新失败时调用）: `webCallError`
8. 支持下载apk (主Android) `webCallDownloadApk`
9. 截图功能 （尹博） `webCallScreenCapture`

####  使用方法

- 重写对应功能的方法，即可实现JS调用Native，暂时支持的功能参考 上述罗列的方法名

- 添加新的方法 重写一下两个方法即可

1. `public func jsCallNative(name: String, body: Any) `
>  重写该方法，注意添加 super.jsCallNative(name:name, body:body), 该方法是JS调用Native时调用
> 
>  name: 方法名
> 
>  body: 该方法传入参数

2. `public func registerJSCallNativeName() -> [String]?`
> 重写该方法 返回对应的方法名 ,该方法可以不使用super.registerJSCallNativeName()


### Native 调用 H5  方法名
#### 对应功能的方法名
1. 本地登录完成 同步H5登录信息: `nativeCallLoginInfo`
2. 本地调用H5页面刷新 : `nativeCallRefresh`
3. 分享完成通知H5页面: `nativeCallShareSuccess`
4. 清除H5缓存: `nativeCallClearCache`


####  使用方法
1.  使用默认方法时调用对应的方法即可，参考上述方法名
2.  `public func nativeCallWeb(funcName: String, body: String?, completionHandler: ((Any?, Error?) -> Void)?)`
> 如需添加新的方法名，使用该方法即可。
> 
> funcName: JS方法名
> 
> body: JS方法的参数
> 
> completionHandler: 调用方法后的回调

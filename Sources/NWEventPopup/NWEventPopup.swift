import UIKit
import WebKit
import HTMLString

public protocol OnNextWebPopupCallback {
    func OnNextWebPopup(scheme: String) -> Void
}

@objc
public class NWEventPopup : NSObject {
    
    private var popupCallback: OnNextWebPopupCallback?
    
    public static let shared = NWEventPopup()
    private var vc: UIViewController?
    private var showTime = 0.0
    
    @objc
    public func initLogger(_ obj:Any?, timer: Double = 7.0) {
        self.vc = obj as? UIViewController
        self.showTime = timer
    }
    
    @objc
    public func requestPopup(_ obj:Any?, paramMap:Dictionary<String, AnyObject>) {

        self.popupCallback = obj as? OnNextWebPopupCallback
        
        let defParams: String = "device_type=APP&ebm_type=event_chk&req_path=&req_type=json"
        var paramStr: String = LogBuilders().build(paramMap as! Dictionary<String, String>)
        if paramStr != "?" {
            paramStr += "&"
        }
                
        WebService.requestGetUrl(
            strURL: "\(AppConstants.getPopupUrl)\(paramStr)\(defParams)",
            parameters: [],
            success: { (task, response) -> Void in
                                                    
                if AppConstants.CONSOLE_LOG {
                    print("response:%@", response!);
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.showTime) {
                    if let vc = obj as? UIViewController, vc.isViewLoaded, vc.view.window != nil {
                        print("showPopup")

                        self.showPopup(vc: obj as? UIViewController, result: StringUtil.toDictionary(response as AnyObject))
                    }
                }
            },
            failure: { (task, error) -> Void in
                                                                        
                if AppConstants.CONSOLE_LOG {
                    print("got an error: \(String(describing: error))")
                }
        })
    }
    
    private func showPopup(vc: UIViewController?, result: Dictionary<String, String>) {
        
        guard var html = result["popup_html"], html.isEmpty == false else {
            print("found not html popup")
            return
        }
        
        let source = "var meta = document.createElement('meta');" + "meta.name = 'viewport';" + "meta.content='width=device-width, shrink-to-fit=yes, user-scalable=no;" + "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        let userContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        webConfiguration.userContentController = userContentController
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.contentScaleFactor = 1.0
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "NWEventPopup"

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        if #available(iOS 10.0, *) {
           webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        }
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.preferences = preferences
        webView.configuration.processPool = WKProcessPool()
        
        let popupCtrl = UIViewController()
        popupCtrl.view.addSubview(webView)
        
//        if let popup_resize = result["popup_resize"], popup_resize.isEmpty == false, popup_resize == "1" {
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: popupCtrl.view.topAnchor),
                webView.trailingAnchor.constraint(equalTo: popupCtrl.view.trailingAnchor),
                webView.leadingAnchor.constraint(equalTo: popupCtrl.view.leadingAnchor),
                webView.bottomAnchor.constraint(equalTo: popupCtrl.view.bottomAnchor)
            ])
//        } else {
//            if let width = result["width"], let height = result["height"] {
//                NSLayoutConstraint.activate([
//                    webView.centerXAnchor.constraint(equalTo: popupCtrl.view.centerXAnchor),
//                    webView.centerYAnchor.constraint(equalTo: popupCtrl.view.centerYAnchor),
//                    webView.widthAnchor.constraint(equalToConstant: CGFloat((width as NSString).floatValue)),
//                    webView.heightAnchor.constraint(equalToConstant: CGFloat((height as NSString).floatValue))
//                ])
//            } else {
//                NSLayoutConstraint.activate([
//                    webView.centerXAnchor.constraint(equalTo: popupCtrl.view.centerXAnchor),
//                    webView.centerYAnchor.constraint(equalTo: popupCtrl.view.centerYAnchor),
//                    webView.widthAnchor.constraint(equalToConstant: popupCtrl.view.bounds.size.width),
//                    webView.heightAnchor.constraint(equalToConstant: popupCtrl.view.bounds.size.height)
//                ])
//            }
//        }
        popupCtrl.modalPresentationStyle = .overCurrentContext
        
        html = html.removingPercentEncoding ?? ""
        html = html.removingHTMLEntities().replacingOccurrences(of: "+", with: " ")
        html = html.replacingOccurrences(of: "xtr_pop_html_plus", with: "+")
        webView.loadHTMLString(html, baseURL: URL(string: "https:"))
        vc?.present(popupCtrl, animated: true, completion: nil)
    }
}

extension NWEventPopup: WKUIDelegate {
    // MARK: WKUIDelegate
    //alert 처리
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {
            (action) in completionHandler()
            
        }))
        vc?.present(alertController, animated: true, completion: nil)
    }

    //confirm 처리
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {
            (action) in
            
            completionHandler(true)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: {
            (action) in completionHandler(false) }))
        
        vc?.present(alertController, animated: true, completion: nil)
            
    }

    //confirm 처리2
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in textField.text = defaultText }
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {
            (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            
            } else {
                completionHandler(defaultText)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(nil)
            
        }))
        vc?.present(alertController, animated: true, completion: nil)
        
    }
}

extension NWEventPopup: WKNavigationDelegate {
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("page finished load")
    }
    
    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation: \(navigation.debugDescription)")
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
    // 탐색을 허용할지 아니면 취소할지 결정(쿠키 설정)
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("decidePolicyForNavigationAction")
        
        var wkNavigationActionPolicy: WKNavigationActionPolicy = .cancel

        defer {
            decisionHandler(wkNavigationActionPolicy)
        }
        
        guard let url = navigationAction.request.url else {
            return
        }

        if (navigationAction.targetFrame == nil) {
            
            let app = UIApplication.shared
            if app.canOpenURL(url) {

                app.open(url, options: [:], completionHandler: nil)
                return
            }
        }
        
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
            } else {
                wkNavigationActionPolicy = .allow
            }
            return
        }
        
        if let scheme = navigationAction.request.url?.scheme,
           (!["http", "https", "file", "about"].contains(scheme)) {
            
            if (scheme.contains("nextweb") || (scheme.contains("lfmall"))) {
                vc?.dismiss(animated: true, completion: {
                    if url.absoluteString == "nextweb://close" {
                        print(url.absoluteString)
                    }
                    self.popupCallback?.OnNextWebPopup(scheme: url.absoluteString)
                })
                return
            }
            
            let app = UIApplication.shared
            if app.canOpenURL(url) {

                app.open(url, options: [:], completionHandler: nil)
                return
            }
        }
        
        wkNavigationActionPolicy = .allow
    }
}

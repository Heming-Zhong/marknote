//
//  VditorController.swift
//  iEdit
//
//  Created by 钟赫明 on 2020/9/29.
//

import Foundation
import WebKit


// MARK: - JavascriptFunction
typealias JavascriptCallback = (Result<Any?, Error>) -> Void

private struct JavascriptFunction {
    let functionString: String
    let callback: JavascriptCallback?
    
    init(functionString: String, callback: JavascriptCallback? = nil) {
        self.functionString = functionString
        self.callback = callback
    }
}

// MARK: - VditorController Coordinator

public class VditorController: NSObject {
    
    // MARK: Properties
    
    var parent: VditorView
    weak var webView: WKWebView?
    
    fileprivate var pageLoaded = false
    fileprivate var pendingFunctions = [JavascriptFunction]()
    
    init(_ parent: VditorView) {
        self.parent = parent
    }
    
    private func addFunction(function: JavascriptFunction) {
        pendingFunctions.append(function)
    }
    
    private func callJavascriptFunction(function: JavascriptFunction) {
        webView?.evaluateJavaScript(function.functionString) { (response, error) in
            if let error = error {
                function.callback?(.failure(error))
            }
            else {
                function.callback?(.success(response))
            }
        }
    }
    
    private func callPendingFunctions() {
        for function in pendingFunctions {
            callJavascriptFunction(function: function)
        }
        pendingFunctions.removeAll()
    }
    
    private func callJavascript(javascriptString: String, callback: JavascriptCallback? = nil) {
        if pageLoaded {
            callJavascriptFunction(function: JavascriptFunction(functionString: javascriptString, callback: callback))
        }
        else {
            addFunction(function: JavascriptFunction(functionString: javascriptString, callback: callback))
        }
    }
}

// MARK: - WKScriptMessageHandler Implementation

extension VditorController: WKScriptMessageHandler {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      print("didFinish")
      parent.onLoadSuccess?()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      print("didFail \(error.localizedDescription)")
      parent.onLoadFail?(error)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      print("didFailProvisionalNavigation")
      parent.onLoadFail?(error)
    }
}

// MARK: - WKNavigationDelegate Implementation

extension VditorController: WKNavigationDelegate {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // is Ready
        if message.name == VditorViewRPC.isReady {
            pageLoaded = true
            callPendingFunctions()
            return
        }
        
        // Content change
        if message.name == VditorViewRPC.textContentDidChange {
            print("updating")
            if parent.edited == false {
                parent.edited = true
            }
            return
        }
        
        // log output
        if message.name == VditorViewRPC.logHandler {
            print(message.body)
        }
    }
}

// MARK: - Public API

extension VditorController {
    public func setWebView(_ WebView: WKWebView) {
        self.webView = WebView
        setDefaultTheme()
        setTabInsertsSpaces(true)
    }
    
    func setTabInsertsSpaces(_ value: Bool) {
        callJavascript(javascriptString: "SetTabInsertSpaces(\(value));")
    }
    
    // deprecated method
    func initContent(_ value: String) {
        let script1 = "var container = document.getElementById('myTextarea')"
        let script2 = "container.value = String.raw`\(value)`;"
//        let script1 = "var init = String.raw`\(value)`;"
//        let script2 = "var model = monaco.editor.createModel(init, 'python');"
        let script = script1 + script2
        callJavascript(javascriptString: script)
    }
    
    func setContent(_ value: String) {
        if let hexString = value.data(using: .utf8)?.hexEncodedString() {
            let script = """
            var content = "\(hexString)";
            SetContent(content);
            """
            callJavascript(javascriptString: script)
        }
    }
    
    func getContent(_ block: JavascriptCallback?) {
        callJavascript(javascriptString: "GetContent();", callback: block)
    }
    
    func setMode(_ value: String) {
        callJavascript(javascriptString: "SetMode(\"\(value)\");")
    }
    
    func getMode(_ block: JavascriptCallback?) {
        callJavascript(javascriptString: "GetMode();", callback: block)
    }
    
    func setThemeName(_ value: String) {
        callJavascript(javascriptString: "SetTheme(\"\(value)\");")
    }
    
    func setFontSize(_ value: Int) {
        callJavascript(javascriptString: "SetFontSize(\(value));")
    }
    
    func setDefaultTheme() {
        setThemeName("vs-dark")
    }
    
    func setReadonly(_ value: Bool) {
        callJavascript(javascriptString: "SetReadOnly(\(value));")
    }
    
    func getTextSelection(_ block: JavascriptCallback?) {
        callJavascript(javascriptString: "GetTextSelection();", callback: block)
    }
}

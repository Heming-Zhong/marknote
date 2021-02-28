//
//  MonacoView.swift
//  iEdit
//
//  Created by 钟赫明 on 2020/9/29.
//

import Foundation
import SwiftUI
import WebKit

//#if os(iOS)
typealias RepresentableView = UIViewRepresentable
//#endif

public struct MonacoView: RepresentableView {
    
    @Binding var code: String
    
    var theme: MonacoTheme
//    var mode: CodeMode
//    var fontSize: Int
    @Binding var saving: Bool
    var edited = false
    
    var onLoadSuccess: (()->())?
    var onLoadFail: ((Error) -> ())?
    var onContentChange: ((String) -> ())?
    
    public init(theme:MonacoTheme = MonacoTheme.vscodedark, code: Binding<String>, saving: Binding<Bool>) {
        self._code = code
//        self.mode = mode
        self.theme = theme
        self._saving = saving
    }
    
    // Life Cycle
    
    // API for iOS
    public func makeUIView(context: Context) -> WKWebView {
        createWebView(context)
    }
    
    // for iOS
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if self.saving == true {
            context.coordinator.getContent({ result in
                switch result {
                    case .success(let resp):
                        guard let newcontent = resp as? String else { return }
                        self.code = newcontent
                        let data = self.code.data(using: .utf8)
                        print("saving")
                        print(self.code)
                        let tempwrapper = FileWrapper(regularFileWithContents: data!)
                        try! tempwrapper.write(to: (Openedfilelist.path)!, originalContentsURL: nil)
                    case .failure(let error):
                        print("Error \(error)")
                }
                self.saving = false
                return 
            })
        }
        else {
            updateWebView(context)
        }
    }
    
    public func makeCoordinator() -> MonacoController {
        MonacoController(self)
    }
    
}

// public API

extension MonacoView {
    public func onLoadSuccess(_ action: @escaping (() -> ())) -> Self {
        var copy = self
        copy.onLoadSuccess = action
        return copy
    }
    
    public func onLoadFail(_ action: @escaping ((Error) -> ())) -> Self {
        var copy = self
        copy.onLoadFail = action
        return copy
    }
    
    public func onContentChange(_ action: @escaping ((String) -> ())) -> Self {
        var copy = self
        copy.onContentChange = action
        return copy
    }
}

// Private API
extension MonacoView {
    private func createWebView(_ context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let userController = WKUserContentController()
        userController.add(context.coordinator, name: MonacoViewRPC.isReady)
        userController.add(context.coordinator, name: MonacoViewRPC.textContentDidChange)
        
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = userController
        
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        
        // iOS
        webView.isOpaque = false
        
        let MonacoBundle = try! Bundle.MonacoBundle()
        guard let indexPath = MonacoBundle.path(forResource: "Vditor/src/test", ofType: "html") else {
            fatalError("MonacoBundle is missing")
        }
        let path = URL(fileURLWithPath: indexPath)
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: indexPath))
        webView.loadFileURL(path, allowingReadAccessTo: path.deletingLastPathComponent())
        
        //webView.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: MonacoBundle.resourceURL!)
        
        context.coordinator.setWebView(webView)
//        context.coordinator.setThemeName(theme.rawValue)
        
//        context.coordinator.setMode(mode.rawValue)
        context.coordinator.setContent(code)
        //context.coordinator.initContent(code)
//        context.coordinator.setFontSize(fontSize)
        
        return webView
    }
    
    fileprivate func updateWebView(_ context: MonacoView.Context) {
//        update(elementGetter: context.coordinator.getMode(_:),
//               elementSetter: context.coordinator.setMode(_:),
//               currentElementState: self.mode.rawValue)
        
        update(elementGetter: context.coordinator.getContent(_:), elementSetter: context.coordinator.setContent(_:), currentElementState: self.code)
        
//        context.coordinator.setThemeName(self.theme.rawValue)
//        context.coordinator.setFontSize(fontSize)
               
    }
    func update(elementGetter: (JavascriptCallback?) -> Void,
                elementSetter: @escaping (_ elementState: String) -> Void,
                currentElementState: String) {
        print("updating webview...")
        elementGetter({ result in
            switch result {
                case .success(let resp):
                    guard let previousElementState = resp as? String else { return }
              
                    if previousElementState != currentElementState {
                        elementSetter(currentElementState)
                    }
              
                    return
                case .failure(let error):
                    print("Error \(error)")
                    return
            }
        })
    }
}



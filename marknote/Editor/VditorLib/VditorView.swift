//
//  VditorView.swift
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

public struct VditorView: RepresentableView {
    
    @EnvironmentObject var controller: VditorController
    @Binding var code: String // 视图中绑定的打开时数据（现在有点没必要了
    
    // TODO：主题自定义
//    var theme: MonacoTheme
    @Binding var edited: Bool
//    @State var edited = false
    
    var onLoadSuccess: (()->())?
    var onLoadFail: ((Error) -> ())?
    var onContentChange: ((String) -> ())?
    
//    public init(code: Binding<String>, edited: Binding<Bool>) {
//        self._code = code
////        self.theme = theme
//        self._edited = edited
//    }
    
    // Life Cycle
    
    // API for iOS
    // 创建视图
    public func makeUIView(context: Context) -> WKWebView {
        createWebView(context)
    }
    
    // for iOS
    // 在View的外部引用数据（@Binding或者是@Observed）发生变化时调用，
    // 用新的外部数据刷新视图
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // 有点没必要，需要修改
//        if self.saving == true {
//            context.coordinator.getContent({ result in
//                switch result {
//                    case .success(let resp):
//                        guard let newcontent = resp as? String else { return }
//                        self.code = newcontent
//                        let data = self.code.data(using: .utf8)
//                        print("saving")
//                        print(self.code)
//                        let tempwrapper = FileWrapper(regularFileWithContents: data!)
//                        try! tempwrapper.write(to: (Openedfilelist.path)!, originalContentsURL: nil)
//                    case .failure(let error):
//                        print("Error \(error)")
//                }
//                self.saving = false
//                return
//            })
//        }
//        else {
            updateWebView(context)
//        }
    }
    
    public func makeCoordinator() -> VditorController {
//        coordinator = VditorController(self)
        controller.parent = self
        coordinator = controller
//        coordinator = controller
        return controller
    }
    
}

// public API

extension VditorView {
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
extension VditorView {
    private func createWebView(_ context: Context) -> WKWebView {
        if controller.webView == nil {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            
            let userController = WKUserContentController()
            userController.add(context.coordinator, name: VditorViewRPC.isReady)
            userController.add(context.coordinator, name: VditorViewRPC.textContentDidChange)
            userController.add(context.coordinator, name: VditorViewRPC.logHandler)
            
            
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            configuration.userContentController = userController
            
            
    //        let webView = WKWebView(frame: .zero, configuration: configuration)
            let webView = VditorWebView(frame: .zero, configuration: configuration)
            webView.navigationDelegate = context.coordinator
            webView.scrollView.isScrollEnabled = false
            
            // iOS
            webView.isOpaque = false
            
            // 加载bundle资源文件
            let EditorBundle = try! Bundle.EditorBundle()
            guard let indexPath = EditorBundle.path(forResource: "Vditor/src/test", ofType: "html") else {
                fatalError("EditorBundle is missing")
            }
            let path = URL(fileURLWithPath: indexPath)
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: indexPath))
            webView.loadFileURL(path, allowingReadAccessTo: path.deletingLastPathComponent())
            
            // 构建WKWebView
            context.coordinator.setWebView(webView)
            // 调用setContent函数进行内容初始化
            context.coordinator.setContent(code)
    //        webView.addInputAccessoryView(toolbar: context.coordinator.getToolbar(height: 44))
            webView.accessoryView = context.coordinator.getToolbar(height: 44)
            return webView
        } else {
            return controller.webView!
        }
    }
    
    fileprivate func updateWebView(_ context: VditorView.Context) {
        // TODO: - 今后可能会加入其他文件的模式支持
//        update(elementGetter: context.coordinator.getMode(_:),
//               elementSetter: context.coordinator.setMode(_:),
//               currentElementState: self.mode.rawValue)
        
        // 这个更新，是以这个editor View中暂存的内容为标准进行的
        update(elementGetter: context.coordinator.getContent(_:), elementSetter: context.coordinator.setContent(_:), currentElementState: self.code)
        
        // TODO: - 今后可能会加入自定义主题的功能
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
              
                    if previousElementState != currentElementState && self.edited == false {
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




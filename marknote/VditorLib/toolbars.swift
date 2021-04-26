//
//  toolbars.swift
//  marknote
//
//  Created by 钟赫明 on 2021/3/30.
//

import Foundation
import UIKit
import SwiftUI
import WebKit

var ToolbarHandle: UInt8 = 0

// MARK: Add a InputAccesoryView to WKWebView
// Link: https://stackoverflow.com/questions/51837022/how-to-edit-accessory-view-of-keyboard-shown-from-wkwebview
extension WKWebView {
//    func addInputAccessoryView(toolbar: UIView?) {
//        guard let toolbar = toolbar else {return}
//        objc_setAssociatedObject(self, &ToolbarHandle, toolbar, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//        var candidateView: UIView? = nil
//        for view in self.scrollView.subviews {
//            let description : String = String(describing: type(of: view))
//            if description.hasPrefix("WKContent") {
//                candidateView = view
//                break
//            }
//        }
//        guard let targetView = candidateView else {return}
//        let newClass: AnyClass? = classWithCustomAccessoryView(targetView: targetView)
//
//        guard let targetNewClass = newClass else {return}
//
//        object_setClass(targetView, targetNewClass)
//    }
//
//    func classWithCustomAccessoryView(targetView: UIView) -> AnyClass? {
//        guard let _ = targetView.superclass else {return nil}
//        let customInputAccesoryViewClassName = "_CustomInputAccessoryView"
//
//        var newClass: AnyClass? = NSClassFromString(customInputAccesoryViewClassName)
//        if newClass == nil {
//            newClass = objc_allocateClassPair(object_getClass(targetView), customInputAccesoryViewClassName, 0)
//        } else {
//            return newClass
//        }
//
//        let newMethod = class_getInstanceMethod(WKWebView.self, #selector(WKWebView.getCustomInputAccessoryView))
//        class_addMethod(newClass.self, #selector(getter: WKWebView.inputAccessoryView), method_getImplementation(newMethod!), method_getTypeEncoding(newMethod!))
//
//        objc_registerClassPair(newClass!)
//
//        return newClass
//    }
//
//    @objc func getCustomInputAccessoryView() -> UIView? {
//        var superWebView: UIView? = self
//        while (superWebView != nil) && !(superWebView is WKWebView) {
//            superWebView = superWebView?.superview
//        }
//
//        guard let webView = superWebView else {return nil}
//
//        let customInputAccessory = objc_getAssociatedObject(webView, &ToolbarHandle)
//        return customInputAccessory as? UIView
//    }
}

/// get ability to set inputAccessoryView (bar above the soft keyboard) of WKWebView
class VditorWebView: WKWebView {
    var accessoryView: UIView?
    override var inputAccessoryView: UIView? {
        return accessoryView
    }
}

// MARK: Keyboard Toolar Config
extension VditorController {
    
    
    func getToolbar(height: Int) -> UIView? {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: 3200, height: height)
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor(.purple)
//        toolBar.barTintColor = UIColor.blue

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onToolbarDoneClick(sender:)) )
        
        let BoldButton = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: self, action: #selector(onToolbarBoldClick(sender:)))
        let ItalicButton = UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: self, action: #selector(onToolbarItalicClick(sender:)))
        let StrikeButton = UIBarButtonItem(image: UIImage(systemName: "strikethrough"), style: .plain, target: self, action: #selector(onToolbarStrikeClick(sender:)))
        let Header1Button = UIBarButtonItem(title: "H1", style: .plain, target: self, action: #selector(onToolbarHeader1Click(sender:)))
        let Header2Button = UIBarButtonItem(title: "H2", style: .plain, target: self, action: #selector(onToolbarHeader2Click(sender:)))
        let Header3Button = UIBarButtonItem(title: "H3", style: .plain, target: self, action: #selector(onToolbarHeader3Click(sender:)))
        let Header4Button = UIBarButtonItem(title: "H4", style: .plain, target: self, action: #selector(onToolbarHeader4Click(sender:)))
        let Header5Button = UIBarButtonItem(title: "H5", style: .plain, target: self, action: #selector(onToolbarHeader5Click(sender:)))
        let Header6Button = UIBarButtonItem(title: "H6", style: .plain, target: self, action: #selector(onToolbarHeader6Click(sender:)))
        let UnorderedListButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(onToolbarUnorderedListClick(sender:)))
        let OrderedListButton = UIBarButtonItem(image: UIImage(systemName: "list.number"), style: .plain, target: self, action: #selector(onToolbarOrderedListClick(sender:)))
        let CheckListButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.square"), style: .plain, target: self, action: #selector(onToolbarCheckListClick(sender:)))
        let IndentButton = UIBarButtonItem(image: UIImage(systemName: "increase.indent"), style: .plain, target: self, action: #selector(onToolbarIndentClick(sender:)))
        let OutdentButton = UIBarButtonItem(image: UIImage(systemName: "decrease.indent"), style: .plain, target: self, action: #selector(onToolbarOutdentClick(sender:)))
        let QuoteButton = UIBarButtonItem(image: UIImage(systemName: "text.quote"), style: .plain, target: self, action: #selector(onToolbarQuoteClick(sender:)))
        let LineButton = UIBarButtonItem(title: "——", style: .plain, target: self, action: #selector(onToolbarLineClick(sender:)))
        let CodeBlockButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left.slash.chevron.right"), style: .plain, target: self, action: #selector(onToolbarCodeBlockClick(sender:)))
        let InlineCodeButton = UIBarButtonItem(title: "< >", style: .plain, target: self, action: #selector(onToolbarInlineCodeClick(sender:)))
        let TableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: self, action: #selector(onToolbarTableClick(sender:)))
        let UndoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(onToolbarUndoClick(sender:)))
        let RedoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward"), style: .plain, target: self, action: #selector(onToolbarRedoClick(sender:)))
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil )
        
        toolBar.setItems([
            BoldButton,
            ItalicButton,
            StrikeButton,
            Header1Button,
            Header2Button,
            Header3Button,
            Header4Button,
            Header5Button,
            Header6Button,
            UnorderedListButton,
            OrderedListButton,
            CheckListButton,
            IndentButton,
            OutdentButton,
            QuoteButton,
            LineButton,
            CodeBlockButton,
            InlineCodeButton,
            TableButton,
            UndoButton,
            RedoButton,
//            flexibleSpaceItem,
            doneButton
        ], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let toolBarScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 3200, height: height))
        toolBarScrollView.frame = toolBar.frame

        toolBarScrollView.showsHorizontalScrollIndicator = false
        toolBarScrollView.showsVerticalScrollIndicator = false
        toolBarScrollView.alwaysBounceVertical = false
        toolBarScrollView.backgroundColor = .clear
        toolBarScrollView.contentSize = CGSize(width: 1000, height: height)
        

        toolBar.sizeToFit()
        toolBarScrollView.addSubview(toolBar)
        toolBarScrollView.sizeToFit()
        return toolBarScrollView
    }

    // MARK: @objc func
    
    @objc func onToolbarBoldClick(sender: UIBarButtonItem) {
        self.setBold()
    }
    
    @objc func onToolbarItalicClick(sender: UIBarButtonItem) {
        self.setItalic()
    }
    
    @objc func onToolbarStrikeClick(sender: UIBarButtonItem) {
        self.setStrike()
    }
    
    @objc func onToolbarHeader1Click(sender: UIBarButtonItem) {
        self.setHeader1()
    }
    
    @objc func onToolbarHeader2Click(sender: UIBarButtonItem) {
        self.setHeader2()
    }
    
    @objc func onToolbarHeader3Click(sender: UIBarButtonItem) {
        self.setHeader3()
    }
    
    @objc func onToolbarHeader4Click(sender: UIBarButtonItem) {
        self.setHeader4()
    }
    
    @objc func onToolbarHeader5Click(sender: UIBarButtonItem) {
        self.setHeader5()
    }
    
    @objc func onToolbarHeader6Click(sender: UIBarButtonItem) {
        self.setHeader6()
    }
    
    @objc func onToolbarUnorderedListClick(sender: UIBarButtonItem) {
        self.setUnorderedList()
    }
    
    @objc func onToolbarOrderedListClick(sender: UIBarButtonItem) {
        self.setOrderedList()
    }
    
    @objc func onToolbarCheckListClick(sender: UIBarButtonItem) {
        self.setCheckList()
    }
    
    @objc func onToolbarIndentClick(sender: UIBarButtonItem) {
        self.setIndent()
    }
    
    @objc func onToolbarOutdentClick(sender: UIBarButtonItem) {
        self.setOutdent()
    }
    
    @objc func onToolbarQuoteClick(sender: UIBarButtonItem) {
        self.setQuote()
    }
    
    @objc func onToolbarLineClick(sender: UIBarButtonItem) {
        self.setLine()
    }
    
    @objc func onToolbarCodeBlockClick(sender: UIBarButtonItem) {
        self.setCodeBlock()
    }
    
    @objc func onToolbarInlineCodeClick(sender: UIBarButtonItem) {
        self.setInlineCode()
    }
    
    @objc func onToolbarTableClick(sender: UIBarButtonItem) {
        self.setTable()
    }
    
    @objc func onToolbarUndoClick(sender: UIBarButtonItem) {
        self.setUndo()
    }
    
    @objc func onToolbarRedoClick(sender: UIBarButtonItem) {
        self.setRedo()
    }
    
    @objc func onToolbarDoneClick(sender: UIBarButtonItem) {
        webView?.resignFirstResponder()
    }
}


extension ContentView {
    var TopToolBarLeading: some View {
            HStack {
                Button(action: {
                    withAnimation {
                        if offset == CGFloat(-320) {
                            offset = CGFloat(0)
                        }
                        else {
                            offset = CGFloat(-320)
                        }
                    }
                }, label: {
                    Image(systemName: "sidebar.left")
                })
            }
    }
    
    var TopToolBarPrincipal: some View {
        HStack {
            Text(Openedfilelist.name).font(.headline)
            if self.Openedfilelist.edited == true {
                Text(" - 已编辑")
                    .font(.subheadline)
                    .frame(width: nil, height: nil, alignment: .center)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .cornerRadius(1.5)
            }
            else {
                EmptyView()
            }
        }
    }
}

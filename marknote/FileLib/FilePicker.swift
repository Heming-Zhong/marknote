//
//  FilePicker.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

// MARK: - 获取外部文件访问权限的视图，基于UIKit实现，封装成一个SwiftUI视图
struct FilePickerController: UIViewControllerRepresentable {
    var callback: (URL) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Update the controller
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
        print("View controller updated")
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        print("Making the picker")
        let controller = UIDocumentPickerViewController.init(forOpeningContentTypes: [UTType.folder])
        controller.directoryURL = FileManager.default.urls(for: .coreServiceDirectory, in: .allDomainsMask).first!
//        print("dir:\(controller.directoryURL)")
        controller.delegate = context.coordinator
//        print("Setup the delegate \(context.coordinator)")
        
        return controller
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerController
        
        init(_ pickerController: FilePickerController) {
            self.parent = pickerController
//            print("Setup a parent")
//            print("Callback: \(parent.callback)")
        }
       
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            print("dirurl\(controller.directoryURL)")
//            print("Selected a document: \(urls[0])")
            parent.callback(urls[0])
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was thrown away :(")
        }
    }
}

// MARK: - 对FilePicker Controller的外部SwiftUI封装
struct PickerView: View {
    var callback: (URL) -> ()
    var body: some View {
        FilePickerController(callback: callback)
    }
}

extension MainView {
    // MARK: - 选取外部文件夹，并保存到书签
    func filePicked(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Error: no permission")
            return
        }
        let bookmarkData = try! url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let bookmarkurl = documentsUrl?.appendingPathComponent(".book")
        try! bookmarkData.write(to: bookmarkurl!)
        
        
        Openedfilelist.reset()
        let Dir = fileitems(name: url.lastPathComponent, path: url)
        let allitems = traversesubfiles(root: Dir)
        
        DirOpened.files = allitems
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        print("Filename: \(DirOpened.files)")
        withAnimation {
            if offset == CGFloat(-320) {
                offset = CGFloat(0)
            }
        }
    }
}

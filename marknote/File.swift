//
//  File.swift
//  用于控制后台的文件相关数据的管理
//
//  Created by 钟赫明 on 2020/10/11.
//

import Foundation
import SwiftUI
import MobileCoreServices
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
        print("dir:\(controller.directoryURL)")
        controller.delegate = context.coordinator
        print("Setup the delegate \(context.coordinator)")
        
        return controller
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerController
        
        init(_ pickerController: FilePickerController) {
            self.parent = pickerController
            print("Setup a parent")
            print("Callback: \(parent.callback)")
        }
       
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("dirurl\(controller.directoryURL)")
            print("Selected a document: \(urls[0])")
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

#if DEBUG
struct PickerView_Preview: PreviewProvider {
    static var previews: some View {
        func filePicked(_ url: URL) {
            print("Filename: \(url)")
        }
        return PickerView(callback: filePicked)
            .aspectRatio(3/2, contentMode: .fit)
    }
}
#endif




struct filecontent: Identifiable {
    var id = UUID()
    var path: URL? = nil
    var content: String = ""
}

// MARK: - 对于打开的文件的相关信息的全局保存
// TODO: - 应该要改个名，在marknote中没必要实现Tab机制
class Tabitem: ObservableObject {
    @Published var path: URL? = nil // 打开的这个文件的URL
    @Published var content: String = "" // 打开的这个文件的内容（打开时的，不是最新的）
    @Published var edited: Bool = false // 文件内容相比打开时是否发生了变化
    @Published var name: String = ""    // 用于显示的文件名
    
    func settabs(url: URL?) {
        // 切换时已经存在coordinator，说明有打开文件，需要先保存
        if coordinator != nil {
            // 调用getContent 更新内容并保存
            coordinator?.getContent({ [self] result in
                switch result {
                    case .success(let resp):
                        guard let newcontent = resp as? String else { return }
                        content = newcontent
                        if path != nil {
                            let saving_data = self.content.data(using: .utf8)
                            let tempwrapper = FileWrapper(regularFileWithContents: saving_data!)
                            try! tempwrapper.write(to: (Openedfilelist.path)!, originalContentsURL: nil)
                        }
//                        print(parent.code)
                    case .failure(let error):
                        print("auto save Error: \(error)")
                }
                if url != nil {
                    // add a record to self.file
                    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    let bookmark = documentsUrl?.appendingPathComponent(".book")
                    let bookmarkData = try! Data(contentsOf: bookmark!)
                    
                    var isStale = false
                    let mark = try! URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
                    guard mark.startAccessingSecurityScopedResource() else {
                        print("Error: no permission")
                        return
                    }
                    
                    defer { mark.stopAccessingSecurityScopedResource() }
                    let wrapper = try! FileWrapper(url: url!)
                    let doc = String(data: wrapper.regularFileContents!, encoding: .utf8)
                    print(doc)
                    self.path = url
                    self.content = doc ?? ""
                    self.edited = false
                    self.name = url?.lastPathComponent ?? ""
                }
                return
            })
        }
        else {
            if url != nil {
                // add a record to self.file
                let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let bookmark = documentsUrl?.appendingPathComponent(".book")
                let bookmarkData = try! Data(contentsOf: bookmark!)

                var isStale = false
                let mark = try! URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
                guard mark.startAccessingSecurityScopedResource() else {
                    print("Error: no permission")
                    return
                }

                defer { mark.stopAccessingSecurityScopedResource() }
                let wrapper = try! FileWrapper(url: url!)
                let doc = String(data: wrapper.regularFileContents!, encoding: .utf8)
                self.path = url
                self.content = doc ?? ""
                self.edited = false
                self.name = url?.lastPathComponent ?? ""
            }
        }
    }
    
    func reset() {
//        file = nil
        self.path = nil
        self.content = ""
    }
}
var Openedfilelist = Tabitem()

// 用来表示目录项
struct fileitems: Identifiable{
    var id = UUID()
    var name: String = ""
    var path: URL? = nil
    var children: [fileitems]? = nil
    var icon: String = ""
    var renaming: Bool = false
}

// 打开的目录
class TargetDir: ObservableObject {
    @Published var files: fileitems = fileitems()
}

var DirOpened = TargetDir()



// MARK: - 遍历所有子文件和目录
func traversesubfiles(root: fileitems) -> fileitems {
    let manager = FileManager.default
    let rooturl = root.path!
    var res = root
    // if root points a directory
    if res.path?.hasDirectoryPath == true {
        res.icon = "folder"
        res.children = []
    }
    // if root points a file
    else {
        res.icon = "doc"
        return res
    }
    
    // contents of root
    let sublist = try! manager.contentsOfDirectory(at: rooturl, includingPropertiesForKeys: [URLResourceKey.nameKey], options: .skipsHiddenFiles)
    
    // recurse
    for ele in sublist {
        let item = fileitems(name: ele.lastPathComponent, path: ele)
        let all = traversesubfiles(root: item)
        res.children?.append(all)
    }
    
    return res
}

var coordinator: MonacoController? = nil // md深井冰....

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
                            try! tempwrapper.write(to: (self.path)!, originalContentsURL: nil)
                            self.edited = false
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

extension fileitems: Comparable {
    static func < (lhs: fileitems, rhs: fileitems) -> Bool {
        return lhs.name < rhs.name
    }
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
    res.children?.sort(by: <)
    
    return res
}

var coordinator: VditorController? = nil // md深井冰....

func savefile() {
    print("saving")
    if Openedfilelist.path != nil {
        coordinator?.getContent({result in
            switch result {
                case .success(let resp):
                    guard let newcontent = resp as? String else { return }
                    Openedfilelist.content = newcontent
                    if Openedfilelist.path != nil {
                        let saving_data = Openedfilelist.content.data(using: .utf8)
                        let tempwrapper = FileWrapper(regularFileWithContents: saving_data!)
                        try! tempwrapper.write(to: (Openedfilelist.path)!, originalContentsURL: nil)
                        Openedfilelist.edited = false
                    }
                    
                case .failure(let error):
                    print("auto save Error: \(error)")
            }
        })
    }
}

// MARK: - 重命名
func renamecallback(cur: inout fileitems) {
    cur.renaming = true
}

func setcontextid(item: fileitems) {
    selectedid = item.id
    setfileitems(id: selectedid, cur: &DirOpened.files, callback: renamecallback)
}

func setfileitems(id: UUID?, cur: inout fileitems, callback: (_ cur: inout fileitems) -> ()) {
    if cur.id == id {
//        cur.renaming = true
        callback(&cur)
    }
    else {
        if cur.children != nil {
            for i in 0..<cur.children!.count {
                setfileitems(id: id, cur: &cur.children![i], callback: callback)
            }
        }
    }
}


// MARK: - 创建文件
func newfilecallback(cur: inout fileitems) {
    let item = fileitems(name: "Untitled.md", path: cur.path?.appendingPathComponent("Untitled.md", isDirectory: false), icon: "doc", renaming: true)

    print(item.path)
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
    
    let _string = ""
    if let data = _string.data(using: .utf8) {
        do {
            try data.write(to: item.path!)
            print("[SUCCESS] new file created")
        } catch {
            print("[ERROR] new file failed...")
            print(error)
            defer {
                cur.path!.stopAccessingSecurityScopedResource()
            }
            return
        }
    }
    
    cur.children?.append(item)
    cur.children?.sort(by: <)
}

func addnewfileAt(item: fileitems) -> Bool {
    setfileitems(id: item.id, cur: &DirOpened.files, callback: newfilecallback)
    return true
}

// MARK: - 创建文件夹
func newfoldercallback(cur: inout fileitems) {
    let item = fileitems(name: "Untitled", path: cur.path?.appendingPathComponent("Untitled", isDirectory: true), children: [], icon: "folder", renaming: true)
    print(item.path)
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
    
    
    let manager = FileManager.default
    do {
        try manager.createDirectory(at: item.path!, withIntermediateDirectories: false, attributes: nil)
        print("[SUCCESS] new folder created")
    } catch {
        print("[ERROR] new folder create failed: \(error)")
        return
    }
    
    cur.children?.append(item)
    cur.children?.sort(by: <)
}

func addnewfolderAt(item: fileitems) {
    setfileitems(id: item.id, cur: &DirOpened.files, callback: newfoldercallback)
}

// MARK: - 删除项目
func rmitemcallback(cur: inout fileitems, index: Int) {
    print(cur.children![index].path)
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
    let manager = FileManager.default
    do {
        try manager.removeItem(at: cur.children![index].path!)
        print("[SUCCESS] remove item success")
    } catch {
        print("[ERROR] remove item failed: \(error)")
        return
    }
    cur.children?.remove(at: index)
}

func rmitems(id: UUID?, cur: inout fileitems, callback: (_ cur: inout fileitems, _ index: Int) -> ()) {
    if cur.children != nil {
        for i in 0..<cur.children!.count {
            // 删除成功后children长度发生变化，所以要实时判断是否越界
            if i >= cur.children!.count {
                break
            }
            if cur.children![i].id == id {
                callback(&cur, i)
            }
            if i < cur.children!.count {
                rmitems(id: id, cur: &cur.children![i], callback: callback)
            }
        }
    }
}

func removeitemAt(item: fileitems) -> Bool {
    rmitems(id: item.id, cur: &DirOpened.files, callback: rmitemcallback)
    return true
}

func setsubpath(cur: inout fileitems) {
    if cur.children != nil {
        for i in 0..<cur.children!.count {
            cur.children![i].path = cur.path?.appendingPathComponent(cur.children![i].name)
            setsubpath(cur: &cur.children![i])
        }
    }
}

// MARK: - 重新设置名称
func findandsetname(id: UUID?, cur: inout fileitems, newname: String) {
    if cur.id == id {
        cur.renaming = false
        let manager = FileManager.default
        
        let old = cur.path
        let new = cur.path?.deletingLastPathComponent().appendingPathComponent(newname)
        let parent = cur.path?.deletingLastPathComponent()
        
        // gain folder access
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
        
        do {
            try manager.moveItem(at: old!, to: new!)
        } catch {
            print("[ERROR] rename file failed...\(error)")
            return
        }
        
        cur.path = new
        cur.name = newname
        // file or folder
        if cur.children == nil {
            // 如果要更新的文件名是当前打开的文件
            if old == Openedfilelist.path {
                Openedfilelist.path = new
            }
            print("[SUCCESS] rename file success...")
        }
        else {
            /*
                注意：为什么重命名文件和目录要分开？
                重命名目录还涉及到对于目录下的所有项
                在DirOpened中的记录进行修改，否则会
                导致这些项的后续操作出错
            */
            setsubpath(cur: &cur)
            print("[SUCCESS] rename folder success...")
        }
        
    }
    else {
        if cur.children != nil {
            for i in 0..<cur.children!.count {
                findandsetname(id: id, cur: &cur.children![i], newname: newname)
            }
        }
    }
}

func setname(name: String, item: fileitems) -> Bool {
    if name == "" {
        // invalid name, do noting
        return false
    }
    else {
        findandsetname(id: item.id, cur: &DirOpened.files, newname: name)
    }
    print(name)
    return true
}

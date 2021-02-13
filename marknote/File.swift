//
//  File.swift
//  filemenu
//
//  Created by 钟赫明 on 2020/10/11.
//

import Foundation
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct FilePickerController: UIViewControllerRepresentable {
    var callback: (URL) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerController>) {
        print("View controller updated")
        // Update the controller
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        print("Making the picker")
        let controller = UIDocumentPickerViewController.init(forOpeningContentTypes: [UTType.folder])
        // let controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeFolder)], in: .open)
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
        /*
        deinit {
            print("Coordinator going away")
        }*/
    }
}

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

/*
struct fileitem: Hashable, Identifiable, Codable{
    var id: Self { self }
    var name: String
    var path: URL?
    var isfile: Bool
}*/




struct filecontent: Identifiable {
    var id = UUID()
    var path: URL? = nil
    var content: String = ""
//    var view: EditorView
}

class Tabitem: ObservableObject {
//    @Published var file: filecontent? = nil
    @Published var path: URL? = nil
    @Published var content: String = ""
    
    func settabs(url: URL?) {
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
//            let tempview = EditorView(document: doc ?? "", fileURL: url, fontSize: 18, fontFamily: "Fira Code")
//            let content = filecontent(path: url, content: doc ?? "")
            self.path = url
            self.content = doc ?? ""
        
//            self.file = content
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

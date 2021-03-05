//
//  ContentView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/1/31.
//

import Foundation
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

var selectedid: UUID? = nil
var input = ""

func setsubpath(cur: inout fileitems) {
    if cur.children != nil {
        for i in 0..<cur.children!.count {
            cur.children![i].path = cur.path?.appendingPathComponent(cur.children![i].name)
            setsubpath(cur: &cur.children![i])
        }
    }
}

func findandsetname(id: UUID?, cur: inout fileitems, newname: String) {
    if cur.id == id {
        cur.renaming = false
        let manager = FileManager.default
        
        let old = cur.path
        let new = cur.path?.deletingLastPathComponent().appendingPathComponent(newname)
        
        do {
            try manager.moveItem(at: old!, to: new!)
        } catch {
            print("[ERROR] rename file failed...")
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

// MARK: - 主页面视图
struct ContentView: View {
    
    
    // MARK: - 选取外部文件夹，并保存到书签
    func filePicked(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Error: no permission")
            return
        }
        let bookmarkData = try! url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let bookmarkurl = documentsUrl?.appendingPathComponent(".book")
        print(bookmarkurl)
        try! bookmarkData.write(to: bookmarkurl!)
        
        
        Openedfilelist.reset()
        let Dir = fileitems(name: url.lastPathComponent, path: url)
        let allitems = traversesubfiles(root: Dir)
        
        DirOpened.files = allitems
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        print("Filename: \(DirOpened.files)")
    }
       
    @State var url = ""
    @State var showpop = false
    @ObservedObject var DirOpened: TargetDir
    @ObservedObject var Openedfilelist: Tabitem
    var root:URL?

    @State var tag:Int? = 0
    
    
    
    
    var body: some View {
        HStack {
            NavigationView {
                List([self.DirOpened.files], children: \.children) {
                    item in
                    if(item.icon == "doc") {
                        Button(action: {
                            print("pressed")
                            Openedfilelist.settabs(url: item.path)
                        }, label: {
                            HStack {
                                Image(systemName: item.icon)
                                if item.renaming {
                                    TextField(item.name, text: .init(
                                        get:{ item.name },
                                        set: { input = $0}
                                    ), onCommit: {
                                        setname(name: input, item: item)
                                    })
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                }
                                else {
                                    Text(item.name)
                                }
                            }
                        }).contextMenu{
                            filecontext(item: item)
                        }
                    }
                    else {
                        empty(item: item, DirOpened: DirOpened)
                            .contextMenu {
                                foldercontext(item: item)
                            }
                    }
                }
                .navigationBarTitle("打开的目录")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button(action: {showpop.toggle()}, label: {
                                Image(systemName: "folder.badge.gear")
                            }).sheet(isPresented: $showpop, content: {
                                PickerView(callback: filePicked)
                            })
                            .padding()
                            .hoverEffect()
                            .keyboardShortcut("o", modifiers: [.command])
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                            })
                            .padding()
                            .hoverEffect()
                            .keyboardShortcut("r", modifiers: [.command])
                        }

                    }
                }
                body1
            }.accentColor(.purple)
            
        }
        .statusBar(hidden: true)
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
    let _string = ""
    if let data = _string.data(using: .utf8) {
        do {
            try data.write(to: item.path!)
            print("[SUCCESS] new file created")
        } catch {
            print("[ERROR] new file failed...")
            print(error)
            return
        }
    }
    cur.children?.append(item)
}

func addnewfileAt(item: fileitems) -> Bool {
    setfileitems(id: item.id, cur: &DirOpened.files, callback: newfilecallback)
    return true
}

// MARK: - 创建文件夹
func newfoldercallback(cur: inout fileitems) {
    let item = fileitems(name: "Untitled", path: cur.path?.appendingPathComponent("Untitled", isDirectory: true), children: [], icon: "folder", renaming: true)
    print(item.path)
    let manager = FileManager.default
    do {
        try manager.createDirectory(at: item.path!, withIntermediateDirectories: false, attributes: nil)
        print("[SUCCESS] new folder created")
    } catch {
        print("[ERROR] new folder create failed: \(error)")
        return
    }
    cur.children?.append(item)
}

func addnewfolderAt(item: fileitems) {
    setfileitems(id: item.id, cur: &DirOpened.files, callback: newfoldercallback)
}

// MARK: - 删除项目
func rmitemcallback(cur: inout fileitems, index: Int) {
    print(cur.children![index].path)
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

// MARK: - ContentView扩展：编辑器视图管理
extension ContentView {
    
    // MARK: - 文件项的右键/长按操作菜单
    struct filecontext: View {
        var item: fileitems
        var body: some View {
            Group {
                Button(action: {
                    print("rename file started...")
                    setcontextid(item: item)
                }, label: {
                    Text("重命名")
                    Image(systemName: "pencil")
                })
                Button(action: {
                    print("delete file started...")
                    removeitemAt(item: item)
                }, label: {
                    Text("删除")
                    Image(systemName: "trash")
                })
            }
        }
    }

    // MARK: - 目录项的右键/长按操作菜单
    struct foldercontext: View {
        var item: fileitems
        var body: some View {
            Group {
                Button(action: {
                    print("rename folder stared...")
                    setcontextid(item: item)
                }, label: {
                    Text("重命名")
                    Image(systemName: "pencil")
                })
                Button(action: {
                    print("delete folder started...")
                    removeitemAt(item: item)
                }, label: {
                    Text("删除")
                    Image(systemName: "trash")
                })
                Button(action: {
                    print("new folder started...")
                    addnewfolderAt(item: item)
                }, label: {
                    Text("新建文件夹")
                    Image(systemName: "folder.badge.plus")
                })
                Button(action: {
                    print("new file started...")
                    addnewfileAt(item: item)
                }, label: {
                    Text("新建文件")
                    Image(systemName: "doc.badge.plus")
                })
            }
        }
    }


    
    func buildeditor() -> AnyView {
        return AnyView( EditorView(document: self.$Openedfilelist.content,edited: self.$Openedfilelist.edited, fileURL: self.Openedfilelist.path) )
    }
    
    // MARK: - 编辑器视图
    var body1: some View {
        VStack {
            if Openedfilelist.path != nil {
                self.buildeditor()
            }
        }
        .navigationTitle(Openedfilelist.name)
        .navigationBarItems(trailing:
                HStack {
                    Button("save") {
                        if self.Openedfilelist.path != nil {
                            coordinator?.getContent({result in
                                switch result {
                                    case .success(let resp):
                                        guard let newcontent = resp as? String else { return }
                                        Openedfilelist.content = newcontent
                                        if Openedfilelist.path != nil {
                                            let saving_data = Openedfilelist.content.data(using: .utf8)
                                            let tempwrapper = FileWrapper(regularFileWithContents: saving_data!)
                                            try! tempwrapper.write(to: (Openedfilelist.path)!, originalContentsURL: nil)
                                            self.Openedfilelist.edited = false
                                        }
                                        
                                    case .failure(let error):
                                        print("auto save Error: \(error)")
                                }
                            })
                        }
                    }
                    .padding()
                    .hoverEffect()
                    .keyboardShortcut("s", modifiers: [.command])
                }
            )
        .navigationBarTitleDisplayMode(.inline)
    }
    struct empty: View {
        var item: fileitems
        @ObservedObject var DirOpened: TargetDir
        var body: some View {
            HStack {
                Image(systemName: item.icon)
                if item.renaming {
                    TextField(item.name, text: .init(
                        get:{ item.name },
                        set: { input = $0 }
                    ), onCommit: {
                        setname(name: input, item: item)
                    })
                    .background(Color.gray.opacity(0.2))
                    .padding(5)
                }
                else {
                    Text(item.name)
                }
            }
        }
    }
}


// MARK: - EditorView：显示指定内容的Markdown编辑器
struct EditorView: View {
    @Binding var document: String
    @Binding var edited: Bool
    var fileURL: URL?
    var body: some View {
        VStack {
            VditorView(code: $document, edited: $edited)
        }
    }
}


func filemode(fileURL: URL?) -> CodeMode {
    let path = fileURL?.pathExtension
    print("\(fileURL)")
    var mode = CodeMode.text
    switch path {
    case "sh":
        mode = CodeMode.shell
        break
    case "py":
        mode = CodeMode.python
        break
    case "cpp":
        mode = CodeMode.c_cplus
        break
    case "c":
        mode = CodeMode.c_cplus
        break
    case "js":
        mode = CodeMode.javascript
    case "swift":
        mode = CodeMode.swift
    default:
        mode = CodeMode.text
    }
    return mode
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(DirOpened: DirOpened, Openedfilelist: Openedfilelist, root: nil)
    }
}

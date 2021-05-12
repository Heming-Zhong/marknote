//
//  FileContext.swift
//  marknote
//
//  Created by 钟赫明 on 2021/3/31.
//

import Foundation
import SwiftUI

// MARK: - ContentView扩展：编辑器视图管理
extension MainView {
    
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
                        .foregroundColor(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                })
            }
        }
    }

    // MARK: - 目录项的右键/长按操作菜单
    struct foldercontext: View {
        @Environment(\.managedObjectContext) var viewContext
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
                        .foregroundColor(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
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
                Button(action: {
                    addtoBookmark(item: item)
                }, label: {
                    Text("加入书签")
                        .foregroundColor(.purple)
                    Image(systemName: "bookmark")
                        .foregroundColor(.purple)
                })
            }
        }
        
        func addtoBookmark(item: fileitems) -> Bool {
            // get permission
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let bookmark = documentsUrl?.appendingPathComponent(".book")
            let bookmarkData = try! Data(contentsOf: bookmark!)
            var isStale = false
            let mark = try! URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
            guard mark.startAccessingSecurityScopedResource() else {
                print("Error: no permission")
                return false
            }
            defer { mark.stopAccessingSecurityScopedResource() }
            
            var data: Data?
            do {
                try data = item.path?.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            }
            catch {
                print("[ERROR] cannot generate BookMarkData!")
                return false
            }
            let newmark = BookMarks(context: viewContext)
            newmark.name = item.name
            newmark.data = data
            do {
                try viewContext.save()
            }
            catch {
                let nsError = error as NSError
                fatalError("[ERROR] Core Data saving: \(nsError)")
                return false
            }
            return true
        }
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: nil, height: nil, alignment: .center)
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


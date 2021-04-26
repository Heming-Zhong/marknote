//
//  sidebarView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/4/3.
//

import Foundation
import SwiftUI

extension ContentView {
    func loadMark(mark: BookMarks) {
        var isStale = true
        var url: URL!
        do {
            url = try URL(resolvingBookmarkData: mark.data!, bookmarkDataIsStale: &isStale)
        }
        catch {
            print("[ERROR] unable to fetch bookmark from CoreData: \(error)")
        }
        filePicked(url)
    }

    
    // MARK: - 侧边栏视图
    var sidebar: some View {
        List {
            Section(header: Text("收藏的目录")) {
                ForEach(Marks) { mark in
                    Button(mark.name ?? "") {
                        loadMark(mark: mark)
                    }
                    .contextMenu {
                        Button(action: {
                            viewContext.delete(mark)
                            do {
                                try viewContext.save()
                            }
                            catch {
                                let nsError = error as NSError
                                fatalError("[ERROR] Core Data saving: \(nsError)")
                            }
                        }, label: {
                            Text("取消")
                                .accentColor(.red)
                            Image(systemName: "bookmark.slash")
                                .accentColor(.red)
                        })
                    }
                }
            }
            Section(header: Text("打开的目录")) {
                OpenedFileTree
            }
            
        }
        .listStyle(SidebarListStyle())
        .navigationBarTitle("文件与目录")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                TopToolBarLeading
            }
//            ToolbarItem(placement: .navigation) {
//                navitool
//                    .hidden()
//            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    var OpenedFileTree: some View {
        OutlineGroup([self.DirOpened.files], children: \.children) {
            item in
            if(item.icon == "doc") {
                Button(action: {
                    print("pressed")
                    Openedfilelist.settabs(url: item.path)
                    
                    withAnimation {
                        if offset == CGFloat(-320) {
                            offset = CGFloat(0)
                        }
                        else {
                            offset = CGFloat(-320)
                        }
                    }
                }, label: {
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
                .frame(width: nil, height: nil, alignment: .center)
            }
            else {
                empty(item: item, DirOpened: DirOpened)
                    .contextMenu {
                        foldercontext(item: item)
                    }
            }
        }
    }
}

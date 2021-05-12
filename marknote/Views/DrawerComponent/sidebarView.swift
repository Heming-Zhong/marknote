//
//  sidebarView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/4/3.
//

import Foundation
import SwiftUI

extension MainView {
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
                ShortcutList
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
        }
        .edgesIgnoringSafeArea(.all)
    }
}

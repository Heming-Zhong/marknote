//
//  ShortcutListView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI


extension MainView {
    var ShortcutList: some View {
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
}

//
//  FileTreeView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI

extension MainView {
    
    var OpenedFileTree: some View {
        HierarchyList(
            data: [self.DirOpened.files],
            id: \.id,
            children: \.children,
            expanded: \.expanded,
            rowContent: {
                item in
                Button(action: {
                    if item.icon == "doc" {
                        print("pressed")
                        Openedfilelist.settabs(url: item.path)

                        if horizontalSizeClass == .compact {
                            withAnimation {
                                if offset == CGFloat(-320) {
                                    offset = CGFloat(0)
                                }
                                else {
                                    offset = CGFloat(-320)
                                }
                            }
                        }
                    }
                    else {
                        setfileitems(id: item.id, cur: &DirOpened.files, callback: setexpansioncallback)
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
                    if item.icon == "doc" {
                        filecontext(item: item)
                    }
                    else {
                        foldercontext(item: item)
                    }
                }
        })        
    }
}

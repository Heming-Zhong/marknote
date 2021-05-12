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

//
//  Editor.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/12.
//

import Foundation
import SwiftUI

extension MainView {
    // deprecated
    func buildeditor() -> AnyView {
        return AnyView( EditorView(document: self.$Openedfilelist.content,edited: self.$Openedfilelist.edited, fileURL: self.Openedfilelist.path) )
    }
    
    // MARK: - 编辑器视图
    var Editor: some View {
        VStack {
            VditorView(code: self.$Openedfilelist.content,edited: self.$Openedfilelist.edited)
                .environmentObject(controller)
        }
        .disabled(horizontalSizeClass == .compact && (offset != CGFloat(-320) ? true : false))
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                TopToolBarLeading
            }
            ToolbarItem(placement: .principal) {
                TopToolBarPrincipal
            }
            ToolbarItem(placement: .automatic, content: {
                Button("save") {
                    savefile()
                }
//                .padding()
                .frame(width: nil, height: nil, alignment: .center)
                .hoverEffect()
            })
            ToolbarItem(placement: .navigationBarTrailing) {
                navitool
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//  EditorView.swift
//  marknote
//
//  Created by 钟赫明 on 2021/4/28.
//

import Foundation
import SwiftUI


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

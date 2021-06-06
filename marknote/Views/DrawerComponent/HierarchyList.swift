//
//  HierarchyList.swift
//  marknote
//
//  Created by 钟赫明 on 2021/5/25.
//

import Foundation
import SwiftUI


func setexpansioncallback(cur: inout fileitems) {
    cur.expanded.toggle()
}

/// self defined Hierarchylist to control and retain the expansion state of every cell
/// https://gist.github.com/zntfdr/085e3d75d59a77ad0125d3a1ef96039b
/// https://www.fivestars.blog/articles/swiftui-hierarchy-list/
public struct HierarchyList<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
    private let recursiveView: RecursiveView<Data, RowContent>

    public init(data: Data, id: KeyPath<Data.Element, UUID>, children: KeyPath<Data.Element, Data?>, expanded: KeyPath<Data.Element, Bool>, rowContent: @escaping (Data.Element) -> RowContent) {
        self.recursiveView = RecursiveView(data: data, id: id, children: children, expanded: expanded, rowContent: rowContent)
    }

    public var body: some View {
        recursiveView
            .animation(.default)
    }
}

private struct RecursiveView<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
    let data: Data
    let id: KeyPath<Data.Element, UUID>
    let children: KeyPath<Data.Element, Data?>
    let expanded: KeyPath<Data.Element, Bool>
    let rowContent: (Data.Element) -> RowContent

    var body: some View {
        ForEach(data) { child in
            if let subChildren = child[keyPath: children] {
                DisclosureGroup(isExpanded: .init(
                                    get:{ child[keyPath: expanded] },
                                    set: {get in
                                        setfileitems(id: child[keyPath: id], cur: &DirOpened.files, callback: setexpansioncallback)
                                    })
                                  , content: {
                    RecursiveView(data: subChildren, id: id, children: children, expanded: expanded, rowContent: rowContent)
                }, label: {
                    rowContent(child)
                })
            } else {
                rowContent(child)
            }
        }
    }
}

struct FSDisclosureGroup<Label, Content>: View where Label: View, Content: View {
    @State var isExpanded: Bool = true
    var content: () -> Content
    var label: () -> Label

    @ViewBuilder
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded, content: content, label: label)
    }
}

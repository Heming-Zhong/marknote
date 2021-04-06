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
import CoreData

var selectedid: UUID? = nil
var input = ""

extension UIHostingController {

    /// Applies workaround so `keyboardShortcut` can be used via SwiftUI.
    ///
    /// When `UIHostingController` is used as a non-root controller with the UIKit app lifecycle,
    /// keyboard shortcuts created in SwiftUI don't work (as of iOS 14.4).
    /// This workaround is harmless and triggers an internal state change that enables keyboard shortcut bridging.
    /// See https://steipete.com/posts/fixing-keyboardshortcut-in-swiftui/
    func applyKeyboardShortcutFix() {
        #if !targetEnvironment(macCatalyst)
        let window = UIWindow()
        window.rootViewController = self
        window.isHidden = false;
        #endif
    }
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
        withAnimation {
            if offset == CGFloat(-320) {
                offset = CGFloat(0)
            }
        }
    }
       
    @State var showpop = false
    @ObservedObject var DirOpened: TargetDir
    @ObservedObject var Openedfilelist: Tabitem
    var root:URL?

    @State var settingpop = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: BookMarks.entity(), sortDescriptors: []) var Marks: FetchedResults<BookMarks>
    @State var offset = CGFloat(-320)
    
    // MARK: - body
    var body: some View {
        let drag = DragGesture(minimumDistance: CGFloat(100))
            .onChanged { g in
                if g.translation.width > 0 && g.translation.width < 320 {
                    withAnimation {
                        offset = g.translation.width - 320
                    }
                }
            }
            .onEnded {
                if $0.translation.width < 120 {
                    withAnimation {
                        offset = CGFloat(-320)
                    }
                }
                else if $0.translation.width >= 120 {
                    withAnimation {
                        offset = CGFloat(0)
                    }
                }
                else {
                    
                }
            }
        let click = TapGesture()
            .onEnded {
                withAnimation {
                    if offset == CGFloat(-320) {
                        offset = CGFloat(0)
                    }
                    else {
                        offset = CGFloat(-320)
                    }
                }
            }
        return
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    NavigationView {
                        body1
                            .frame(width: .infinity, height: .infinity, alignment: .trailing)
                            .disabled(offset == CGFloat(0) ? true : false)
                            .opacity((-Double(offset) + 320) / 640)
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
                                    .padding()
                                    .frame(width: nil, height: nil, alignment: .center)
                                    .hoverEffect()
                                })
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    navitool
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    
                    ZStack(alignment: .leading) {
//                        if offset > CGFloat(-320) {
//                            Rectangle()
//                                .frame(width: geometry.size.width + offset, height: .infinity, alignment: .trailing)
//                                .opacity(0.1)
//                                .gesture(click)
////                                .hoverEffect()
//                                .ignoresSafeArea(.all)
//                                .edgesIgnoringSafeArea(.all)
//                        }
                        
//                        GeometryReader { _ in
//                            EmptyView()
//                        }
//                        .background(Color.gray.opacity(0.3))
//                        .opacity(offset == CGFloat(0) ? 1.0 : 0.0)
//                        .animation(Animation.easeIn.delay(0.25))
//                        .gesture(click)
////                        .ignoresSafeArea(.all)
//                        .hoverEffect()
//                        .onHover(perform: {
//                            print($0)
//                        })
                        NavigationView {
                            sidebar
                        }
                        .frame(width: CGFloat(320), height: .infinity)
                        .offset(x: offset)
                        .transition(.move(edge: .leading))
                        .ignoresSafeArea(.all)
                        .accessibility(hidden: offset < CGFloat(-220))
                        .shadow(radius: 0.7)
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .gesture(drag)
            }
            .accentColor(.purple)
    }
    
    var navitool: some View {
        HStack {
            Button(action: {showpop.toggle()}, label: {
                Image(systemName: "folder.badge.gear")
                    .imageScale(.medium)
            }).sheet(isPresented: $showpop, content: {
                PickerView(callback: filePicked)
                    .accentColor(.purple)
            })
            .frame(width: nil, height: nil, alignment: .center)
            .hoverEffect()
            .keyboardShortcut("o", modifiers: [.command])
            .padding()
            Button(action: {
                if DirOpened.files.path != nil {
                    print("refreshing")
                    filePicked(DirOpened.files.path!)
                }
            }, label: {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.medium)
            })
            .frame(width: nil, height: nil, alignment: .center)
            .hoverEffect()
            .keyboardShortcut("r", modifiers: [.command])
            .padding()
            Button(action: {
                settingpop.toggle()
            }, label: {
                Image(systemName: "gear")
                    .imageScale(.medium)
            }).sheet(isPresented: $settingpop, content: {
                SettingMenu()
            })
            .frame(width: nil, height: nil, alignment: .center)
            .hoverEffect()
            .keyboardShortcut("g", modifiers: [.command])
            .padding()
            Button(action: {
                savefile()
            }, label: {
                EmptyView()
            })
            .frame(width: 0, height: 0)
            .keyboardShortcut("s", modifiers: [.command])
            Button(action: {
                withAnimation {
                    if offset == CGFloat(-320) {
                        offset = CGFloat(0)
                    }
                    else {
                        offset = CGFloat(-320)
                    }
                }
            }, label: {
                EmptyView()
            })
            .frame(width: 0, height: 0)
            .keyboardShortcut("l", modifiers: [.command])
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(DirOpened: DirOpened, Openedfilelist: Openedfilelist, root: nil)
    }
}

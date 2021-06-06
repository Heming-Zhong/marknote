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
import UIKit

var selectedid: UUID? = nil
var input = ""

//extension UIHostingController {
//
//    /// Applies workaround so `keyboardShortcut` can be used via SwiftUI.
//    ///
//    /// When `UIHostingController` is used as a non-root controller with the UIKit app lifecycle,
//    /// keyboard shortcuts created in SwiftUI don't work (as of iOS 14.4).
//    /// This workaround is harmless and triggers an internal state change that enables keyboard shortcut bridging.
//    /// See https://steipete.com/posts/fixing-keyboardshortcut-in-swiftui/
//    func applyKeyboardShortcutFix() {
//        #if !targetEnvironment(macCatalyst)
//        let window = UIWindow()
//        window.rootViewController = self
//        window.isHidden = false;
//        #endif
//    }
//}

// MARK: - 主页面视图
struct MainView: View {
    
    // Pop View States
    @State var pickerpop = false
    @State var settingpop = false
    
    // Observed Values
    @ObservedObject var DirOpened: TargetDir
    @ObservedObject var Openedfilelist: Tabitem
    @EnvironmentObject var controller: VditorController
    
    // Core Data
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: BookMarks.entity(), sortDescriptors: []) var Marks: FetchedResults<BookMarks>
    
    // Regular or Compact state
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // Drawer Offset
    @State var offset = CGFloat(-320)
    
    // MARK: - body
    var body: some View {
        let drag = DragGesture(minimumDistance: CGFloat(50))
            .onChanged { g in
                if g.translation.width > -320 && g.translation.width < 320 {
                    withAnimation {
                        offset = g.translation.width - 320
                    }
                }
            }
            .onEnded {
                print($0.translation.width)
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
                    withAnimation {
                        offset = CGFloat(0)
                    }
                }
            }
        return
            GeometryReader { geometry in
                
                /// diffirent layout in regular or compact mode
                /// in regular: just use NavigationView
                /// in compact: use self designed drawer view
                /// source: https://developer.apple.com/forums/thread/650180
                if horizontalSizeClass == .compact {
                    ZStack(alignment: .leading) {
                        Primary
                            .ignoresSafeArea()
                        if offset > CGFloat(-320) && horizontalSizeClass == .compact {
                            ShadowCover
                                .frame(width: geometry.size.width + offset, height: .infinity, alignment: .trailing)
                        }
                        Drawer
                            .ignoresSafeArea()
                    }
                    .trackpad_support(offset: $offset, show_picker: $pickerpop, show_setting: $settingpop)
//                    .keyshortcut_support(show_picker: $pickerpop, show_setting: $settingpop)
                    .gesture(drag)
                    .ignoresSafeArea()
                    
                } else {
                    NavigationView {
                        sidebar
                        Editor
                    }
                    .keyshortcut_support(show_picker: $pickerpop, show_setting: $settingpop)
                    .ignoresSafeArea(.all)
                }
            }
            .accentColor(.purple)
    }
    
    var navitool: some View {
        HStack {
            Button(action: {pickerpop.toggle()}, label: {
                Image(systemName: "folder.badge.gear")
                    .imageScale(.medium)
            }).sheet(isPresented: $pickerpop, content: {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(DirOpened: DirOpened, Openedfilelist: Openedfilelist)
    }
}

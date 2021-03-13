//
//  marknoteApp.swift
//  marknote
//
//  Created by 钟赫明 on 2021/1/31.
//

import SwiftUI

@main
struct marknoteApp: App {
//    let persistenceController = PersistenceController.shared

//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
    var body: some Scene {
        WindowGroup {
            ContentView(DirOpened: DirOpened,Openedfilelist: Openedfilelist,root: nil)
        }.commands {
            Command()
        }
    }
}

struct Command: Commands {
    var body: some Commands {
        CommandMenu("编辑") {
            Button(action: {
                savefile()
            }, label: {
                Text("保存")
            })
            .keyboardShortcut("s", modifiers: [.command])
        }
    }
}

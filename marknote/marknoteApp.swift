//
//  marknoteApp.swift
//  marknote
//
//  Created by 钟赫明 on 2021/1/31.
//

import SwiftUI

@main
struct marknoteApp: App {
    let persistenceController = PersistenceController.shared
    static let controller = VditorController(nil)

    var body: some Scene {
        WindowGroup {
            MainView(DirOpened: DirOpened,Openedfilelist: Openedfilelist)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(marknoteApp.controller)
        }
    }
}

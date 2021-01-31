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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

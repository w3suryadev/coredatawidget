//
//  coredataPracticeApp.swift
//  coredataPractice
//
//  Created by Suryadev Singh on 07/09/23.
//

import SwiftUI

@main
struct coredataPracticeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

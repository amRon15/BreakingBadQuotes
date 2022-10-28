//
//  breakingbadApp.swift
//  breakingbad
//
//  Created by 邱允聰 on 28/10/2022.
//

import SwiftUI

@main
struct breakingbadApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

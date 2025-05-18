//
//  ArtistShotAppApp.swift
//  ArtistShotApp
//
//  Created by Jimmy Mantilla on 18/05/25.
//

import SwiftUI

@main
struct ArtistShotAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

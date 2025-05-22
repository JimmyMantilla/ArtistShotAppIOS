//
//  ArtistShotAppApp.swift
//  ArtistShotApp
//
//  Created by Jimmy Mantilla on 18/05/25.
//

import SwiftUI
import Resolver

@main
struct ArtistShotAppApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        Resolver.registerAllServices()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

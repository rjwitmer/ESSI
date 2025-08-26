//
//  ESSIApp.swift
//  ESSI
//
//  Created by Bob Witmer on 2025-08-26.
//

import SwiftUI
import SwiftData

@main
struct ESSIApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .modelContainer(for: Snack.self)    // Setup the 'container' or database structure which will hold the Snack types
        }
    }
    // Print out the application path where simulator data can be found - can by used with 'DB Browser for SQLite'
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

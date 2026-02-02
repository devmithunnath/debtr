//
//  debtrApp.swift
//  debtr
//
//  Created by Mithun Nath on 2026-02-02.
//

import SwiftUI
import SwiftData

@main
struct debtrApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DebtItem.self,
            Payment.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 700)
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.hiddenTitleBar)
        .conditionalWindowDragBehavior()
    }
}

extension Scene {
    func conditionalWindowDragBehavior() -> some Scene {
        if #available(macOS 15.0, *) {
            return self.windowBackgroundDragBehavior(.enabled)
        } else {
            return self
        }
    }
}

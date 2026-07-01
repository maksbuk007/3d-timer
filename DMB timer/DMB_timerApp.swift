//
//  DMB_timerApp.swift
//  DMB timer
//
//  Created by  BOSS on 30.06.26.
//

import SwiftUI
import SwiftData

@main
struct DMB_timerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Soldier.self)
    }
}

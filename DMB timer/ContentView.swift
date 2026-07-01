//
//  ContentView.swift
//  DMB timer
//
//  Created by  BOSS on 30.06.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var soldiers: [Soldier]

    var body: some View {
        NavigationStack {
            VStack {
                Text("ДМБ-Таймер загружен")
                    .font(.title)
                Text("У вас добавлено бойцов: \(soldiers.count)")
            }
            .navigationTitle("Главная")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Soldier.self, inMemory: true)
}

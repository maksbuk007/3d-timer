//
//  ContentView.swift
//  DMB timer
//
//  Created by  BOSS on 30.06.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Подключаемся к БД
    @Environment(\.modelContext) private var modelContext
    
    // Автоматически достаем всех солдат из БД
    @Query(sort: \Soldier.startDate, order: .forward) private var soldiers: [Soldier]
    
    // Переменная, которая следит, открыт ли экран добавления (false - закрыт)
    @State private var showingAddScreen = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Задаем темный фон
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                if soldiers.isEmpty {
                    Text("Список пуст. Добавьте бойца.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(soldiers) { soldier in
                            NavigationLink(destination: TimerView(soldier: soldier)) {
                                HStack {
                                    Text(soldier.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium))
                                    
                                    Spacer()
                                    
                                    Text("\(calculateProgress(for: soldier)) %")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                            }
                            .listRowBackground(Color(uiColor: .secondarySystemBackground))
                        }
                        .onDelete(perform: deleteSoldiers) // Добавляем возможность удалять свайпом
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Военнослужащие")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { /* Пока оставим пустым, позже настроим навигацию */ }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                        .foregroundColor(.gray)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Кнопка добавления, меняющая состояние showingAddScreen
                    Button(action: { showingAddScreen = true }) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.gray)
                    }
                }
            }
            // Вызов модального окна при showingAddScreen = true
            .sheet(isPresented: $showingAddScreen) {
                AddSoldierView()
            }
            .preferredColorScheme(.dark)
        }
    }
    
    // MARK: - Методы
    
    // Функция для удаления солдата из БД
    private func deleteSoldiers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(soldiers[index])
            }
        }
    }
    
    // Временная функция расчета процента
    private func calculateProgress(for soldier: Soldier) -> String {
        let total = soldier.endDate.timeIntervalSince(soldier.startDate)
        let passed = Date().timeIntervalSince(soldier.startDate)
        
        if passed <= 0 { return "0" }
        if passed >= total { return "100" }
        
        let percent = (passed / total) * 100
        return String(format: "%.0f", percent)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Soldier.self, inMemory: true)
}

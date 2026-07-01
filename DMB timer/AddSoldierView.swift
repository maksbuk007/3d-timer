import SwiftUI
import SwiftData

struct AddSoldierView: View {
    // доступ к контексту БД для сохранения
    @Environment(\.modelContext) private var modelContext
    // Позволяет закрыть этот экран
    @Environment(\.dismiss) private var dismiss

    // Переменные состояния для хранения того, что вводит пользователь
    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Имя", text: $name)
                    
                    DatePicker("Дата призыва", selection: $startDate, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "ru_RU"))
                    
                    DatePicker("Дата дембеля", selection: $endDate, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "ru_RU"))
                }
                .listRowBackground(Color(uiColor: .secondarySystemBackground))
            }
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemBackground)) // Ставим темный фон
            .navigationTitle("Добавление солдата")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                        .foregroundColor(.gray)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveSoldier) {
                        Image(systemName: "checkmark.square")
                            .foregroundColor(.gray)
                    }
                    .disabled(name.isEmpty) // не сработает, пока не введут имя
                }
            }
            .preferredColorScheme(.dark) // включаем темную тему
        }
    }

    // Функция сохранения
    private func saveSoldier() {
        let newSoldier = Soldier(name: name, startDate: startDate, endDate: endDate)
        modelContext.insert(newSoldier) // Записываем в базу
        dismiss() // Закрываем экран
    }
}

#Preview {
    AddSoldierView()
}

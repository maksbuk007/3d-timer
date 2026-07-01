import SwiftUI
import SwiftData

struct AddSoldierView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // Если этот объект передан — мы в режиме редактирования
    var soldierToEdit: Soldier?
    
    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(86400 * 365)
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Имя бойца", text: $name)
                
                DatePicker("Дата призыва", selection: $startDate, displayedComponents: .date)
                    .environment(\.locale, Locale(identifier: "ru_RU")) // Русский язык
                
                DatePicker("Дата дембеля", selection: $endDate, displayedComponents: .date)
                    .environment(\.locale, Locale(identifier: "ru_RU")) // Русский язык
            }
            .navigationTitle(soldierToEdit == nil ? "Добавить бойца" : "Редактировать")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        save()
                    }
                }
            }
            // Загружаем данные при открытии, если мы пришли сюда редактировать
            .onAppear {
                if let soldier = soldierToEdit {
                    name = soldier.name
                    startDate = soldier.startDate
                    endDate = soldier.endDate
                }
            }
        }
    }
    
    private func save() {
        if let soldier = soldierToEdit {
            // Обновляем существующего
            soldier.name = name
            soldier.startDate = startDate
            soldier.endDate = endDate
        } else {
            // Создаем нового
            let newSoldier = Soldier(name: name, startDate: startDate, endDate: endDate)
            modelContext.insert(newSoldier)
        }
        dismiss()
    }
}

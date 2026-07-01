import SwiftUI
import SwiftData

struct MainTabView: View {
    // Получаем доступ к контексту базы данных для удаления элементов
    @Environment(\.modelContext) private var modelContext
    
    // подписка на изменения в списке бойцов
    @Query(sort: \Soldier.startDate) private var soldiers: [Soldier]
    
    @State private var showingAddScreen = false
    @State private var soldierToEdit: Soldier? = nil // Для логики редактирования

    var body: some View {
        TabView {
            // Вкладка "Главная" со списком бойцов
            NavigationStack {
                List {
                    if soldiers.isEmpty {
                        ContentUnavailableView("Нет бойцов", systemImage: "person.badge.plus", description: Text("Нажмите +, чтобы добавить нового военнослужащего."))
                    } else {
                        ForEach(soldiers) { soldier in
                            NavigationLink(destination: TimerView(soldier: soldier)) {
                                VStack(alignment: .leading) {
                                    Text(soldier.name).font(.headline)
                                    Text("Служит с: \(soldier.startDate.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteSoldiers)
                    }
                }
                .navigationTitle("Мои бойцы")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddScreen = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    // Здесь должен быть экран AddSoldierView
                    // Если он принимает солдата, можно передать nil для создания нового
                    AddSoldierView()
                }
            }
            .tabItem {
                Label("Главная", systemImage: "house.fill")
            }
            
            // Вкладка "Настройки"
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(.blue)
        .preferredColorScheme(.dark)
    }

    // Функция удаления
    private func deleteSoldiers(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(soldiers[index])
        }
    }
}

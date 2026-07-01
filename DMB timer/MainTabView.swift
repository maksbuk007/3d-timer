import SwiftUI

struct MainTabView: View {
    // Временный тестовый объект военнослужащего, пока полностью не подключена база данных
    let mockSoldier = Soldier(name: "Имя Бойца #1", startDate: Date().addingTimeInterval(-86400 * 55), endDate: Date().addingTimeInterval(86400 * 493))
    
    var body: some View {
        TabView {
            // Первая вкладка — Главная с таймером
            NavigationStack {
                TimerView(soldier: mockSoldier)
            }
            .tabItem {
                Label("Главная", systemImage: "house.fill")
            }
            
            // Вторая вкладка — Настройки
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(.blue) // Синий цвет активных иконок нижнего бара по макету
        .preferredColorScheme(.dark)
    }
}

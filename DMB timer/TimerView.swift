import SwiftUI

struct TimerView: View {
    let soldier: Soldier // Солдат, которого мы передаем с прошлого экрана
    
    // Создаем таймер, который срабатывает каждую 1 секунду
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Переменная для обновления интерфейса каждую секунду
    @State private var currentDate = Date()
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Вычисляем данные через наш менеджер
                    let timeData = TimeManager.calculateTime(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    
                    // Блок процентов (пока без круга, просто текст, как в макете)
                    VStack {
                        Text(String(format: "%.6f %%", timeData.percent))
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    // Карточка "Прошло"
                    TimeCardView(
                        title: "Прошло",
                        days: timeData.passed.d,
                        hours: timeData.passed.h,
                        minutes: timeData.passed.m,
                        seconds: timeData.passed.s
                    )
                    
                    // Карточка "Осталось"
                    TimeCardView(
                        title: "Осталось",
                        days: timeData.remaining.d,
                        hours: timeData.remaining.h,
                        minutes: timeData.remaining.m,
                        seconds: timeData.remaining.s
                    )
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        // Этот модификатор "слушает" таймер и обновляет переменную currentDate
        .onReceive(timer) { input in
            currentDate = input
        }
        .navigationTitle(soldier.name) // Имя бойца в заголовке
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Вспомогательные элементы UI

// Вынесли верстку карточки времени в отдельную структуру, чтобы не дублировать код
struct TimeCardView: View {
    var title: String
    var days: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack(spacing: 20) {
                TimeComponent(value: days, label: "Дней")
                TimeComponent(value: hours, label: "Часов")
                TimeComponent(value: minutes, label: "Минут")
                TimeComponent(value: seconds, label: "Секунд")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(15)
    }
}

// Верстка одной колонки (например, "14 \n Часов")
struct TimeComponent: View {
    var value: Int
    var label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(String(format: "%02d", value)) // %02d добавляет нули, если число < 10 (например, "05")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .monospacedDigit() // Цифры не будут "прыгать" по ширине при смене секунд
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(minWidth: 50)
    }
}

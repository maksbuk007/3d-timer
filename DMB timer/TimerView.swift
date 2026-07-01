import SwiftUI

struct TimerView: View {
    let soldier: Soldier
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var currentDate = Date()
    
    // Вычисляем процент заполнения круга
    var progressPercent: Double {
        let total = soldier.endDate.timeIntervalSince(soldier.startDate)
        let passed = currentDate.timeIntervalSince(soldier.startDate)
        if total <= 0 { return 100.0 }
        return max(0, min((passed / total) * 100, 100))
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    let timeData = TimeManager.calculateTime(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    let achievements = AchievementManager.evaluate(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    
                    // 1. ВЫЗОВ кругового прогресс-бара
                    CircularProgressView(percent: progressPercent)
                        .frame(width: 280, height: 280) // Увеличил размер, чтобы было как на макете 1.0
                        .padding(.top, 20)
                    
                    // 2. Карточки времени
                    HStack(spacing: 15) {
                        TimeCardView(title: "ПРОШЛО:", days: timeData.passed.d, hours: timeData.passed.h, minutes: timeData.passed.m, seconds: timeData.passed.s)
                        TimeCardView(title: "ОСТАЛОСЬ:", days: timeData.remaining.d, hours: timeData.remaining.h, minutes: timeData.remaining.m, seconds: timeData.remaining.s)
                    }
                    
                    // 3. Блок Достижений
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Достижения")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(achievements) { achievement in
                            HStack {
                                Image(systemName: achievement.isUnlocked ? "checkmark.seal.fill" : "lock.fill")
                                    .foregroundColor(achievement.isUnlocked ? .green : .gray)
                                    .font(.title3)
                                
                                Text(achievement.title)
                                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
                                    .strikethrough(!achievement.isUnlocked, color: .gray)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
            }
        }
        .onReceive(timer) { input in
            currentDate = input
        }
        .navigationTitle(soldier.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Элементы интерфейса

// ОБЪЯВЛЕНИЕ кругового прогресс-бара
struct CircularProgressView: View {
    var percent: Double
    
    // Переменная настроек живет здесь, внутри структуры
    @AppStorage("percentageAccuracy") private var percentageAccuracy = 5
    
    var body: some View {
        ZStack {
            // Серый фон круга
            Circle()
                .stroke(lineWidth: 25) // Сделал потолще, под дизайн 1.0
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Цветная заполняющаяся линия
            Circle()
                .trim(from: 0.0, to: CGFloat(min(percent / 100, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue) // Синий цвет по макету 1.0
                .rotationEffect(Angle(degrees: -90)) // Чтобы круг начинался с 12 часов
                .animation(.linear, value: percent)
            
            // Проценты внутри
            VStack {
                // Используем динамическую точность из Настроек
                Text(String(format: "%.\(percentageAccuracy)f", percent))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.blue) // Текст тоже синий по макету
                
                Text("%")
                    .foregroundColor(.gray)
                    .font(.title3)
                    .bold()
            }
        }
    }
}

// Оставляем старые структуры без изменений
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
            
            VStack(spacing: 8) { // Изменил на VStack, чтобы влезло как в макете 1.0
                TimeComponent(value: days, label: "дней")
                TimeComponent(value: hours, label: "часов")
                TimeComponent(value: minutes, label: "минут")
                TimeComponent(value: seconds, label: "секунд")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct TimeComponent: View {
    var value: Int
    var label: String
    
    var body: some View {
        HStack(spacing: 5) {
            Text("\(value)")
                .font(.body)
                .bold()
                .foregroundColor(.white)
                .monospacedDigit()
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

import SwiftUI

struct TimerView: View {
    let soldier: Soldier
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var currentDate = Date()
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    let timeData = TimeManager.calculateTime(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    let achievements = AchievementManager.evaluate(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    
                    // Круговой прогресс-бар
                    CircularProgressView(percent: timeData.percent)
                        .frame(width: 200, height: 200)
                        .padding(.top, 20)
                    
                    // Карточки времени
                    TimeCardView(title: "Прошло", days: timeData.passed.d, hours: timeData.passed.h, minutes: timeData.passed.m, seconds: timeData.passed.s)
                    TimeCardView(title: "Осталось", days: timeData.remaining.d, hours: timeData.remaining.h, minutes: timeData.remaining.m, seconds: timeData.remaining.s)
                    
                    // Блок Достижений
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

// Новый элемент: Круговой прогресс
struct CircularProgressView: View {
    var percent: Double
    
    var body: some View {
        ZStack {
            // Серый фон круга
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Цветная заполняющаяся линия
            Circle()
                .trim(from: 0.0, to: CGFloat(min(percent / 100, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(.green) // Можно поменять на нужный цвет
                .rotationEffect(Angle(degrees: -90)) // Чтобы круг начинался с 12 часов
                .animation(.linear, value: percent)
            
            // Проценты внутри
            VStack {
                Text(String(format: "%.5f", percent))
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Text("%")
                    .foregroundColor(.gray)
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

struct TimeComponent: View {
    var value: Int
    var label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(String(format: "%02d", value))
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .monospacedDigit()
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(minWidth: 50)
    }
}

import SwiftUI

struct TimerView: View {
    let soldier: Soldier
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var currentDate = Date()
    @State private var showingEditScreen = false
    
    // Подтягиваем сохраненное фото фона
    @AppStorage("backgroundImageData") private var backgroundImageData: Data?
    
    var progressPercent: Double {
        let total = soldier.endDate.timeIntervalSince(soldier.startDate)
        let passed = currentDate.timeIntervalSince(soldier.startDate)
        
// MARK: - DEBUG print
        let p = max(0, min((passed / total) * 100, 100))
            print("DEBUG: Прошло \(p)%")
// MARK: - print end
        
        if total <= 0 { return 100.0 }
        return max(0, min((passed / total) * 100, 100))
    }
    
    var body: some View {
        ZStack {
            // Фон: если есть картинка - рендерим её, иначе стандартный цвет
            if let data = backgroundImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .ignoresSafeArea()
            } else {
                Color(uiColor: .systemBackground).ignoresSafeArea()
            }
            
            ScrollView {
                VStack(spacing: 30) {
                    let timeData = TimeManager.calculateTime(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    let achievements = AchievementManager.evaluate(start: soldier.startDate, end: soldier.endDate, current: currentDate)
                    
                    // Круговой прогресс-бар
                    CircularProgressView(percent: progressPercent)
                        .frame(width: 240, height: 240)
                        .padding(.top, 20)
                    
                    // Карточки времени
                    HStack(spacing: 15) {
                        TimeCardView(title: "ПРОШЛО:", days: timeData.passed.d, hours: timeData.passed.h, minutes: timeData.passed.m, seconds: timeData.passed.s)
                        TimeCardView(title: "ОСТАЛОСЬ:", days: timeData.remaining.d, hours: timeData.remaining.h, minutes: timeData.remaining.m, seconds: timeData.remaining.s)
                    }
                    
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
                            .background(Color(uiColor: .secondarySystemBackground).opacity(0.85)) // Легкая прозрачность
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Править") {
                    showingEditScreen = true
                }
            }
        }
        .sheet(isPresented: $showingEditScreen) {
            AddSoldierView(soldierToEdit: soldier)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Элементы интерфейса

struct CircularProgressView: View {
    var percent: Double
    @AppStorage("percentageAccuracy") private var percentageAccuracy = 5
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 25)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(percent / 100, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: percent)
            
            VStack {
                Text(String(format: "%.\(percentageAccuracy)f", percent))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.blue)
                
                Text("%")
                    .foregroundColor(.gray)
                    .font(.title3)
                    .bold()
            }
        }
    }
}

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
            
            VStack(spacing: 8) {
                TimeComponent(value: days, label: "дней")
                TimeComponent(value: hours, label: "часов")
                TimeComponent(value: minutes, label: "минут")
                TimeComponent(value: seconds, label: "секунд")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground).opacity(0.85)) // Прозрачность
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

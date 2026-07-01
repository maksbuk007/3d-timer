import Foundation

// Модель одного достижения
struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let isUnlocked: Bool
}

struct AchievementManager {
    // Главная функция, возвращающая массив из 24 ачивок
    static func evaluate(start: Date, end: Date, current: Date) -> [Achievement] {
        // Переводим время в дни для удобства (86400 секунд = 1 день)
        let daysPassed = current.timeIntervalSince(start) / 86400
        let daysRemaining = end.timeIntervalSince(current) / 86400
        let totalDays = end.timeIntervalSince(start) / 86400
        let currentYear = Calendar.current.component(.year, from: current)
        
        // Массив всех достижений с условиями их получения
        return [
            Achievement(title: "1. Призыв", isUnlocked: current >= start),
            Achievement(title: "2. Наступление лета", isUnlocked: countPassedMonths(6, start: start, current: current) >= 1),
            Achievement(title: "3. 500 дней до дембеля", isUnlocked: daysRemaining <= 500 && current >= start),
            Achievement(title: "4. 100 дней после призыва", isUnlocked: daysPassed >= 100),
            Achievement(title: "5. Наступление осени", isUnlocked: countPassedMonths(9, start: start, current: current) >= 1),
            Achievement(title: "6. Прошла четверть службы", isUnlocked: daysPassed >= (totalDays / 4)),
            Achievement(title: "7. 400 дней до дембеля", isUnlocked: daysRemaining <= 400 && current >= start),
            Achievement(title: "8. 200 дней после призыва", isUnlocked: daysPassed >= 200),
            Achievement(title: "9. Наступление зимы", isUnlocked: countPassedMonths(12, start: start, current: current) >= 1),
            Achievement(title: "10. Новый 2027 год", isUnlocked: currentYear >= 2027),
            Achievement(title: "11. 300 дней до дембеля", isUnlocked: daysRemaining <= 300 && current >= start),
            Achievement(title: "12. Половина службы", isUnlocked: daysPassed >= (totalDays / 2)),
            Achievement(title: "13. Наступление весны", isUnlocked: countPassedMonths(3, start: start, current: current) >= 1),
            Achievement(title: "14. 300 дней после призыва", isUnlocked: daysPassed >= 300),
            Achievement(title: "15. 200 дней до дембеля", isUnlocked: daysRemaining <= 200 && current >= start),
            Achievement(title: "16. Наступление лета (повтор)", isUnlocked: countPassedMonths(6, start: start, current: current) >= 2),
            Achievement(title: "17. 400 дней после призыва", isUnlocked: daysPassed >= 400),
            Achievement(title: "18. Осталась четверть службы", isUnlocked: daysRemaining <= (totalDays / 4) && current >= start),
            Achievement(title: "19. 400 дней после призыва (повтор)", isUnlocked: daysPassed >= 400),
            Achievement(title: "20. Осталась четверть службы (повтор)", isUnlocked: daysRemaining <= (totalDays / 4) && current >= start),
            Achievement(title: "21. 100 дней до дембеля", isUnlocked: daysRemaining <= 100 && current >= start),
            Achievement(title: "22. Наступление осени (повтор)", isUnlocked: countPassedMonths(9, start: start, current: current) >= 2),
            Achievement(title: "23. 500 дней после призыва", isUnlocked: daysPassed >= 500),
            Achievement(title: "24. Дембель", isUnlocked: current >= end)
        ]
    }
    
    // Вспомогательная функция для подсчета наступления сезонов
    private static func countPassedMonths(_ targetMonth: Int, start: Date, current: Date) -> Int {
        var count = 0
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: start)
        let currentYear = calendar.component(.year, from: current)
        
        for year in startYear...currentYear {
            let comps = DateComponents(year: year, month: targetMonth, day: 1)
            if let targetDate = calendar.date(from: comps) {
                if targetDate >= start && targetDate <= current {
                    count += 1
                }
            }
        }
        return count
    }
}

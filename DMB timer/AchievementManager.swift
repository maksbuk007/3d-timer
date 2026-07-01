import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let isUnlocked: Bool
}

struct AchievementManager {
    static func evaluate(start: Date, end: Date, current: Date) -> [Achievement] {
        let calendar = Calendar.current
        
        let startDay = calendar.startOfDay(for: start)
        let currentDay = calendar.startOfDay(for: current)
        let endDay = calendar.startOfDay(for: end)
        
        let daysPassed = calendar.dateComponents([.day], from: startDay, to: currentDay).day ?? 0
        let daysRemaining = calendar.dateComponents([.day], from: currentDay, to: endDay).day ?? 0
        let totalDays = calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 1
        
        // Массив всех возможных ачивок с метаданными
        // isRelevant - проверяет, нужно ли показывать это достижение
        let rawAchievements: [(title: String, isUnlocked: Bool, isRelevant: Bool)] = [
            ("1. Призыв", current >= start, true),
            ("2. Наступление лета", countPassedMonths(6, start: start, current: current) >= 1, true),
            ("3. 500 дней до дембеля", daysRemaining <= 500 && current >= start, totalDays >= 500),
            ("4. 100 дней после призыва", daysPassed >= 100, totalDays >= 100),
            ("5. Наступление осени", countPassedMonths(9, start: start, current: current) >= 1, true),
            ("6. Прошла четверть службы", daysPassed >= (totalDays / 4), totalDays >= 4),
            ("7. 400 дней до дембеля", daysRemaining <= 400 && current >= start, totalDays >= 400),
            ("8. 200 дней после призыва", daysPassed >= 200, totalDays >= 200),
            ("9. Наступление зимы", countPassedMonths(12, start: start, current: current) >= 1, true),
            ("10. Новый 2027 год", calendar.component(.year, from: current) >= 2027, true),
            ("11. 300 дней до дембеля", daysRemaining <= 300 && current >= start, totalDays >= 300),
            ("12. Половина службы", daysPassed >= (totalDays / 2), totalDays >= 2),
            ("13. Наступление весны", countPassedMonths(3, start: start, current: current) >= 1, true),
            ("14. 300 дней после призыва", daysPassed >= 300, totalDays >= 300),
            ("15. 200 дней до дембеля", daysRemaining <= 200 && current >= start, totalDays >= 200),
            ("16. Наступление лета (повтор)", countPassedMonths(6, start: start, current: current) >= 2, totalDays >= 365),
            ("17. 400 дней после призыва", daysPassed >= 400, totalDays >= 400),
            ("18. Осталась четверть службы", daysRemaining <= (totalDays / 4) && current >= start, totalDays >= 4),
            ("19. 400 дней после призыва (повтор)", daysPassed >= 400, totalDays >= 400),
            ("20. Осталась четверть службы (повтор)", daysRemaining <= (totalDays / 4) && current >= start, totalDays >= 4),
            ("21. 100 дней до дембеля", daysRemaining <= 100 && current >= start, totalDays >= 100),
            ("22. Наступление осени (повтор)", countPassedMonths(9, start: start, current: current) >= 2, totalDays >= 365),
            ("23. 500 дней после призыва", daysPassed >= 500, totalDays >= 500),
            ("24. Дембель", current >= end, true)
        ]
        
        // Фильтруем список
        return rawAchievements
            .filter { $0.isRelevant }
            .map { Achievement(title: $0.title, isUnlocked: $0.isUnlocked) }
    }
    
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

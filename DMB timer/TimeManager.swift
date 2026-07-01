import Foundation

struct TimeManager {
    static func calculateTime(start: Date, end: Date, current: Date = Date()) -> (passed: (d: Int, h: Int, m: Int, s: Int), remaining: (d: Int, h: Int, m: Int, s: Int), percent: Double) {
        
        let calendar = Calendar.current
        
        // 1. Считаем процент
        let totalSeconds = end.timeIntervalSince(start)
        let passedSeconds = max(0, current.timeIntervalSince(start))
        let percent = totalSeconds > 0 ? (min(passedSeconds, totalSeconds) / totalSeconds) * 100 : 100
        
        // 2. Считаем Прошло (TimeInterval)
        let pTotal = Int(passedSeconds)
        let pDays = pTotal / 86400
        let pHours = (pTotal % 86400) / 3600
        let pMinutes = (pTotal % 3600) / 60
        let pSecs = pTotal % 60
        
        // 3. Считаем Осталось (Календарно)
        let startOfCurrent = calendar.startOfDay(for: current)
        let startOfEnd = calendar.startOfDay(for: end)
        
        let componentsRemaining = calendar.dateComponents([.day], from: startOfCurrent, to: startOfEnd)
        let rDays = max(0, componentsRemaining.day ?? 0)
        
        // Часы, минуты и секунды для "Осталось" считаем от текущего момента до конца
        let remainingSeconds = max(0, end.timeIntervalSince(current))
        let rTotal = Int(remainingSeconds)
        let rHours = (rTotal % 86400) / 3600
        let rMinutes = (rTotal % 3600) / 60
        let rSecs = rTotal % 60
        
        return (
            passed: (pDays, pHours, pMinutes, pSecs),
            remaining: (rDays, rHours, rMinutes, rSecs),
            percent: percent
        )
    }
}

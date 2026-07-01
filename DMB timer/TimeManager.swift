import Foundation

struct TimeManager {
    // Функция принимает начальную, конечную и текущую даты, а возвращает tuple с результатами
    static func calculateTime(start: Date, end: Date, current: Date = Date()) -> (passed: (d: Int, h: Int, m: Int, s: Int), remaining: (d: Int, h: Int, m: Int, s: Int), percent: Double) {
        
        let totalSeconds = end.timeIntervalSince(start)
        var passedSeconds = current.timeIntervalSince(start)
        var remainingSeconds = end.timeIntervalSince(current)
        
        // Защита от отрицательных значений
        if passedSeconds < 0 {
            passedSeconds = 0
            remainingSeconds = totalSeconds
        } else if remainingSeconds < 0 {
            remainingSeconds = 0
            passedSeconds = totalSeconds
        }
        
        // Вычисляем процент
        let percent = totalSeconds > 0 ? (passedSeconds / totalSeconds) * 100 : 100
        
        // Переводим секунды в дни, часы и минуты
        let pDays = Int(passedSeconds) / 86400
        let pHours = (Int(passedSeconds) % 86400) / 3600
        let pMinutes = (Int(passedSeconds) % 3600) / 60
        let pSecs = Int(passedSeconds) % 60
        
        let rDays = Int(remainingSeconds) / 86400
        let rHours = (Int(remainingSeconds) % 86400) / 3600
        let rMinutes = (Int(remainingSeconds) % 3600) / 60
        let rSecs = Int(remainingSeconds) % 60
        
        return (
            passed: (pDays, pHours, pMinutes, pSecs),
            remaining: (rDays, rHours, rMinutes, rSecs),
            percent: percent
        )
    }
}

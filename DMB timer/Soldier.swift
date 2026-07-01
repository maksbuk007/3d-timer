import Foundation
import SwiftData

@Model
final class Soldier {
    var id: UUID
    var name: String
    var startDate: Date // Дата призыва
    var endDate: Date   // Дата дембеля
    
    init(name: String = "", startDate: Date = Date(), endDate: Date = Date().addingTimeInterval(31536000)) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
}

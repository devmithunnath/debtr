import Foundation
import SwiftData

enum DebtType: String, Codable, CaseIterable, Identifiable {
    case creditCard = "Credit Card"
    case personalLoan = "Personal Loan"
    case lineOfCredit = "Line of Credit"
    case personalDebt = "Personal Debt"
    
    var id: String { rawValue }
}

@Model
final class DebtItem {
    var id: UUID
    var type: DebtType
    var name: String
    var startingBalance: Decimal
    var currentBalance: Decimal
    var apr: Decimal?
    var dueDate: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \Payment.debtItem)
    var payments: [Payment] = []
    
    init(type: DebtType, name: String, startingBalance: Decimal, currentBalance: Decimal, apr: Decimal? = nil, dueDate: Date? = nil) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.apr = apr
        self.dueDate = dueDate
    }
}

@Model
final class Payment {
    var id: UUID
    var amount: Decimal
    var date: Date
    var note: String
    
    var debtItem: DebtItem?
    
    init(amount: Decimal, date: Date, note: String, debtItem: DebtItem? = nil) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.note = note
        self.debtItem = debtItem
    }
}

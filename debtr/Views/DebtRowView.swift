import SwiftUI

struct DebtRowView: View {
    let debt: DebtItem
    let viewPaymentsAction: () -> Void
    @AppStorage("currencyCode") private var currencyCode: String = "USD"
    
    var body: some View {
        Button(action: viewPaymentsAction) {
            HStack(spacing: 16) {
                // Icon with glowing glass background
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(typeColor.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(typeColor.opacity(0.3), lineWidth: 1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: iconName(for: debt.type))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(typeColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(debt.name)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Text(debt.type.rawValue)
                        if debt.apr != nil || debt.dueDate != nil {
                            Text("•")
                        }
                        if let apr = debt.apr {
                            Text("\(apr.formatted())% APR")
                        }
                    }
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(debt.currentBalance, format: .currency(code: currencyCode))
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    if let due = debt.dueDate {
                        Text("Due \(due.formatted(.dateTime.month().day()))")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.white.opacity(0.4))
                    } else {
                        Text("History")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.blue.opacity(0.8))
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.2))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    var typeColor: Color {
        switch debt.type {
        case .creditCard: return .blue
        case .personalLoan: return .purple
        case .lineOfCredit: return .green
        case .personalDebt: return .orange
        }
    }
    
    func iconName(for type: DebtType) -> String {
        switch type {
        case .creditCard: return "creditcard"
        case .personalLoan: return "banknote"
        case .lineOfCredit: return "building.columns"
        case .personalDebt: return "person.2"
        }
    }
}

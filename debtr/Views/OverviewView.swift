import SwiftUI

struct OverviewView: View {
    var debts: [DebtItem]
    @AppStorage("currencyCode") private var currencyCode: String = "USD"
    
    var totalCurrent: Decimal {
        debts.reduce(0) { $0 + $1.currentBalance }
    }
    
    var totalStarting: Decimal {
        debts.reduce(0) { $0 + $1.startingBalance }
    }
    
    var totalPaid: Decimal {
        totalStarting - totalCurrent
    }
    
    var progress: Double {
        guard totalStarting > 0 else { return 0 }
        let p = (totalPaid / totalStarting)
        return NSDecimalNumber(decimal: p).doubleValue
    }
    
    var upcomingDebts: [DebtItem] {
        debts.compactMap { $0.dueDate != nil ? $0 : nil }
            .sorted(by: { $0.dueDate! < $1.dueDate! })
            .prefix(2)
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title Section
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("Debtr")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Text("Your path to zero.")
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(totalCurrent, format: .currency(code: currencyCode).precision(.fractionLength(0)))
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("away from cashflow positive")
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Text("Started at \(totalStarting.formatted(.currency(code: currencyCode).precision(.fractionLength(0)))) • Paid so far \(totalPaid.formatted(.currency(code: currencyCode).precision(.fractionLength(0))))")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // Progress Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Progress")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Text(progress, format: .percent.precision(.fractionLength(0)))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(progress), height: 10)
                            .shadow(color: .blue.opacity(0.5), radius: 5)
                    }
                }
                .frame(height: 10)
                
                Text("You're \(totalPaid.formatted(.currency(code: currencyCode).precision(.fractionLength(0)))) closer to being debt-free.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if !upcomingDebts.isEmpty {
                // Next Payments Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Next payments")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 8) {
                        ForEach(upcomingDebts) { debt in
                            HStack {
                                Text(debt.name)
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                if let date = debt.dueDate {
                                    Text(date, format: .dateTime.month().day().year())
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                            .font(.system(.subheadline, design: .rounded))
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                }
            }
            
            // Bottom Quote
            Text("\"Every payment brings you one step closer to financial freedom.\"")
                .font(.system(.caption, design: .rounded))
                .italic()
                .foregroundColor(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

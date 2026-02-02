import SwiftUI
import SwiftData

struct PaymentsSheetView: View {
    @Bindable var debt: DebtItem
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @AppStorage("currencyCode") private var currencyCode: String = "USD"
    
    @State private var newAmount: Decimal = 0.0
    @State private var newDate: Date = Date()
    @State private var newNote: String = ""
    @State private var showingAddForm = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.85).ignoresSafeArea()
            LiquidBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(debt.name)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Text("Payment History")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 28)
                .padding(.top, 48)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Quick Add Section
                        GlassSection(title: "Add Payment", icon: "plus.circle.fill", color: .green) {
                            GlassCurrencyField(label: "Amount", value: $newAmount, currencyCode: currencyCode)
                            
                            if showingAddForm {
                                DatePicker("Date", selection: $newDate, displayedComponents: .date)
                                    .padding(.vertical, 8)
                                    .colorInvert()
                                GlassTextField(label: "Note", text: $newNote, placeholder: "e.g. Monthly minimum")
                            }
                            
                            HStack {
                                Button(showingAddForm ? "Show Less" : "More Options") {
                                    withAnimation { showingAddForm.toggle() }
                                }
                                .buttonStyle(.plain)
                                .font(.caption)
                                .foregroundColor(.blue)
                                
                                Spacer()
                                
                                Button("Record") {
                                    addPayment()
                                }
                                .disabled(newAmount <= 0)
                                .buttonStyle(GlassButtonStyle(color: .green))
                            }
                        }
                        
                        // History Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Records")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 4)
                            
                            if debt.payments.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "tray")
                                        .font(.title)
                                        .foregroundColor(.white.opacity(0.2))
                                    Text("No payments recorded yet")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(40)
                                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.02)))
                            } else {
                                ForEach(debt.payments.sorted(by: { $0.date > $1.date })) { payment in
                                    PaymentHistoryRow(payment: payment, currencyCode: currencyCode) {
                                        deletePayment(payment)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(width: 450, height: 600)
        .preferredColorScheme(.dark)
    }
    
    func addPayment() {
        let payment = Payment(amount: newAmount, date: newDate, note: newNote)
        debt.payments.append(payment)
        debt.currentBalance -= newAmount
        
        // Reset
        newAmount = 0
        newNote = ""
        showingAddForm = false
    }
    
    func deletePayment(_ payment: Payment) {
        debt.currentBalance += payment.amount
        modelContext.delete(payment)
    }
}

struct PaymentHistoryRow: View {
    let payment: Payment
    let currencyCode: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.amount, format: .currency(code: currencyCode))
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                if !payment.note.isEmpty {
                    Text(payment.note)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(payment.date, format: .dateTime.month().day().year())
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.caption2)
                        .foregroundColor(.red.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
        )
    }
}

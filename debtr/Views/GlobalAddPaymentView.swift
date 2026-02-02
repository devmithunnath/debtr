import SwiftUI
import SwiftData

struct GlobalAddPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @AppStorage("currencyCode") private var currencyCode: String = "USD"
    
    var debts: [DebtItem]
    
    @State private var selectedDebt: DebtItem?
    @State private var amount: Decimal = 0.0
    @State private var date: Date = Date()
    @State private var note: String = ""
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8).ignoresSafeArea()
            LiquidBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Record Payment")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(.white)
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
                    VStack(spacing: 24) {
                        // Section: Target
                        GlassSection(title: "Target Debt", icon: "target", color: .blue) {
                            HStack {
                                Text("Select Debt")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Picker("", selection: $selectedDebt) {
                                    Text("Choose...").tag(nil as DebtItem?)
                                    ForEach(debts) { debt in
                                        Text(debt.name).tag(debt as DebtItem?)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.menu)
                            }
                        }
                        
                        if selectedDebt != nil {
                            // Section: Payment Details
                            GlassSection(title: "Payment Details", icon: "banknote.fill", color: .green) {
                                GlassCurrencyField(label: "Amount", value: $amount, currencyCode: currencyCode)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Payment Date")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                    DatePicker("", selection: $date, displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                        .labelsHidden()
                                        .colorInvert()
                                        .colorMultiply(.green)
                                }
                                
                                GlassTextField(label: "Note", text: $note, placeholder: "Optional note")
                            }
                        } else {
                            // Guidance for user
                            VStack(spacing: 12) {
                                Image(systemName: "arrow.up")
                                    .font(.title)
                                    .foregroundColor(.blue.opacity(0.5))
                                Text("Select a debt above to continue")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                            .background(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.05), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Footer
                VStack(spacing: 0) {
                    Divider().background(Color.white.opacity(0.1))
                    HStack {
                        Button("Cancel") { dismiss() }
                            .buttonStyle(GlassButtonStyle(color: .white.opacity(0.5)))
                        
                        Spacer()
                        
                        Button("Save Payment") {
                            savePayment()
                        }
                        .disabled(selectedDebt == nil || amount <= 0)
                        .buttonStyle(GlassButtonStyle(color: .green))
                    }
                    .padding(24)
                }
                .background(.ultraThinMaterial)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(width: 450, height: 600)
        .preferredColorScheme(.dark)
    }
    
    private func savePayment() {
        guard let debt = selectedDebt else { return }
        
        let payment = Payment(amount: amount, date: date, note: note, debtItem: debt)
        modelContext.insert(payment)
        
        // Update the debt's current balance
        debt.currentBalance -= amount
        
        dismiss()
    }
}

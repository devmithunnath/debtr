import SwiftUI
import SwiftData

struct AddDebtView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @AppStorage("currencyCode") private var currencyCode: String = "USD"
    
    @State private var name = ""
    @State private var type: DebtType = .creditCard
    @State private var startingBalance: Decimal = 0.0
    @State private var currentBalance: Decimal = 0.0
    @State private var apr: Decimal = 0.0
    @State private var dueDate: Date = Date()
    @State private var hasDueDate = false
    @State private var hasApr = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8).ignoresSafeArea()
            LiquidBackground()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Add New Debt")
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
                    VStack(spacing: 20) {
                        // Section: Details
                        GlassSection(title: "Details", icon: "doc.text.fill", color: .blue) {
                            GlassTextField(label: "Name", text: $name, placeholder: "e.g. Chase Credit Card")
                            
                            HStack {
                                Text("Type")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Picker("", selection: $type) {
                                    ForEach(DebtType.allCases) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.menu)
                            }
                        }
                        
                        // Section: Balances
                        GlassSection(title: "Balances", icon: "dollarsign.circle.fill", color: .green) {
                            GlassCurrencyField(label: "Starting", value: $startingBalance, currencyCode: currencyCode)
                            GlassCurrencyField(label: "Current", value: $currentBalance, currencyCode: currencyCode)
                        }
                        
                        // Section: Extras
                        GlassSection(title: "Settings", icon: "slider.horizontal.3", color: .purple) {
                            ToggleView(label: "Annual Percentage Rate (APR)", isOn: $hasApr)
                            if hasApr {
                                GlassNumberField(label: "APR %", value: $apr)
                            }
                            
                            ToggleView(label: "Set Due Date", isOn: $hasDueDate)
                            if hasDueDate {
                                DatePicker("", selection: $dueDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .colorInvert() // Basic way to make it look okay on dark
                                    .colorMultiply(.blue)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                // Footer
                VStack(spacing: 0) {
                    Divider().background(Color.white.opacity(0.1))
                    HStack {
                        Button("Cancel") { dismiss() }
                            .buttonStyle(GlassButtonStyle(color: .white.opacity(0.5)))
                        
                        Spacer()
                        
                        Button("Save Debt") {
                            save()
                        }
                        .disabled(name.isEmpty)
                        .buttonStyle(GlassButtonStyle(color: .blue))
                    }
                    .padding(24)
                }
                .background(.ultraThinMaterial)
            }
        }
        .frame(width: 480, height: 650)
        .preferredColorScheme(.dark)
    }
    
    func save() {
        let newDebt = DebtItem(
            type: type,
            name: name,
            startingBalance: startingBalance,
            currentBalance: currentBalance,
            apr: hasApr ? apr : nil,
            dueDate: hasDueDate ? dueDate : nil
        )
        modelContext.insert(newDebt)
        dismiss()
    }
}

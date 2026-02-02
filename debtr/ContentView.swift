import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DebtItem.dueDate, order: .forward) private var debts: [DebtItem]
    
    @State private var showingAddDebt = false
    @State private var showingSettings = false
    @State private var showingRecordPayment = false
    @State private var selectedDebtForPayments: DebtItem?
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Liquid Gradient Background Layer
            Color(red: 0.02, green: 0.02, blue: 0.05).ignoresSafeArea()
            LiquidBackground()
            
            VStack(alignment: .leading, spacing: 0) {
                // Header / Overview Section
                OverviewView(debts: debts)
                    .padding(.horizontal, 24)
                    .padding(.top, 48)
                    .padding(.bottom, 24)
                
                // Content Section
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Text("Your Debts")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 10) {
                            Button(action: { showingRecordPayment = true }) {
                                Label("Record Payment", systemImage: "banknote.fill")
                            }
                            .buttonStyle(GlassButtonStyle(color: .green))
                            .disabled(debts.isEmpty)
                            
                            Button(action: { showingAddDebt = true }) {
                                Label("Add Debt", systemImage: "plus")
                            }
                            .buttonStyle(GlassButtonStyle(color: .blue))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    ScrollView {
                        VStack(spacing: 14) {
                            if debts.isEmpty {
                                EmptyStateView()
                            } else {
                                ForEach(debts) { debt in
                                    DebtRowView(debt: debt) {
                                        selectedDebtForPayments = debt
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            
            // Settings Button
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
            .padding(24)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingAddDebt) {
            AddDebtView()
        }
        .sheet(isPresented: $showingRecordPayment) {
            GlobalAddPaymentView(debts: debts)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(item: $selectedDebtForPayments) { debt in
            PaymentsSheetView(debt: debt)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
            }
            
            VStack(spacing: 8) {
                Text("Debt Free")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("You are debt free! Add your first debt to start tracking.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(48)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color.white.opacity(0.1), lineWidth: 1))
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DebtItem.self, inMemory: true)
}

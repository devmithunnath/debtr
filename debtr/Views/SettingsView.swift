import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("currencyCode") private var currencyCode: String = "USD"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    let currencies = ["USD", "EUR", "GBP", "CAD", "AUD", "JPY", "CNY", "INR"]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.02, green: 0.02, blue: 0.05).ignoresSafeArea()
            LiquidBackground()
            
            VStack(spacing: 0) {
                // Header - added extra top padding for hidden title bar
                HStack {
                    Text("Settings")
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
                .padding(.top, 48) // More space for the window drag area
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Section: Currency
                        GlassSection(title: "Currency", icon: "dollarsign.circle.fill", color: .green) {
                            HStack {
                                Text("Primary Currency")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Picker("", selection: $currencyCode) {
                                    ForEach(currencies, id: \.self) { code in
                                        Text(code).tag(code)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.menu)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        // Section: About
                        GlassSection(title: "About", icon: "info.circle.fill", color: .purple) {
                            HStack {
                                Text("Version")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Text("1.0.0")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                
                // Footer
                VStack(spacing: 0) {
                    Divider().background(Color.white.opacity(0.1))
                    Button("Done") { dismiss() }
                        .buttonStyle(GlassButtonStyle(color: .blue))
                        .frame(maxWidth: .infinity)
                        .padding(24)
                }
                .background(.ultraThinMaterial)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(width: 420, height: 550)
        .preferredColorScheme(.dark)
    }
}

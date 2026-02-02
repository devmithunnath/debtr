import SwiftUI

// MARK: - Glass Components

struct GlassSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14, weight: .bold))
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(spacing: 12) {
                content
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.05))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.1), lineWidth: 1))
            )
        }
    }
}

struct GlassTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.4))
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.3)))
                .foregroundColor(.white)
        }
    }
}

struct GlassCurrencyField: View {
    let label: String
    @Binding var value: Decimal
    let currencyCode: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.4))
            TextField("", value: $value, format: .currency(code: currencyCode))
                .textFieldStyle(.plain)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.3)))
                .foregroundColor(.white)
        }
    }
}

struct GlassNumberField: View {
    let label: String
    @Binding var value: Decimal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.4))
            TextField("", value: $value, format: .number)
                .textFieldStyle(.plain)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.3)))
                .foregroundColor(.white)
        }
    }
}

struct ToggleView: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
        }
    }
}

struct LiquidBackground: View {
    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 500, height: 400)
                .blur(radius: 100)
                .offset(x: -200, y: -250)
            
            Ellipse()
                .fill(Color.purple.opacity(0.2))
                .frame(width: 400, height: 500)
                .blur(radius: 100)
                .offset(x: 200, y: 200)
            
            Ellipse()
                .fill(Color.cyan.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: 0, y: 0)
        }
        .ignoresSafeArea()
    }
}

struct GlassButtonStyle: ButtonStyle {
    var color: Color = .blue
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isPressed ? color.opacity(0.4) : Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(configuration.isPressed ? color : Color.white.opacity(0.15), lineWidth: 1.5)
                    )
            )
            .foregroundColor(configuration.isPressed ? .white : .white.opacity(0.9))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

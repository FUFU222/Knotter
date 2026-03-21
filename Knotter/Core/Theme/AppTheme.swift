import SwiftUI

enum AppTheme {
    // MARK: - Spacing
    static let cornerRadius: CGFloat = 12
    static let spacing: CGFloat = 16
    static let smallSpacing: CGFloat = 8
    static let iconSize: CGFloat = 28

    // MARK: - Animations
    static let springSnappy = Animation.spring(response: 0.35, dampingFraction: 0.7)
    static let springBouncy = Animation.spring(response: 0.4, dampingFraction: 0.5)
    static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let easeOutQuick = Animation.easeOut(duration: 0.2)

    // MARK: - Shadows
    static func glowShadow(color: Color = .rescueOrange, radius: CGFloat = 12) -> some View {
        color.opacity(0.4).blur(radius: radius)
    }
}

// MARK: - Haptics Utility

enum Haptics {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - View Modifiers

extension View {
    /// タップ時にスケールダウンするインタラクティブボタン
    func pressAnimation() -> some View {
        self.buttonStyle(PressButtonStyle())
    }
}

struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

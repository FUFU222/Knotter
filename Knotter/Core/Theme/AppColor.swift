import SwiftUI

extension Color {
    // MARK: - Core Palette
    static let rescueOrange = Color(red: 1.0, green: 0.353, blue: 0.0) // #FF5A00
    static let darkBackground = Color(red: 0.07, green: 0.07, blue: 0.07)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let subtleGray = Color(red: 0.6, green: 0.6, blue: 0.6)

    // MARK: - Extended Palette
    static let emberGlow = Color(red: 1.0, green: 0.45, blue: 0.1)
    static let deepOrange = Color(red: 0.85, green: 0.25, blue: 0.0)
    static let surfaceElevated = Color(red: 0.15, green: 0.15, blue: 0.15)
    static let shimmerBase = Color(red: 0.14, green: 0.14, blue: 0.14)
    static let shimmerHighlight = Color(red: 0.22, green: 0.22, blue: 0.22)
}

// MARK: - Gradients

extension LinearGradient {
    /// メインのオレンジグラデーション
    static let orangeGlow = LinearGradient(
        colors: [.deepOrange, .rescueOrange, .emberGlow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// 投稿オーバーレイ用（4段階でより自然に）
    static let feedOverlay = LinearGradient(
        colors: [.clear, .clear, .black.opacity(0.3), .black.opacity(0.85)],
        startPoint: .top,
        endPoint: .bottom
    )
}

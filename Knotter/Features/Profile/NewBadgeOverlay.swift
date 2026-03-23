import SwiftUI

/// 新バッジ獲得時の祝福オーバーレイ
struct NewBadgeOverlay: View {
    let badge: BadgeDefinition
    let onDismiss: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(appeared ? 0.7 : 0)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 20) {
                Text(String(localized: "badge_new_earned"))
                    .font(.headline)
                    .foregroundColor(.subtleGray)

                ZStack {
                    // Glow effect
                    Circle()
                        .fill(badge.badgeCategory.accentColor.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)

                    Circle()
                        .fill(badge.badgeCategory.accentColor.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: badge.iconName)
                        .font(.system(size: 44))
                        .foregroundColor(badge.badgeCategory.accentColor)
                }
                .scaleEffect(appeared ? 1.0 : 0.3)

                Text(badge.localizedName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if let desc = badge.localizedDescription {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.subtleGray)
                        .multilineTextAlignment(.center)
                }

                Button {
                    dismiss()
                } label: {
                    Text("OK")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient.orangeGlow
                        )
                        .cornerRadius(14)
                }
                .padding(.horizontal, 40)
                .padding(.top, 8)
            }
            .padding(32)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 30)
        }
        .onAppear {
            withAnimation(AppTheme.springBouncy) {
                appeared = true
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            appeared = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onDismiss()
        }
    }
}

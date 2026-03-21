import SwiftUI

struct FireLikeButton: View {
    let isLiked: Bool
    let likeCount: Int
    let onTap: () -> Void

    @State private var animationScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.0

    var body: some View {
        VStack(spacing: 4) {
            Button(action: {
                withAnimation(AppTheme.springBouncy) {
                    animationScale = 1.5
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(AppTheme.springBouncy) {
                        animationScale = 1.0
                    }
                }

                // いいね時にグローエフェクト
                if !isLiked {
                    withAnimation(.easeOut(duration: 0.3)) {
                        glowOpacity = 0.6
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            glowOpacity = 0.0
                        }
                    }
                }

                Haptics.medium()
                onTap()
            }) {
                ZStack {
                    // グロー背景
                    Circle()
                        .fill(Color.rescueOrange)
                        .frame(width: 50, height: 50)
                        .blur(radius: 15)
                        .opacity(glowOpacity)

                    Image(systemName: isLiked ? "flame.fill" : "flame")
                        .font(.system(size: AppTheme.iconSize))
                        .foregroundStyle(
                            isLiked
                                ? AnyShapeStyle(.linearGradient(
                                    colors: [.emberGlow, .rescueOrange],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                : AnyShapeStyle(.white)
                        )
                        .scaleEffect(animationScale)
                        .shadow(
                            color: isLiked ? .rescueOrange.opacity(0.5) : .clear,
                            radius: 8
                        )
                }
            }

            Text("\(likeCount)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(AppTheme.springSnappy, value: likeCount)
        }
    }
}

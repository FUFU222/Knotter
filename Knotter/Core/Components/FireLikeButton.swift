import SwiftUI

struct FireLikeButton: View {
    let isLiked: Bool
    let likeCount: Int
    let onTap: () -> Void

    @State private var animationScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 4) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    animationScale = 1.4
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        animationScale = 1.0
                    }
                }
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                onTap()
            }) {
                Image(systemName: isLiked ? "flame.fill" : "flame")
                    .font(.system(size: AppTheme.iconSize))
                    .foregroundColor(isLiked ? .rescueOrange : .white)
                    .scaleEffect(animationScale)
            }

            Text("\(likeCount)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

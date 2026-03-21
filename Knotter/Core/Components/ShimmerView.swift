import SwiftUI

/// シマー（キラキラ）ローディングプレースホルダー
struct ShimmerView: View {
    @State private var phase: CGFloat = -1.0

    var body: some View {
        GeometryReader { geometry in
            Color.shimmerBase
                .overlay(
                    LinearGradient(
                        colors: [
                            .shimmerBase,
                            .shimmerHighlight,
                            .shimmerBase
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.6)
                    .offset(x: geometry.size.width * phase)
                )
                .clipped()
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1.5
            }
        }
    }
}

/// フィード用のスケルトンローディング
struct FeedSkeletonView: View {
    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // フィルターバーのスケルトン
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.smallSpacing) {
                        ForEach(0..<5, id: \.self) { _ in
                            ShimmerView()
                                .frame(width: 72, height: 36)
                                .cornerRadius(AppTheme.cornerRadius)
                        }
                    }
                    .padding(.horizontal, AppTheme.spacing)
                    .padding(.vertical, AppTheme.smallSpacing)
                }

                // メインコンテンツのスケルトン
                ZStack(alignment: .bottom) {
                    ShimmerView()
                        .ignoresSafeArea()

                    // 下部のテキストスケルトン
                    VStack(alignment: .leading, spacing: 12) {
                        ShimmerView()
                            .frame(width: 120, height: 16)
                            .cornerRadius(4)

                        ShimmerView()
                            .frame(width: 200, height: 14)
                            .cornerRadius(4)

                        ShimmerView()
                            .frame(width: 80, height: 28)
                            .cornerRadius(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppTheme.spacing)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

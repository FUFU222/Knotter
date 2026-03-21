import SwiftUI

/// ダブルタップ時に表示する炎エフェクトオーバーレイ
struct DoubleTapLikeOverlay: View {
    @Binding var showEffect: Bool

    @State private var scale: CGFloat = 0.0
    @State private var opacity: Double = 0.0
    @State private var particleOffsets: [CGSize] = (0..<6).map { _ in .zero }
    @State private var particleOpacities: [Double] = Array(repeating: 0.0, count: 6)

    var body: some View {
        ZStack {
            // メインの炎アイコン
            Image(systemName: "flame.fill")
                .font(.system(size: 80, weight: .bold))
                .foregroundStyle(.linearGradient(
                    colors: [.emberGlow, .rescueOrange, .deepOrange],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .shadow(color: .rescueOrange.opacity(0.6), radius: 20)
                .scaleEffect(scale)
                .opacity(opacity)

            // パーティクル（小さな炎）
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: "flame.fill")
                    .font(.system(size: CGFloat.random(in: 14...22)))
                    .foregroundColor(.emberGlow)
                    .offset(particleOffsets[i])
                    .opacity(particleOpacities[i])
            }
        }
        .onChange(of: showEffect) { newValue in
            if newValue {
                triggerAnimation()
            }
        }
    }

    private func triggerAnimation() {
        // リセット
        scale = 0.0
        opacity = 1.0
        particleOffsets = (0..<6).map { _ in .zero }
        particleOpacities = Array(repeating: 1.0, count: 6)

        // メインの炎: バウンスイン
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
            scale = 1.2
        }

        // 少し縮む
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }

        // パーティクル散開
        for i in 0..<6 {
            let angle = Double(i) * (360.0 / 6.0) * .pi / 180.0
            let distance: CGFloat = CGFloat.random(in: 40...70)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    particleOffsets[i] = CGSize(
                        width: cos(angle) * distance,
                        height: sin(angle) * distance - 20 // 上方向バイアス
                    )
                    particleOpacities[i] = 0.0
                }
            }
        }

        // フェードアウト
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0.0
            }
        }

        // リセット
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showEffect = false
        }
    }
}

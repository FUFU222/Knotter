import SwiftUI

@main
struct KnotterApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch authViewModel.authState {
                case .loading:
                    SplashView()
                case .unauthenticated:
                    AuthView(viewModel: authViewModel)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                case .authenticated:
                    ContentView(authViewModel: authViewModel)
                        .transition(.opacity)
                }
            }
            .animation(AppTheme.springGentle, value: authViewModel.authState)
            .preferredColorScheme(.dark)
            .task {
                await authViewModel.checkSession()
            }
        }
    }
}

// MARK: - Splash View

struct SplashView: View {
    @State private var flameScale: CGFloat = 0.6
    @State private var flameOpacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            ZStack {
                // パルスリング
                Circle()
                    .stroke(Color.rescueOrange.opacity(0.2), lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .scaleEffect(pulseScale)
                    .opacity(2.0 - Double(pulseScale))

                // メインの炎
                VStack(spacing: 16) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(LinearGradient.orangeGlow)
                        .shadow(color: .rescueOrange.opacity(0.5), radius: 20)
                        .scaleEffect(flameScale)
                        .opacity(flameOpacity)

                    Text("KNOTTER")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                        .kerning(6)
                        .opacity(flameOpacity)
                }
            }
        }
        .onAppear {
            // 炎のフェードイン
            withAnimation(AppTheme.springBouncy) {
                flameScale = 1.0
                flameOpacity = 1.0
            }

            // パルスアニメーション（繰り返し）
            withAnimation(
                .easeOut(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                pulseScale = 2.0
            }
        }
    }
}

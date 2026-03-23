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
    @State private var iconScale: CGFloat = 0.8
    @State private var iconOpacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                Image("KnotterLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)

                Text("KNOTTER")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .kerning(6)
                    .opacity(iconOpacity)

                Text(String(localized: "app_tagline"))
                    .font(.subheadline)
                    .foregroundColor(.subtleGray)
                    .opacity(iconOpacity)
            }
        }
        .onAppear {
            withAnimation(AppTheme.springBouncy) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
        }
    }
}

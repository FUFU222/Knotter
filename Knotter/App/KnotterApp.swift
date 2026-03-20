import SwiftUI

@main
struct KnotterApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch authViewModel.authState {
                case .loading:
                    splashView
                case .unauthenticated:
                    AuthView(viewModel: authViewModel)
                case .authenticated:
                    ContentView(authViewModel: authViewModel)
                }
            }
            .preferredColorScheme(.dark)
            .task {
                await authViewModel.checkSession()
            }
        }
    }

    private var splashView: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.rescueOrange)
                ProgressView()
                    .tint(.rescueOrange)
            }
        }
    }
}

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var logoAppeared = false
    @State private var formAppeared = false
    @State private var errorShake = false

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    // Logo area — 起動時アニメーション
                    VStack(spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(LinearGradient.orangeGlow)
                            .shadow(color: .rescueOrange.opacity(0.4), radius: 20)
                            .scaleEffect(logoAppeared ? 1.0 : 0.5)
                            .opacity(logoAppeared ? 1 : 0)

                        Text("KNOTTER")
                            .font(.system(size: 32, weight: .black, design: .default))
                            .foregroundColor(.white)
                            .kerning(4)
                            .opacity(logoAppeared ? 1 : 0)
                            .offset(y: logoAppeared ? 0 : 10)

                        Text(String(localized: "app_tagline"))
                            .font(.subheadline)
                            .foregroundColor(.subtleGray)
                            .opacity(logoAppeared ? 1 : 0)
                    }
                    .padding(.top, 60)

                    // Form — フェードインアニメーション
                    VStack(spacing: AppTheme.spacing) {
                        // Mode switcher
                        modeSwitcher

                        // Email
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(localized: "auth_email"))
                                .font(.caption)
                                .foregroundColor(.subtleGray)
                            TextField("email@example.com", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(14)
                                .background(Color.cardBackground)
                                .cornerRadius(AppTheme.cornerRadius)
                                .foregroundColor(.white)
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(localized: "auth_password"))
                                .font(.caption)
                                .foregroundColor(.subtleGray)
                            SecureField(String(localized: "auth_password_hint"), text: $viewModel.password)
                                .textContentType(viewModel.authMode == .signUp ? .newPassword : .password)
                                .padding(14)
                                .background(Color.cardBackground)
                                .cornerRadius(AppTheme.cornerRadius)
                                .foregroundColor(.white)
                        }

                        // Confirm password (sign up only)
                        if viewModel.authMode == .signUp {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(String(localized: "auth_confirm_password"))
                                    .font(.caption)
                                    .foregroundColor(.subtleGray)
                                SecureField(String(localized: "auth_confirm_password_hint"), text: $viewModel.confirmPassword)
                                    .textContentType(.newPassword)
                                    .padding(14)
                                    .background(Color.cardBackground)
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .foregroundColor(.white)

                                if viewModel.passwordMismatch {
                                    Text(String(localized: "auth_password_mismatch"))
                                        .font(.caption2)
                                        .foregroundColor(.red)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Error message — シェイクアニメーション
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.rescueOrange)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .offset(x: errorShake ? -6 : 0)
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }

                        // Submit button
                        Button {
                            Task {
                                await viewModel.submit()
                                if viewModel.errorMessage != nil {
                                    triggerShake()
                                    Haptics.heavy()
                                } else {
                                    Haptics.success()
                                }
                            }
                        } label: {
                            Group {
                                if viewModel.isProcessing {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text(viewModel.authMode == .signIn ? String(localized: "auth_sign_in") : String(localized: "auth_create_account"))
                                        .fontWeight(.bold)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Group {
                                    if viewModel.canSubmit {
                                        LinearGradient.orangeGlow
                                    } else {
                                        LinearGradient(colors: [Color.subtleGray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                                    }
                                }
                            )
                            .cornerRadius(AppTheme.cornerRadius)
                            .animation(AppTheme.easeOutQuick, value: viewModel.canSubmit)
                        }
                        .pressAnimation()
                        .disabled(!viewModel.canSubmit)
                    }
                    .padding(.horizontal, AppTheme.spacing)
                    .opacity(formAppeared ? 1 : 0)
                    .offset(y: formAppeared ? 0 : 20)

                    Spacer(minLength: 40)
                }
            }
        }
        .animation(AppTheme.springSnappy, value: viewModel.authMode)
        .animation(AppTheme.springSnappy, value: viewModel.errorMessage)
        .onAppear {
            withAnimation(AppTheme.springBouncy.delay(0.1)) {
                logoAppeared = true
            }
            withAnimation(AppTheme.springGentle.delay(0.3)) {
                formAppeared = true
            }
        }
    }

    // MARK: - Mode Switcher

    private var modeSwitcher: some View {
        HStack(spacing: 0) {
            modeTab(title: String(localized: "auth_sign_in"), mode: .signIn)
            modeTab(title: String(localized: "auth_sign_up"), mode: .signUp)
        }
        .background(Color.cardBackground)
        .cornerRadius(AppTheme.cornerRadius)
    }

    private func modeTab(title: String, mode: AuthViewModel.AuthMode) -> some View {
        Button {
            withAnimation(AppTheme.springSnappy) {
                viewModel.authMode = mode
                viewModel.errorMessage = nil
            }
            Haptics.selection()
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(viewModel.authMode == mode ? .bold : .regular)
                .foregroundColor(viewModel.authMode == mode ? .white : .subtleGray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    Group {
                        if viewModel.authMode == mode {
                            LinearGradient.orangeGlow.opacity(0.9)
                        } else {
                            Color.clear
                        }
                    }
                )
                .cornerRadius(AppTheme.cornerRadius)
        }
    }

    // MARK: - Shake Animation

    private func triggerShake() {
        withAnimation(.default) { errorShake = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.default) { errorShake = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            withAnimation(.default) { errorShake = true }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            withAnimation(.default) { errorShake = false }
        }
    }
}

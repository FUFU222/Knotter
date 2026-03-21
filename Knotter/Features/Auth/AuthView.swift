import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    // Logo area
                    VStack(spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.rescueOrange)

                        Text("KNOTTER")
                            .font(.system(size: 32, weight: .black, design: .default))
                            .foregroundColor(.white)
                            .kerning(4)

                        Text(String(localized: "app_tagline"))
                            .font(.subheadline)
                            .foregroundColor(.subtleGray)
                    }
                    .padding(.top, 60)

                    // Mode switcher
                    HStack(spacing: 0) {
                        modeTab(title: String(localized: "auth_sign_in"), mode: .signIn)
                        modeTab(title: String(localized: "auth_sign_up"), mode: .signUp)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(AppTheme.cornerRadius)
                    .padding(.horizontal, AppTheme.spacing)

                    // Form
                    VStack(spacing: AppTheme.spacing) {
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
                                }
                            }
                        }

                        // Error message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.rescueOrange)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                        }

                        // Submit button
                        Button {
                            Task { await viewModel.submit() }
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
                                viewModel.canSubmit
                                    ? Color.rescueOrange
                                    : Color.subtleGray.opacity(0.3)
                            )
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                        .disabled(!viewModel.canSubmit)
                    }
                    .padding(.horizontal, AppTheme.spacing)

                    Spacer(minLength: 40)
                }
            }
        }
    }

    // MARK: - Sub views

    private func modeTab(title: String, mode: AuthViewModel.AuthMode) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.authMode = mode
                viewModel.errorMessage = nil
            }
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(viewModel.authMode == mode ? .bold : .regular)
                .foregroundColor(viewModel.authMode == mode ? .white : .subtleGray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    viewModel.authMode == mode
                        ? Color.rescueOrange.opacity(0.8)
                        : Color.clear
                )
                .cornerRadius(AppTheme.cornerRadius)
        }
    }
}

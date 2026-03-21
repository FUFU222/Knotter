import Foundation
import Supabase

@MainActor
final class AuthViewModel: ObservableObject {

    enum AuthState: Equatable {
        case loading
        case unauthenticated
        case authenticated
    }

    enum AuthMode {
        case signIn
        case signUp
    }

    @Published var authState: AuthState = .loading
    @Published var authMode: AuthMode = .signIn
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isProcessing: Bool = false

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - Validation

    var canSubmit: Bool {
        let emailValid = email.contains("@") && email.contains(".")
        let passwordValid = password.count >= 6
        if authMode == .signUp {
            return emailValid && passwordValid && password == confirmPassword && !isProcessing
        }
        return emailValid && passwordValid && !isProcessing
    }

    var passwordMismatch: Bool {
        authMode == .signUp && !confirmPassword.isEmpty && password != confirmPassword
    }

    // MARK: - Auth Actions

    /// 初回起動時のセッション確認
    func checkSession() async {
        do {
            let session = try await client.auth.session
            _ = session.user
            authState = .authenticated
        } catch {
            authState = .unauthenticated
        }
    }

    /// サインイン
    func signIn() async {
        isProcessing = true
        errorMessage = nil
        do {
            _ = try await client.auth.signIn(
                email: email,
                password: password
            )
            authState = .authenticated
            resetForm()
        } catch {
            errorMessage = mapError(error)
        }
        isProcessing = false
    }

    /// サインアップ
    func signUp() async {
        isProcessing = true
        errorMessage = nil
        do {
            let response = try await client.auth.signUp(
                email: email,
                password: password
            )
            // Supabaseの設定次第でメール確認が必要な場合がある
            if response.session != nil {
                authState = .authenticated
                resetForm()
            } else {
                errorMessage = String(localized: "error_confirm_email")
            }
        } catch {
            errorMessage = mapError(error)
        }
        isProcessing = false
    }

    /// サインアウト
    func signOut() async {
        do {
            try await client.auth.signOut()
        } catch {
            print("[AuthViewModel] signOut error: \(error)")
        }
        authState = .unauthenticated
        resetForm()
    }

    /// 送信（モード別）
    func submit() async {
        switch authMode {
        case .signIn:
            await signIn()
        case .signUp:
            await signUp()
        }
    }

    // MARK: - Helpers

    private func resetForm() {
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }

    private func mapError(_ error: Error) -> String {
        let message = error.localizedDescription.lowercased()
        if message.contains("invalid login") || message.contains("invalid_credentials") {
            return String(localized: "error_invalid_credentials")
        }
        if message.contains("already registered") || message.contains("user_already_exists") {
            return String(localized: "error_already_registered")
        }
        if message.contains("weak password") || message.contains("password") {
            return String(localized: "error_weak_password")
        }
        if message.contains("rate limit") {
            return String(localized: "error_rate_limit")
        }
        return String(localized: "error_generic")
    }
}

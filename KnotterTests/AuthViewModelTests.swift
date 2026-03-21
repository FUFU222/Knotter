import XCTest
@testable import Knotter

@MainActor
final class AuthViewModelTests: XCTestCase {

    // MARK: - Validation (canSubmit)

    func testCanSubmit_signIn_validCredentials() {
        let sut = AuthViewModel()
        sut.authMode = .signIn
        sut.email = "test@example.com"
        sut.password = "123456"

        XCTAssertTrue(sut.canSubmit)
    }

    func testCanSubmit_signIn_invalidEmail() {
        let sut = AuthViewModel()
        sut.authMode = .signIn
        sut.email = "invalid"
        sut.password = "123456"

        XCTAssertFalse(sut.canSubmit)
    }

    func testCanSubmit_signIn_shortPassword() {
        let sut = AuthViewModel()
        sut.authMode = .signIn
        sut.email = "test@example.com"
        sut.password = "12345"

        XCTAssertFalse(sut.canSubmit)
    }

    func testCanSubmit_signUp_passwordMismatch() {
        let sut = AuthViewModel()
        sut.authMode = .signUp
        sut.email = "test@example.com"
        sut.password = "123456"
        sut.confirmPassword = "654321"

        XCTAssertFalse(sut.canSubmit)
    }

    func testCanSubmit_signUp_passwordMatch() {
        let sut = AuthViewModel()
        sut.authMode = .signUp
        sut.email = "test@example.com"
        sut.password = "123456"
        sut.confirmPassword = "123456"

        XCTAssertTrue(sut.canSubmit)
    }

    func testCanSubmit_isProcessing_returnsFalse() {
        let sut = AuthViewModel()
        sut.email = "test@example.com"
        sut.password = "123456"
        sut.isProcessing = true

        XCTAssertFalse(sut.canSubmit)
    }

    // MARK: - passwordMismatch

    func testPasswordMismatch_signUp_different() {
        let sut = AuthViewModel()
        sut.authMode = .signUp
        sut.password = "123456"
        sut.confirmPassword = "abcdef"

        XCTAssertTrue(sut.passwordMismatch)
    }

    func testPasswordMismatch_signUp_same() {
        let sut = AuthViewModel()
        sut.authMode = .signUp
        sut.password = "123456"
        sut.confirmPassword = "123456"

        XCTAssertFalse(sut.passwordMismatch)
    }

    func testPasswordMismatch_signUp_emptyConfirm() {
        let sut = AuthViewModel()
        sut.authMode = .signUp
        sut.password = "123456"
        sut.confirmPassword = ""

        XCTAssertFalse(sut.passwordMismatch, "空のconfirmPasswordではmismatch表示しない")
    }

    func testPasswordMismatch_signIn_alwaysFalse() {
        let sut = AuthViewModel()
        sut.authMode = .signIn
        sut.password = "123456"
        sut.confirmPassword = "abcdef"

        XCTAssertFalse(sut.passwordMismatch, "サインインモードではmismatch判定しない")
    }

    // MARK: - Initial State

    func testInitialState() {
        let sut = AuthViewModel()

        XCTAssertEqual(sut.authState, .loading)
        XCTAssertEqual(sut.authMode, .signIn)
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.password.isEmpty)
        XCTAssertTrue(sut.confirmPassword.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isProcessing)
    }
}

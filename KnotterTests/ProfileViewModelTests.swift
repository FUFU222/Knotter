import XCTest
@testable import Knotter

@MainActor
final class ProfileViewModelTests: XCTestCase {

    // MARK: - enforceMaxBio

    func testEnforceMaxBio_underLimit_noChange() {
        let sut = ProfileViewModel()
        sut.editingBio = "Short bio"

        sut.enforceMaxBio()

        XCTAssertEqual(sut.editingBio, "Short bio")
    }

    func testEnforceMaxBio_overLimit_truncates() {
        let sut = ProfileViewModel()
        sut.editingBio = String(repeating: "x", count: 200)

        sut.enforceMaxBio()

        XCTAssertEqual(sut.editingBio.count, ProfileViewModel.maxBioLength)
    }

    func testEnforceMaxBio_exactLimit_noChange() {
        let sut = ProfileViewModel()
        let exactBio = String(repeating: "x", count: ProfileViewModel.maxBioLength)
        sut.editingBio = exactBio

        sut.enforceMaxBio()

        XCTAssertEqual(sut.editingBio, exactBio)
    }

    // MARK: - maxBioLength

    func testMaxBioLength_is160() {
        XCTAssertEqual(ProfileViewModel.maxBioLength, 160)
    }

    // MARK: - Computed Properties

    func testPostCount_empty() {
        let sut = ProfileViewModel()
        XCTAssertEqual(sut.postCount, 0)
    }

    func testTotalLikes_empty() {
        let sut = ProfileViewModel()
        XCTAssertEqual(sut.totalLikes, 0)
    }

    // MARK: - Editing State

    func testCancelEditing_setsIsEditingFalse() {
        let sut = ProfileViewModel()
        sut.isEditing = true

        sut.cancelEditing()

        XCTAssertFalse(sut.isEditing)
    }

    func testStartEditing_withoutProfile_doesNotSetEditing() {
        let sut = ProfileViewModel()
        sut.profile = nil

        sut.startEditing()

        XCTAssertFalse(sut.isEditing)
    }

    // MARK: - Initial State

    func testInitialState() {
        let sut = ProfileViewModel()

        XCTAssertNil(sut.profile)
        XCTAssertTrue(sut.myPosts.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isEditing)
        XCTAssertFalse(sut.isSaving)
        XCTAssertEqual(sut.followerCount, 0)
        XCTAssertEqual(sut.followingCount, 0)
    }
}

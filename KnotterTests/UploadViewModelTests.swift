import XCTest
@testable import Knotter

@MainActor
final class UploadViewModelTests: XCTestCase {

    private var mockRepo: MockPostRepository!
    private var sut: UploadViewModel!

    override func setUp() {
        super.setUp()
        mockRepo = MockPostRepository()
        sut = UploadViewModel(repository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    // MARK: - canSubmit

    func testCanSubmit_allFieldsSet_returnsTrue() {
        sut.selectedImage = UIImage()
        sut.selectedKnotType = .bowline

        XCTAssertTrue(sut.canSubmit)
    }

    func testCanSubmit_noImage_returnsFalse() {
        sut.selectedImage = nil
        sut.selectedKnotType = .bowline

        XCTAssertFalse(sut.canSubmit)
    }

    func testCanSubmit_noKnotType_returnsFalse() {
        sut.selectedImage = UIImage()
        sut.selectedKnotType = nil

        XCTAssertFalse(sut.canSubmit)
    }

    func testCanSubmit_isSubmitting_returnsFalse() {
        sut.selectedImage = UIImage()
        sut.selectedKnotType = .bowline
        sut.isSubmitting = true

        XCTAssertFalse(sut.canSubmit)
    }

    // MARK: - enforceMaxCaption

    func testEnforceMaxCaption_underLimit_noChange() {
        sut.caption = "Short caption"

        sut.enforceMaxCaption()

        XCTAssertEqual(sut.caption, "Short caption")
    }

    func testEnforceMaxCaption_overLimit_truncates() {
        sut.caption = String(repeating: "a", count: 150)

        sut.enforceMaxCaption()

        XCTAssertEqual(sut.caption.count, UploadViewModel.maxCaptionLength)
    }

    func testEnforceMaxCaption_exactLimit_noChange() {
        let exactCaption = String(repeating: "a", count: UploadViewModel.maxCaptionLength)
        sut.caption = exactCaption

        sut.enforceMaxCaption()

        XCTAssertEqual(sut.caption, exactCaption)
    }

    // MARK: - Initial State

    func testInitialState() {
        XCTAssertNil(sut.selectedItem)
        XCTAssertNil(sut.selectedImage)
        XCTAssertTrue(sut.caption.isEmpty)
        XCTAssertNil(sut.selectedKnotType)
        XCTAssertFalse(sut.showSuccessAlert)
        XCTAssertFalse(sut.isSubmitting)
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - maxCaptionLength

    func testMaxCaptionLength_is100() {
        XCTAssertEqual(UploadViewModel.maxCaptionLength, 100)
    }
}

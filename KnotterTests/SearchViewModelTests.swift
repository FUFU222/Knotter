import XCTest
@testable import Knotter

@MainActor
final class SearchViewModelTests: XCTestCase {

    // MARK: - SearchScope

    func testSearchScope_allCases() {
        let allCases = SearchScope.allCases
        XCTAssertEqual(allCases.count, 2)
        XCTAssertTrue(allCases.contains(.posts))
        XCTAssertTrue(allCases.contains(.users))
    }

    func testSearchScope_displayName_notEmpty() {
        for scope in SearchScope.allCases {
            XCTAssertFalse(scope.displayName.isEmpty, "\(scope) should have a non-empty displayName")
        }
    }

    // MARK: - Initial State

    func testInitialState() {
        let sut = SearchViewModel()

        XCTAssertTrue(sut.query.isEmpty)
        XCTAssertEqual(sut.selectedScope, .posts)
        XCTAssertTrue(sut.postResults.isEmpty)
        XCTAssertTrue(sut.userResults.isEmpty)
        XCTAssertFalse(sut.isSearching)
    }
}

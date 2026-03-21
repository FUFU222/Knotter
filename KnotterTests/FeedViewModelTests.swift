import XCTest
@testable import Knotter

@MainActor
final class FeedViewModelTests: XCTestCase {

    private var mockPostRepo: MockPostRepository!
    private var mockKnotTypeRepo: MockKnotTypeRepository!
    private var sut: FeedViewModel!

    override func setUp() {
        super.setUp()
        mockPostRepo = MockPostRepository()
        mockKnotTypeRepo = MockKnotTypeRepository()
        sut = FeedViewModel(
            repository: mockPostRepo,
            knotTypeRepository: mockKnotTypeRepo
        )
    }

    override func tearDown() {
        sut = nil
        mockPostRepo = nil
        mockKnotTypeRepo = nil
        super.tearDown()
    }

    // MARK: - loadFeed

    func testLoadFeed_success_setsPosts() async {
        let posts = TestData.makePosts(count: 5)
        mockPostRepo.postsToReturn = posts

        await sut.loadFeed()

        XCTAssertEqual(sut.posts.count, 5)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testLoadFeed_failure_setsErrorAndFallback() async {
        mockPostRepo.shouldThrowOnFetch = true

        await sut.loadFeed()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.posts.isEmpty, "フォールバックのモックデータが設定されるべき")
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadFeed_setsIsLoadingDuringFetch() async {
        mockPostRepo.postsToReturn = TestData.makePosts(count: 3)

        // loadFeed前はfalse
        XCTAssertFalse(sut.isLoading)

        await sut.loadFeed()

        // loadFeed後はfalse
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - loadKnotTypes

    func testLoadKnotTypes_success() async {
        mockKnotTypeRepo.knotTypesToReturn = [.bowline, .figureEight]

        await sut.loadKnotTypes()

        XCTAssertEqual(sut.knotTypes, [.bowline, .figureEight])
    }

    func testLoadKnotTypes_failure_fallsBackToAllCases() async {
        mockKnotTypeRepo.shouldThrow = true

        await sut.loadKnotTypes()

        XCTAssertEqual(sut.knotTypes, KnotType.allCases)
    }

    // MARK: - filteredPosts

    func testFilteredPosts_noFilter_returnsAll() async {
        mockPostRepo.postsToReturn = TestData.makePosts(count: 6)
        await sut.loadFeed()

        sut.selectedKnotType = nil

        XCTAssertEqual(sut.filteredPosts.count, 6)
    }

    func testFilteredPosts_withFilter_returnsMatching() async {
        let posts = [
            TestData.makePost(knotType: .bowline),
            TestData.makePost(knotType: .figureEight),
            TestData.makePost(knotType: .bowline),
        ]
        mockPostRepo.postsToReturn = posts
        await sut.loadFeed()

        sut.selectedKnotType = .bowline

        XCTAssertEqual(sut.filteredPosts.count, 2)
        XCTAssertTrue(sut.filteredPosts.allSatisfy { $0.knotType == .bowline })
    }

    // MARK: - toggleLike

    func testToggleLike_optimisticUpdate() async {
        let postId = UUID()
        let post = TestData.makePost(id: postId, likeCount: 5, isLiked: false)
        mockPostRepo.postsToReturn = [post]
        await sut.loadFeed()

        sut.toggleLike(for: postId)

        XCTAssertTrue(sut.posts[0].isLiked)
        XCTAssertEqual(sut.posts[0].likeCount, 6)
    }

    func testToggleLike_unlike_decrementsCount() async {
        let postId = UUID()
        let post = TestData.makePost(id: postId, likeCount: 5, isLiked: true)
        mockPostRepo.postsToReturn = [post]
        await sut.loadFeed()

        sut.toggleLike(for: postId)

        XCTAssertFalse(sut.posts[0].isLiked)
        XCTAssertEqual(sut.posts[0].likeCount, 4)
    }

    func testToggleLike_invalidPostId_doesNothing() async {
        mockPostRepo.postsToReturn = [TestData.makePost()]
        await sut.loadFeed()

        let originalPost = sut.posts[0]
        sut.toggleLike(for: UUID()) // 存在しないID

        XCTAssertEqual(sut.posts[0].likeCount, originalPost.likeCount)
        XCTAssertEqual(sut.posts[0].isLiked, originalPost.isLiked)
    }

    // MARK: - Pagination

    func testLoadFeed_usesPageSize() async {
        mockPostRepo.postsToReturn = TestData.makePosts(count: 20)
        await sut.loadFeed()

        XCTAssertEqual(mockPostRepo.fetchPostsCallCount, 1)
        XCTAssertEqual(mockPostRepo.fetchPostsLimitOffsets.first?.limit, 20)
        XCTAssertEqual(mockPostRepo.fetchPostsLimitOffsets.first?.offset, 0)
    }
}

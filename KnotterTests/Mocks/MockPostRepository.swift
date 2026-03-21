import Foundation
@testable import Knotter

/// テスト用のモックPostRepository
final class MockPostRepository: PostRepository {

    var postsToReturn: [Post] = []
    var shouldThrowOnFetch = false
    var toggleLikeResult = true
    var shouldThrowOnToggleLike = false
    var shouldThrowOnCreate = false
    var knotTypesToReturn: [KnotTypeRecord] = []

    // 呼び出し記録
    var fetchPostsCallCount = 0
    var fetchPostsLimitOffsets: [(limit: Int, offset: Int)] = []
    var toggleLikeCallCount = 0
    var lastToggledPostId: UUID?
    var createPostCallCount = 0

    func fetchPosts() async throws -> [Post] {
        try await fetchPosts(limit: 20, offset: 0)
    }

    func fetchPosts(limit: Int, offset: Int) async throws -> [Post] {
        fetchPostsCallCount += 1
        fetchPostsLimitOffsets.append((limit: limit, offset: offset))
        if shouldThrowOnFetch {
            throw NSError(domain: "MockError", code: -1)
        }
        // ページネーションをシミュレート
        let start = min(offset, postsToReturn.count)
        let end = min(offset + limit, postsToReturn.count)
        return Array(postsToReturn[start..<end])
    }

    func toggleLike(postId: UUID) async throws -> Bool {
        toggleLikeCallCount += 1
        lastToggledPostId = postId
        if shouldThrowOnToggleLike {
            throw NSError(domain: "MockError", code: -1)
        }
        return toggleLikeResult
    }

    func fetchKnotTypes() async throws -> [KnotTypeRecord] {
        return knotTypesToReturn
    }

    func createPost(imageData: Data, caption: String, knotTypeSlug: String) async throws {
        createPostCallCount += 1
        if shouldThrowOnCreate {
            throw NSError(domain: "MockError", code: -1)
        }
    }
}

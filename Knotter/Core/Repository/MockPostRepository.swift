import Foundation

/// モックデータを返すリポジトリ実装
/// ネットワーク不要。開発・プレビュー用。
final class MockPostRepository: PostRepository {

    func fetchPosts() async throws -> [Post] {
        // 少し遅延を入れてローディング体験を再現
        try await Task.sleep(nanoseconds: 300_000_000)
        return MockPosts.samples
    }

    func toggleLike(postId: UUID) async throws -> Bool {
        // モックでは常に成功
        return true
    }

    func createPost(imageData: Data, caption: String, knotTypeSlug: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    func fetchKnotTypes() async throws -> [KnotTypeRecord] {
        return KnotType.allCases.map { knotType in
            KnotTypeRecord(
                id: UUID(),
                slug: knotType.rawValue,
                displayName: knotType.displayName,
                description: nil
            )
        }
    }
}

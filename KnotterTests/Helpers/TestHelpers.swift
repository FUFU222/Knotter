import Foundation
@testable import Knotter

/// テスト用のサンプルデータ
enum TestData {
    static func makePost(
        id: UUID = UUID(),
        userId: UUID = UUID(),
        username: String = "testuser",
        mediaType: MediaType = .image,
        mediaUrl: String = "https://example.com/image.jpg",
        caption: String = "Test caption",
        knotType: KnotType = .bowline,
        likeCount: Int = 0,
        isLiked: Bool = false
    ) -> Post {
        Post(
            id: id,
            userId: userId,
            username: username,
            mediaType: mediaType,
            mediaUrl: mediaUrl,
            caption: caption,
            knotType: knotType,
            likeCount: likeCount,
            isLiked: isLiked
        )
    }

    static func makePosts(count: Int) -> [Post] {
        (0..<count).map { i in
            makePost(
                id: UUID(),
                username: "user\(i)",
                caption: "Post \(i)",
                knotType: KnotType.allCases[i % KnotType.allCases.count],
                likeCount: i
            )
        }
    }
}

import XCTest
@testable import Knotter

final class SupabaseDTOsTests: XCTestCase {

    // MARK: - SupabasePostDTO.toPost()

    func testToPost_defaultIsLikedFalse() {
        let dto = makePostDTO()

        let post = dto.toPost()

        XCTAssertFalse(post.isLiked)
    }

    func testToPost_isLikedTrue() {
        let dto = makePostDTO()

        let post = dto.toPost(isLiked: true)

        XCTAssertTrue(post.isLiked)
    }

    func testToPost_mapsAllFields() {
        let id = UUID()
        let userId = UUID()
        let dto = makePostDTO(
            id: id,
            userId: userId,
            mediaType: "image",
            mediaUrl: "https://example.com/img.jpg",
            caption: "Test caption",
            likeCount: 42,
            knotSlug: "bowline",
            username: "testuser"
        )

        let post = dto.toPost(isLiked: true)

        XCTAssertEqual(post.id, id)
        XCTAssertEqual(post.userId, userId)
        XCTAssertEqual(post.username, "testuser")
        XCTAssertEqual(post.mediaType, .image)
        XCTAssertEqual(post.mediaUrl, "https://example.com/img.jpg")
        XCTAssertEqual(post.caption, "Test caption")
        XCTAssertEqual(post.knotType, .bowline)
        XCTAssertEqual(post.likeCount, 42)
        XCTAssertTrue(post.isLiked)
    }

    func testToPost_nilCaption_becomesEmptyString() {
        let dto = makePostDTO(caption: nil)

        let post = dto.toPost()

        XCTAssertEqual(post.caption, "")
    }

    func testToPost_unknownMediaType_defaultsToImage() {
        let dto = makePostDTO(mediaType: "unknown_type")

        let post = dto.toPost()

        XCTAssertEqual(post.mediaType, .image)
    }

    func testToPost_unknownKnotSlug_defaultsToBowline() {
        let dto = makePostDTO(knotSlug: "unknown_knot")

        let post = dto.toPost()

        XCTAssertEqual(post.knotType, .bowline)
    }

    // MARK: - Helpers

    private func makePostDTO(
        id: UUID = UUID(),
        userId: UUID = UUID(),
        mediaType: String = "image",
        mediaUrl: String = "https://example.com/img.jpg",
        caption: String? = "Test",
        likeCount: Int = 0,
        knotSlug: String = "bowline",
        username: String = "testuser"
    ) -> SupabasePostDTO {
        SupabasePostDTO(
            id: id,
            userId: userId,
            mediaType: mediaType,
            mediaUrl: mediaUrl,
            thumbnailUrl: nil,
            caption: caption,
            likeCount: likeCount,
            createdAt: "2025-01-01T00:00:00Z",
            profiles: SupabaseProfileDTO(username: username, avatarUrl: nil),
            knotTypes: SupabaseKnotTypeDTO(slug: knotSlug, displayName: "Test Knot")
        )
    }
}

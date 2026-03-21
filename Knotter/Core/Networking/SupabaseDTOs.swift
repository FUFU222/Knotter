import Foundation

/// Supabase APIレスポンスの共通DTO
/// 複数のリポジトリで共有して使用する

// MARK: - Post DTO

struct SupabasePostDTO: Decodable {
    let id: UUID
    let userId: UUID
    let mediaType: String
    let mediaUrl: String
    let thumbnailUrl: String?
    let caption: String?
    let likeCount: Int
    let createdAt: String
    let profiles: SupabaseProfileDTO
    let knotTypes: SupabaseKnotTypeDTO

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case mediaType = "media_type"
        case mediaUrl = "media_url"
        case thumbnailUrl = "thumbnail_url"
        case caption
        case likeCount = "like_count"
        case createdAt = "created_at"
        case profiles
        case knotTypes = "knot_types"
    }

    /// DTOからドメインモデルへ変換
    func toPost(isLiked: Bool = false) -> Post {
        Post(
            id: id,
            userId: userId,
            username: profiles.username,
            mediaType: MediaType(rawValue: mediaType) ?? .image,
            mediaUrl: mediaUrl,
            caption: caption ?? "",
            knotType: KnotType(rawValue: knotTypes.slug) ?? .bowline,
            likeCount: likeCount,
            isLiked: isLiked
        )
    }
}

// MARK: - Profile DTO (join用の軽量版)

struct SupabaseProfileDTO: Decodable {
    let username: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case username
        case avatarUrl = "avatar_url"
    }
}

// MARK: - KnotType DTO

struct SupabaseKnotTypeDTO: Decodable {
    let slug: String
    let displayName: String

    enum CodingKeys: String, CodingKey {
        case slug
        case displayName = "display_name"
    }
}

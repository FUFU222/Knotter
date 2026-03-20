import Foundation
import Supabase

final class SupabaseSearchRepository: SearchRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - DTO

    private struct PostDTO: Decodable {
        let id: UUID
        let userId: UUID
        let mediaType: String
        let mediaUrl: String
        let thumbnailUrl: String?
        let caption: String?
        let likeCount: Int
        let createdAt: String
        let profiles: ProfileDTO
        let knotTypes: KnotTypeDTO

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
    }

    private struct ProfileDTO: Decodable {
        let username: String
        let avatarUrl: String?

        enum CodingKeys: String, CodingKey {
            case username
            case avatarUrl = "avatar_url"
        }
    }

    private struct KnotTypeDTO: Decodable {
        let slug: String
        let displayName: String

        enum CodingKeys: String, CodingKey {
            case slug
            case displayName = "display_name"
        }
    }

    // MARK: - SearchRepository

    func searchPosts(query: String) async throws -> [Post] {
        let dtos: [PostDTO] = try await client
            .from("posts")
            .select("*, profiles(username, avatar_url), knot_types(slug, display_name)")
            .ilike("caption", pattern: "%\(query)%")
            .order("created_at", ascending: false)
            .limit(30)
            .execute()
            .value

        return dtos.map { dto in
            Post(
                id: dto.id,
                userId: dto.userId,
                username: dto.profiles.username,
                mediaType: MediaType(rawValue: dto.mediaType) ?? .image,
                mediaUrl: dto.mediaUrl,
                caption: dto.caption ?? "",
                knotType: KnotType(rawValue: dto.knotTypes.slug) ?? .bowline,
                likeCount: dto.likeCount,
                isLiked: false
            )
        }
    }

    func searchUsers(query: String) async throws -> [Profile] {
        let profiles: [Profile] = try await client
            .from("profiles")
            .select()
            .ilike("username", pattern: "%\(query)%")
            .order("username")
            .limit(30)
            .execute()
            .value

        return profiles
    }
}

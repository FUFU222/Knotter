import Foundation
import Supabase

/// Supabase接続のプロフィールリポジトリ実装
final class SupabaseProfileRepository: ProfileRepository {

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

    // MARK: - ProfileRepository

    func fetchMyProfile() async throws -> Profile {
        let userId = try await client.auth.session.user.id
        return try await fetchProfile(userId: userId)
    }

    func fetchProfile(userId: UUID) async throws -> Profile {
        let profile: Profile = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
        return profile
    }

    func updateProfile(userId: UUID, payload: Profile.UpdatePayload) async throws -> Profile {
        let updated: Profile = try await client
            .from("profiles")
            .update(payload)
            .eq("id", value: userId.uuidString)
            .select()
            .single()
            .execute()
            .value
        return updated
    }

    func fetchUserPosts(userId: UUID) async throws -> [Post] {
        let dtos: [PostDTO] = try await client
            .from("posts")
            .select("*, profiles(username, avatar_url), knot_types(slug, display_name)")
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
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

    func uploadAvatar(userId: UUID, imageData: Data) async throws -> String {
        let fileName = "\(userId.uuidString)/avatar.jpg"

        // アップロード（上書き）
        try await client.storage
            .from("avatars")
            .upload(
                fileName,
                data: imageData,
                options: .init(contentType: "image/jpeg", upsert: true)
            )

        // 公開URLを取得
        let url = try client.storage
            .from("avatars")
            .getPublicURL(path: fileName)

        // プロフィールのavatar_urlを更新
        let payload = Profile.UpdatePayload(
            username: nil,
            displayName: nil,
            bio: nil,
            avatarUrl: url.absoluteString
        )
        _ = try await updateProfile(userId: userId, payload: payload)

        return url.absoluteString
    }
}

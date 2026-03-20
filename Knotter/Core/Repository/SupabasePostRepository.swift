import Foundation
import Supabase

/// Supabase接続のリポジトリ実装
final class SupabasePostRepository: PostRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - DTO (Supabaseレスポンス用)

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

    private struct LikeRow: Codable {
        let userId: UUID
        let postId: UUID

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case postId = "post_id"
        }
    }

    // MARK: - PostRepository

    func fetchPosts() async throws -> [Post] {
        // 現在のユーザーがいいね済みか判定するためにuser_idを取得
        let currentUserId = try? await client.auth.session.user.id

        let dtos: [PostDTO] = try await client
            .from("posts")
            .select("*, profiles(username, avatar_url), knot_types(slug, display_name)")
            .order("created_at", ascending: false)
            .execute()
            .value

        // いいね状態を一括取得
        var likedPostIds: Set<UUID> = []
        if let userId = currentUserId {
            struct LikeRecord: Decodable {
                let postId: UUID
                enum CodingKeys: String, CodingKey {
                    case postId = "post_id"
                }
            }
            let likes: [LikeRecord] = try await client
                .from("likes")
                .select("post_id")
                .eq("user_id", value: userId.uuidString)
                .execute()
                .value
            likedPostIds = Set(likes.map(\.postId))
        }

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
                isLiked: likedPostIds.contains(dto.id)
            )
        }
    }

    func toggleLike(postId: UUID) async throws -> Bool {
        let userId = try await client.auth.session.user.id
        let row = LikeRow(userId: userId, postId: postId)

        // いいね済みか確認
        let existing: [LikeRow] = try await client
            .from("likes")
            .select("user_id, post_id")
            .eq("user_id", value: userId.uuidString)
            .eq("post_id", value: postId.uuidString)
            .execute()
            .value

        if existing.isEmpty {
            // いいね追加
            try await client
                .from("likes")
                .insert(row)
                .execute()
            return true // liked
        } else {
            // いいね解除
            try await client
                .from("likes")
                .delete()
                .eq("user_id", value: userId.uuidString)
                .eq("post_id", value: postId.uuidString)
                .execute()
            return false // unliked
        }
    }

    // MARK: - Create Post

    private struct CreatePostPayload: Encodable {
        let userId: UUID
        let mediaType: String
        let mediaUrl: String
        let caption: String
        let knotTypeId: UUID
        let likeCount: Int

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case mediaType = "media_type"
            case mediaUrl = "media_url"
            case caption
            case knotTypeId = "knot_type_id"
            case likeCount = "like_count"
        }
    }

    func createPost(imageData: Data, caption: String, knotTypeSlug: String) async throws {
        let userId = try await client.auth.session.user.id

        // 1. Supabase Storageに画像アップロード
        let fileName = "\(userId.uuidString)/\(UUID().uuidString).jpg"
        try await client.storage
            .from("post-media")
            .upload(
                fileName,
                data: imageData,
                options: .init(contentType: "image/jpeg", upsert: false)
            )

        // 2. 公開URLを取得
        let mediaUrl = try client.storage
            .from("post-media")
            .getPublicURL(path: fileName)
            .absoluteString

        // 3. knot_type_idを取得
        let knotTypes: [KnotTypeRecord] = try await client
            .from("knot_types")
            .select()
            .eq("slug", value: knotTypeSlug)
            .limit(1)
            .execute()
            .value

        guard let knotType = knotTypes.first else {
            throw NSError(domain: "Knotter", code: 404, userInfo: [NSLocalizedDescriptionKey: "結索タイプが見つかりません"])
        }

        // 4. postsテーブルにINSERT
        let payload = CreatePostPayload(
            userId: userId,
            mediaType: "image",
            mediaUrl: mediaUrl,
            caption: caption,
            knotTypeId: knotType.id,
            likeCount: 0
        )
        try await client
            .from("posts")
            .insert(payload)
            .execute()
    }

    func fetchKnotTypes() async throws -> [KnotTypeRecord] {
        let records: [KnotTypeRecord] = try await client
            .from("knot_types")
            .select()
            .order("display_name")
            .execute()
            .value

        return records
    }
}

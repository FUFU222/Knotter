import Foundation
import Supabase

/// Supabase接続のフォローリポジトリ実装
final class SupabaseFollowRepository: FollowRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - DTO

    private struct FollowRow: Encodable {
        let followerId: UUID
        let followingId: UUID

        enum CodingKeys: String, CodingKey {
            case followerId = "follower_id"
            case followingId = "following_id"
        }
    }

    private struct FollowRecord: Decodable {
        let id: UUID
        let followerId: UUID
        let followingId: UUID
        let createdAt: String

        enum CodingKeys: String, CodingKey {
            case id
            case followerId = "follower_id"
            case followingId = "following_id"
            case createdAt = "created_at"
        }
    }

    /// follows JOIN profiles 用のDTO（follower側）
    private struct FollowerDTO: Decodable {
        let followerId: UUID
        let profiles: Profile

        enum CodingKeys: String, CodingKey {
            case followerId = "follower_id"
            case profiles
        }
    }

    /// follows JOIN profiles 用のDTO（following側）
    private struct FollowingDTO: Decodable {
        let followingId: UUID
        let profiles: Profile

        enum CodingKeys: String, CodingKey {
            case followingId = "following_id"
            case profiles
        }
    }

    // MARK: - FollowRepository

    func follow(userId: UUID) async throws {
        let currentUserId = try await client.auth.session.user.id

        let row = FollowRow(followerId: currentUserId, followingId: userId)

        // followsテーブルにINSERT
        try await client
            .from("follows")
            .insert(row)
            .execute()

        // フォローする側の following_count を +1
        try await client
            .rpc("increment_following_count", params: ["user_id_param": currentUserId.uuidString])
            .execute()

        // フォローされる側の follower_count を +1
        try await client
            .rpc("increment_follower_count", params: ["user_id_param": userId.uuidString])
            .execute()
    }

    func unfollow(userId: UUID) async throws {
        let currentUserId = try await client.auth.session.user.id

        // followsテーブルからDELETE
        try await client
            .from("follows")
            .delete()
            .eq("follower_id", value: currentUserId.uuidString)
            .eq("following_id", value: userId.uuidString)
            .execute()

        // フォローする側の following_count を -1
        try await client
            .rpc("decrement_following_count", params: ["user_id_param": currentUserId.uuidString])
            .execute()

        // フォローされる側の follower_count を -1
        try await client
            .rpc("decrement_follower_count", params: ["user_id_param": userId.uuidString])
            .execute()
    }

    func isFollowing(userId: UUID) async throws -> Bool {
        let currentUserId = try await client.auth.session.user.id

        let records: [FollowRecord] = try await client
            .from("follows")
            .select()
            .eq("follower_id", value: currentUserId.uuidString)
            .eq("following_id", value: userId.uuidString)
            .limit(1)
            .execute()
            .value

        return !records.isEmpty
    }

    func fetchFollowers(userId: UUID) async throws -> [Profile] {
        // follows テーブルで following_id = userId のレコードを取得し、
        // follower_id 側の profiles を JOIN で取得
        let dtos: [FollowerDTO] = try await client
            .from("follows")
            .select("follower_id, profiles:follower_id(id, username, display_name, avatar_url, bio, created_at, updated_at)")
            .eq("following_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value

        return dtos.map(\.profiles)
    }

    func fetchFollowing(userId: UUID) async throws -> [Profile] {
        // follows テーブルで follower_id = userId のレコードを取得し、
        // following_id 側の profiles を JOIN で取得
        let dtos: [FollowingDTO] = try await client
            .from("follows")
            .select("following_id, profiles:following_id(id, username, display_name, avatar_url, bio, created_at, updated_at)")
            .eq("follower_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value

        return dtos.map(\.profiles)
    }
}

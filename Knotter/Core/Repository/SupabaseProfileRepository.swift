import Foundation
import Supabase

/// Supabase接続のプロフィールリポジトリ実装
final class SupabaseProfileRepository: ProfileRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
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
        let dtos: [SupabasePostDTO] = try await client
            .from("posts")
            .select("*, profiles(username, avatar_url), knot_types(slug, display_name)")
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value

        return dtos.map { $0.toPost() }
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

import Foundation
import Supabase

final class SupabaseSearchRepository: SearchRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - SearchRepository

    func searchPosts(query: String) async throws -> [Post] {
        // ilike用にワイルドカード文字をエスケープ
        let sanitized = query
            .replacingOccurrences(of: "%", with: "\\%")
            .replacingOccurrences(of: "_", with: "\\_")

        let dtos: [SupabasePostDTO] = try await client
            .from("posts")
            .select("*, profiles(username, avatar_url), knot_types(slug, display_name)")
            .ilike("caption", pattern: "%\(sanitized)%")
            .order("created_at", ascending: false)
            .limit(30)
            .execute()
            .value

        return dtos.map { $0.toPost() }
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

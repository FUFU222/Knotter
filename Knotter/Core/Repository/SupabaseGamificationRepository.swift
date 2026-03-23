import Foundation
import Supabase

/// Supabase接続のゲーミフィケーションリポジトリ実装
final class SupabaseGamificationRepository: GamificationRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    func fetchUserStats(userId: UUID) async throws -> UserStats? {
        let response: [UserStats] = try await client
            .from("user_stats")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
        return response.first
    }

    func fetchMyStats() async throws -> UserStats? {
        let userId = try await client.auth.session.user.id
        return try await fetchUserStats(userId: userId)
    }

    func fetchAllBadgeDefinitions() async throws -> [BadgeDefinition] {
        try await client
            .from("badge_definitions")
            .select()
            .order("sort_order")
            .execute()
            .value
    }

    func fetchUserBadges(userId: UUID) async throws -> [UserBadge] {
        try await client
            .from("user_badges")
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
    }

    func fetchMyBadges() async throws -> [UserBadge] {
        let userId = try await client.auth.session.user.id
        return try await fetchUserBadges(userId: userId)
    }

    func checkAndAwardBadges() async throws -> [BadgeDefinition] {
        let userId = try await client.auth.session.user.id
        return try await client
            .rpc("check_and_award_badges", params: ["p_user_id": userId.uuidString])
            .execute()
            .value
    }
}

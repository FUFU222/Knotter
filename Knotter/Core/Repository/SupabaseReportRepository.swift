import Foundation

final class SupabaseReportRepository: ReportRepository {
    func reportPost(postId: UUID, reason: ReportReason) async throws {
        let userId = try await SupabaseManager.client.auth.session.user.id
        try await SupabaseManager.client
            .from("reports")
            .insert([
                "reporter_id": userId.uuidString,
                "post_id": postId.uuidString,
                "reason": reason.rawValue
            ])
            .execute()
    }

    func reportUser(userId: UUID, reason: ReportReason) async throws {
        let myId = try await SupabaseManager.client.auth.session.user.id
        try await SupabaseManager.client
            .from("reports")
            .insert([
                "reporter_id": myId.uuidString,
                "reported_user_id": userId.uuidString,
                "reason": reason.rawValue
            ])
            .execute()
    }

    func blockUser(userId: UUID) async throws {
        let myId = try await SupabaseManager.client.auth.session.user.id
        try await SupabaseManager.client
            .from("blocks")
            .insert([
                "blocker_id": myId.uuidString,
                "blocked_id": userId.uuidString
            ])
            .execute()
    }

    func unblockUser(userId: UUID) async throws {
        let myId = try await SupabaseManager.client.auth.session.user.id
        try await SupabaseManager.client
            .from("blocks")
            .delete()
            .eq("blocker_id", value: myId.uuidString)
            .eq("blocked_id", value: userId.uuidString)
            .execute()
    }

    func fetchBlockedUsers() async throws -> [UUID] {
        struct BlockRow: Decodable {
            let blocked_id: UUID
        }
        let myId = try await SupabaseManager.client.auth.session.user.id
        let rows: [BlockRow] = try await SupabaseManager.client
            .from("blocks")
            .select("blocked_id")
            .eq("blocker_id", value: myId.uuidString)
            .execute()
            .value
        return rows.map(\.blocked_id)
    }
}

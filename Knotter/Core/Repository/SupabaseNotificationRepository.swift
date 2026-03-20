import Foundation
import Supabase

final class SupabaseNotificationRepository: NotificationRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - DTO

    private struct NotificationDTO: Decodable {
        let id: UUID
        let userId: UUID
        let actorId: UUID?
        let type: String
        let postId: UUID?
        let isRead: Bool
        let createdAt: String
        let profiles: ActorDTO

        enum CodingKeys: String, CodingKey {
            case id
            case userId = "user_id"
            case actorId = "actor_id"
            case type
            case postId = "post_id"
            case isRead = "is_read"
            case createdAt = "created_at"
            case profiles
        }
    }

    private struct ActorDTO: Decodable {
        let username: String
        let avatarUrl: String?

        enum CodingKeys: String, CodingKey {
            case username
            case avatarUrl = "avatar_url"
        }
    }

    private struct MarkReadPayload: Encodable {
        let isRead: Bool

        enum CodingKeys: String, CodingKey {
            case isRead = "is_read"
        }
    }

    // MARK: - NotificationRepository

    func fetchNotifications() async throws -> [AppNotification] {
        let dtos: [NotificationDTO] = try await client
            .from("notifications")
            .select("*, profiles!notifications_actor_id_fkey(username, avatar_url)")
            .order("created_at", ascending: false)
            .limit(50)
            .execute()
            .value

        return dtos.compactMap { dto in
            guard let type = AppNotification.NotificationType(rawValue: dto.type) else { return nil }
            return AppNotification(
                id: dto.id,
                userId: dto.userId,
                actorId: dto.actorId,
                actorUsername: dto.profiles.username,
                actorAvatarUrl: dto.profiles.avatarUrl,
                type: type,
                postId: dto.postId,
                isRead: dto.isRead,
                createdAt: dto.createdAt
            )
        }
    }

    func markAsRead(notificationId: UUID) async throws {
        try await client
            .from("notifications")
            .update(MarkReadPayload(isRead: true))
            .eq("id", value: notificationId.uuidString)
            .execute()
    }

    func markAllAsRead() async throws {
        let userId = try await client.auth.session.user.id
        try await client
            .from("notifications")
            .update(MarkReadPayload(isRead: true))
            .eq("user_id", value: userId.uuidString)
            .eq("is_read", value: "false")
            .execute()
    }
}

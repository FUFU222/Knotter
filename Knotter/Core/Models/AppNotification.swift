import Foundation

struct AppNotification: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let actorId: UUID?
    let actorUsername: String
    let actorAvatarUrl: String?
    let type: NotificationType
    let postId: UUID?
    let isRead: Bool
    let createdAt: String

    enum NotificationType: String, Codable {
        case like
        case comment
        case follow
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case actorId = "actor_id"
        case actorUsername = "actor_username"
        case actorAvatarUrl = "actor_avatar_url"
        case type
        case postId = "post_id"
        case isRead = "is_read"
        case createdAt = "created_at"
    }
}

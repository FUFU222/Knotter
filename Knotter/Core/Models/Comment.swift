import Foundation

struct Comment: Identifiable, Codable {
    let id: UUID
    let postId: UUID
    let userId: UUID
    let username: String
    let avatarUrl: String?
    let content: String
    let createdAt: String
}

import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID
    var username: String
    var displayName: String?
    var avatarUrl: String?
    var bio: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case displayName = "display_name"
        case avatarUrl = "avatar_url"
        case bio
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    /// プロフィール更新用のペイロード
    struct UpdatePayload: Encodable {
        let username: String?
        let displayName: String?
        let bio: String?
        let avatarUrl: String?

        enum CodingKeys: String, CodingKey {
            case username
            case displayName = "display_name"
            case bio
            case avatarUrl = "avatar_url"
        }
    }
}

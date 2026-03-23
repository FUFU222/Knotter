import Foundation

struct UserStats: Codable {
    let userId: UUID
    let postCount: Int
    let totalLikesReceived: Int
    let currentStreak: Int
    let longestStreak: Int
    let lastPostDate: String?
    let distinctKnotTypesPosted: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case postCount = "post_count"
        case totalLikesReceived = "total_likes_received"
        case currentStreak = "current_streak"
        case longestStreak = "longest_streak"
        case lastPostDate = "last_post_date"
        case distinctKnotTypesPosted = "distinct_knot_types_posted"
    }
}

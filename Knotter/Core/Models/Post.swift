import Foundation

struct Post: Identifiable, Codable {
    let id: UUID
    let userId: UUID?
    let username: String
    let mediaType: MediaType
    let mediaUrl: String
    let caption: String
    let knotType: KnotType
    var likeCount: Int
    var isLiked: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case username
        case mediaType = "media_type"
        case mediaUrl = "media_url"
        case caption
        case knotType = "knot_type"
        case likeCount = "like_count"
        case isLiked = "is_liked"
    }
}

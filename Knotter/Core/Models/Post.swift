import Foundation

struct Post: Identifiable, Codable {
    let id: UUID
    let username: String
    let mediaType: MediaType
    let mediaAssetName: String
    let caption: String
    let knotType: KnotType
    var likeCount: Int
    var isLiked: Bool
}

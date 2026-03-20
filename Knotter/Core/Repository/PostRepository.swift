import Foundation

/// Post取得・操作のリポジトリプロトコル
/// MockとSupabase実装を差し替え可能にする
protocol PostRepository {
    /// フィード用の投稿一覧を取得
    func fetchPosts() async throws -> [Post]

    /// いいねをトグル（認証実装後に有効化）
    func toggleLike(postId: UUID) async throws -> Bool

    /// 結索タイプ一覧を取得
    func fetchKnotTypes() async throws -> [KnotTypeRecord]

    /// 投稿を作成（画像アップロード + DBインサート）
    func createPost(imageData: Data, caption: String, knotTypeSlug: String) async throws
}

/// DBのknot_typesテーブルに対応するレコード
struct KnotTypeRecord: Identifiable, Codable {
    let id: UUID
    let slug: String
    let displayName: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case displayName = "display_name"
        case description
    }
}

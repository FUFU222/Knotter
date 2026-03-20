import Foundation

/// フォロー機能のリポジトリプロトコル
/// MockとSupabase実装を差し替え可能にする
protocol FollowRepository {
    /// 指定ユーザーをフォローする
    func follow(userId: UUID) async throws

    /// 指定ユーザーのフォローを解除する
    func unfollow(userId: UUID) async throws

    /// 指定ユーザーをフォロー中かどうか判定する
    func isFollowing(userId: UUID) async throws -> Bool

    /// 指定ユーザーのフォロワー一覧を取得する
    func fetchFollowers(userId: UUID) async throws -> [Profile]

    /// 指定ユーザーがフォロー中のユーザー一覧を取得する
    func fetchFollowing(userId: UUID) async throws -> [Profile]
}

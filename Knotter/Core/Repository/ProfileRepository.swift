import Foundation

/// プロフィール操作のリポジトリプロトコル
protocol ProfileRepository {
    /// 現在のユーザーのプロフィールを取得
    func fetchMyProfile() async throws -> Profile

    /// 指定ユーザーのプロフィールを取得
    func fetchProfile(userId: UUID) async throws -> Profile

    /// プロフィールを更新
    func updateProfile(userId: UUID, payload: Profile.UpdatePayload) async throws -> Profile

    /// 指定ユーザーの投稿一覧を取得
    func fetchUserPosts(userId: UUID) async throws -> [Post]

    /// アバター画像をアップロードしてURLを返す
    func uploadAvatar(userId: UUID, imageData: Data) async throws -> String
}

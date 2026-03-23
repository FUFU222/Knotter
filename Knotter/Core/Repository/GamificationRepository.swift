import Foundation

/// ゲーミフィケーション（ランク・バッジ・ストリーク）のリポジトリプロトコル
protocol GamificationRepository {
    func fetchUserStats(userId: UUID) async throws -> UserStats?
    func fetchMyStats() async throws -> UserStats?
    func fetchAllBadgeDefinitions() async throws -> [BadgeDefinition]
    func fetchUserBadges(userId: UUID) async throws -> [UserBadge]
    func fetchMyBadges() async throws -> [UserBadge]
    func checkAndAwardBadges() async throws -> [BadgeDefinition]
}

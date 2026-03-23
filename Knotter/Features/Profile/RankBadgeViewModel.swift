import Foundation

@MainActor
final class RankBadgeViewModel: ObservableObject {
    @Published var userStats: UserStats?
    @Published var rank: UserRank = .beginner
    @Published var rankProgress: Double = 0.0
    @Published var rankPoints: Int = 0
    @Published var earnedBadgeIds: Set<UUID> = []
    @Published var allBadges: [BadgeDefinition] = []
    @Published var newlyEarnedBadges: [BadgeDefinition] = []
    @Published var isLoading = false

    private let repository: GamificationRepository

    init(repository: GamificationRepository = SupabaseGamificationRepository()) {
        self.repository = repository
    }

    var earnedBadges: [BadgeDefinition] {
        allBadges.filter { earnedBadgeIds.contains($0.id) }
    }

    var unearnedBadges: [BadgeDefinition] {
        allBadges.filter { !earnedBadgeIds.contains($0.id) }
    }

    func badgesByCategory(_ category: BadgeCategory) -> [BadgeDefinition] {
        allBadges.filter { $0.badgeCategory == category }
    }

    func isEarned(_ badge: BadgeDefinition) -> Bool {
        earnedBadgeIds.contains(badge.id)
    }

    func loadData(userId: UUID) async {
        isLoading = true
        async let statsTask = repository.fetchUserStats(userId: userId)
        async let badgesTask = repository.fetchAllBadgeDefinitions()
        async let earnedTask = repository.fetchUserBadges(userId: userId)

        do {
            let (stats, badges, earned) = try await (statsTask, badgesTask, earnedTask)
            self.userStats = stats
            self.allBadges = badges
            self.earnedBadgeIds = Set(earned.map(\.badgeId))

            if let stats = stats {
                self.rank = UserRank.rank(for: (stats.postCount * 10) + (stats.totalLikesReceived * 2) + (stats.longestStreak * 5))
                self.rankPoints = (stats.postCount * 10) + (stats.totalLikesReceived * 2) + (stats.longestStreak * 5)
                self.rankProgress = UserRank.progress(currentPoints: rankPoints, currentRank: rank)
            }
        } catch {
            print("[RankBadgeViewModel] load failed: \(error)")
        }
        isLoading = false
    }

    func checkForNewBadges() async {
        do {
            let newBadges = try await repository.checkAndAwardBadges()
            if !newBadges.isEmpty {
                self.newlyEarnedBadges = newBadges
                for badge in newBadges {
                    earnedBadgeIds.insert(badge.id)
                }
                Haptics.success()
            }
        } catch {
            print("[RankBadgeViewModel] badge check failed: \(error)")
        }
    }
}

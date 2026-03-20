import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {

    @Published var profile: Profile?
    @Published var userPosts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var isFollowing: Bool = false
    @Published var isTogglingFollow: Bool = false
    @Published var followerCount: Int = 0
    @Published var followingCount: Int = 0

    let userId: UUID

    private let profileRepository: ProfileRepository
    private let followRepository: FollowRepository

    var postCount: Int { userPosts.count }

    init(
        userId: UUID,
        profileRepository: ProfileRepository = SupabaseProfileRepository(),
        followRepository: FollowRepository = SupabaseFollowRepository()
    ) {
        self.userId = userId
        self.profileRepository = profileRepository
        self.followRepository = followRepository
    }

    func load() async {
        isLoading = true
        do {
            async let profileTask = profileRepository.fetchProfile(userId: userId)
            async let postsTask = profileRepository.fetchUserPosts(userId: userId)
            async let followingTask = followRepository.isFollowing(userId: userId)
            async let followersTask = followRepository.fetchFollowers(userId: userId)
            async let followingListTask = followRepository.fetchFollowing(userId: userId)

            let (p, posts, following, followers, followingList) = try await (
                profileTask, postsTask, followingTask, followersTask, followingListTask
            )

            profile = p
            userPosts = posts
            isFollowing = following
            followerCount = followers.count
            followingCount = followingList.count
        } catch {
            print("[UserProfileViewModel] load error: \(error)")
        }
        isLoading = false
    }

    func toggleFollow() async {
        isTogglingFollow = true
        do {
            if isFollowing {
                try await followRepository.unfollow(userId: userId)
                isFollowing = false
                followerCount = max(0, followerCount - 1)
            } else {
                try await followRepository.follow(userId: userId)
                isFollowing = true
                followerCount += 1
            }
        } catch {
            print("[UserProfileViewModel] toggleFollow error: \(error)")
        }
        isTogglingFollow = false
    }
}

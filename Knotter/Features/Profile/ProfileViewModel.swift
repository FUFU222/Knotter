import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var profile: Profile?
    @Published var myPosts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // 編集用
    @Published var editingUsername: String = ""
    @Published var editingDisplayName: String = ""
    @Published var editingBio: String = ""
    @Published var isEditing: Bool = false
    @Published var isSaving: Bool = false
    @Published var avatarItem: PhotosPickerItem?
    @Published var avatarImage: UIImage?
    @Published var isUploadingAvatar: Bool = false
    @Published var followerCount: Int = 0
    @Published var followingCount: Int = 0

    private let profileRepository: ProfileRepository
    private let postRepository: PostRepository
    private let followRepository: FollowRepository

    static let maxBioLength = 160

    init(
        profileRepository: ProfileRepository = SupabaseProfileRepository(),
        postRepository: PostRepository = SupabasePostRepository(),
        followRepository: FollowRepository = SupabaseFollowRepository()
    ) {
        self.profileRepository = profileRepository
        self.postRepository = postRepository
        self.followRepository = followRepository
    }

    var postCount: Int { myPosts.count }

    var totalLikes: Int {
        myPosts.reduce(0) { $0 + $1.likeCount }
    }

    // MARK: - Load

    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            let p = try await profileRepository.fetchMyProfile()
            profile = p
            editingUsername = p.username
            editingDisplayName = p.displayName ?? ""
            editingBio = p.bio ?? ""

            // 自分の投稿 + フォロー数を取得
            async let postsTask = profileRepository.fetchUserPosts(userId: p.id)
            async let followersTask = followRepository.fetchFollowers(userId: p.id)
            async let followingTask = followRepository.fetchFollowing(userId: p.id)

            let (posts, followers, following) = try await (postsTask, followersTask, followingTask)
            myPosts = posts
            followerCount = followers.count
            followingCount = following.count
        } catch {
            errorMessage = "プロフィールの読み込みに失敗しました"
            print("[ProfileViewModel] load error: \(error)")
        }
        isLoading = false
    }

    // MARK: - Edit

    func startEditing() {
        guard let p = profile else { return }
        editingUsername = p.username
        editingDisplayName = p.displayName ?? ""
        editingBio = p.bio ?? ""
        isEditing = true
    }

    func cancelEditing() {
        isEditing = false
    }

    func enforceMaxBio() {
        if editingBio.count > Self.maxBioLength {
            editingBio = String(editingBio.prefix(Self.maxBioLength))
        }
    }

    func saveProfile() async {
        guard let userId = profile?.id else { return }
        isSaving = true
        do {
            let payload = Profile.UpdatePayload(
                username: editingUsername.isEmpty ? nil : editingUsername,
                displayName: editingDisplayName.isEmpty ? nil : editingDisplayName,
                bio: editingBio.isEmpty ? nil : editingBio,
                avatarUrl: nil // アバターは別途アップロード
            )
            let updated = try await profileRepository.updateProfile(userId: userId, payload: payload)
            profile = updated
            isEditing = false
        } catch {
            errorMessage = "保存に失敗しました"
            print("[ProfileViewModel] save error: \(error)")
        }
        isSaving = false
    }

    // MARK: - Avatar

    func loadAvatarImage() async {
        guard let item = avatarItem else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            avatarImage = uiImage
            await uploadAvatar(uiImage: uiImage)
        }
    }

    private func uploadAvatar(uiImage: UIImage) async {
        guard let userId = profile?.id,
              let jpegData = uiImage.jpegData(compressionQuality: 0.8) else { return }
        isUploadingAvatar = true
        do {
            let url = try await profileRepository.uploadAvatar(userId: userId, imageData: jpegData)
            profile?.avatarUrl = url
        } catch {
            errorMessage = "アバターのアップロードに失敗しました"
            print("[ProfileViewModel] avatar upload error: \(error)")
        }
        isUploadingAvatar = false
    }
}

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
    static let minUsernameLength = 3
    static let maxUsernameLength = 20
    /// ユーザー名に使用可能: 英数字、アンダースコア、ドット
    static let usernameRegex = /^[a-zA-Z0-9_.]+$/

    var usernameValidationError: String? {
        let name = editingUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return String(localized: "error_username_empty")
        }
        if name.count < Self.minUsernameLength {
            return String(localized: "error_username_too_short")
        }
        if name.count > Self.maxUsernameLength {
            return String(localized: "error_username_too_long")
        }
        if name.wholeMatch(of: Self.usernameRegex) == nil {
            return String(localized: "error_username_invalid_chars")
        }
        return nil
    }

    var canSaveProfile: Bool {
        usernameValidationError == nil && !isSaving
    }

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
            errorMessage = String(localized: "error_profile_load")
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

    func enforceMaxUsername() {
        if editingUsername.count > Self.maxUsernameLength {
            editingUsername = String(editingUsername.prefix(Self.maxUsernameLength))
        }
    }

    func saveProfile() async {
        guard let userId = profile?.id else { return }
        guard usernameValidationError == nil else {
            errorMessage = usernameValidationError
            return
        }
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
            errorMessage = String(localized: "error_profile_save")
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
        let resized = ImageResizer.resize(uiImage, maxDimension: 400)
        guard let userId = profile?.id,
              let jpegData = resized.jpegData(compressionQuality: 0.8) else { return }
        isUploadingAvatar = true
        do {
            let url = try await profileRepository.uploadAvatar(userId: userId, imageData: jpegData)
            profile?.avatarUrl = url
        } catch {
            errorMessage = String(localized: "error_avatar_upload")
            print("[ProfileViewModel] avatar upload error: \(error)")
        }
        isUploadingAvatar = false
    }
}

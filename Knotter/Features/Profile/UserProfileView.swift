import SwiftUI

/// 他ユーザーのプロフィール画面（フォローボタン付き）
struct UserProfileView: View {
    let userId: UUID
    @StateObject private var viewModel: UserProfileViewModel
    @Environment(\.dismiss) private var dismiss

    init(userId: UUID) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: UserProfileViewModel(userId: userId))
    }

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            if viewModel.isLoading && viewModel.profile == nil {
                ProgressView()
                    .tint(.rescueOrange)
                    .scaleEffect(1.5)
            } else if let profile = viewModel.profile {
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader(profile: profile)
                        statsRow
                        followButton

                        if let bio = profile.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, AppTheme.spacing)
                        }

                        userPostsSection
                    }
                    .padding(.top, AppTheme.spacing)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "person.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.subtleGray)
                    Text(String(localized: "profile_user_not_found"))
                        .foregroundColor(.subtleGray)
                }
            }
        }
        .navigationTitle(viewModel.profile?.username ?? String(localized: "profile_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            await viewModel.load()
        }
    }

    // MARK: - Header

    private func profileHeader(profile: Profile) -> some View {
        VStack(spacing: 12) {
            if let urlStr = profile.avatarUrl, let url = URL(string: urlStr) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    avatarPlaceholder
                }
                .frame(width: 88, height: 88)
                .clipShape(Circle())
            } else {
                avatarPlaceholder
            }

            Text(profile.username)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            if let displayName = profile.displayName, !displayName.isEmpty {
                Text(displayName)
                    .font(.subheadline)
                    .foregroundColor(.subtleGray)
            }
        }
    }

    private var avatarPlaceholder: some View {
        Circle()
            .fill(Color.cardBackground)
            .frame(width: 88, height: 88)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.subtleGray)
            )
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(value: "\(viewModel.postCount)", label: String(localized: "profile_posts"))
            Divider().frame(height: 32).background(Color.subtleGray.opacity(0.3))
            statItem(value: "\(viewModel.followerCount)", label: String(localized: "profile_followers"))
            Divider().frame(height: 32).background(Color.subtleGray.opacity(0.3))
            statItem(value: "\(viewModel.followingCount)", label: String(localized: "profile_following"))
        }
        .padding(.horizontal, AppTheme.spacing)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.subtleGray)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Follow Button

    private var followButton: some View {
        Button {
            Task { await viewModel.toggleFollow() }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: viewModel.isFollowing ? "person.badge.minus" : "person.badge.plus")
                Text(viewModel.isFollowing ? String(localized: "profile_following") : String(localized: "profile_follow"))
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(viewModel.isFollowing ? .subtleGray : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(viewModel.isFollowing ? Color.cardBackground : Color.rescueOrange)
            .cornerRadius(AppTheme.cornerRadius)
        }
        .disabled(viewModel.isTogglingFollow)
        .padding(.horizontal, AppTheme.spacing)
    }

    // MARK: - Posts Grid

    private var userPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "profile_posts"))
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.spacing)

            if viewModel.userPosts.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.subtleGray)
                    Text(String(localized: "profile_no_posts"))
                        .font(.subheadline)
                        .foregroundColor(.subtleGray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 2),
                        GridItem(.flexible(), spacing: 2),
                        GridItem(.flexible(), spacing: 2)
                    ],
                    spacing: 2
                ) {
                    ForEach(viewModel.userPosts) { post in
                        postThumbnail(post: post)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private func postThumbnail(post: Post) -> some View {
        ZStack {
            Color.cardBackground
            MediaPlaceholderView(assetName: post.mediaUrl, mediaType: post.mediaType)

            if post.mediaType == .video {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "video.fill")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(4)
                    }
                    Spacer()
                }
            }

            VStack {
                Spacer()
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                    Text("\(post.likeCount)")
                        .font(.caption2)
                }
                .foregroundColor(.white)
                .padding(4)
                .background(.black.opacity(0.5))
                .cornerRadius(4)
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipped()
    }
}

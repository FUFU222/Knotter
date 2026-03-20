import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.authViewModel) private var authViewModel
    @State private var showSignOutConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.profile == nil {
                    ProgressView()
                        .tint(.rescueOrange)
                        .scaleEffect(1.5)
                } else if let profile = viewModel.profile {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Avatar + Info
                            profileHeader(profile: profile)

                            // Stats
                            statsRow

                            // Bio
                            if let bio = profile.bio, !bio.isEmpty {
                                Text(bio)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, AppTheme.spacing)
                            }

                            // Edit button
                            Button {
                                viewModel.startEditing()
                            } label: {
                                Text("プロフィール編集")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.rescueOrange)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                            .stroke(Color.rescueOrange, lineWidth: 1.5)
                                    )
                            }
                            .padding(.horizontal, AppTheme.spacing)

                            // My Posts Grid
                            myPostsSection
                        }
                        .padding(.top, AppTheme.spacing)
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "person.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.subtleGray)
                        Text("プロフィールを読み込めませんでした")
                            .foregroundColor(.subtleGray)
                    }
                }
            }
            .navigationTitle("プロフィール")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSignOutConfirm = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.subtleGray)
                    }
                }
            }
            .confirmationDialog("ログアウト", isPresented: $showSignOutConfirm) {
                Button("ログアウト", role: .destructive) {
                    Task { await authViewModel?.signOut() }
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("ログアウトしますか？")
            }
            .sheet(isPresented: $viewModel.isEditing) {
                ProfileEditView(viewModel: viewModel)
            }
            .task {
                await viewModel.loadProfile()
            }
        }
    }

    // MARK: - Header

    private func profileHeader(profile: Profile) -> some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                if let avatarImage = viewModel.avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                } else if let urlStr = profile.avatarUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        avatarPlaceholder
                    }
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                } else {
                    avatarPlaceholder
                }

                if viewModel.isUploadingAvatar {
                    Circle()
                        .fill(.black.opacity(0.5))
                        .frame(width: 88, height: 88)
                    ProgressView()
                        .tint(.white)
                }
            }

            // Username
            Text(profile.username)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Display name
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
            statItem(value: "\(viewModel.postCount)", label: "投稿")
            Divider()
                .frame(height: 32)
                .background(Color.subtleGray.opacity(0.3))
            statItem(value: "\(viewModel.followerCount)", label: "フォロワー")
            Divider()
                .frame(height: 32)
                .background(Color.subtleGray.opacity(0.3))
            statItem(value: "\(viewModel.followingCount)", label: "フォロー中")
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

    // MARK: - My Posts

    private var myPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("自分の投稿")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.spacing)

            if viewModel.myPosts.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.subtleGray)
                    Text("まだ投稿がありません")
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
                    ForEach(viewModel.myPosts) { post in
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

            // Video indicator
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

            // Like count overlay
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

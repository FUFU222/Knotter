import SwiftUI

struct FeedItemView: View {
    let post: Post
    let onLikeTapped: () -> Void
    @State private var showComments = false

    var body: some View {
        ZStack {
            // Background media
            MediaPlaceholderView(assetName: post.mediaUrl, mediaType: post.mediaType)
                .ignoresSafeArea()

            // Gradient overlay for readability
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, .black.opacity(0.8)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: 300)
            }
            .ignoresSafeArea()

            // Content overlay
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    // Left: post info
                    VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                        if let userId = post.userId {
                            NavigationLink(value: userId) {
                                Text(post.username)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        } else {
                            Text(post.username)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        Text(post.caption)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(3)

                        Text(post.knotType.displayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.rescueOrange.opacity(0.8))
                            .cornerRadius(6)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Right: action buttons
                    VStack(spacing: 20) {
                        FireLikeButton(
                            isLiked: post.isLiked,
                            likeCount: post.likeCount,
                            onTap: onLikeTapped
                        )

                        Button(action: { showComments = true }) {
                            VStack(spacing: 4) {
                                Image(systemName: "bubble.left.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text(String(localized: "feed_comments"))
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.trailing, 4)
                }
                .padding(.horizontal, AppTheme.spacing)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showComments) {
            CommentsView(postId: post.id)
        }
    }
}

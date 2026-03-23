import SwiftUI

struct FeedItemView: View {
    let post: Post
    let onLikeTapped: () -> Void
    @State private var showComments = false
    @State private var showDoubleTapEffect = false
    @State private var contentAppeared = false
    @State private var showReportSheet = false

    var body: some View {
        ZStack {
            // Background media
            MediaPlaceholderView(assetName: post.mediaUrl, mediaType: post.mediaType)
                .ignoresSafeArea()

            // Gradient overlay（より自然な4段階グラデーション）
            LinearGradient.feedOverlay
                .ignoresSafeArea()

            // Content overlay
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    // Left: post info — スライドインアニメーション
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

                        // 結び目タイプのタグ — グラデーション背景
                        Text(post.knotType.displayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                LinearGradient.orangeGlow
                                    .opacity(0.9)
                            )
                            .cornerRadius(6)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: contentAppeared ? 0 : -30)
                    .opacity(contentAppeared ? 1 : 0)

                    // Right: action buttons — フェードインアニメーション
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
                        .pressAnimation()

                        // 通報メニュー
                        Menu {
                            Button(role: .destructive) {
                                showReportSheet = true
                            } label: {
                                Label(String(localized: "report_post"), systemImage: "exclamationmark.triangle")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.trailing, 8)
                    .offset(x: contentAppeared ? 0 : 20)
                    .opacity(contentAppeared ? 1 : 0)
                }
                .padding(.horizontal, AppTheme.spacing)
                .padding(.bottom, 32)
            }

            // ダブルタップいいねエフェクト
            DoubleTapLikeOverlay(showEffect: $showDoubleTapEffect)
        }
        // ダブルタップジェスチャー
        .onTapGesture(count: 2) {
            if !post.isLiked {
                onLikeTapped()
            }
            showDoubleTapEffect = true
            Haptics.heavy()
        }
        .sheet(isPresented: $showComments) {
            CommentsView(postId: post.id)
        }
        .sheet(isPresented: $showReportSheet) {
            ReportSheet(targetType: .post(post.id))
        }
        .onAppear {
            // コンテンツのスライドインアニメーション
            withAnimation(AppTheme.springGentle.delay(0.15)) {
                contentAppeared = true
            }
        }
        .onDisappear {
            contentAppeared = false
        }
    }
}

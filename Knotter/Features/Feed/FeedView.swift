import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.posts.isEmpty {
                    // シマーローディング
                    FeedSkeletonView()
                        .transition(.opacity)
                } else if viewModel.posts.isEmpty {
                    emptyStateView
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                } else {
                    feedContentView
                        .transition(.opacity)
                }
            }
            .animation(AppTheme.springGentle, value: viewModel.isLoading)
            .animation(AppTheme.springGentle, value: viewModel.posts.isEmpty)
            .navigationDestination(for: UUID.self) { userId in
                UserProfileView(userId: userId)
            }
            .task {
                await viewModel.loadFeed()
                await viewModel.loadKnotTypes()
            }
        }
    }

    // MARK: - Feed Content

    private var feedContentView: some View {
        VStack(spacing: 0) {
            KnotTypeFilterView(
                knotTypes: viewModel.knotTypes,
                selectedKnotType: $viewModel.selectedKnotType
            )

            GeometryReader { geometry in
                TabView {
                    ForEach(viewModel.filteredPosts) { post in
                        FeedItemView(
                            post: post,
                            onLikeTapped: { viewModel.toggleLike(for: post.id) }
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .rotationEffect(.degrees(-90))
                        .task {
                            await viewModel.loadMoreIfNeeded(currentPost: post)
                        }
                    }
                }
                .frame(width: geometry.size.height, height: geometry.size.width)
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: geometry.size.width)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "flame.slash")
                .font(.system(size: 56))
                .foregroundStyle(
                    .linearGradient(
                        colors: [.subtleGray, .subtleGray.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text(String(localized: "feed_no_posts"))
                .font(.headline)
                .foregroundColor(.subtleGray)

            Button {
                Task {
                    Haptics.light()
                    await viewModel.loadFeed()
                }
            } label: {
                Label(String(localized: "common_retry"), systemImage: "arrow.clockwise")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.rescueOrange)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.rescueOrange.opacity(0.15))
                    .cornerRadius(20)
            }
            .pressAnimation()
        }
    }
}

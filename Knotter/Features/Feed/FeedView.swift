import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.posts.isEmpty {
                    ProgressView()
                        .tint(.rescueOrange)
                        .scaleEffect(1.5)
                } else if viewModel.posts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "flame.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.subtleGray)
                        Text(String(localized: "feed_no_posts"))
                            .foregroundColor(.subtleGray)
                    }
                } else {
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
            }
            .navigationDestination(for: UUID.self) { userId in
                UserProfileView(userId: userId)
            }
            .task {
                await viewModel.loadFeed()
                await viewModel.loadKnotTypes()
            }
        }
    }
}

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(viewModel.posts) { post in
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
        .background(Color.darkBackground)
    }
}

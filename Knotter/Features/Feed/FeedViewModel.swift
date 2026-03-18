import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [Post]

    init(posts: [Post] = MockPosts.samples) {
        self.posts = posts
    }

    func toggleLike(for postId: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likeCount += posts[index].isLiked ? 1 : -1
    }
}

import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var knotTypes: [KnotType] = []
    @Published var selectedKnotType: KnotType? = nil

    private let repository: PostRepository
    private let knotTypeRepository: KnotTypeRepository
    private let pageSize = 20
    private var hasMorePages = true
    private var isLoadingMore = false

    /// フィルタ済みの投稿一覧
    var filteredPosts: [Post] {
        guard let selected = selectedKnotType else {
            return posts
        }
        return posts.filter { $0.knotType == selected }
    }

    init(
        repository: PostRepository = SupabasePostRepository(),
        knotTypeRepository: KnotTypeRepository = SupabaseKnotTypeRepository()
    ) {
        self.repository = repository
        self.knotTypeRepository = knotTypeRepository
    }

    /// フィードを読み込む（先頭ページ）
    func loadFeed() async {
        isLoading = true
        errorMessage = nil
        hasMorePages = true
        do {
            let fetched = try await repository.fetchPosts(limit: pageSize, offset: 0)
            posts = fetched
            hasMorePages = fetched.count >= pageSize
        } catch {
            errorMessage = String(localized: "error_feed_load")
            // フォールバック: モックデータを表示
            posts = MockPosts.samples
            print("[FeedViewModel] Supabase fetch failed, using mock: \(error)")
        }
        isLoading = false
    }

    /// 追加ページを読み込む（無限スクロール）
    func loadMoreIfNeeded(currentPost: Post) async {
        // 最後から3番目の投稿が表示されたら次ページを取得
        guard let index = filteredPosts.firstIndex(where: { $0.id == currentPost.id }),
              index >= filteredPosts.count - 3,
              hasMorePages,
              !isLoadingMore else { return }

        isLoadingMore = true
        do {
            let fetched = try await repository.fetchPosts(limit: pageSize, offset: posts.count)
            posts.append(contentsOf: fetched)
            hasMorePages = fetched.count >= pageSize
        } catch {
            print("[FeedViewModel] loadMore failed: \(error)")
        }
        isLoadingMore = false
    }

    /// 結び目タイプ一覧を読み込む
    func loadKnotTypes() async {
        do {
            knotTypes = try await knotTypeRepository.fetchKnotTypes()
        } catch {
            // フォールバック: enum の全ケースを使用
            knotTypes = KnotType.allCases
            print("[FeedViewModel] Failed to load knot types: \(error)")
        }
    }

    /// いいねをトグル（ローカル即時反映 + 非同期でサーバ同期）
    func toggleLike(for postId: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }

        // ローカル即時反映（楽観的更新）
        posts[index].isLiked.toggle()
        posts[index].likeCount += posts[index].isLiked ? 1 : -1

        // サーバ同期（認証実装後に有効化）
        Task {
            do {
                _ = try await repository.toggleLike(postId: postId)
            } catch {
                // 失敗時はローカル状態を戻す（postIdで再検索して安全にアクセス）
                guard let i = self.posts.firstIndex(where: { $0.id == postId }) else { return }
                self.posts[i].isLiked.toggle()
                self.posts[i].likeCount += self.posts[i].isLiked ? 1 : -1
                print("[FeedViewModel] toggleLike failed: \(error)")
            }
        }
    }
}

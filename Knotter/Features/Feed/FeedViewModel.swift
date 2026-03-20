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

    /// フィードを読み込む
    func loadFeed() async {
        isLoading = true
        errorMessage = nil
        do {
            posts = try await repository.fetchPosts()
        } catch {
            errorMessage = "投稿の読み込みに失敗しました"
            // フォールバック: モックデータを表示
            posts = MockPosts.samples
            print("[FeedViewModel] Supabase fetch failed, using mock: \(error)")
        }
        isLoading = false
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
                // 失敗時はローカル状態を戻す
                posts[index].isLiked.toggle()
                posts[index].likeCount += posts[index].isLiked ? 1 : -1
                print("[FeedViewModel] toggleLike failed: \(error)")
            }
        }
    }
}

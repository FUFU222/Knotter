import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchScope: SearchScope = .posts
    @Published var posts: [Post] = []
    @Published var users: [Profile] = []
    @Published var isSearching: Bool = false
    @Published var errorMessage: String?

    enum SearchScope: CaseIterable {
        case posts
        case users

        var displayName: String {
            switch self {
            case .posts: return String(localized: "search_scope_posts")
            case .users: return String(localized: "search_scope_users")
            }
        }
    }

    private let repository: SearchRepository

    init(repository: SearchRepository = SupabaseSearchRepository()) {
        self.repository = repository
    }

    func search() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            posts = []
            users = []
            return
        }
        isSearching = true
        errorMessage = nil
        do {
            switch searchScope {
            case .posts:
                posts = try await repository.searchPosts(query: query)
            case .users:
                users = try await repository.searchUsers(query: query)
            }
        } catch {
            errorMessage = String(localized: "error_search")
            print("[SearchViewModel] search failed: \(error)")
        }
        isSearching = false
    }
}

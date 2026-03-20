import Foundation

@MainActor
final class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var newCommentText: String = ""
    @Published var isLoading: Bool = false
    @Published var isSending: Bool = false

    let postId: UUID
    private let repository: CommentRepository

    static let maxCommentLength = 500

    init(postId: UUID, repository: CommentRepository = SupabaseCommentRepository()) {
        self.postId = postId
        self.repository = repository
    }

    func loadComments() async {
        isLoading = true
        do {
            comments = try await repository.fetchComments(postId: postId)
        } catch {
            print("[CommentsViewModel] fetch failed: \(error)")
        }
        isLoading = false
    }

    func sendComment() async {
        let text = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        isSending = true
        do {
            let comment = try await repository.addComment(postId: postId, content: text)
            comments.append(comment)
            newCommentText = ""
        } catch {
            print("[CommentsViewModel] send failed: \(error)")
        }
        isSending = false
    }

    func deleteComment(_ comment: Comment) async {
        do {
            try await repository.deleteComment(commentId: comment.id)
            comments.removeAll { $0.id == comment.id }
        } catch {
            print("[CommentsViewModel] delete failed: \(error)")
        }
    }
}

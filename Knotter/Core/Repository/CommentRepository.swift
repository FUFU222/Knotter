import Foundation

protocol CommentRepository {
    func fetchComments(postId: UUID) async throws -> [Comment]
    func addComment(postId: UUID, content: String) async throws -> Comment
    func deleteComment(commentId: UUID) async throws
}

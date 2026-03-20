import Foundation
import Supabase

final class SupabaseCommentRepository: CommentRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    // MARK: - DTO

    private struct CommentDTO: Decodable {
        let id: UUID
        let postId: UUID
        let userId: UUID
        let content: String
        let createdAt: String
        let profiles: ProfileDTO

        enum CodingKeys: String, CodingKey {
            case id
            case postId = "post_id"
            case userId = "user_id"
            case content
            case createdAt = "created_at"
            case profiles
        }
    }

    private struct ProfileDTO: Decodable {
        let username: String
        let avatarUrl: String?

        enum CodingKeys: String, CodingKey {
            case username
            case avatarUrl = "avatar_url"
        }
    }

    private struct InsertCommentPayload: Encodable {
        let postId: UUID
        let userId: UUID
        let content: String

        enum CodingKeys: String, CodingKey {
            case postId = "post_id"
            case userId = "user_id"
            case content
        }
    }

    // MARK: - CommentRepository

    func fetchComments(postId: UUID) async throws -> [Comment] {
        let dtos: [CommentDTO] = try await client
            .from("comments")
            .select("*, profiles(username, avatar_url)")
            .eq("post_id", value: postId.uuidString)
            .order("created_at", ascending: true)
            .execute()
            .value

        return dtos.map { dto in
            Comment(
                id: dto.id,
                postId: dto.postId,
                userId: dto.userId,
                username: dto.profiles.username,
                avatarUrl: dto.profiles.avatarUrl,
                content: dto.content,
                createdAt: dto.createdAt
            )
        }
    }

    func addComment(postId: UUID, content: String) async throws -> Comment {
        let userId = try await client.auth.session.user.id
        let payload = InsertCommentPayload(postId: postId, userId: userId, content: content)

        let dto: CommentDTO = try await client
            .from("comments")
            .insert(payload)
            .select("*, profiles(username, avatar_url)")
            .single()
            .execute()
            .value

        return Comment(
            id: dto.id,
            postId: dto.postId,
            userId: dto.userId,
            username: dto.profiles.username,
            avatarUrl: dto.profiles.avatarUrl,
            content: dto.content,
            createdAt: dto.createdAt
        )
    }

    func deleteComment(commentId: UUID) async throws {
        try await client
            .from("comments")
            .delete()
            .eq("id", value: commentId.uuidString)
            .execute()
    }
}

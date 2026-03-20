import Foundation

protocol SearchRepository {
    func searchPosts(query: String) async throws -> [Post]
    func searchUsers(query: String) async throws -> [Profile]
}

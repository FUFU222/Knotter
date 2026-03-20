import Foundation

protocol KnotTypeRepository {
    func fetchKnotTypes() async throws -> [KnotType]
}

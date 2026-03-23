import Foundation

protocol KnotTypeRepository {
    func fetchKnotTypes() async throws -> [KnotType]
    func fetchHotKnotTypes(limit: Int) async throws -> [KnotType]
}

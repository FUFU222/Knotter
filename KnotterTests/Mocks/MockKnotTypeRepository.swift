import Foundation
@testable import Knotter

/// テスト用のモックKnotTypeRepository
final class MockKnotTypeRepository: KnotTypeRepository {

    var knotTypesToReturn: [KnotType] = KnotType.allCases
    var shouldThrow = false

    func fetchKnotTypes() async throws -> [KnotType] {
        if shouldThrow {
            throw NSError(domain: "MockError", code: -1)
        }
        return knotTypesToReturn
    }
}

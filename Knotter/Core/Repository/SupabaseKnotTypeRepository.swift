import Foundation
import Supabase

/// knot_types テーブルから結び目タイプを取得するSupabase実装
final class SupabaseKnotTypeRepository: KnotTypeRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.client) {
        self.client = client
    }

    func fetchKnotTypes() async throws -> [KnotType] {
        let records: [KnotTypeRecord] = try await client
            .from("knot_types")
            .select()
            .order("display_name")
            .execute()
            .value

        return records.compactMap { KnotType(rawValue: $0.slug) }
    }
}

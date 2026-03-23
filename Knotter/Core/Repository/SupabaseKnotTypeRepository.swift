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

    func fetchHotKnotTypes(limit: Int = 8) async throws -> [KnotType] {
        struct HotKnotResult: Codable {
            let slug: String
            let displayName: String
            let postCount: Int

            enum CodingKeys: String, CodingKey {
                case slug
                case displayName = "display_name"
                case postCount = "post_count"
            }
        }

        let results: [HotKnotResult] = try await client
            .rpc("get_hot_knot_types", params: ["max_count": limit])
            .execute()
            .value

        return results.compactMap { KnotType(slug: $0.slug) }
    }
}

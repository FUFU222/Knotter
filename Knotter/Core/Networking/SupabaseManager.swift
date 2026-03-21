import Foundation
import Supabase

enum SupabaseManager {

    private static let secrets: [String: String] = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String] else {
            fatalError("Secrets.plist not found. See README for setup instructions.")
        }
        return dict
    }()

    static let client: SupabaseClient = {
        guard let urlString = secrets["SUPABASE_URL"],
              let url = URL(string: urlString),
              let key = secrets["SUPABASE_ANON_KEY"] else {
            fatalError("SUPABASE_URL or SUPABASE_ANON_KEY missing in Secrets.plist")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: key)
    }()
}

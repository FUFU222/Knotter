import Foundation
import Supabase

enum SupabaseManager {

    static let client = SupabaseClient(
        supabaseURL: URL(string: "https://knrgflkcbtsubgjidcae.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtucmdmbGtjYnRzdWJnamlkY2FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NDMxMzQsImV4cCI6MjA4OTQxOTEzNH0.VGgBF7aeeGHvG_q_lgBh5bazB7hfO1mwO7RKA7UnqJ8"
    )
}

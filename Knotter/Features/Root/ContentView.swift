import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .feed

    enum Tab {
        case feed
        case search
        case upload
        case notifications
        case profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(String(localized: "tab_feed"))
                }
                .tag(Tab.feed)

            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(String(localized: "tab_search"))
                }
                .tag(Tab.search)

            UploadView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text(String(localized: "tab_upload"))
                }
                .tag(Tab.upload)

            NotificationsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text(String(localized: "tab_notifications"))
                }
                .tag(Tab.notifications)

            ProfileView()
                .environment(\.authViewModel, authViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(String(localized: "tab_profile"))
                }
                .tag(Tab.profile)
        }
        .tint(.rescueOrange)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.darkBackground)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - AuthViewModel Environment Key

private struct AuthViewModelKey: EnvironmentKey {
    static let defaultValue: AuthViewModel? = nil
}

extension EnvironmentValues {
    var authViewModel: AuthViewModel? {
        get { self[AuthViewModelKey.self] }
        set { self[AuthViewModelKey.self] = newValue }
    }
}

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .feed

    enum Tab {
        case feed
        case upload
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("フィード")
                }
                .tag(Tab.feed)

            UploadView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("投稿")
                }
                .tag(Tab.upload)
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

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Scope picker
                    Picker(String(localized: "search_scope"), selection: $viewModel.searchScope) {
                        ForEach(SearchViewModel.SearchScope.allCases, id: \.self) { scope in
                            Text(scope.displayName).tag(scope)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, AppTheme.spacing)
                    .padding(.vertical, AppTheme.smallSpacing)
                    .onChange(of: viewModel.searchScope) { _ in
                        Task { await viewModel.search() }
                    }

                    if viewModel.isSearching {
                        Spacer()
                        ProgressView()
                            .tint(.rescueOrange)
                            .scaleEffect(1.5)
                        Spacer()
                    } else if viewModel.searchText.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.subtleGray)
                            Text(String(localized: "search_hint"))
                                .foregroundColor(.subtleGray)
                        }
                        Spacer()
                    } else {
                        switch viewModel.searchScope {
                        case .posts:
                            postResults
                        case .users:
                            userResults
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "search_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $viewModel.searchText, prompt: Text(String(localized: "search_prompt")))
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .navigationDestination(for: UUID.self) { userId in
                UserProfileView(userId: userId)
            }
        }
    }

    // MARK: - Post Results

    private var postResults: some View {
        Group {
            if viewModel.posts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.subtleGray)
                    Text(String(localized: "search_no_posts"))
                        .foregroundColor(.subtleGray)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(viewModel.posts) { post in
                            postCell(post: post)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }

    private func postCell(post: Post) -> some View {
        ZStack {
            Color.cardBackground
            MediaPlaceholderView(assetName: post.mediaUrl, mediaType: post.mediaType)

            // Caption overlay
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: 60)
            }

            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(post.caption)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                .padding(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipped()
        .cornerRadius(4)
    }

    // MARK: - User Results

    private var userResults: some View {
        Group {
            if viewModel.users.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "person.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.subtleGray)
                    Text(String(localized: "search_no_users"))
                        .foregroundColor(.subtleGray)
                }
                .frame(maxHeight: .infinity)
            } else {
                List(viewModel.users) { user in
                    NavigationLink(value: user.id) {
                    HStack(spacing: 12) {
                        // Avatar
                        if let urlStr = user.avatarUrl, urlStr.hasPrefix("http"),
                           let url = URL(string: urlStr) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                userAvatarPlaceholder
                            }
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                        } else {
                            userAvatarPlaceholder
                        }

                        // Info
                        VStack(alignment: .leading, spacing: 2) {
                            Text(user.username)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            if let displayName = user.displayName, !displayName.isEmpty {
                                Text(displayName)
                                    .font(.caption)
                                    .foregroundColor(.subtleGray)
                            }
                        }

                        Spacer()
                    }
                    }
                    .listRowBackground(Color.darkBackground)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }

    private var userAvatarPlaceholder: some View {
        Circle()
            .fill(Color.cardBackground)
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.subtleGray)
            )
    }
}

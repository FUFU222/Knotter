import SwiftUI

struct CommentsView: View {
    @StateObject private var viewModel: CommentsViewModel

    init(postId: UUID) {
        _viewModel = StateObject(wrappedValue: CommentsViewModel(postId: postId))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .tint(.rescueOrange)
                        Spacer()
                    } else if viewModel.comments.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "bubble.left")
                                .font(.system(size: 48))
                                .foregroundColor(.subtleGray)
                            Text(String(localized: "comments_empty"))
                                .foregroundColor(.subtleGray)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.comments) { comment in
                                    commentRow(comment)
                                    Divider()
                                        .background(Color.subtleGray.opacity(0.2))
                                }
                            }
                        }
                    }

                    // Input area
                    inputBar
                }
            }
            .navigationTitle(String(localized: "comments_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task {
                await viewModel.loadComments()
            }
            .alert(
                String(localized: "upload_error_title"),
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button(String(localized: "common_cancel"), role: .cancel) {}
            } message: {
                if let msg = viewModel.errorMessage {
                    Text(msg)
                }
            }
        }
    }

    // MARK: - Comment Row

    private func commentRow(_ comment: Comment) -> some View {
        HStack(alignment: .top, spacing: 10) {
            // Avatar
            if let urlStr = comment.avatarUrl, urlStr.hasPrefix("http"),
               let url = URL(string: urlStr) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    avatarPlaceholder
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            } else {
                avatarPlaceholder
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(comment.username)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(comment.content)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                Text(comment.createdAt.prefix(10))
                    .font(.caption2)
                    .foregroundColor(.subtleGray)
            }

            Spacer()
        }
        .padding(.horizontal, AppTheme.spacing)
        .padding(.vertical, 10)
    }

    private var avatarPlaceholder: some View {
        Circle()
            .fill(Color.cardBackground)
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.subtleGray)
            )
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField(String(localized: "comments_placeholder"), text: $viewModel.newCommentText, axis: .vertical)
                .lineLimit(1...3)
                .padding(10)
                .background(Color.cardBackground)
                .cornerRadius(AppTheme.cornerRadius)
                .foregroundColor(.white)

            Button {
                Task { await viewModel.sendComment() }
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(
                        viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? .subtleGray
                            : .rescueOrange
                    )
            }
            .disabled(
                viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || viewModel.isSending
            )
        }
        .padding(.horizontal, AppTheme.spacing)
        .padding(.vertical, 10)
        .background(Color.darkBackground)
    }
}

import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.notifications.isEmpty {
                    ProgressView()
                        .tint(.rescueOrange)
                        .scaleEffect(1.5)
                } else if viewModel.notifications.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.subtleGray)
                        Text("通知はまだありません")
                            .foregroundColor(.subtleGray)
                    }
                } else {
                    List(viewModel.notifications) { notification in
                        if let actorId = notification.actorId {
                            NavigationLink(value: actorId) {
                                notificationRow(notification)
                            }
                            .listRowBackground(
                                notification.isRead ? Color.darkBackground : Color.cardBackground
                            )
                            .onTapGesture {
                                Task { await viewModel.markAsRead(notification) }
                            }
                        } else {
                            notificationRow(notification)
                                .listRowBackground(
                                    notification.isRead ? Color.darkBackground : Color.cardBackground
                                )
                                .onTapGesture {
                                    Task { await viewModel.markAsRead(notification) }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.unreadCount > 0 {
                        Button("すべて既読") {
                            Task { await viewModel.markAllAsRead() }
                        }
                        .font(.caption)
                        .foregroundColor(.rescueOrange)
                    }
                }
            }
            .navigationDestination(for: UUID.self) { userId in
                UserProfileView(userId: userId)
            }
            .task {
                await viewModel.loadNotifications()
            }
        }
    }

    // MARK: - Notification Row

    private func notificationRow(_ notification: AppNotification) -> some View {
        HStack(spacing: 12) {
            // Avatar
            if let urlStr = notification.actorAvatarUrl, urlStr.hasPrefix("http"),
               let url = URL(string: urlStr) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    avatarPlaceholder
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } else {
                avatarPlaceholder
            }

            // Message
            VStack(alignment: .leading, spacing: 4) {
                Text(notificationMessage(notification))
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text(notification.createdAt.prefix(10))
                    .font(.caption2)
                    .foregroundColor(.subtleGray)
            }

            Spacer()

            // Unread indicator
            if !notification.isRead {
                Circle()
                    .fill(Color.rescueOrange)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
    }

    private var avatarPlaceholder: some View {
        Circle()
            .fill(Color.cardBackground)
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.subtleGray)
            )
    }

    private func notificationMessage(_ notification: AppNotification) -> AttributedString {
        var result = AttributedString(notification.actorUsername)
        result.font = .subheadline.bold()

        let action: String
        switch notification.type {
        case .like:
            action = "があなたの投稿にいいねしました"
        case .comment:
            action = "があなたの投稿にコメントしました"
        case .follow:
            action = "があなたをフォローしました"
        }

        result += AttributedString(action)
        return result
    }
}

import Foundation

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AppNotification] = []
    @Published var isLoading: Bool = false
    @Published var unreadCount: Int = 0
    @Published var errorMessage: String?

    private let repository: NotificationRepository

    init(repository: NotificationRepository = SupabaseNotificationRepository()) {
        self.repository = repository
    }

    func loadNotifications() async {
        isLoading = true
        errorMessage = nil
        do {
            notifications = try await repository.fetchNotifications()
            unreadCount = notifications.filter { !$0.isRead }.count
        } catch {
            errorMessage = String(localized: "error_load_notifications")
            print("[NotificationsViewModel] fetch failed: \(error)")
        }
        isLoading = false
    }

    func markAsRead(_ notification: AppNotification) async {
        guard !notification.isRead else { return }
        do {
            try await repository.markAsRead(notificationId: notification.id)
            if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
                let n = notifications[index]
                notifications[index] = AppNotification(
                    id: n.id, userId: n.userId, actorId: n.actorId,
                    actorUsername: n.actorUsername,
                    actorAvatarUrl: n.actorAvatarUrl, type: n.type,
                    postId: n.postId, isRead: true, createdAt: n.createdAt
                )
                unreadCount = max(0, unreadCount - 1)
            }
        } catch {
            print("[NotificationsViewModel] markAsRead failed: \(error)")
        }
    }

    func markAllAsRead() async {
        do {
            try await repository.markAllAsRead()
            notifications = notifications.map { n in
                AppNotification(
                    id: n.id, userId: n.userId, actorId: n.actorId,
                    actorUsername: n.actorUsername,
                    actorAvatarUrl: n.actorAvatarUrl, type: n.type,
                    postId: n.postId, isRead: true, createdAt: n.createdAt
                )
            }
            unreadCount = 0
        } catch {
            errorMessage = String(localized: "error_mark_read")
            print("[NotificationsViewModel] markAllAsRead failed: \(error)")
        }
    }
}

import Foundation

protocol NotificationRepository {
    func fetchNotifications() async throws -> [AppNotification]
    func markAsRead(notificationId: UUID) async throws
    func markAllAsRead() async throws
}

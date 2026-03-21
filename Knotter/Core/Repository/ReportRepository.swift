import Foundation

/// 通報・ブロック用リポジトリプロトコル
protocol ReportRepository {
    func reportPost(postId: UUID, reason: ReportReason) async throws
    func reportUser(userId: UUID, reason: ReportReason) async throws
    func blockUser(userId: UUID) async throws
    func unblockUser(userId: UUID) async throws
    func fetchBlockedUsers() async throws -> [UUID]
}

enum ReportReason: String, CaseIterable, Identifiable {
    case spam = "spam"
    case harassment = "harassment"
    case inappropriateContent = "inappropriate_content"
    case impersonation = "impersonation"
    case other = "other"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spam: return String(localized: "report_reason_spam")
        case .harassment: return String(localized: "report_reason_harassment")
        case .inappropriateContent: return String(localized: "report_reason_inappropriate")
        case .impersonation: return String(localized: "report_reason_impersonation")
        case .other: return String(localized: "report_reason_other")
        }
    }
}

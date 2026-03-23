import SwiftUI

enum UserRank: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case master
    case legend

    var displayName: String {
        switch self {
        case .beginner: return String(localized: "rank_beginner")
        case .intermediate: return String(localized: "rank_intermediate")
        case .advanced: return String(localized: "rank_advanced")
        case .master: return String(localized: "rank_master")
        case .legend: return String(localized: "rank_legend")
        }
    }

    var iconName: String {
        switch self {
        case .beginner: return "leaf"
        case .intermediate: return "shield.fill"
        case .advanced: return "star.fill"
        case .master: return "crown.fill"
        case .legend: return "bolt.shield.fill"
        }
    }

    var color: Color {
        switch self {
        case .beginner: return .gray
        case .intermediate: return .green
        case .advanced: return .blue
        case .master: return .purple
        case .legend: return .rescueOrange
        }
    }

    var minPoints: Int {
        switch self {
        case .beginner: return 0
        case .intermediate: return 100
        case .advanced: return 500
        case .master: return 1500
        case .legend: return 5000
        }
    }

    var nextRank: UserRank? {
        switch self {
        case .beginner: return .intermediate
        case .intermediate: return .advanced
        case .advanced: return .master
        case .master: return .legend
        case .legend: return nil
        }
    }

    static func rank(for points: Int) -> UserRank {
        if points >= 5000 { return .legend }
        if points >= 1500 { return .master }
        if points >= 500 { return .advanced }
        if points >= 100 { return .intermediate }
        return .beginner
    }

    /// Progress toward next rank (0.0 - 1.0)
    static func progress(currentPoints: Int, currentRank: UserRank) -> Double {
        guard let next = currentRank.nextRank else { return 1.0 }
        let rangeStart = currentRank.minPoints
        let rangeEnd = next.minPoints
        let progress = Double(currentPoints - rangeStart) / Double(rangeEnd - rangeStart)
        return min(max(progress, 0), 1)
    }
}

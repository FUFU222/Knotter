import Foundation

struct BadgeDefinition: Identifiable, Codable {
    let id: UUID
    let slug: String
    let nameJa: String
    let nameEn: String
    let descriptionJa: String?
    let descriptionEn: String?
    let iconName: String
    let category: String
    let requirementType: String
    let requirementValue: Int?
    let requirementKnotType: String?
    let sortOrder: Int?

    var localizedName: String {
        let isJapanese = Locale.current.language.languageCode?.identifier == "ja"
        return isJapanese ? nameJa : nameEn
    }

    var localizedDescription: String? {
        let isJapanese = Locale.current.language.languageCode?.identifier == "ja"
        return isJapanese ? descriptionJa : descriptionEn
    }

    var badgeCategory: BadgeCategory {
        BadgeCategory(rawValue: category) ?? .milestone
    }

    enum CodingKeys: String, CodingKey {
        case id, slug, category
        case nameJa = "name_ja"
        case nameEn = "name_en"
        case descriptionJa = "description_ja"
        case descriptionEn = "description_en"
        case iconName = "icon_name"
        case requirementType = "requirement_type"
        case requirementValue = "requirement_value"
        case requirementKnotType = "requirement_knot_type"
        case sortOrder = "sort_order"
    }
}

enum BadgeCategory: String, CaseIterable {
    case knot
    case streak
    case milestone
    case social

    var displayName: String {
        switch self {
        case .knot: return String(localized: "badge_category_knot")
        case .streak: return String(localized: "badge_category_streak")
        case .milestone: return String(localized: "badge_category_milestone")
        case .social: return String(localized: "badge_category_social")
        }
    }
}

struct UserBadge: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let badgeId: UUID
    let earnedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case badgeId = "badge_id"
        case earnedAt = "earned_at"
    }
}

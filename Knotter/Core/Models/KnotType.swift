import Foundation

enum KnotType: String, CaseIterable, Codable, Identifiable {
    case bowline
    case cloveHitch
    case twoHalfHitches
    case slipKnot
    case cloveHitchAlt
    case figureEight

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bowline: return "もやい結び"
        case .cloveHitch: return "巻き結び"
        case .twoHalfHitches: return "ふた結び"
        case .slipKnot: return "引き解け結び"
        case .cloveHitchAlt: return "クローブヒッチ"
        case .figureEight: return "エイトノット"
        }
    }
}

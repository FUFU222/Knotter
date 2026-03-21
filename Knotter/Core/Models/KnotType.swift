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
        case .bowline: return String(localized: "knot_bowline")
        case .cloveHitch: return String(localized: "knot_clove_hitch")
        case .twoHalfHitches: return String(localized: "knot_two_half_hitches")
        case .slipKnot: return String(localized: "knot_slip_knot")
        case .cloveHitchAlt: return String(localized: "knot_clove_hitch_alt")
        case .figureEight: return String(localized: "knot_figure_eight")
        }
    }
}

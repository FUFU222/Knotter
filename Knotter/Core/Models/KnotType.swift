import Foundation

enum KnotType: String, CaseIterable, Codable, Identifiable {
    case bowline
    case cloveHitch
    case twoHalfHitches
    case slipKnot
    case cloveHitchAlt
    case figureEight
    case squareKnot
    case sheetBend
    case doubleSheetBend
    case halfKnot
    case halfHitch
    case overhandKnot
    case bowKnot
    case fuhrerKnot
    case stevedoreKnot
    case doubleBowline
    case tripleBowline
    case roundTurnTwoHalfHitches
    case coilBowline
    case anchorBend
    case prusikKnot
    case seatKnot

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bowline: return String(localized: "knot_bowline")
        case .cloveHitch: return String(localized: "knot_clove_hitch")
        case .twoHalfHitches: return String(localized: "knot_two_half_hitches")
        case .slipKnot: return String(localized: "knot_slip_knot")
        case .cloveHitchAlt: return String(localized: "knot_clove_hitch_alt")
        case .figureEight: return String(localized: "knot_figure_eight")
        case .squareKnot: return String(localized: "knot_square_knot")
        case .sheetBend: return String(localized: "knot_sheet_bend")
        case .doubleSheetBend: return String(localized: "knot_double_sheet_bend")
        case .halfKnot: return String(localized: "knot_half_knot")
        case .halfHitch: return String(localized: "knot_half_hitch")
        case .overhandKnot: return String(localized: "knot_overhand_knot")
        case .bowKnot: return String(localized: "knot_bow_knot")
        case .fuhrerKnot: return String(localized: "knot_fuhrer_knot")
        case .stevedoreKnot: return String(localized: "knot_stevedore_knot")
        case .doubleBowline: return String(localized: "knot_double_bowline")
        case .tripleBowline: return String(localized: "knot_triple_bowline")
        case .roundTurnTwoHalfHitches: return String(localized: "knot_round_turn")
        case .coilBowline: return String(localized: "knot_coil_bowline")
        case .anchorBend: return String(localized: "knot_anchor_bend")
        case .prusikKnot: return String(localized: "knot_prusik_knot")
        case .seatKnot: return String(localized: "knot_seat_knot")
        }
    }

    /// DB slug との変換
    var slug: String {
        switch self {
        case .bowline: return "bowline"
        case .cloveHitch: return "clove_hitch"
        case .twoHalfHitches: return "two_half_hitches"
        case .slipKnot: return "slip_knot"
        case .cloveHitchAlt: return "clove_hitch_alt"
        case .figureEight: return "figure_eight"
        case .squareKnot: return "square_knot"
        case .sheetBend: return "sheet_bend"
        case .doubleSheetBend: return "double_sheet_bend"
        case .halfKnot: return "half_knot"
        case .halfHitch: return "half_hitch"
        case .overhandKnot: return "overhand_knot"
        case .bowKnot: return "bow_knot"
        case .fuhrerKnot: return "fuhrer_knot"
        case .stevedoreKnot: return "stevedore_knot"
        case .doubleBowline: return "double_bowline"
        case .tripleBowline: return "triple_bowline"
        case .roundTurnTwoHalfHitches: return "round_turn_two_half_hitches"
        case .coilBowline: return "coil_bowline"
        case .anchorBend: return "anchor_bend"
        case .prusikKnot: return "prusik_knot"
        case .seatKnot: return "seat_knot"
        }
    }

    init?(slug: String) {
        switch slug {
        case "bowline": self = .bowline
        case "clove_hitch": self = .cloveHitch
        case "two_half_hitches": self = .twoHalfHitches
        case "slip_knot": self = .slipKnot
        case "clove_hitch_alt": self = .cloveHitchAlt
        case "figure_eight": self = .figureEight
        case "square_knot": self = .squareKnot
        case "sheet_bend": self = .sheetBend
        case "double_sheet_bend": self = .doubleSheetBend
        case "half_knot": self = .halfKnot
        case "half_hitch": self = .halfHitch
        case "overhand_knot": self = .overhandKnot
        case "bow_knot": self = .bowKnot
        case "fuhrer_knot": self = .fuhrerKnot
        case "stevedore_knot": self = .stevedoreKnot
        case "double_bowline": self = .doubleBowline
        case "triple_bowline": self = .tripleBowline
        case "round_turn_two_half_hitches": self = .roundTurnTwoHalfHitches
        case "coil_bowline": self = .coilBowline
        case "anchor_bend": self = .anchorBend
        case "prusik_knot": self = .prusikKnot
        case "seat_knot": self = .seatKnot
        default: return nil
        }
    }
}

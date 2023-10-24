import Foundation

enum Currency: String, CaseIterable {
    case EUR
    case TRY
    case GEL

    var displayName: String {
        switch self {
        case .EUR: return "EUR"
        case .TRY: return "TRY"
        case .GEL: return "GEL"
        }
    }
}

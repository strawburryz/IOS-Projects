
import Foundation

enum ShipType: String, CaseIterable {
    case destroyer = "Destroyer (2)"
    case submarine = "Submarine (3)"
    case cruiser = "Cruiser (3)"
    case battleship = "Battleship (4)"
    case carrier = "Carrier (5)"

    var size: Int {
        switch self {
        case .destroyer:
            return 2
        case .submarine, .cruiser:
            return 3
        case .battleship:
            return 4
        case .carrier:
            return 5
        }
    }
}


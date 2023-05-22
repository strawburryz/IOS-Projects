

import Foundation

struct Ship: Equatable {
    let type: ShipType
    let direction: Direction
    var position: Position
    var hits: Int
    var id = UUID()
    
    var isSunk: Bool {
        return hits == type.size
    }
}

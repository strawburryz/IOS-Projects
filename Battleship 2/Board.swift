
import Foundation
import SwiftUI

class Board: ObservableObject {
    @Published var cells: [[Cell]]
    var ships: [Ship]
    @Published var humanGuessedPositions: Set<Position> = []
    @Published var computerGuessedPositions: Set<Position> = []
    

    
    init() {
        var newCells: [[Cell]] = []
        for _ in 0..<10 {
            var cellRow: [Cell] = []
            for _ in 0..<10 {
                let cell = Cell()
                cellRow.append(cell)
            }
            newCells.append(cellRow)
        }
        self.cells = newCells
        self.ships = []
    }
    
    
    func placeShip(_ shipType: ShipType, at position: Position, in direction: Direction) {
        let newShip = Ship(type: shipType, direction: direction, position: position, hits: 0)
        ships.append(newShip)

        if direction == .horizontal {
            for i in 0..<shipType.size {
                cells[position.row][position.column + i].ship = newShip
            }
        } else { // direction == .vertical
            for i in 0..<shipType.size {
                cells[position.row + i][position.column].ship = newShip
            }
        }
    }

    
    func cellStatusAt(_ position: Position) -> Cell.CellStatus {
        return cells[position.row][position.column].status
    }
    
    func hitAt(_ position: Position) -> Ship? {
        if let ship = cells[position.row][position.column].ship {
            if let index = ships.firstIndex(where: { $0.id == ship.id }) {
                ships[index].hits += 1
                cells[position.row][position.column].status = .hit
                if ships[index].isSunk {
                    print("\(ships[index].type.rawValue) sunk!")
                    return ships[index]
                }
            }
        } else {
            cells[position.row][position.column].status = .miss
        }
        return nil
    }
    

    func allShipsSunk() -> Bool {
        // If no ships have been placed yet, return false
        if ships.isEmpty {
            return false
        }
        
        // Otherwise, check if all ships are sunk
        return ships.allSatisfy { $0.isSunk }
    }

    func canPlaceShip(ofType shipType: ShipType, at position: Position, in direction: Direction) -> Bool {
        let shipSize = shipType.size

        if direction == .horizontal {
            guard position.column + shipSize <= 10 else { return false }
            for i in 0..<shipSize {
                if cells[position.row][position.column + i].ship != nil {
                    return false // There's already a ship in this cell
                }
            }
        } else { // direction == .vertical
            guard position.row + shipSize <= 10 else { return false }
            for i in 0..<shipSize {
                if cells[position.row + i][position.column].ship != nil {
                    return false // There's already a ship in this cell
                }
            }
        }

        return true // The ship can be placed here
    }

    func hit(_ position: Position) -> Bool {
            if let ship = cells[position.row][position.column].ship {
                if let index = ships.firstIndex(where: { $0.id == ship.id }) {
                    return !ships[index].isSunk
                }
            }
            return false
        }
    
}

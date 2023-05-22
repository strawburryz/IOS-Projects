import Foundation

class Game: ObservableObject {
    
    enum Player {
        case human
        case computer
    }
    @Published var showingPlayerBoard: Bool = false
    @Published var lastMoveWasHit: Bool?

    @Published var currentPlayer: Player = .human
    
    @Published var playerBoard: Board
    @Published var opponentBoard: Board
    @Published var selectedShip: ShipType? = .destroyer
    @Published var selectedDirection: Direction = .horizontal
    @Published var gameStarted: Bool = false
    @Published var gameEnded: Bool = false
    @Published var playerWon: Bool = false
    @Published var placedShips: [ShipType] = []
    @Published var lastHitPosition: Position? = nil
    @Published var lastSunkPosition: Position? = nil

    
    @Published var lastSunkShip: Ship?
    
    init() {
        playerBoard = Board()
        opponentBoard = Board()
    }
    
    func makeMove(position: Position) {
        // First, check if the player has already guessed the position
        let targetBoard = currentPlayer == .human ? opponentBoard : playerBoard
        let guessedPositions = currentPlayer == .human ? targetBoard.humanGuessedPositions : targetBoard.computerGuessedPositions

        if guessedPositions.contains(position) {
            // If the position has already been guessed, simply return without doing anything
            return
        }
        
        guard !gameEnded else { return }

        
        if currentPlayer == .human {
            targetBoard.humanGuessedPositions.insert(position)
        } else {
            targetBoard.computerGuessedPositions.insert(position)
        }
        
        let sunkShip = targetBoard.hitAt(position)
        let hitShip = targetBoard.hit(position)

           if sunkShip != nil {
               lastSunkPosition = position
               lastHitPosition = nil
           } else if hitShip {
               lastHitPosition = position
           }

        // Check if the game has ended
        if targetBoard.allShipsSunk() {
            gameEnded = true
            // Determine the winner based on who made the last move
            playerWon = currentPlayer == .human
        } else {
            // Switch to the other player
            currentPlayer = currentPlayer == .human ? .computer : .human
            if currentPlayer == .computer {
                showingPlayerBoard = true
                makeComputerMove()
            }
        }
    }

    private func makeComputerMove() {
        // Ensure there are positions left to guess
        guard opponentBoard.computerGuessedPositions.count < 100 else { return }
        
        var position: Position
        if let lastHit = lastHitPosition, lastSunkPosition != lastHit {
            // If there's a previous hit and it didn't sink a ship, guess around it
            let potentialPositions = [
                Position(row: lastHit.row + 1, column: lastHit.column),
                Position(row: lastHit.row - 1, column: lastHit.column),
                Position(row: lastHit.row, column: lastHit.column + 1),
                Position(row: lastHit.row, column: lastHit.column - 1)
            ].filter { $0.row >= 0 && $0.row < 10 && $0.column >= 0 && $0.column < 10
                && !opponentBoard.computerGuessedPositions.contains($0) }
            
            if potentialPositions.isEmpty {
                position = randomPosition()
            } else {
                position = potentialPositions.randomElement()!
            }
        } else {
            // If there's no hit or the last hit sunk a ship, guess randomly
            position = randomPosition()
        }

        opponentBoard.computerGuessedPositions.insert(position)
        makeMove(position: position)
    }
    
    private func randomPosition() -> Position {
        var position: Position
        repeat {
            let randomRow = Int.random(in: 0..<10)
            let randomColumn = Int.random(in: 0..<10)
            position = Position(row: randomRow, column: randomColumn)
        } while opponentBoard.computerGuessedPositions.contains(position)
        return position
    }

    
    // Method to place a ship on a board
    func placeShip(_ shipType: ShipType, at position: Position) {
        // print("Placing \(shipType.rawValue) at \(position.row), \(position.column)")
        guard !gameStarted else { return }

        // Remove existing ship of the same type
        playerBoard.ships.removeAll(where: { $0.type == shipType })
        for row in playerBoard.cells {
            for cell in row {
                if cell.ship?.type == shipType {
                    cell.ship = nil
                }
            }
        }

        // Check if ship can be placed without going off the board
        let shipSize = shipType.size
        let canPlaceHorizontally = position.column + shipSize <= 10
        let canPlaceVertically = position.row + shipSize <= 10
        if (selectedDirection == .horizontal && !canPlaceHorizontally) || (selectedDirection == .vertical && !canPlaceVertically) {
            // Show some error to the user
            return
        }
        
        // Check if the ship overlaps with another ship
        var overlapsWithOtherShip = false
        if selectedDirection == .horizontal && canPlaceHorizontally {
            for i in 0..<shipSize {
                if playerBoard.cells[position.row][position.column + i].ship != nil {
                    overlapsWithOtherShip = true
                    break
                }
            }
        } else if selectedDirection == .vertical && canPlaceVertically {
            for i in 0..<shipSize {
                if playerBoard.cells[position.row + i][position.column].ship != nil {
                    overlapsWithOtherShip = true
                    break
                }
            }
        }

        if overlapsWithOtherShip || (selectedDirection == .horizontal && !canPlaceHorizontally) || (selectedDirection == .vertical && !canPlaceVertically) {
            // Show some error to the user
            return
        }

        // Place the new ship
        let newShip = Ship(type: shipType, direction: selectedDirection, position: position, hits: 0)
        playerBoard.ships.append(newShip)
        placedShips.append(shipType)

        if newShip.direction == .horizontal {
            for i in 0..<newShip.type.size {
                playerBoard.cells[position.row][position.column + i].ship = newShip
            }
        } else {
            for i in 0..<newShip.type.size {
                playerBoard.cells[position.row + i][position.column].ship = newShip
            }
        }

        // Automatically select the next unplaced ship
        selectedShip = ShipType.allCases.first { !placedShips.contains($0) }
    }

    
    func startGame() {
        let allShipsPlaced = ShipType.allCases.allSatisfy { shipType in
            playerBoard.ships.contains { $0.type == shipType }
        }

        if allShipsPlaced {
            initializeOpponentBoard()
            gameStarted = true
        } else {
            // Show an alert or some other indication that all ships must be placed before starting the game
        }
    }

    func endGameEarly(){
        gameEnded = true
        endGame()
    }
    
    func endGame() {
        // Reset the game here.
        playerBoard = Board()
        opponentBoard = Board()
        selectedShip = .destroyer
        selectedDirection = .horizontal
        gameStarted = false
        gameEnded = false
        playerWon = false
        placedShips = []
        currentPlayer = .human
        showingPlayerBoard = false
        
    }
    
    private func initializeOpponentBoard() {
        for shipType in ShipType.allCases {
            var placed = false
            while !placed {
                let randomRow = Int.random(in: 0..<10)
                let randomColumn = Int.random(in: 0..<10)
                let randomDirection: Direction = Bool.random() ? .horizontal : .vertical

                let position = Position(row: randomRow, column: randomColumn)
                if opponentBoard.canPlaceShip(ofType: shipType, at: position, in: randomDirection) {
                    opponentBoard.placeShip(shipType, at: position, in: randomDirection)
                    placed = true
                }
            }
        }
    }
}

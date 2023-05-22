import Foundation
import SwiftUI

struct BoardView: View {
    @ObservedObject var game: Game
    let hideShips: Bool
    @Binding var board: Board
    var onTap: ((Position) -> Void)?
    var letterArray = ["A","B","C","D","E","F","G","H","I","J"]
    
    var body: some View {
        VStack (spacing: 5) {
            HStack{
                ForEach(0..<10, id: \.self){
                    if letterArray[$0] == "A"{
                        Text("  ")
                    }
                    Text(" \(letterArray[$0])\($0+1)  ").font(.system(size: 10))
                }
            }
            ForEach(0..<10, id: \.self) { row in
                HStack (spacing: 5){
                    HStack{
                        if letterArray[row] == "I"{
                            Text("")
                        }
                        Text("\(letterArray[row])\(row+1)").font(.system(size: 10))
                    }
                    ForEach(0..<10, id: \.self) { column in
                        CellView(cell: $board.cells[row][column], hideShips: hideShips)
                            .onTapGesture {
                                if game.currentPlayer == .human {
                                    let position = Position(row: row, column: column)
                                    onTap?(position)
                                }
                            }
                    }
                }
            }
        }
    }

    private var currentBoard: Board {
        return game.currentPlayer == .human ? game.opponentBoard : game.playerBoard
    }

}

//
//  GameState.swift
//  TicTacToe2
//
//  Created by csuftitan on 3/14/23.
//

import Foundation

class GameState: ObservableObject{
    
    @Published var board = [[Cell]]()
    @Published var turn = Tile.X
    
    
    init(){
        
        resetBoard()
        
    }
    
    func placeTile(_ row: Int, _ column: Int){
        if (board[row][column].tile != Tile.Empty){
            return
        }
        board[row][column].tile = turn == Tile.X ? Tile.X : Tile.O
        turn = turn == Tile.X ? Tile.O : Tile.X
    }
    
    func checkForDraw() -> Bool{
        for row in board{
            for cell in row{
                if(cell.tile == Tile.Empty){
                    return false
                }
            }
        }
        return true
    }
    
    func checkVictory() ->Bool{
        
        //horizontal
        if(isTurnTile(0,0) && isTurnTile(0, 1) && isTurnTile(0, 2)){
            return true
        }
        if(isTurnTile(1,0) && isTurnTile(1, 1) && isTurnTile(1, 2)){
            return true
        }
        if(isTurnTile(2,0) && isTurnTile(2, 1) && isTurnTile(2, 2)){
            return true
        }
        
        //vertical
        if(isTurnTile(0,0) && isTurnTile(1, 0) && isTurnTile(2, 0)){
            return true
        }
        if(isTurnTile(0,1) && isTurnTile(1, 1) && isTurnTile(2, 1)){
            return true
        }
        if(isTurnTile(0,2) && isTurnTile(1, 2) && isTurnTile(2, 2)){
            return true
        }
        
        //diagonal
        if(isTurnTile(0,0) && isTurnTile(1, 1) && isTurnTile(2, 2)){
            return true
        }
        if(isTurnTile(0,2) && isTurnTile(1, 1) && isTurnTile(2, 0)){
            return true
        }
        
        return false
    }
    
    
    func isTurnTile(_ row: Int,_ column: Int)->Bool{
        return board[row][column].tile == turn
        
    }
    
    func resetBoard(){
        var newBoard = [[Cell]]()
        
        for _ in 0...2{
            var row = [Cell]()
            for _ in 0...2{
                row.append(Cell(tile: Tile.Empty))
            }
            newBoard.append(row)
        }
        board = newBoard
    }
    
    
}

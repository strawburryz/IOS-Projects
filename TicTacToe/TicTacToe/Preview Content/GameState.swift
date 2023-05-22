//
//  GameState.swift
//  TicTacToe
//
//  Created by csuftitan on 3/13/23.
//

import Foundation

class GameState: ObservableObject{
    @Published var board = [[Cell]]()
    @Published var turn = Tile.Kiss
    @Published var hugScore = 0
    @Published var kissScore = 0
    @Published var showAlert = false
    @Published var alertMessage = "Draw"
    
    init(){
        resetBoard()
    }
    
    func turnText() -> String {
        return turn == Tile.Kiss ? "Turn: X" : "Turn: O"
    }
    
    func placeTile(_ row: Int, _ column: Int){
        if(board[row][column].tile != Tile.Empty){
            return
        }
        
        board[row][column].tile = turn == Tile.Kiss ? Tile.Kiss : Tile.Hug
        
        if(checkForVictory()){
            if(turn == Tile.Kiss){
                kissScore += 1
            }
            else {
                hugScore += 1
            }
            let winner = turn == Tile.Kiss ? "Kisses" : "Hugs"
            alertMessage = winner + " Win!"
            showAlert = true
        }
        else {
            turn = turn == Tile.Kiss ? Tile.Hug : Tile.Kiss
            
            if(checkForDraw()){
                alertMessage = "Draw"
                showAlert = true
            }
            
        }
    }
    
    func checkForDraw() -> Bool {
        for row in board{
            for cell in row{
                if cell.tile == Tile.Empty{
                    return false
                }
            }
        }
        
        return true
    }
    
    func checkForVictory() -> Bool{
        //Vertical
        if isTurnTile(0, 0) && isTurnTile(1, 0) && isTurnTile(2, 0) && isTurnTile(3, 0){
            return true
        }
        if isTurnTile(0, 1) && isTurnTile(1, 1) && isTurnTile(2, 1) && isTurnTile(3, 1){
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 2) && isTurnTile(2, 2) && isTurnTile(3, 2){
            return true
        }
        if isTurnTile(0, 3) && isTurnTile(1, 3) && isTurnTile(2, 3) && isTurnTile(3, 3){
            return true
        }
        
        //horizontal
        if isTurnTile(0, 0) && isTurnTile(0, 1) && isTurnTile(0, 2) && isTurnTile(0, 3){
            return true
        }
        if isTurnTile(1, 0) && isTurnTile(1, 1) && isTurnTile(1, 2) && isTurnTile(1, 3){
            return true
        }
        if isTurnTile(2, 0) && isTurnTile(2, 1) && isTurnTile(2, 2) && isTurnTile(2, 3){
            return true
        }
        if isTurnTile(3, 0) && isTurnTile(3, 1) && isTurnTile(3, 2) && isTurnTile(3, 3){
            return true
        }
        
        //diagonal
        if isTurnTile(0, 0) && isTurnTile(1, 1) && isTurnTile(2, 2) && isTurnTile(3, 3){
            return true
        }
        if isTurnTile(0, 3) && isTurnTile(1, 2) && isTurnTile(2, 1) && isTurnTile(3, 0){
            return true
        }
        
        return false
    }
    
    func isTurnTile(_ row: Int, _ column: Int)-> Bool{
        return board[row][column].tile == turn
    }
    
    
    func resetBoard(){
        var newBoard = [[Cell]]()
        
        for _ in 0...3{
            var row=[Cell]()
            
            for _ in 0...3{
                row.append(Cell(tile: Tile.Empty))
            }
            newBoard.append(row)
        }
        board = newBoard
    }
}


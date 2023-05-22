//
//  Cell.swift
//  TicTacToe2
//
//  Created by csuftitan on 3/14/23.
//

import Foundation
import SwiftUI


struct Cell{
    var tile: Tile
    
    func displayTile() -> String{
        switch(tile){
        case Tile.X:
            return "X"
        case Tile.O:
            return "O"
        default:
            return ""
        }
    }
    func colorCell () -> Color {
        switch(tile){
        case Tile.X:
            return Color.black
        case Tile.O:
            return Color.red
        default:
            return Color.black
        }
    }
    
}

enum Tile{
    case X
    case O
    case Empty
}

//
//  Cell.swift
//  TicTacToe
//
//  Created by csuftitan on 3/13/23.
//

import Foundation
import SwiftUI

struct Cell{
    var tile: Tile
    
    func displayTile() -> String{
        switch (tile) {
            case Tile.Hug:
                return "O"
            case Tile.Kiss:
                return "X"
            default:
                return ""
        }
    }
    func tileColor()-> Color{
        switch (tile) {
            case Tile.Hug:
                return Color.red
            case Tile.Kiss:
                return Color.black
            default:
                return Color.black
        }
    }
    

}

enum Tile {
    case Hug
    case Kiss
    case Empty
}

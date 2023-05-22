//
//  ContentView.swift
//  TicTacToe
//
//  Created by csuftitan on 3/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var gameState = GameState()
    
    
    var body: some View {
        
        Text(gameState.turnText()).font(.title).bold().padding()
        Spacer()
        
        Text(String(format: "Kisses: %d", gameState.kissScore)).font(.title).bold().padding()
        
        VStack (spacing: 5){
            ForEach(0...3, id: \.self){
                row in
                HStack (spacing: 5){
                    ForEach(0...3, id: \.self){
                        column in
                        
                        let cell = gameState.board[row][column]
                        Text(cell.displayTile()).font(.system(size: 60)).foregroundColor(cell.tileColor()).bold().frame(maxWidth: .infinity, maxHeight: .infinity).aspectRatio(1, contentMode: .fit).background(Color.white).onTapGesture {
                            gameState.placeTile(row, column)
                        }
                    }
                    
                }
            }
        }.background(Color.black)
            .padding()
            .alert(isPresented: $gameState.showAlert){
                Alert(title: Text(gameState.alertMessage),
                      dismissButton: .default(Text("Okay")){
                    gameState.resetBoard()
                }
                )
            }
        Text(String(format: "Hugs: %d", gameState.hugScore)).font(.title).bold().padding()
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

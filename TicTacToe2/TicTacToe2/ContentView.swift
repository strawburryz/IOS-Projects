//
//  ContentView.swift
//  TicTacToe2
//
//  Created by csuftitan on 3/14/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(spacing:5) {
            ForEach(0...2, id: \.self){
                row in
                HStack(spacing:5){
                    ForEach(0...2, id: \.self){
                        column in
                        
                        
                        Text("X").font(.system(size: 60)).bold().frame(maxWidth: .infinity,maxHeight: .infinity).aspectRatio(1,contentMode: .fit).background(Color.white)
                    }
                }
            }
        }.background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Edutainment
//
//  Created by csuftitan on 4/1/23.
//

import SwiftUI

struct SecondView: View {
    let table: Int
    let question: Int
    let numbers = 1...12
    var random:Int {
       return numbers.randomElement()!
    }
    @State private var currentAnswer = ""
   
    
    var body: some View{
        VStack{
            Text("Multiply By \(table)'s")
                .font(.title)
                .foregroundColor(.blue)
            Spacer()
            
            let equation = generateQuestion(table)
            var number = equation.secondNum
            var answer = equation.answer

            Text("What is \(table) x \(number) ?").font(.system(size: 35)).bold()
            TextField("Enter in your answer", text: $currentAnswer, onCommit:{checkAnswer(answer)}).padding()
            Spacer()
 
        }
        
    }
    func generateQuestion(_: Int) -> (secondNum:Int, answer:Int){
        let number = random
        let answer = table * number
        
        return(number, answer)
    }
    func checkAnswer(_ answer: Int){
        if (answer == Int(currentAnswer)){
            
        }
        
    }
}

struct ContentView: View {
    @State private var activeGame = false
    @State var selectedTables = 0
    @State var numberOfQuestions = 5

        var body: some View {
            if !activeGame{
                Text("settings").foregroundColor(.blue)
                    VStack{
                        HStack{
                            VStack{
                                Text("Multiplication Tables").font(.system(size: 14))
                                Picker("Table", selection: $selectedTables){
                                    ForEach(1 ..< 12){
                                        table in Text("\(table)")
                                    }
                                }.pickerStyle(WheelPickerStyle())
                            }
                            VStack{
                                Text("Number Of Questions").font(.system(size: 14))
                                Picker("Questions", selection: $numberOfQuestions){
                                    ForEach([5,10,15,20,25], id: \.self){
                                        table in Text("\(table)")
                                    }
                                }.pickerStyle(WheelPickerStyle())
                            }
                        }
                        Button("start") {
                            activeGame = true
                        }
                }
            }
            else{
                SecondView(table: selectedTables+1, question: numberOfQuestions)
                Button("Restart") {
                    activeGame = false
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

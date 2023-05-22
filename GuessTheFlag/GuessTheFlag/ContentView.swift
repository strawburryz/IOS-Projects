//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by csuftitan on 3/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameOver = false
    @State private var count = 1
    @State private var gameOverTitle = ""

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var flagNumber = 0
    @State private var flagSelected = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            flagNumber = number
                            withAnimation {
                                flagSelected.toggle()
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(flagSelected ? 360 : 0), axis: flagNumber == number ? (x:0, y:1, z:0) : (x:0, y:0, z:0))
                                .opacity(flagSelected && flagNumber != number ? 0.25: 1)
                                .scaleEffect(flagSelected && flagNumber != number ? 0.75 : 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("Question: \(count)/8")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                Spacer()


                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(gameOverTitle, isPresented: $gameOver) {
            Button("Restart", action: restartGame)
        } message: {
            Text("\(scoreTitle)! Your score is \(score) out of 8")
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score = score + 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
           
        }

        showingScore = true
        if count == 8{
            gameOverTitle = "Game Over"
            showingScore = false
            gameOver = true
        }
    }

    func askQuestion() {
        flagSelected = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        count += 1
    }
    
    func restartGame(){
        score = 0
        gameOver = false
        correctAnswer = Int.random(in: 0...2)
        count = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

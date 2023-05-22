//
//  ContentView.swift
//  WordScramble
//
//  Created by csuftitan on 4/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    var body: some View {
        NavigationView {
              List {
                  Section {
                      TextField("Enter your word", text: $newWord)
                  }

                  Section {
                      ForEach(usedWords, id: \.self) { word in
                          HStack {
                              Image(systemName: "\(word.count).circle")
                              Text(word)
                          }
                      }
                  }
              }.navigationTitle(rootWord).toolbar (content: {
                  ToolbarItem(placement:.navigationBarLeading){
                      Text("Score: \(score)")
                  }
                  ToolbarItem(placement:.primaryAction){
                      Button("Restart", action: startGame)
                  }
              }).onSubmit(addNewWord).onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) {
                  Button("OK", role: .cancel) { }
              } message: {
                  Text(errorMessage)
              }
              .textInputAutocapitalization(.never)
        }
    }
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // exit if the remaining string is empty
        guard answer.count > 0 else { return }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard sameWord(word: answer) else {
            wordError(title: "This is the root word", message: "Be more original")
            return
        }
        
        guard lessThanThree(word: answer) else {
            wordError(title: "This answer is too short", message: "Sorry not sorry")
            return
        }
        score += answer.count 

        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                score = 0
                usedWords = []
                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    func sameWord (word: String) -> Bool {
        if (word == rootWord){
            return false
        }
        return true
    }
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    func lessThanThree (word:String) -> Bool {
        if (word.count < 3){
            return false
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

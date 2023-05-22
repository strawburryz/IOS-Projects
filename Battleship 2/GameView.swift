import Foundation
import SwiftUI


enum AlertType: Identifiable {
    case endGame
    case sunkShip

    var id: Int {
        switch self {
        case .endGame:
            return 1
        case .sunkShip:
            return 2
        }
    }
}


struct GameView: View {
    @ObservedObject var game: Game
    @State private var currentAlert: AlertType?

    var body: some View {
        Group {
            if game.gameStarted {
                ActiveGameView(game: game)
            } else {
                SetupGameView(game: game)
            }
        }
        .onChange(of: game.gameEnded) { newValue in
            if newValue {
                currentAlert = .endGame
            }
        }
        .onChange(of: game.lastSunkShip) { newValue in
            if newValue != nil && !game.gameEnded {
                currentAlert = .sunkShip
            }
        }
        .alert(item: $currentAlert) { alertType in
            switch alertType {
            case .endGame:
                return Alert(
                    title: Text(game.playerWon ? "You won!" : "Opponent won. You lost."),
                    message: Text(game.playerWon ? "Great job, Let's play again!" : "Better luck next time."),
                    dismissButton: .default(Text("OK")){
                        game.endGame()
                    }
                )
            case .sunkShip:
                return Alert(
                    title: Text("Ship Sunk!"),
                    message: Text("\(game.lastSunkShip?.type.rawValue ?? "Unknown") has been sunk."),
                    dismissButton: .default(Text("OK")) {
                        game.lastSunkShip = nil // Reset the lastSunkShip after showing the alert
                    }
                )
            }
        }
    }
}

struct ActiveGameView: View {
    @ObservedObject var game: Game
    @State private var showingEndGameAlert = false
    @State private var showingSunkShipAlert = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("Your Board")
                        .font(.headline)
                        .fontWeight(.bold)
                    BoardView(
                        game: game,
                        hideShips: false,
                        board: $game.playerBoard
                    )
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                }
                VStack {
                    HStack {
                        Spacer()
                        HStack {
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            Text("= Hit")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Button(action: {
                            game.endGameEarly()
                                    }) {
                                        Text("End Game")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: 110, height: 40)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.black, lineWidth: 2.5)
                                    )

                        HStack {
                            Text("    Miss =")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                    BoardView(
                        game: game,
                        hideShips: game.currentPlayer == .human,
                        board: $game.opponentBoard,
                        onTap: { position in
                            game.makeMove(position: position)
                        }
                    )
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                    Text("Opponent's Board")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
        }
        .padding()

    }
}


struct SetupGameView: View {
    @ObservedObject var game: Game

    var body: some View {
        VStack {
            Text("Place your ships!")
                .font(.headline)
                .fontWeight(.bold)

            HStack{
                Picker(selection: $game.selectedDirection, label: Text("Select a direction")) {
                    Text("Horizontal").tag(Direction.horizontal)
                    Text("Vertical").tag(Direction.vertical)
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 165)
                Picker("Select a ship", selection: Binding(
                    get: { game.selectedShip?.rawValue ?? "All ships placed" },
                    set: { newValue in
                        game.selectedShip = ShipType(rawValue: newValue)
                    }
                )) {
                    ForEach(ShipType.allCases, id: \.self) { ship in
                        if !game.placedShips.contains(ship) {
                            Text(ship.rawValue)
                                .tag(ship.rawValue)
                        }
                    }
                }.pickerStyle(DefaultPickerStyle()).accentColor(.black)
            }
            Spacer()
            Text("Your Board")
                .font(.title)
                .fontWeight(.bold)
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray)
                    .frame(width: 350, height: 350)
                BoardView(
                    game: game,
                    hideShips: false,
                    board: $game.playerBoard,
                    onTap: { position in
                        if let selectedShip = game.selectedShip, !game.placedShips.contains(selectedShip) {
                            game.placeShip(selectedShip, at: position)
                        }
                    }
                )
            }
            Spacer()
            Button(action: game.startGame) {
                Text("start")
                    .font(.title)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 90, height: 40)
            .background(Color.gray)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .cornerRadius(10)
            Spacer()
            VStack {
                Text("Remaining ships to place:")
                    .font(.headline)
                    .fontWeight(.bold)
                ForEach(ShipType.allCases, id: \.self) { ship in
                    if !game.placedShips.contains(ship) {
                        Text(ship.rawValue)
                    }
                }
            }
        Spacer()
        }
        .padding()
    }
}

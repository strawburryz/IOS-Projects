import SwiftUI

struct CellView: View {
    @Binding var cell: Cell
    let hideShips: Bool

    var body: some View {
        Rectangle()
            .fill(colorForCell)
            .frame(width: 25, height: 25)
            .border(Color.black, width: 3)
    }

    var colorForCell: Color {
        if cell.ship != nil {
            if cell.status == .hit {
                return .red // This cell contains a part of a ship that has been hit
            } else {
                // use return .black for debugging
                 return hideShips ? .blue : .black // This cell contains a part of a ship that is not hit
//                return .black
            }
        } else {
            switch cell.status {
            case .empty:
                return .blue // This cell does not contain a part of a ship
            case .hit:
                return .red // This cell was targeted and hit
            case .miss:
                return .white // This cell was targeted but it was a miss
            }
        }
    }
}

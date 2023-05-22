
import SwiftUI
import Combine

class Cell: ObservableObject {
    @Published var ship: Ship?
    @Published var status: CellStatus = .empty
    
    enum CellStatus {
        case empty
        case hit
        case miss
    }
}

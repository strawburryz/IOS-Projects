//
//  Digit.swift
//  CalculatorSWIFT
//
//  Created by csuftitan on 3/13/23.
//

import Foundation

enum Digit: Int, CaseIterable, CustomStringConvertible {
    case zero, one, two, three, four, five, six, seven, eight, nine
    
    var description: String {
        "\(rawValue)"
    }
}

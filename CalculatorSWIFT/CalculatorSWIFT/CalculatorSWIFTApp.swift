//
//  CalculatorSWIFTApp.swift
//  CalculatorSWIFT
//
//  Created by csuftitan on 3/13/23.
//

import SwiftUI

@main
struct CalculatorSWIFTApp: App {
    var body: some Scene {
            WindowGroup {
                CalcView()
                    .environmentObject(CalcView.ViewModel())
            }
    }
}


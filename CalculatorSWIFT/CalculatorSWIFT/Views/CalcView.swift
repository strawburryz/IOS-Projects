//
//  CalcView.swift
//  CalculatorSWIFT
//
//  Created by csuftitan on 3/13/23.
//

import SwiftUI

// MARK: - BODY

struct CalcView: View {
    
    var buttonTypes: [[ButtonType]] {
           [[.allClear, .negative, .percent, .operation(.division)],
            [.digit(.seven), .digit(.eight), .digit(.nine), .operation(.multiplication)],
            [.digit(.four), .digit(.five), .digit(.six), .operation(.subtraction)],
            [.digit(.one), .digit(.two), .digit(.three), .operation(.addition)],
            [.digit(.zero), .decimal, .equals]]
       }
    
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        VStack {
                    Spacer()
                    displayText
                    buttonPad
                }
        .padding(Constants.padding)
        .background(Color.black)
    }
}

// MARK: - PREVIEWS

struct CalcView_Previews: PreviewProvider {
    static var previews: some View {
        CalcView()
    }
}

// MARK: - COMPONENTS
extension CalcView {
    
    private var displayText: some View {
             Text(viewModel.displayText)
                 .padding()
                 .foregroundColor(.white)
                 .frame(maxWidth: .infinity, alignment: .trailing)
                 .font(.system(size: 88, weight: .light))
                 .lineLimit(1)
                 .minimumScaleFactor(0.2)
         }
         
         private var buttonPad: some View {
             VStack(spacing: Constants.padding) {
                 ForEach(viewModel.buttonTypes, id: \.self) { row in
                     HStack(spacing: Constants.padding) {
                         ForEach(row, id: \.self) { buttonType in
                             CalculatorButton(buttonType: buttonType)
                         }
                     }
                 }
             }
         }
     }

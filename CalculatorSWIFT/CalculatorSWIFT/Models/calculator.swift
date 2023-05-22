//
//  calculator.swift
//  CalculatorSWIFT
//
//  Created by csuftitan on 3/20/23.
//

import Foundation

struct Calculator {
    
    private struct ArithmeticExpression: Equatable {
        var number: Decimal
        var operation: ArithmeticOperation
        
        func evaluate(with secondNumber: Decimal) -> Decimal {
            switch operation {
            case .addition:
                return number + secondNumber
            case .subtraction:
                return number - secondNumber
            case .multiplication:
                return number * secondNumber
            case .division:
                return number / secondNumber
            }
        }
    }
    
    // MARK: - PROPERTIES
    
    private var newNumber: Decimal? {
        didSet {
            guard newNumber != nil else { return }
            carryingNegative = false
            carryingDecimal = false
            carryingZeroCount = 0
            pressedClear = false
        }
    }
    private var expression: ArithmeticExpression?
    private var result: Decimal?
    
    private var carryingNegative: Bool = false
    private var carryingDecimal: Bool = false
    private var carryingZeroCount: Int = 0
    
    private var pressedClear: Bool = false
    
    private var prevNum = ""
    private var prevOper = ""
    private var currentExpression: String = ""
    
    // MARK: - COMPUTED PROPERTIES
    
    var displayText: String {
        return getNumberString(forNumber: number, withCommas: true)
    }
    
    var showAllClear: Bool {
        newNumber == nil && expression == nil && result == nil || pressedClear
    }
        
    var number: Decimal? {
        if pressedClear || carryingDecimal {
            return newNumber
        }
        return newNumber ?? expression?.number ?? result
    }
    
    private var containsDecimal: Bool {
        return getNumberString(forNumber: number).contains(".")
    }
    
    // MARK: - OPERATIONS
    
    mutating func setDigit(_ digit: Digit) {
        if containsDecimal && digit == .zero {
            carryingZeroCount += 1
        } else if canAddDigit(digit) {
            let numberString = getNumberString(forNumber: newNumber)
            prevNum = numberString
            newNumber = Decimal(string: numberString.appending("\(digit.rawValue)"))
        }
    }
    
    mutating func setOperation(_ operation: ArithmeticOperation) {
        guard var number = newNumber ?? result else { return }
        prevNum = getNumberString(forNumber: number)
                if (!prevNum.contains(".")) {
                    prevNum += ".0"
                }
                currentExpression.append(prevOper.description + prevNum)
                prevOper = operation.description
                
                if let existingExpression = expression {
                    number = existingExpression.evaluate(with: number)
                }
                
                number = eval(mathExpression: currentExpression)
                expression = ArithmeticExpression(number: number, operation: operation)
                newNumber = nil
    }
    
    mutating func toggleSign() {
        if let number = newNumber {
            newNumber = -number
            return
        }
        if let number = result {
            result = -number
            return
        }
        
        carryingNegative.toggle()
    }
    
    mutating func setPercent() {
        if let number = newNumber {
            newNumber = number / 100
            return
        }
        if let number = result {
            result = number / 100
            return
        }
    }
    
    mutating func setDecimal() {
        if containsDecimal { return }
        carryingDecimal = true
    }
    
    mutating func evaluate() {
        guard let number = newNumber, let expressionToEvaluate = expression else { return }
                
                prevNum = getNumberString(forNumber: number)
                if (!prevNum.contains(".")) {
                    prevNum += ".0"
                }
                currentExpression.append(prevOper + prevNum)
                
                result = expressionToEvaluate.evaluate(with: number)
                result = eval(mathExpression: currentExpression)
                expression = nil
                newNumber = nil
                
                prevOper = ""
                prevNum = ""
                currentExpression = ""
    }
    
    mutating func allClear() {
        newNumber = nil
        expression = nil
        result = nil
        carryingNegative = false
        carryingDecimal = false
        carryingZeroCount = 0
        
        prevOper = ""
        prevNum = ""
        currentExpression = ""
    }
    
    mutating func clear() {
        newNumber = nil
        carryingNegative = false
        carryingDecimal = false
        carryingZeroCount = 0
        
        pressedClear = true
        prevNum = ""
    }
    
    // MARK: - HELPERS
    
    func operationIsHighlighted(_ operation: ArithmeticOperation) -> Bool {
        return expression?.operation == operation && newNumber == nil
    }
    
    private func getNumberString(forNumber number: Decimal?, withCommas: Bool = false) -> String {
        var numberString = (withCommas ? number?.formatted(.number) : number.map(String.init)) ?? "0"
        
        if carryingNegative {
            numberString.insert("-", at: numberString.startIndex)
        }
        
        if carryingDecimal {
            numberString.insert(".", at: numberString.endIndex)
        }
        
        if carryingZeroCount > 0 {
            numberString.append(String(repeating: "0", count: carryingZeroCount))
        }
        
        return numberString
    }
    
    private func canAddDigit(_ digit: Digit) -> Bool {
        return number != nil || digit != .zero
    }
    
    private func eval(mathExpression: String) -> Decimal {
        var workings = mathExpression.replacingOccurrences(of: "×", with: "*")
        workings = workings.replacingOccurrences(of: "÷", with: "/")
        let exp: NSExpression = NSExpression(format: workings)
        let result = exp.expressionValue(with:nil, context: nil)
        return Decimal(result as! Double)
        }
}

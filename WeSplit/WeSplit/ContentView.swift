//
//  ContentView.swift
//  WeSplit
//
//  Created by csuftitan on 3/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount=0.0
    @State private var numberOfPeople=2
    @State private var tipPercentage=20
    @State private var customSplit=false
    @State private var peopleLeft=1
    @State private var customAmount=0.0
    
    let tipPercentages=[10,15,20,25,0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let newAmount=checkAmount-customAmount
        let newPeople = Double(numberOfPeople + 2) - Double(peopleLeft)
        
        if !customSplit{
            let tipValue = checkAmount / 100 * tipSelection
            let grandTotal = checkAmount + tipValue
            let amountPerPerson = grandTotal / peopleCount
        
            return amountPerPerson
        }
        
        else{
            let tipValue = newAmount / 100 * tipSelection
            let newTotal = newAmount + tipValue
            let amountPerPerson = newTotal / newPeople
            
            return amountPerPerson
        }
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code:Locale.current.currencyCode ?? "USD")).keyboardType(.decimalPad)
                }header: {
                    Text("Check Amount")
                }
                Section{
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section{
                    VStack {
                        Toggle("Custom Split?", isOn: $customSplit)
                    }
                    if customSplit{
                    Section{
                        Picker("Number of people", selection: $peopleLeft) {
                            ForEach(1 ... numberOfPeople+1, id: \.self) {
                                Text("\($0) people")
                                }
                            }
                        }
                    }
                }
                if customSplit{
                    Section{
                        TextField("Custom Amount", value: $customAmount, format: .currency(code:Locale.current.currencyCode ?? "USD")).keyboardType(.decimalPad)
                    }header: {
                        Text("Custom Amount")
                    }
                }
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                    }header: {
                        Text("How much tip do you want to leave?")
                    }
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                }header: {
                    Text("Total per person")
                }
            }.navigationTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

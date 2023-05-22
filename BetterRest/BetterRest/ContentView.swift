//
//  ContentView.swift
//  BetterRest
//
//  Created by csuftitan on 3/29/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    var calculateBedtime: String{
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
           return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                } header: {
                    Text("When do you want to wake up?")
                }
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    Picker("Daily coffee intake", selection: $coffeeAmount){
                        ForEach(1 ..< 21) {
                            if ($0 == 1){
                                Text("\($0) cup")
                            }
                            else{
                                Text("\($0) cups")
                            }
                        }
                    }
                }
                Section {
                    Text("You need to go to bed at \(calculateBedtime)").font(.system(size: 30)).foregroundColor(.pink).multilineTextAlignment(.center)
                }
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("BetterRest")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader).foregroundColor(.pink)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

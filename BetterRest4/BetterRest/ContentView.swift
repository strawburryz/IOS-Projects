import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8
    @State private var sleepAmountRange = 1...12
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false


    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("When do you want to wake up?")
                            .font(.headline)
                            .padding(5)
                        
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Picker("Hours to sleep", selection: $sleepAmount) {
                        ForEach(sleepAmountRange, id: \.self) { amount in
                            Text("\(amount)").tag(amount)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
                
                Section{
                    Text("Sleep at: " + calculatedBedtime)
                        .font(.title)
                        .fontWeight(.thin)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    private var calculatedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.minute ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error: Unable to calculate bedtime"
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

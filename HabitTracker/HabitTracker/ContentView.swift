//
//  ContentView.swift
//  HabitTracker
//
//  Created by csuftitan on 4/17/23.
//

import SwiftUI


struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let description: String
}

struct ExpenseStyle: ViewModifier {
    let type: String
    func body(content: Content) -> some View {
        if type == "Health"{
            return AnyView(content.foregroundColor(.green))
        }
        else if type == "School"{
            return AnyView(content.foregroundColor(.orange))
        }
        else if type == "Work"{
            return AnyView(content.foregroundColor(.blue))
        }
        else {
            return AnyView(content.foregroundColor(.red))
        }
    }
}

extension View{
    func expenseStyle(type: String) -> some View{
        self.modifier(ExpenseStyle(type: type))
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in  HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type) .expenseStyle(type: item.type)
                    }

                    Spacer()
                }
            }.onDelete(perform: removeItems)
            }.toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("iHabit")
        }.sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var description = ""
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss

    let types = ["Health", "School", "Work", "Finances"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                TextField("Description", text: $description)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Add new habit")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, description: "Text")
                    expenses.items.append(item)
                    dismiss()
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

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}

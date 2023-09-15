//
//  TransactionView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI

struct TransactionView: View {
    //    private  var allExpenses  : [Expense]
    @State private var groupedExpenses  : [ GroupedExpenses] = []
    @State private var addExpense: Bool = false
    
    @Environment(\.dismiss) private var dismiss
 
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    
    @State private var categories: [Category] = [
        Category(id: 0, categoryName: "Groceries"),
        Category(id: 1, categoryName: "Bills"),
        Category(id: 2, categoryName: "Subscriptions")
    ]
    
    @State private var selectedCategory: Category = Category(id: 0, categoryName: "Create a category first")
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section("Title"){
                        TextField("Magic Keyboard", text: $title)
                    }
                    
                    Section("Description"){
                        TextField("Brought a keyboard at the Apple Store", text: $description)
                    }
                    
                    Section("Amount"){
                        HStack(spacing: 4){
                            Text("LKR")
                                .fontWeight(.regular)
                            TextField("", value: $amount, formatter: formatter)
                                .keyboardType(.numberPad)
                        }
                    }
                    //date Picker
                    Section("Date"){
                        HStack {
                            Text("Date")
                                .foregroundColor(Color(.darkGray))
                            Spacer()
                            DatePicker(
                                selection: $date,
                                in: dateClosedRange,
                                displayedComponents: .date,
                                label: { Text("") }
                            )
                        }
                    }
                    
                    //category Picker
                    Section("Category"){
                        HStack{
                            Text("Category")
                                .foregroundColor(Color(.gray))
                            Spacer()
                            
                            Picker(selection: $selectedCategory, label: Text(""), content: {
                                if categories.count > 0 {
                                    ForEach(categories) { category in
                                        Text(category.categoryName).tag(category)
                                    }
                                } else {
                                    Text(selectedCategory.categoryName).tag(selectedCategory)
                                }
                            })
                        }
                    }
                }
                
                Button {
                    TransactionView()
                        .disabled(isAddButtonDisable)
                } label: {
                    ZStack {
                        LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea(edges : .top)
                            .clipShape(RoundedRectangle (cornerRadius: 10))
                            .frame(height: 50)
                            .padding(35)
                        
                        Label("Submit expense", systemImage: "plus")
                            .labelStyle(.titleOnly)
                            .padding(.horizontal, 44)
//                        .padding(.vertical, 12)
                    }
                }
                .foregroundColor(.white)
                .cornerRadius(10)
               
            }.background(.opacity(0.05))
            .navigationTitle("Expenses")
        }
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let max = Date()
        return min...max
    }
    
    func addNewExpense() {
        let expense = Expense(title: title, subTitle: description, amount: amount, date: date)
    }
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var isAddButtonDisable: Bool{
        return title.isEmpty || description.isEmpty || amount == .zero
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}

//
//  AddTransactionView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
//    @State private var allcategories: [Category]
    
    var body: some View {
        NavigationStack{
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
                            .fontWeight(.semibold)
                        TextField("", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                    }
                }
                //date Picker
                Section("Date"){
                    DatePicker("", selection:  $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                //category Picker
                
            }.navigationTitle("Add Expense")
            .toolbar{
                ToolbarItem(){
                    Button("Cancel"){
                        dismiss()
                    }.tint(.red)
                }
                
                ToolbarItem(){
                    Button("Add", action: addExpense)
                        .disabled(isAddButtonDisable)
                }
            }
        }
    }
    func addExpense(){
        let expense = Expense(title: title, subTitle: description, amount: amount, date: date)
        dismiss()
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

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}

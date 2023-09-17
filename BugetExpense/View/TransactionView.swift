//
//  TransactionView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI

struct TransactionView: View {
    
    @ObservedObject var transactionVM = TransactionViewModel()
    @State var showMessage = false
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section("Title"){
                        TextField("Magic Keyboard", text: $transactionVM.expense.title)
                    }
                    
                    Section("Description"){
                        TextField("Brought a keyboard at the Apple Store", text: $transactionVM.expense.subtitle)
                    }
                    
                    Section("Amount"){
                            TextField("LKR", value: $transactionVM.expense.amount, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                    }
                    Section("Date"){
                        DatePicker("Date", selection: $transactionVM.expense.date, displayedComponents: .date)
                    }
                    Section("Category"){
                        Picker("Category", selection: $transactionVM.selectedCategoryIndex) {
                            ForEach(0..<transactionVM.categories.count, id: \.self) { category in
                                Text(transactionVM.categories[category].categoryName).tag(category)
                            }
                        }
                    }
                }

                Button {
                    transactionVM.addExpense()
                    showMessage = true
                } label: {
                    ZStack {
                        LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .clipShape(RoundedRectangle (cornerRadius: 10))
                            .frame(height: 45)
                            .padding(35)
                        
                        Label("Submit expense", systemImage: "plus")
                            .labelStyle(.titleOnly)
                            .padding( 0)
                    }
                }
                .foregroundColor(.white)
            }.background(.opacity(0.05))
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        ExpenseListView(expenseVM: ExpenseViewModel())
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
            }
        }
        .onAppear {
            // Fetch categories when the view appears
            transactionVM.fetchCategories()
            print("Fetching categories...")
        }
        .alert(item: $transactionVM.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: .default(Text("OK")) {
                }
            )
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}

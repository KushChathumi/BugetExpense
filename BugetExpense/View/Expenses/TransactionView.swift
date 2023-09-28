//
//  TransactionView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI

struct TransactionView: View {

    @ObservedObject var transactionVM: TransactionViewModel
    @State var showMessage = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginVM : LoginViewModel

    init(userID: String) {
        // Initialize TransactionViewModel with the provided userID
        self._transactionVM = ObservedObject(initialValue: TransactionViewModel(userID: userID))
    }

    var body: some View {
        NavigationView {
                VStack {
                    Divider().background( LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing))
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
                        Section("Category") {
                            if transactionVM.categories.isEmpty {
                                Text("No categories available")
                            } else {
                                Picker("Category", selection: $transactionVM.selectedCategoryIndex) {
                                    ForEach(0..<transactionVM.categories.count, id: \.self) { category in
                                        Text(transactionVM.categories[category].categoryName).tag(category)
                                    }
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
                            
                            Label("Add", systemImage: "plus")
                                .labelStyle(.titleOnly)
                                .fontWeight(.semibold)
                                .padding( 0)
                        }
                    }
                    .foregroundColor(.white)
                    
                    Divider()
                    
                }
                .background(.opacity(0.05))
                .navigationTitle("Expenses")
                .navigationBarBackButtonHidden(true) // Hide the default back button
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        // Create a custom back button
                        Button(action: {
                            // Navigate back to the previous view
                            presentationMode.wrappedValue.dismiss()
                            
                        }) {
                            Image(systemName: "arrow.uturn.backward")
                                .foregroundColor(Color(.white))
                                .fontWeight(.heavy)
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
                    print("Alert")
                }
            )
        }
    }
}

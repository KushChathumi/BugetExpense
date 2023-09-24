//
//  ExpenseView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-24.
//

import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel: expsense
    @ObservedObject var loginVM: LoginViewModel
    
    let userID: String? // Assuming you have the user's ID

    var body: some View {
        NavigationStack{
            List {
                ForEach(viewModel.expenses, id: \.safeID) { expense in
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                // Display expense title
                                Text(expense.title)
                                    .fontWeight(.semibold)
                                    .font(.title3)
                                    .foregroundColor(Color("purple2"))
                                
                                // Display expense amount
                                Text("LKR. \(String(format: "%.2f", expense.amount))")
                                    .foregroundColor(Color(.gray))
                                    .font(.system(size: 14))

                                // Display expense subtitle (with line limit and truncation)
                                Text(expense.subtitle)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .foregroundColor(Color(.gray))
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            
                            // Button to delete the expense
                            Button {
//                                viewModel.deleteExpense(expenseID: expense.id ?? "")
                            } label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }.accentColor(.red) // Set the button's text color
                        }
                    }.padding(0)
                }
            }.navigationBarTitle("Expenses") // Set the navigation bar title
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // Navigation link to the TransactionView
                        NavigationLink{
                            TransactionView(userID: loginVM.currentUser?.id ?? "")
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "plus") // Display a plus button in the navigation bar
                        }
                    }
                }
        }.onAppear {
            if let userID = userID {
                self.viewModel.fetchExpenses(forUserID: userID)
            }
        }
    }
}


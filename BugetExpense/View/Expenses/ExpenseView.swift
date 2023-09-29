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
        
        NavigationView {
            VStack{
                Divider().background( LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                List {
                    if viewModel.groupedExpenses.isEmpty {
                        Text("No expenses to display.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(viewModel.groupedExpenses.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(dateFormatter.string(from: date)).foregroundColor(Color("purple2"))) {
                                ForEach(viewModel.groupedExpenses[date]!, id: \.self) { expense in
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
                                                viewModel.deleteExpense(expense)
                                                print(expense.id)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                            }.accentColor(.red) // Set the button's text color
                                        }
                                    }.padding(0)
                                }
                            }
                        }
                    }
                }
                Divider()
            }.navigationTitle("Expenses")
            
             .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Navigation link to the TransactionView
                    NavigationLink{
                        TransactionView(userID: loginVM.currentUser?.id ?? "")
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "plus") // Display a plus button in the navigation bar
                            .tint(.white)
                            .fontWeight(.heavy)
                    }
                }
            }
        }
        .onAppear {
            if let userID = userID {
                self.viewModel.fetchExpenses(forUserID: userID)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

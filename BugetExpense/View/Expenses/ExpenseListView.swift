//
//  ExpenseListView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-17.
//

import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var expenseVM: ExpenseViewModel
    @State private var isTransactionViewPresented = false
    @EnvironmentObject var loginVM : LoginViewModel
    
    var body: some View {
        NavigationView {
            List {
                // Iterate through the keys (dates) in sorted order
                ForEach(expenseVM.groupedExpenses.keys.sorted(), id: \.self) { date in
                    // Create a section header with the formatted date
                    Section(header:
                        Text(formatDate(date))
                            .font(.title3) // Set the desired font size and style for the section header
                            .foregroundColor(.black) // Customize the text color if needed
                        .fontWeight(.semibold)
                    ) {
                        // Iterate through expenses within this date
                        ForEach(expenseVM.groupedExpenses[date] ?? []) { expense in
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        // Display expense title
                                        Text(expense.title)
                                            .fontWeight(.semibold)
                                            .font(.title3)
                                            .foregroundColor(Color("purple2"))
                                        
                                        // Display expense category
                                        Text("Category: \(expense.category.categoryName)")
                                            .font(.system(size: 16))
                                        
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
                                        expenseVM.deleteExpense(expenseID: expense.id ?? "")
                                    } label: {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }.accentColor(.red) // Set the button's text color
                                }
                            }.padding(0)
                        }
                    }.foregroundColor(.black) // Set the text color for this section
                    .fontWeight(.semibold) // Set the font weight for this section
                }
            }
            .navigationBarTitle("Expenses") // Set the navigation bar title
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
        }
        .onAppear {
            expenseVM.fetchExpenses() // Fetch expenses when the view appears
            print(expenseVM.expenses)
        }
    }
    
    // Helper function to format a date as a string (ignoring time)
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Calendar.current.startOfDay(for: date))
    }
}

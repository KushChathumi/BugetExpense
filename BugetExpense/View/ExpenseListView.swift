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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenseVM.groupedExpenses.keys.sorted(), id: \.self) { date in
                    Section(header:
                        Text(formatDate(date))
                            .font(.title3) // Set the desired font size and style for the section header
                            .foregroundColor(.black) // Customize the text color if needed
                        .fontWeight(.semibold)
                    ) {
                        ForEach(expenseVM.groupedExpenses[date] ?? []) { expense in
                            VStack{
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(expense.title)
                                            .fontWeight(.semibold)
                                            .font(.title3)
                                            .foregroundColor(Color("purple2"))
                                        Text("Category: \(expense.category.categoryName)")
                                            .font(.system(size: 16))
                                        Text("LKR. \(String(format: "%.2f", expense.amount))")
                                            .foregroundColor(Color(.gray))
                                            .font(.system(size: 14))
                                        Text(expense.subtitle)
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                            .foregroundColor(Color(.gray))
                                            .font(.system(size: 14))
                                    }
                                    Spacer()
                                    
                                    Button {
                                        expenseVM.deleteExpense(expenseID: expense.id ?? "")
                                    } label: {
                                        Image(systemName: "trash")
                                            .resizable() 
                                            .frame(width: 20, height: 20)
                                    }.accentColor(.red)
                                }
                            }.padding(0)
                        }
                    }.foregroundColor(.black)
                    .fontWeight(.semibold)
                }
            }
            .navigationBarTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        TransactionView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            expenseVM.fetchExpenses()
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

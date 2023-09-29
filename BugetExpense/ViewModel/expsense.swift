//
//  expsense.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class expsense: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var expenses: [ExpenseData] = []
    @Published var groupedExpenses = [Date: [ExpenseData]]()
    @Published var errorMessage = ""
    @Published var expens = [Expense]()
    @Published var dataLoaded = false // Indicates whether data is loaded
    
    func fetchExpenses(forUserID userID: String) {
        db.collection("expenses")
            .whereField("userID", isEqualTo: userID) // Filter by user ID
            .order(by: "date", descending: true) // Sort by date in descending order
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                // Clear existing expenses and groupedExpenses
                self.expenses = []
                self.groupedExpenses = [:]
                
                for document in documents {
                    do {
                        var expense = try document.data(as: ExpenseData.self)
                        
                        // Set the id property based on the document ID
                        expense.id = document.documentID
                        
                        // Round the date to midnight to ensure expenses on the same date are grouped together
                        let calendar = Calendar.current
                        let roundedDate = calendar.startOfDay(for: expense.date)
                        expense.date = roundedDate
                        
                        self.expenses.append(expense)
                    } catch {
                        print(error)
                    }
                }
                
                // Group expenses by date
                self.groupedExpenses = Dictionary(grouping: self.expenses, by: { $0.date })
                
                // Sort the grouped expenses by date in descending order
                self.groupedExpenses = self.groupedExpenses
                    .sorted(by: { $0.key > $1.key })
                    .reduce(into: [Date: [ExpenseData]]()) { result, element in
                        result[element.key] = element.value
                    }
                
                // Data is loaded, set dataLoaded to true
                self.dataLoaded = true
            }
    }

    
    func calculateDateWiseSpendAmounts() -> [String: String] {
        var dateWiseSpendAmounts: [String: String] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d" // Use the desired date format
        
        for (date, expenses) in groupedExpenses {
            let totalAmount = expenses.reduce(0.0) { $0 + $1.amount }
            let formattedTotalAmount = String(format: "%.2f", totalAmount)
            let formattedDate = dateFormatter.string(from: date)
            dateWiseSpendAmounts[formattedDate] = formattedTotalAmount
        }
        
        return dateWiseSpendAmounts
    }
    
    func calculateTotalExpenseAmount() -> Double {
        let totalAmount = expenses.reduce(0.0) { $0 + $1.amount }
        return totalAmount
    }
    
    func deleteExpense(_ expense: ExpenseData) {
            guard let expenseID = expense.id else {
                errorMessage = "Expense ID is missing."
                return
            }

            let expenseRef = db.collection("expenses").document(expenseID)
            
            expenseRef.delete { error in
                if let error = error {
                    self.errorMessage = ("Error deleting expense: \(error.localizedDescription)")
                    print(self.errorMessage)
                } else {
                    print("Successfully Deleted ..")
                }
            }
        }
}

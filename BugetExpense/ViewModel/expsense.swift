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
                        let expense = try document.data(as: ExpenseData.self)
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
            }
    }

    
    //    func deleteExpense(deleteExpense: ExpenseData) {
    //        let db = Firestore.firestore()
    //
    //        if let expenseID = deleteExpense.id {
    //            // Delete the Firestore document associated with the expense ID
    //            db.collection("expenses").document(expenseID).delete { error in
    //                if let error = error {
    //                    // Handle data deletion error and set the custom error message
    //                    self.errorMessage = "Error deleting expense: \(error.localizedDescription)"
    //                    print(self.errorMessage)
    //                } else {
    //                    DispatchQueue.main.async {
    //                        // Remove the deleted expense from the list
    //                        self.expenses.removeAll { data in
    //                            return data.id == deleteExpense.id
    //                        }
    //                    }
    //                    print("Expense deleted successfully.")
    //                }
    //            }
    //        } else {
    //            // Handle the case where expense ID is missing
    //            self.errorMessage = "Expense ID is nil, cannot delete expense."
    //            print(self.errorMessage)
    //        }
    //    }
}

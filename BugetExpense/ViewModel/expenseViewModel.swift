//
//  expenseViewModel.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-17.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExpenseViewModel: ObservableObject {
    @Published var expenses = [Expense]() // Store fetched expenses here
    @Published var groupedExpenses = [Date: [Expense]]() // Grouped expenses by date
    private var db = Firestore.firestore()
    
    func fetchExpenses() {
        let expensesRef = db.collection("expenses")
        
        expensesRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error)")
                return
            }
            
            if let documents = snapshot?.documents {
                self.expenses = documents.compactMap { document in
                    var expense = try? document.data(as: Expense.self)
                    expense?.id = document.documentID
                    return expense
                }
                
                // Group expenses by date (ignoring the time component)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Define your desired date format
                
                self.groupedExpenses = Dictionary(grouping: self.expenses) { expense in
                    if let date = dateFormatter.date(from: dateFormatter.string(from: expense.date)) {
                        return date
                    }
                    return expense.date // Use the original date if parsing fails (unlikely)
                }
            }
        }
    }
    
    // Function to delete an expense by ID
    func deleteExpense(expenseID: String) {
        let expensesRef = db.collection("expenses")
        
        expensesRef.document(expenseID).delete { error in
            if let error = error {
                print("Error deleting expense: \(error)")
            } else {
                // Remove the deleted expense from the local array
                if let index = self.expenses.firstIndex(where: { $0.id == expenseID }) {
                    self.expenses.remove(at: index)
                    
                    // Regroup expenses by date after deletion
                    self.regroupExpenses()
                }
            }
        }
    }
    
    // Helper function to regroup expenses by date
    private func regroupExpenses() {
        // Group expenses by date (ignoring the time component)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Define your desired date format
        
        self.groupedExpenses = Dictionary(grouping: self.expenses) { expense in
            if let date = dateFormatter.date(from: dateFormatter.string(from: expense.date)) {
                return date
            }
            return expense.date // Use the original date if parsing fails (unlikely)
        }
    }
}

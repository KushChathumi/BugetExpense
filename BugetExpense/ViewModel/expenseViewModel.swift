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
    @Published var expenses = [Expense]()
    @Published var groupedExpenses = [Date: [Expense]]()
    @Published var categoryExpenses = [String: Double]()
    @Published var dataPoints = [Date]()
    @Published var values = [Double]()
    var userID: String?
    private var db = Firestore.firestore()

    // Function to fetch all expenses from Firestore
    func fetchExpenses() {
        let expensesRef = db.collection("expenses")

        expensesRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching expenses: \(error)")
                return
            }

            if let documents = snapshot?.documents {
                // Parse documents into Expense objects
                self.expenses = documents.compactMap { document in
                    var expense = try? document.data(as: Expense.self)
                    expense?.id = document.documentID
                    return expense
                }

                // Sort expenses by date in descending order
                self.sortExpensesDescending()
            }
        }
    }

    func deleteExpense(expenseID: String) {
        let expensesRef = db.collection("expenses")

        expensesRef.document(expenseID).delete { error in
            if let error = error {
                print("Error deleting expense: \(error)")
            } else {
                // Remove the deleted expense from the local array
                if let index = self.expenses.firstIndex(where: { $0.id == expenseID }) {
                    self.expenses.remove(at: index)
                    self.regroupExpenses()
                }
            }
        }
    }

    private func regroupExpenses() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        self.groupedExpenses = Dictionary(grouping: self.expenses) { expense in
            if let date = dateFormatter.date(from: dateFormatter.string(from: expense.date)) {
                return date
            }
            return expense.date
        }
    }

    func sortExpensesDescending() {
        expenses.sort { $0.date > $1.date }
        expenses = expenses.reversed()
        regroupExpenses()
    }
}

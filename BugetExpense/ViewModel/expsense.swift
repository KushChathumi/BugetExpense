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
    @Published var groupedExpenses = [Date: [Expense]]()
    @Published var errorMessage = ""
    @Published var expens = [Expense]()
    
    func fetchExpenses(forUserID userID: String) {
        db.collection("expenses")
            .whereField("userID", isEqualTo: userID) // Filter by user ID
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.expenses = documents.compactMap { document in
                    do {
                        let expense = try document.data(as: ExpenseData.self)
                        return expense
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }
    }
}

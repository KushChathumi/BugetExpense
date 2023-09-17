//
//  TransactionViewModel.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-17.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TransactionViewModel: ObservableObject {
    @Published var expense = Expense()
    @Published var selectedCategoryIndex = 0
    @Published var message = ""
    @Published var categories = [Category]()
    @Published var alertItem: AlertItem?
    
    private var db = Firestore.firestore()
    
    // Function to fetch the expense
    func fetchCategories() {
        let categoriesRef = db.collection("Category")
        
        categoriesRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }
            
            if let documents = snapshot?.documents {
                self.categories = documents.compactMap { document in
                    var category = try? document.data(as: Category.self)
                    category?.id = document.documentID
                    return category
                }
                print("Fetched categories: \(self.categories)")
            }
        }
    }
    
    // Function to add a new expense
   func addExpense() {
       let expensesRef = db.collection("expenses")

       // Validate the input
       if expense.title.isEmpty || expense.subtitle.isEmpty || expense.amount <= 0 {
           alertItem = AlertItem(title: "Error", message: "Please fill in all fields and provide a valid amount.")
           return
       }

       do {
           // Set the category name and ID in the expense data
           let expenseData: [String: Any] = [
               "title": expense.title,
               "subtitle": expense.subtitle,
               "amount": expense.amount,
               "date": expense.date,
               "category": [
                   "categoryName": categories[selectedCategoryIndex].categoryName,
                   "id": categories[selectedCategoryIndex].id
               ]
           ]

           // Add the expense to Firestore
           expensesRef.addDocument(data: expenseData) { error in
               if let error = error {
                   self.alertItem = AlertItem(title: "Error", message: "Error adding expense: \(error.localizedDescription)")
               } else {
                   self.alertItem = AlertItem(title: "Success", message: "Expense added successfully")
                   self.expense.title = ""
                   self.expense.subtitle = ""
                   self.expense.amount = 0.0
                   self.expense.date = Date()
                   self.selectedCategoryIndex = 0
               }
           }
       }
   }
}


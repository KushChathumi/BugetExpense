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
    
    @Published var categoryData: [CategoryData] = []
    
    private var db = Firestore.firestore()
    
    // User ID of the logged-in user (you should set this when the user logs in)
    var userID: String?
    
    // Initialize your view model with a userID
    init(userID: String) {
        self.userID = userID
        // Fetch categories when the view model is initialized
        fetchCategories()
    }
    
    // Function to fetch categories from Firestore
    func fetchCategories() {
        let categoriesRef = db.collection("Category")
        
        // Add a filter condition for the userID
        categoriesRef.whereField("userID", isEqualTo: userID ?? "").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
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
                
                // Calculate category expenses
                self.calculateCategoryExpenses()
//                print("Fetched categories: \(self.categories)")
            }
        }
    }


    // Function to calculate category expenses
    func calculateCategoryExpenses() {
        // Calculate category expenses based on fetched categories
        var categoryExpenses: [CategoryData] = []

        for category in categories {
            let categoryRef = db.collection("expenses")
                .whereField("category.id", isEqualTo: category.id ?? "")
                .whereField("userID", isEqualTo: userID ?? "") // Filter by user ID

            categoryRef.getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching expenses for category \(category.categoryName): \(error)")
                    return
                }

                if let documents = snapshot?.documents {
                    let categoryExpense = documents.compactMap { document in
                        try? document.data(as: Expense.self)
                    }.reduce(0) { $0 + $1.amount }

                    categoryExpenses.append(CategoryData(name: category.categoryName, amount: categoryExpense))
                    self.categoryData = categoryExpenses
                    self.objectWillChange.send()
                }
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
                    "id": categories[selectedCategoryIndex].id ?? ""
                ],
                "userID": userID // Set the user ID
            ]

            // Add the expense to Firestore
            expensesRef.addDocument(data: expenseData) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.alertItem = AlertItem(title: "Error", message: "Error adding expense: \(error.localizedDescription)")
                } else {
                    self.alertItem = AlertItem(title: "Success", message: "Expense added successfully")
                    self.expense.title = ""
                    self.expense.subtitle = ""
                    self.expense.amount = 0.0
                    self.expense.date = Date()
                    self.selectedCategoryIndex = 0

                    // Recalculate category expenses after adding a new expense
                    self.calculateCategoryExpenses()
                }
            }
        }
    }
}

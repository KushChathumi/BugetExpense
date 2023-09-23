//
//  Expense.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Expense: Identifiable, Codable {
    var id: String?
    var title: String
    var subtitle: String
    var amount: Double
    var date: Date
    var userID: String // This property holds the logged-in user's ID
    var category: Category
    
    init(userID: String = "") {
        self.id = ""
        self.title = ""
        self.subtitle = ""
        self.amount = 0.0
        self.date = Date()
        self.userID = userID // Initialize with the logged-in user's ID
        self.category = Category(categoryName: "", userID: userID) // Pass the userID to the Category as well
    }
}

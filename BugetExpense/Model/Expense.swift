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
    var category: Category
    
    init() {
        self.id = ""
        self.title = ""
        self.subtitle = ""
        self.amount = 0.0
        self.date = Date()
        self.category = Category(id: "", categoryName: "")
    }
}


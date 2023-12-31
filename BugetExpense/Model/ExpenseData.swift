//
//  ExpenseData.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ExpenseData: Identifiable, Codable, Hashable {
    var id: String?
    var title: String
    var subtitle: String
    var amount: Double
    var date: Date
    
    
    var safeID: String {
        return id ?? UUID().uuidString
    }
}



//
//  Category.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import Foundation
import FirebaseFirestoreSwift

struct Category: Identifiable, Codable, Hashable {
    var id: String?
    var categoryName: String
    var userID: String // Add the user ID property

    // Initialize a category with a user ID
    init(categoryName: String, userID: String) {
        self.categoryName = categoryName
        self.userID = userID
    }
}

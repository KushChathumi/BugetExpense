//
//  Category.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import Foundation

struct Category: Identifiable, Hashable {
    var id: String
    var categoryName: String
//    var userID : String
    
    init(id: String, categoryName: String) {
        self.id = id
        self.categoryName = categoryName
//        self.userID = userID
    }

}

//
//  Category.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import Foundation

struct Category: Identifiable {
    var id: ObjectIdentifier
    let categoryName: String
    
    init(id: ObjectIdentifier, categoryName: String) {
        self.id = id
        self.categoryName = categoryName
    }
}

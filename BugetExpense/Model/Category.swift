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
}

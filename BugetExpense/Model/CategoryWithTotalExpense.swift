//
//  CategoryWithTotalExpense.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-28.
//

import Foundation

struct CategoryWithTotalExpense : Identifiable {
    var id = UUID()
    var categoryName: String
    var totalExpense: Double
}

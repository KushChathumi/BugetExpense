//
//  Expense.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import Foundation
 
class Expense {

    let title: String
    let subTitle: String
    let amount: Double
    let date: Date
    let categort: Category?
    
    init(title: String, subTitle: String, amount: Double, date: Date, categort: Category? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.categort = categort
    }
}

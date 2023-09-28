//
//  DashboardViewModel.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-27.
//

import Foundation

struct ReportItem: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let subtitle: String
    let amount: Double
}

class DashboardViewModel: ObservableObject {
    @Published var reportItems: [ReportItem] = []
    
    init(expensesViewModel: expsense) {
        // Listen for changes in the expensesViewModel's expenses property
        expensesViewModel.$expenses
            .map { expenses in
                // Transform the expenses data into ReportItems
                return expenses.map { expense in
                    ReportItem(date: expense.date, title: expense.title, subtitle: expense.subtitle, amount: expense.amount)
                }
            }
            .assign(to: &$reportItems)
        print("Report Items: \(reportItems)")
    }
}

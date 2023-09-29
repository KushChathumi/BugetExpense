//
//  DashboardTabView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-28.
//

import SwiftUI
import Charts

struct DashboardTabView: View {
    let title: String
    let dateFilter: DateFilter
    
    @ObservedObject var viewModel: expsense
    
    let userID: String?
    
    enum DateFilter {
        case currentDate
        case lastWeek
        case currentMonth
    }
    
    var body: some View {
        List {
            VStack() {
                Text(title)
                Chart {
                    ForEach(filteredExpenses) { data in
                        BarMark(x: PlottableValue.value("Type", data.title),
                                y: PlottableValue.value("amount", data.amount))
                    }
                }
                .chartXAxisLabel("Expense Type", position: .bottom)
                .chartYAxisLabel("Amount", position: .leading)
                .frame(height: 125)
                
            }
        }
        .onAppear {
            if let userID = userID {
                viewModel.fetchExpenses(forUserID: userID)
            }
        }
    }

    private var filteredExpenses: [ExpenseData] {
        let currentDate = Date()
        switch dateFilter {
        case .currentDate:
            return viewModel.expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
        case .lastWeek:
            let lastWeekStartDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
            return viewModel.expenses.filter { $0.date >= lastWeekStartDate && $0.date <= currentDate }
        case .currentMonth:
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
            return viewModel.expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: startOfMonth) }
        }
    }
}



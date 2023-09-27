//
//  ReportView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI
import Charts

struct ReportView: View {
    
    @ObservedObject var viewModel: expsense
    @ObservedObject var loginVM: LoginViewModel
    let userID: String? // Assuming you have the user's ID

    
    var body: some View {
        NavigationStack  {
            List{
                VStack{
                    Text("title")
                    
//                    ForEach(viewModel.groupedExpenses.keys.sorted(by: >), id: \.self) { date in
//                        Section(header: Text(dateFormatter.string(from: date)).foregroundColor(Color("purple2"))) {
//                            ForEach(viewModel.groupedExpenses[date]!, id: \.self) { expense in
//                                Text(expense.title)
//                                    .fontWeight(.semibold)
//                                    .font(.title3)
//                                    .foregroundColor(Color("purple2"))
//                            }}}
                }
                
                
                                Chart {
                                    ForEach(viewModel.expenses){ data in
                                        BarMark(x: PlottableValue.value("Type", data.title),
                                                y: PlottableValue.value("amount", data.amount))
                                    }
                                }
            }
        }.navigationTitle("Report")
            .onAppear {
                if let userID = userID {
                    self.viewModel.fetchExpenses(forUserID: userID)
                }
            }
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}


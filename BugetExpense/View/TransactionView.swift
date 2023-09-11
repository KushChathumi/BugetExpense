//
//  TransactionView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI

struct TransactionView: View {
    //    private  var allExpenses  : [Expense]
    @State private var groupedExpenses  : [ GroupedExpenses] = []
    @State private var addExpense: Bool = false
    var body: some View {
        NavigationStack  {
            List{
                
            }.navigationTitle("Expenses")
                .toolbar{
                    ToolbarItem() {
                        Button {
                            addExpense.toggle()
                        }label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
        }.sheet(isPresented: $addExpense){
            AddTransactionView()
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}

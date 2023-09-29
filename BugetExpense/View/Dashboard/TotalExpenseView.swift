//
//  TotalExpenseView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-29.
//

import SwiftUI

struct TotalExpenseView: View {
    
    @ObservedObject var expsenseVM: expsense
    @State private var totalExpense: Double? // Use an optional Double
    
    let userID: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("orange"))
                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
            
            VStack {
                Text("Total Expenses")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.white))
                    .padding(.top, 5)
                    .font(.system(size: 20))
                
                // Display the totalExpense if available, or show a loading indicator
                if let totalExpense = totalExpense {
                    Text(String(format: "%.2f", totalExpense))
                        .font(.title3)
                        .padding(.top, 1)
                        .foregroundColor(Color(.white))
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(.white)))
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear {
            if let userID = userID {
                self.expsenseVM.fetchExpenses(forUserID: userID)
            }
        }
        .onChange(of: expsenseVM.expenses) { _ in
            // Update totalExpense when expenses change
            totalExpense = expsenseVM.calculateTotalExpenseAmount()
        }
        .frame(width: 150, height: 100)
        .padding()
    }
}

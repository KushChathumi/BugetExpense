//
//  TotalIncomeView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-29.
//

import SwiftUI

struct TotalIncomeView: View {
    
    @ObservedObject var categoryVM : CategoryViewModel
    @State private var totalBudget: Double = 0.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10) // Rounded rectangle for the card
                .foregroundColor(Color("green")) // Card background color
                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 4) // Shadow effect
            
            VStack {
                Text("Total Income")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.white))
                    .padding(.top, 5)
                    .font(.system(size: 20))
                
                Text((String(format: "%.2f", totalBudget)))
                    .font(.title3)
                    .padding(.top,1)
                    .foregroundColor(Color(.white))
                    .fontWeight(.bold)
                    .font(.system(size: 20))
             
            }
        }.onAppear {
            categoryVM.getData()
            totalBudget = categoryVM.calculateTotalBudget(for: categoryVM.categories)
        }
        .frame(width: 150, height: 100) // Set the card's size
        .padding(.all) // Add padding to the card
    }
}

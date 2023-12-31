//
//  DashboardView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-11.
//

import SwiftUI
import Charts

struct DashboardView: View { 
    
    @ObservedObject var viewModel: expsense
    @ObservedObject var loginVM: LoginViewModel
    @State private var categoryTotals: [CategoryWithTotalExpense] = []
    let userID: String?
    
    var body: some View {
        NavigationView {
            VStack{
                Divider().background( LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 1){
                        TotalIncomeView(categoryVM: CategoryViewModel(userID: loginVM.currentUser?.id ?? ""))
                        TotalExpenseView(expsenseVM: expsense(), userID: loginVM.currentUser?.id ?? "")
                    }
                }.background(Color.gray.opacity(0.15))
                
                TabView {
                    DashboardTabView(title: "Current Date", dateFilter: .currentDate, viewModel: viewModel, userID: userID)
                        .tabItem {
                            Image(systemName: "calendar.circle.fill")
                                .foregroundColor(.red)
                            Text("Current Date")
                        }
                    DashboardTabView(title: "Last Week", dateFilter: .lastWeek, viewModel: viewModel, userID: userID)
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Last Week")
                        }
//                    ScrollView(.horizontal, showsIndicators: false){
//                        HStack(spacing: 1){
//                            TotalIncomeView(categoryVM: CategoryViewModel(userID: loginVM.currentUser?.id ?? ""))
//                            TotalExpenseView(expsenseVM: expsense(), userID: loginVM.currentUser?.id ?? "")
//                        }
//                    }.background(Color.gray.opacity(0.15))
                }
                .tabViewStyle(PageTabViewStyle()) // Optional, for page-style tab navigation
                .navigationTitle("Dashboard")
                .accentColor(.blue)
                .frame(height: 230)
                .padding(.top, 0)
               
                Text("Day Wise Total Amount").font(.title3)
                
                List {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Date")
                            Spacer()
                            Text("Total Amount")
                        }
                        .font(.headline)
                        .foregroundColor(.black) // Apply styles to the header row
                        Divider()
                        ForEach(Array(viewModel.calculateDateWiseSpendAmounts().sorted(by: { $0.key > $1.key })), id: \.key) { date, amount in
                            HStack {
                                Text(date).foregroundColor(.gray)
                                Spacer()
                                Text(" \(amount)").foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                            Divider()
                        }
                    }
                }
                Divider()
            }
        }
        .onAppear {
            if let userID = userID {
                self.viewModel.fetchExpenses(forUserID: userID)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // "MMM" represents the month abbreviation, "d" represents the day
        return formatter
    }
}

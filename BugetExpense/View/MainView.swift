//
//  MainView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            DashboardView()
                .tabItem{
                    Label("dashboard", systemImage: "tray.and.arrow.up.fill")
                }
            ExpenseListView(expenseVM: ExpenseViewModel())
                .tabItem{
                    Label("Expenses2", systemImage: "creditcard.fill")
                }
            ReportView()
                .tabItem{
                    Label("Report", systemImage: "chart.bar.fill")
                }
            SettingView()
                .tabItem{
                    Label("Setting", systemImage: "gearshape.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

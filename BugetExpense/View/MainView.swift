//
//  MainView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    var body: some View {
        TabView{
//            ExpenseListView(viewModel: ExpenseViewModel(), loginVM: LoginViewModel(), userID: loginVM.currentUser?.id)
//                .tabItem{
//                    Label("dashboard", systemImage: "tray.and.arrow.up.fill")
//                }
            UserProfileView()
                .tabItem{
                    Label("dashboard2", systemImage: "tray.and.arrow.up.fill")
                }
            ExpenseView(viewModel: expsense(), loginVM: LoginViewModel(), userID: loginVM.currentUser?.id)
                .tabItem{
                    Label("Expenses", systemImage: "creditcard.fill")
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

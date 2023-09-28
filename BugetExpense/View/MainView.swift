//
//  MainView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    let categories: [Category] = [] // Populate with your category data
    @State private var isLoading = false
    
    var body: some View {
        TabView{
            ExpenseView(viewModel: expsense(), loginVM: LoginViewModel(), userID: loginVM.currentUser?.id)
                .tabItem{
                    Label("Expenses", systemImage: "note.text.badge.plus")
                }
            DashboardView(viewModel: expsense(), loginVM: LoginViewModel(),  userID: loginVM.currentUser?.id)
                .tabItem{
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            CategoriesView(categoryVM: CategoryViewModel(userID: loginVM.currentUser?.id ?? ""))
                .tabItem{
                    Label("Categories", systemImage: "gearshape.fill")
                }
        }.accentColor((Color("Purple5")))
    }
}
 

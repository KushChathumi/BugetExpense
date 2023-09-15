//
//  DashboardView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-03.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationView {
            List{
                Section("Charts") {
                    
                }
                Section ("Expenses")  {
                    
                }
            }
            .navigationTitle("Dashboard")
        }
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

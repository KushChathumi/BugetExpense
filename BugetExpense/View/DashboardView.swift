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
        List{
            Section("Charts") {
                
            }
            Section ("Category")  {
                
            }
            Section("Log out"){
                Button {
                    loginVM.signOut()
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: "arrow.left.circle.fill")
                            .tint(.red)
                        Text("Sign out")
                            .fontWeight(.semibold)
                            .accentColor(.gray)
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

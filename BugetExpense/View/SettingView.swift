//
//  SettingView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationView {
            List{
                Section ("Category")  {
                    NavigationLink{
                        CategoriesView()
                    }label: {
                        HStack{
                            Text("Category")
                        }
                    }
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
            }//.padding(.top, 10)
            .navigationTitle("Setting")
        }
        
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

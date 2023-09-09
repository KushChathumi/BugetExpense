//
//  ContentView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-02.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel

    var body: some View {
        Group  {
            if loginVM.userSession != nil {
                DashboardView()
            }else {
                SignInView()
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

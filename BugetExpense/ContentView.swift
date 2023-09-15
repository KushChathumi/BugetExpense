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
                MainView()
            }else {
                SignInView()
            }
        }
    }
}


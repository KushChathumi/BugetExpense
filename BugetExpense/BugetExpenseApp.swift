//
//  BugetExpenseApp.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-02.
//

import SwiftUI
import Firebase

@main
struct BugetExpenseApp: App {
    
    @StateObject var loginVM   =  LoginViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
                ContentView()
                    .environmentObject(loginVM)

        }
    }
}

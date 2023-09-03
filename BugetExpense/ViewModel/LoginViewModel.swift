//
//  LoginViewModel.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-02.
//

import Foundation
import SwiftUI

class LoginViewModel : ObservableObject{
    
    @Published var name:String = ""
    @Published var email:String = ""
    @Published var password: String = ""
    
    @Published var showSignInView : Bool = false
    @Published var showSignUpView : Bool = false
    @Published var showDashboardView : Bool = false
}

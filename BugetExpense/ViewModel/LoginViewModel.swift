//
//  LoginViewModel.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-02.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class LoginViewModel : ObservableObject{
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var showSignInView : Bool = false
    @Published var showSignUpView : Bool = false
    @Published var showDashboardView : Bool = false
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("sign In")
    }
    
    func  createUser(withEmail email: String, password: String, name: String) async throws{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, name: name, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
            DashboardView()
        } catch {
            print("DEBUG : Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        
    }
    
    func fetchUser() async {
        
    }
}

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

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class LoginViewModel : ObservableObject{

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var hasError = false
    @Published var errorMessage = ""
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch {
            hasError = true
            errorMessage = error.localizedDescription
            print("DEBUG : Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func  createUser(withEmail email: String, password: String, name: String) async throws{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, name: name, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            hasError = true
            errorMessage = error.localizedDescription
            print("DEBUG : Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }catch {
            hasError = true
            errorMessage = error.localizedDescription
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
            self.currentUser = try? snapshot.data(as: User.self)
//            print("DEBUG: Current User is \(String(describing: self.currentUser))")
    }
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { [self] error in
            callback?(error)
            self.hasError = true
            errorMessage = "Email sent to your email address"
        }
    }
}

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

// Protocol defining a common form requirement
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class LoginViewModel : ObservableObject{

    // Published properties for user session, current user, and error handling
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var hasError = false
    @Published var errorMessage = ""
    @Published var hasSuccess = false
    @Published var successMessage = ""
    @Published var userID: String?
    
    // Initialize the ViewModel
    init(){
        // Initialize userSession with the current authenticated user, if any
        self.userSession = Auth.auth().currentUser
        
        // Fetch user data asynchronously when the ViewModel is initialized
        Task {
            await fetchUser()
        }
    }
    
    // Function to sign in with email and password
    func signIn(withEmail email: String, password: String) async throws {
        do {
            // Attempt to sign in using Firebase Authentication
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Update userSession with the signed-in user
            self.userSession = result.user
            
            // Fetch user data and update currentUser
            await fetchUser()
            self.userID = result.user.uid
            // Print the user's ID for debugging
            print("logged user \(currentUser?.id)")
            print("logged user's userID \(userID)")
        } catch {
            // Handle authentication errors and update error state
            hasError = true
            errorMessage = error.localizedDescription
            print("DEBUG : Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    // Function to create a new user with email, password, and name
    func createUser(withEmail email: String, password: String, name: String) async throws {
        do {
            // Create a new user using Firebase Authentication
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update userSession with the created user
            self.userSession = result.user
            
            // Create a User object with ID, name, and email
            let user = User(id: result.user.uid, name: name, email: email)
            
            // Encode and store user data in Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            // Update currentUser with the created user
            self.currentUser = user
            
            // Fetch user data asynchronously
            await fetchUser()
            self.userID = result.user.uid
        } catch {
            // Handle user creation errors and update error state
            hasError = true
            errorMessage = error.localizedDescription
            print("DEBUG : Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    // Function to sign out the current user
    func signOut(){
        do{
            // Sign out the user using Firebase Authentication
            try Auth.auth().signOut()
            
            // Clear userSession and currentUser
            self.userSession = nil
            self.currentUser = nil
        } catch {
            // Handle sign-out errors and update error state
            hasError = true
            errorMessage = error.localizedDescription
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // Function to fetch user data from Firestore
    func fetchUser() async {
        if let uid = Auth.auth().currentUser?.uid {
            do {
                // Fetch the user document from Firestore
                let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
                
                // Try to decode user data and update currentUser
                self.currentUser = try? snapshot.data(as: User.self)
            } catch {
                // Handle Firestore fetch errors and print error details
                print("Error fetching user data: \(error.localizedDescription)")
            }
        } else {
            // Handle the case where there's no authenticated user
            print("No authenticated user.")
        }
    }
    
    // Function to send a password reset email
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { [self] error in
            // Execute the provided callback and update error state
            callback?(error)
            self.hasSuccess = true
            successMessage = "Email sent to your email address"
        }
    }
}

//
//  UserProfileView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-23.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject var loginVM = LoginViewModel()
    @State private var isLoading = false // Optional: Add a loading indicator

    var body: some View {
        VStack {
            if let currentUser = loginVM.currentUser {
                Text("Logged-in User Details")
                Text("Name: \(currentUser.name)")
                Text("Email: \(currentUser.email)")
                Text("User ID: \(currentUser.id)")
            } else {
                Text("User not logged in.")
            }
        }
        .onAppear {
            // Start a Task to fetch the user details asynchronously
            Task {
                isLoading = true // Optional: Show a loading indicator
                await loginVM.fetchUser()
                isLoading = false // Optional: Hide the loading indicator when done
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}


//
//  CategoryViewModel.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-16.
//

import Foundation
import Firebase

class CategoryViewModel: ObservableObject {
    
    @Published var categories = [Category]()
    
    // User ID of the logged-in user
    var userID: String
    
    // Published property to display custom error messages
    @Published var errorMessage = ""
  
    // Initialize the ViewModel with the logged-in user's ID
    init(userID: String) {
        self.userID = userID
        getData() // Fetch data when the ViewModel is initialized
    }
    
    // Function to fetch categories associated with the logged-in user
    func getData() {
        let db = Firestore.firestore()
        
        // Use the userID property to filter categories for the logged-in user
        db.collection("Category")
            .whereField("userID", isEqualTo: userID) // Filter by user ID
            .getDocuments { snapshot, error in
                if let error = error {
                    // Handle data retrieval error and set the custom error message
                    self.errorMessage = "Error retrieving data: \(error.localizedDescription)"
                    print(self.errorMessage)
                    return
                }
                
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        // Map Firestore documents to Category objects
                        self.categories = snapshot.documents.compactMap { doc in
                            var categoryData = doc.data()
                            categoryData["id"] = doc.documentID
                            return try? Firestore.Decoder().decode(Category.self, from: categoryData)
                        }
                    }
                }
            }
    }

    // Function to add a new category
    func addCategory(categoryName: String) {
        let db = Firestore.firestore()

        // Create a new Category object with the provided name and user ID
        let newCategory = Category(categoryName: categoryName, userID: userID)

        // Encode and add the new category to Firestore
        do {
            let encodedCategory = try Firestore.Encoder().encode(newCategory)
            db.collection("Category").addDocument(data: encodedCategory) { error in
                if let error = error {
                    // Handle data storage error and set the custom error message
                    self.errorMessage = "Error adding category: \(error.localizedDescription)"
                    print(self.errorMessage)
                } else {
                    // Refresh the category list after adding a new category
                    self.getData()
                }
            }
        } catch {
            // Handle encoding error
            self.errorMessage = "Error encoding category data: \(error.localizedDescription)"
            print(self.errorMessage)
        }
    }

    // Function to delete a category
    func deleteCategory(deleteCategory: Category) {
        let db = Firestore.firestore()
        
        if let categoryID = deleteCategory.id {
            // Delete the Firestore document associated with the category ID
            db.collection("Category").document(categoryID).delete { error in
                if let error = error {
                    // Handle data deletion error and set the custom error message
                    self.errorMessage = "Error deleting category: \(error.localizedDescription)"
                    print(self.errorMessage)
                } else {
                    DispatchQueue.main.async {
                        // Remove the deleted category from the list
                        self.categories.removeAll { data in
                            return data.id == deleteCategory.id
                        }
                    }
                    print("Category deleted successfully.")
                }
            }
        } else {
            // Handle the case where category ID is missing
            self.errorMessage = "Category ID is nil, cannot delete category."
            print(self.errorMessage)
        }
    }
}

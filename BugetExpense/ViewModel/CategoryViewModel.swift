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
  
    func getData() {
        let db = Firestore.firestore()

        db.collection("Category").getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving data: \(error.localizedDescription)")
                return
            }

            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.categories = snapshot.documents.compactMap { doc in
                        var categoryData = doc.data()
                        categoryData["id"] = doc.documentID
                        return try? Firestore.Decoder().decode(Category.self, from: categoryData)
                    }

                    // Print the fetched categories to the console
                    for category in self.categories {
                        print("Category ID: \(category.id ?? ""), Name: \(category.categoryName)")
                    }
                }
            }
        }
    }

    
    func addData(categoryName: String){
        let db = Firestore.firestore()
        
        db.collection("Category").addDocument(data: ["categoryName": categoryName]) { error in
            if error == nil{
                self.getData()
            }else {
                
            }
        }
    }
    

    func deleteData(deleteCategory: Category) {
        let db = Firestore.firestore()
        
        if let categoryID = deleteCategory.id {
            db.collection("Category").document(categoryID).delete { error in
                if let error = error {
                    print("Error deleting data: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.categories.removeAll { data in
                            return data.id == deleteCategory.id
                        }
                    }
                    print("Data deleted successfully.")
                }
            }
        } else {
            // Handle the case where deleteCategory.id is nil
            print("Category ID is nil, cannot delete data.")
        }
    }

}

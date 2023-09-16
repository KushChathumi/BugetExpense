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
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.categories = snapshot.documents.map { doc in
                            return Category(id: doc.documentID,
                                            categoryName: doc["categoryName"] as? String ?? "")
                        }
                        
                        // Print the fetched categories to the console
                        for category in self.categories {
                            print("Category ID: \(category.id), Name: \(category.categoryName)")
                        }
                    }
                }
            } else {
                print("Error retrieving data: \(error?.localizedDescription ?? "Unknown error")")
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
    
//    func deleteData(deleteCategory: Category){
//        let db = Firestore.firestore()
//
//        db.collection("Category").document(deleteCategory.id).delete { error in
//            if error == nil {
//                DispatchQueue.main.async {
//                    self.categories.removeAll { data in
//                        return data.id == deleteCategory.id
//                    }
//                }
//            } else {
//                print("Error retrieving data: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
//    }
    
    func deleteData(deleteCategory: Category) {
        let db = Firestore.firestore()
        
        db.collection("Category").document(deleteCategory.id).delete { error in
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
    }

}

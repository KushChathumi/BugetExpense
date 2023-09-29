//
//  CategoriesView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @State private var isAlertShowing = false
    @State private var newCategort: String = ""
    @State private var budget: String = ""
    @State private var totalBudget: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack{
                Divider().background( LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                
                VStack {
                    List (categoryVM.categories) { category in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(category.categoryName)
                                Spacer()
                                
                                Button {
                                    categoryVM.deleteCategory(deleteCategory: category)
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                                
                            }
                            Text(String(category.budget))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        HStack {
                            TextField("New Category", text: $newCategort)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    handelSubmit()
                                }
                            TextField("Budget ", text: $budget)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    handelSubmit()
                                }
                        }
                        
                        if newCategort.count > 0 {
                            Button{
                                newCategort = ""
                            } label: {
                                Label("clear", systemImage: "xmark.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 6)
                            }
                        }
                        
                        Button{
                            handelSubmit()
                        }label: {
                            Label("Submit", systemImage: "paperplane.fill")
                                .labelStyle(.iconOnly)
                                .padding(6)
                        }
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .alert("Must Provide a category name and the Budget amount.", isPresented: $isAlertShowing) {
                            Button("Ok", role: .cancel){
                                isAlertShowing = false
                            }
                        }
                    }
                    .navigationTitle("Categories")
                    .padding(6)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            // Navigation link to the TransactionView
                            Button{
                                loginVM.signOut()
                            } label: {
                                Text("Sign out")
                                    .accentColor(.white)
                                    .fontWeight(.heavy)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.bottom, 5)
                }
                .onAppear {
                    // Call the getData() function when the view appears
                    categoryVM.getData()
                    totalBudget = categoryVM.calculateTotalBudget(for: categoryVM.categories)
                }
            }
        }
    }
    
    func handelSubmit() {
        if newCategort.count > 0 {
            if let budgetValue = Double(budget) {
                categoryVM.addCategory(categoryName: newCategort, buget: budgetValue)
                newCategort = ""
                budget = ""
            } else {
                // Handle the case where budget is not a valid Double
                // You can display an error message or show an alert
                print("Invalid budget value")
                isAlertShowing = true
                newCategort = ""
                budget = ""
            }
        } else {
            isAlertShowing = true
        }
    }
}


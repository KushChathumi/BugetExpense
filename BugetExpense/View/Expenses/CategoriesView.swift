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
                
                List (categoryVM.categories) { category in
                    HStack {
                        Text(category.categoryName)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        Text("LKR. \(String(format: "%.2f", category.budget))")
                            .foregroundColor(.secondary)
                        
                        Button(action : {
                            categoryVM.deleteCategory(deleteCategory: category)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                    } .padding(.vertical, 8)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .listStyle(PlainListStyle())
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    VStack {
                        HStack{
                            TextField("New Category", text: $newCategort)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    handelSubmit()
                                }
                            
                            Spacer()
                            
                            if newCategort.count > 0 {
                                Button{
                                    newCategort = ""
                                } label: {
                                    Label("clear", systemImage: "xmark.circle.fill")
                                        .labelStyle(.iconOnly)
                                        .padding(.trailing, 6)
                                }
                            }
                        }
                        
                        HStack{
                            TextField("Budget ", text: $budget)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    handelSubmit()
                                }
                            
                            Spacer()
                            
                            if budget.count > 0 {
                                Button{
                                    budget = ""
                                } label: {
                                    Label("clear", systemImage: "xmark.circle.fill")
                                        .labelStyle(.iconOnly)
                                        .padding(.trailing, 6)
                                }
                            }
                        }
                    }.shadow(radius: 6)
                    
                    Button{
                        handelSubmit()
                    } label: {
                        Label("Submit", systemImage: "paperplane.fill")
                            .labelStyle(.iconOnly)
                            .padding(15)
                    }
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .alert("Must Provide a category name and the Budget amount.", isPresented: $isAlertShowing) {
                        Button("Ok", role: .cancel){
                            isAlertShowing = false
                        }
                    }
                } .padding(.all, 10)
                   
                
                Spacer()
                
                Divider()
                    .padding(.vertical, 5)
            }
            .navigationTitle("Categories")
            .padding(.bottom, 5)
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
            }.onAppear {
                // Call the getData() function when the view appears
                categoryVM.getData()
                totalBudget = categoryVM.calculateTotalBudget(for: categoryVM.categories)
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


//
//  CategoriesView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var loginVM  :  LoginViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    @State private var isAlertShowing = false
    @State private var newCategort: String = ""

    var body: some View {
        
        VStack {
            List (categoryVM.categories) { category in
                HStack {
                    Text(category.categoryName)
                    
                    Spacer()
                    
                    Button {
                        categoryVM.deleteCategory(deleteCategory: category)
                    } label: {
                        Image(systemName: "minus.circle")
                            .tint(.red)
                    }

                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
               TextField("New Category", text: $newCategort)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        handelSubmit()
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
                .alert("Must Provide a category name", isPresented: $isAlertShowing) {
                    Button("Ok", role: .cancel){
                        isAlertShowing = false
                    }
                }
            }
            .navigationTitle("Categories")
            .padding(6)
            
            Divider()
            
            .padding(.bottom, 5)
        }
        .onAppear {
            // Call the getData() function when the view appears
            categoryVM.getData()
        }
    }
    
    func handelSubmit(){
        if newCategort.count > 0 {
            categoryVM.addCategory(categoryName: newCategort)
            newCategort = ""
        }
        else {
            isAlertShowing = true
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categoryVM: CategoryViewModel(userID: LoginViewModel().userSession?.uid ?? ""))
    }
}

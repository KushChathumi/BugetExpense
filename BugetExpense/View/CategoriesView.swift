//
//  CategoriesView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-15.
//

import SwiftUI

struct CategoriesView: View {
    
    @State private var isAlertShowing = false
    @State private var newCategort: String = ""
    @State private var categories: [Category] = [
        Category(id: 0, categoryName: "Groceries"),
        Category(id: 1, categoryName: "Bills"),
        Category(id: 2, categoryName: "Subscriptions")
    ]
    
    var body: some View {
        
        VStack {
            List{
                ForEach(categories) { category in
                    Text(category.categoryName)
                }
                .onDelete(perform: handelDelete)
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
//        .background(.white)
    }
    
    func handelSubmit(){
        if newCategort.count > 0 {
            categories.append(Category(
                id: categories.count,
                categoryName: newCategort
            ))
            newCategort = ""
        }
        else {
            isAlertShowing = true
        }
    }
    
    func handelDelete(at offsets: IndexSet){
        categories.remove(atOffsets: offsets)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}

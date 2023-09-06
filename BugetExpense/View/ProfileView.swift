//
//  ProfileView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-06.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List{
            Section{
                HStack {
                    Text(User.MOCK_USER.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(User.MOCK_USER.name)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                         
                    }
                }
            }
            Section("Account"){
                Button {
                    
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: "arrow.left.circle.fill")
                            .tint(.red)
                        Text("Sign out")
                            .fontWeight(.semibold)
                            .accentColor(.gray)
                    }
                }

            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//
//  SignUpView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-03.
//

import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var loginVM  :  LoginViewModel
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            VStack (spacing: 10){
                VStack(spacing: 2){
                    Text("Sign Up")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.purple)
                    Image("register")
                        .resizable()
                        .scaledToFit()
                    Text("Create your account")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                SignUpBottomControllers()
            }
        }
//        Error Message popuped
        .alert("Error", isPresented: $loginVM.hasError) {
        } message: {
            Text(loginVM.errorMessage)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

//MARK: AuthenticationFormProtocol
extension SignUpBottomControllers: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && !name.isEmpty
    }
}

struct SignUpBottomControllers: View  {
    
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var loginVM  :  LoginViewModel
    
    @FocusState var focus
    
    var  body: some View{
        VStack(spacing: 10){
            VStack{
                VStack(alignment: .leading, spacing: 5) {
                    Text("Name")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            TextField("Name", text: $name)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                    }.background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                    }
                }.padding(.horizontal,5)
                    
            }.padding(.horizontal, 10)
            
            VStack{
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            TextField("example@gmail.com", text: $email)
                                .padding(.leading, 10)
                                .focused($focus)
                    }.background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                    }
                }.padding(.horizontal,5)
            }.padding(.horizontal, 10)
            
            VStack (spacing: 10){
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            SecureField("should be minimum 6 characters", text: $password)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        } .background{
                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                        }
                }.padding(.horizontal,5)
            }.padding(.horizontal, 10)
            
             Text("")
                .foregroundColor(.white)
            
             //Sign Up button
            Button{
                Task{
                    try await loginVM.createUser(withEmail: email, password: password, name: name)
                }
            } label: {
                
                ZStack {
                    LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges : .top)
                        .clipShape(RoundedRectangle (cornerRadius: 10))
                        .frame(height: 50)
                    
                    
                    Text("Sign Up").bold()
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                }.padding(.horizontal , 20)
            }.disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            
            Text("")
                .foregroundColor(.white)

            //Sign In button
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Have you already an account? ")
                            .foregroundColor(.secondary)
                        Text("Login")
                            .underline()
                            .foregroundColor(.purple)
                            .fontWeight(.semibold)
                    }
                }

        }.padding()
    }
}
      

//
//  SignUpView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-03.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var loginVM  :   LoginViewModel =  LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            VStack (spacing: 10){
                VStack(spacing: 2){
                    Text("Sign Up").font(.system(size: 30))
                        .bold()
                        .foregroundColor(.purple)
                    Image("register").resizable().scaledToFit()
                    Text("Create your account")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                SignUpBottomControllers(loginVM: loginVM)
            }
            Spacer()
        }
        
        .fullScreenCover(isPresented: $loginVM.showSignInView){
            SignInView()
        }

    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct SignUpBottomControllers: View  {
    
    @ObservedObject var loginVM  :  LoginViewModel
    @FocusState var focus
    
    var  body: some View{
        VStack(spacing: 10){
            VStack{
                HStack {
//                    Image(systemName: "person.circle.fill")
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            TextField("Name", text: $loginVM.name)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                    }
                }.padding(.horizontal,15)
                    .background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                    }
            }.padding(.horizontal, 15)
            
            VStack{
                HStack {
//                    Image(systemName: "envelope.circle.fill")
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            TextField("Email", text: $loginVM.email)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                    }
                }.padding(.horizontal,15)
                    .background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                    }
            }.padding(.horizontal, 15)
            
            VStack (spacing: 10){
                HStack {
//                    Image(systemName: "lock.circle.fill")
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            SecureField("Password", text: $loginVM.password)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        }
                }.padding(.horizontal,15)
                    .background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                    }
                
            }.padding(.horizontal, 15)
            
            VStack (spacing: 10){
                HStack {
//                    Image(systemName: "lock.circle.fill")
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            SecureField("Confirm Password", text: $loginVM.confirmPassword)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        }
                }.padding(.horizontal,15)
                    .background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                    }
                
            }.padding(.horizontal, 15)
            
             Text("")
                .foregroundColor(.white)
            
                            
            Button{
//                loginVM.showSignInView = true
                Task{
                    try await loginVM.createUser(withEmail:loginVM.email, password: loginVM.password, name:loginVM.name)
                }
            } label: {
                
                ZStack {
                    LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges : .top)
                        .clipShape(RoundedRectangle (cornerRadius: 10))
                        .frame(height: 50)
                    
                    
                    Text("Sign Up").bold()
                        .foregroundColor(.white)
                }.padding(.horizontal , 20)
            }
            
            Text("")
                .foregroundColor(.white)

            
                Button {
                    loginVM.showSignInView = true
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
      

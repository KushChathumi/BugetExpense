//
//  SignInView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-02.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var loginVM  :   LoginViewModel =  LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            VStack (spacing: 10){
                VStack(spacing: 2){
                    Text("Welcome Back").font(.system(size: 30))
                        .bold()
                        .foregroundColor(.purple)
                    Image("login").resizable().scaledToFit()
                    Text("Login to your account")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                BottomControllers(loginVM: loginVM)
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $loginVM.showSignUpView){
            SignUpView()
        }
        
        .fullScreenCover(isPresented: $loginVM.showDashboardView){
            DashboardView()
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct BottomControllers: View  {
    
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
                            TextField("Email Address", text: $loginVM.email)
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
            
            Text("Forget Your Password")
                .underline()
                .foregroundColor(.blue)
            
            Text("")
                .foregroundColor(.white)
                            
            Button{
                //loginVM.showDashboardView = true
                Task{
                    try await loginVM.signIn(withEmail: loginVM.email, password: loginVM.password)
                }
            } label: {
                
                ZStack {
                    LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges : .top)
                        .clipShape(RoundedRectangle (cornerRadius: 10))
                        .frame(height: 50)
                    
                    
                    Text("Login").bold()
                        .foregroundColor(.white)
                }.padding(.horizontal , 20)
            }
            
            Text("")
                .foregroundColor(.white)

                Button {
                    loginVM.showSignUpView = true
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have account? ")
                            .foregroundColor(.secondary)
                        Text("Sign Up")
                            .underline()
                            .foregroundColor(.purple)
                            .fontWeight(.semibold)
                    }
                }
        }.padding()
    }
}
      

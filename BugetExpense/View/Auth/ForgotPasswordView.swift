//
//  ForgotPasswordView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-09.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var loginVM  :  LoginViewModel
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white.ignoresSafeArea(.all)
                VStack (spacing: 5){
                    VStack(spacing: 2){
                        Text("Welcome Back").font(.system(size: 30))
                            .bold()
                            .foregroundColor(.purple)
                            .padding(.vertical, 50)
                            
                        Image("forgotPW")
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical,5)
                            .frame(width: 300)
                        Text("")
                            .font(.system(size: 50, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    
                    ForgotPasswordControllers()
                }
            }
        }
//        Error Message popuped
        .alert("Success", isPresented: $loginVM.hasSuccess) {
        } message: {
            Text(loginVM.successMessage)
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

//MARK: AuthenticationFormProtocol
extension ForgotPasswordControllers: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
    }
}

//MARK: Forgot form creation
struct ForgotPasswordControllers: View  {
    
    @State private var email = ""
    @EnvironmentObject var loginVM  :  LoginViewModel
    @FocusState var focus
    
    var  body: some View{
        VStack(alignment: .leading, spacing: 10){
            Text("Enter your email address to receive an email to reset your password")
                .font(.system(size: 18, design: .rounded))
                .foregroundColor(Color(.systemGray))
                .padding(.leading)
            Text("")
            
            VStack{
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .autocapitalization(.none)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("grey"))
                        .frame(height: 50)
                        .overlay{
                            TextField("example@gmail.com", text: $email)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                    }
                        .background{
                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                        }
                }.padding(.horizontal,0)
                    
            }.padding(.horizontal, 15)


            // Sign In button
            Button{
                loginVM.sendPasswordReset(withEmail: email)
            } label: {
                
                ZStack {
                    LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges : .top)
                        .clipShape(RoundedRectangle (cornerRadius: 10))
                        .frame(height: 50)
                    
                    
                    Text("Send")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }.padding(.horizontal , 20)
            }.disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
        }.padding()
        
        Spacer()
        
        NavigationLink{
            SignInView()
                .navigationBarBackButtonHidden(true)
        } label: {
            HStack(spacing: 3) {
                Text("Have you already an account? ")
                    .foregroundColor(.secondary)
                Text("Login")
                    .underline()
                    .foregroundColor(.purple)
                    .fontWeight(.semibold)
            }.padding(.leading)
                .padding(.top, 50)
        }
    }
}
      

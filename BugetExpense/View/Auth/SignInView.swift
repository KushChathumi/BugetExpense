//
//  SignInView.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-02.
//

import SwiftUI

struct SignInView: View {

    @EnvironmentObject var loginVM  :  LoginViewModel
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.white.ignoresSafeArea(.all)
                VStack (spacing: 10){
                    VStack(spacing: 2){
                        Text("Welcome Back").font(.system(size: 30))
                            .bold()
                            .foregroundColor(.purple)
                            
                        Image("login")
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical,5)
                        Text("Login to your account")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    
                    BottomControllers()
                }
                Spacer()
            }
        }
//        Error Message popuped
        .alert("Error", isPresented: $loginVM.hasError) {
        } message: {
            Text(loginVM.errorMessage)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

//MARK: AuthenticationFormProtocol
extension BottomControllers: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

//MARK: Login form creation
struct BottomControllers: View  {
    
    @State private var email = ""
    @State private var password = ""

    @EnvironmentObject var loginVM  :  LoginViewModel
    @FocusState var focus
    
    var  body: some View{
        VStack(alignment: .leading, spacing: 15){
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
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                    }
                        .background{
                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                        }
                }.padding(.horizontal,0)
                    
            }.padding(.horizontal, 15)
            
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
                            SecureField("Password", text: $password)
                                .padding(.leading, 10)
                                .focused($focus)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                        }.background{
                            RoundedRectangle(cornerRadius: 10).foregroundColor(Color("grey"))
                        }
                }.padding(.horizontal,5)
                    
                
            }.padding(.horizontal, 10)
            
            //Forgot password
            NavigationLink{
                ForgotPasswordView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Forget Your Password")
                        .foregroundColor(.blue)
                }.padding(.leading, 20)
            }

            Text("")
                .foregroundColor(.white)

            // Sign In button
            Button{
                Task{
                    try await loginVM.signIn(withEmail: email, password: password)
                }
            } label: {
                
                ZStack {
                    LinearGradient(colors: [Color("Purple3"),Color("Purple5")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges : .top)
                        .clipShape(RoundedRectangle (cornerRadius: 10))
                        .frame(height: 50)
                    
                    
                    Text("Login")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }.padding(.horizontal , 20)
            }.disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            
            Text("")
                .foregroundColor(.white)

            // Sign up Button
            NavigationLink{
                SignUpView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Don't have account? ")
                        .foregroundColor(.secondary)
                    Text("Sign Up")
                        .underline()
                        .foregroundColor(.purple)
                        .fontWeight(.semibold)
                }.padding(.leading, 60)
            }
            
        }.padding()
    }
}
      

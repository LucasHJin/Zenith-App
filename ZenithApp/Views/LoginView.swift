//
//  LoginView.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-27.
//
import SwiftUI


struct LoginView: View {
    @StateObject var LoginVM = LoginViewViewModel()
    
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
 
    var body: some View {
        NavigationView {
            ZStack {
                Image("BackgroundLogin")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    VStack{
                        Text("Zenith")
                            .font(.system(size: 50))
                            .bold()
                            .foregroundColor(Color("Colour5"))
                            .shadow(color: .white, radius: 10)
                        Image("DbImage")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .offset(y: -50)
                    }
                    .offset(y: -60)

                    VStack{
                        if !LoginVM.errorMessage.isEmpty {
                            Text(LoginVM.errorMessage)
                                .foregroundColor(Color.red)
                        }
                        TextField("Email Address", text: $LoginVM.email)
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(10)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black, radius: 10)
                            .border(.red, width: CGFloat(wrongUsername))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Password", text: $LoginVM.password)
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 10)
                            .border(.red, width: CGFloat(wrongPassword))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        Button {
                            LoginVM.login()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 300, height: 50)
                                    .foregroundColor(Color("Colour2"))
                                    .cornerRadius(10)
                                    .shadow(color: .black, radius: 5)
                                Text("Login")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        VStack {
                            Text("Want to get started?")
                                .foregroundColor(.white)
                                .bold()
                            NavigationLink("Create an Account", destination: CreateAccountView())
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color("Colour3"))
                                .cornerRadius(10)
                                .shadow(color: .black, radius: 5)
                        }
                        .offset(y: 55)
                    }
                    
                    .offset(y: -100)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

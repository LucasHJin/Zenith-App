//
//  CreateAccountView.swift
//  Zenith
//
//  Created by Lucas Jin on 2024-01-27.
//

import SwiftUI

struct CreateAccountView: View {
    @State var CreateAccountVM = CreateAccountViewViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundCreateAccount")
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
                        TextField("Name", text: $CreateAccountVM.name)
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        TextField("Email Address", text: $CreateAccountVM.email)
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Password", text: $CreateAccountVM.password)
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        Button {
                            CreateAccountVM.register()
                        } label: {
                            ZStack{
                                Rectangle()
                                    .frame(width: 300, height: 50)
                                    .foregroundColor(Color("Colour4"))
                                    .cornerRadius(10)
                                    .shadow(color: .black, radius: 5)
                                Text("Create Account")
                                    .foregroundColor(.white)
                            }
                        }
                        
                    }
                    
                    .offset(y: -110)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CreateAccountView()
}

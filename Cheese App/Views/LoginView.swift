//
//  LoginView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import AuthenticationServices


struct LoginView: View {
    let auth = Auth()
    var body: some View {
        NavigationView {
            
            
            ZStack {
                // Background color
                CustomColors.background
                    .edgesIgnoringSafeArea(.all) // Extend the color to the edges of the screen
                // Foreground content
                VStack {
                    Text("Sign In")
                        .font(.custom("IowanOldStyle-Roman", size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(CustomColors.textColor)
                        .multilineTextAlignment(.center)
                    SignInWithAppleButton(
                        onRequest: auth.startSignInWithAppleFlow,
                        onCompletion: auth.handleSignInWithAppleCompletion
                    )
                    .frame(width: 200, height: 50)
                    
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundColor(.black)
                            Text("Sign in with Google")
                                .foregroundColor(.black)
                        }
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                    }
                    NavigationLink(destination: AppView()) {
                        Text("Skip Login")
                            .font(.custom("IowanOldStyle-Roman", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(CustomColors.textColor)
                            .multilineTextAlignment(.center)
                    }
               
                }
                .padding()
            }
        }
    }



}




#Preview {
    LoginView()
}

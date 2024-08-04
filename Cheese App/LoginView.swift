//
//  LoginView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
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
                                 onRequest: handleSignInWithApple,
                                 onCompletion: handleSignInWithAppleCompletion
                             )
                             .frame(width: 200, height: 50)

            }
            .padding()
        }
    }

    func handleSignInWithApple() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.performRequests()
        }

        func handleSignInWithAppleCompletion(credential: ASAuthorizationAppleIDCredential) {
            // You can retrieve the user's Apple ID information here
            let userIdentifier = credential.user
            let fullName = credential.fullName
            let email = credential.email

        }
}




#Preview {
    LoginView()
}

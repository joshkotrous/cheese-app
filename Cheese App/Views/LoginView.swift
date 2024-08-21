//
//  LoginView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit


struct LoginView: View {
    @State private var currentNonce: String?

    var body: some View {
        NavigationStack {
            
            
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
                        
                    SignInWithAppleButton(
                        onRequest: { request in
                            currentNonce = handleOnRequest(request: request)
                        },
                        onCompletion: { result in
                            handleOnCompletion(result: result, currentNonce: currentNonce)
                        }
                    )
                    .frame(width: 280, height: 45)
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

func handleOnRequest(request: ASAuthorizationAppleIDRequest) -> String {
    print("handling request")
    let nonce = Auth().randomNonceString()
    request.requestedScopes = [.fullName, .email]
    request.nonce = Auth().sha256(nonce)
    return nonce
}

func handleOnCompletion(result: Result<ASAuthorization, Error>, currentNonce: String?) {
    print("Handling completion")
    switch result {
    case .success(let authorization):
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            signInWithSupabase(idToken: idTokenString, nonce: nonce)
        }
    case .failure(let error):
        print("Authorization failed: \(error.localizedDescription)")
    }
}


func signInWithSupabase(idToken: String, nonce: String) {
    Task {
        do {
            let result = try await Database().supabase.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
            print(result.accessToken)
        } catch {
            print(error)
        }
    }
}




#Preview {
    LoginView()
}

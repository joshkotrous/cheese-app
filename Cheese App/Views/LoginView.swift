//
//  LoginView.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Supabase
import os
import GoogleSignIn
import GoogleSignInSwift

// Google Sign-In Manager to handle sign-in operations
class GoogleSignInManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorText: String? = nil
    
    func signIn(withPresenting presentingViewController: UIViewController) {
        Task {
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
                guard let idToken = result.user.idToken?.tokenString else {
                    self.errorText = "No idToken found."
                    return
                }

                let accessToken = result.user.accessToken.tokenString

                // Call your backend or database manager to handle sign-in
                try await Database().googleSignIn(idToken: idToken, accessToken: accessToken)

                // Update the state
                DispatchQueue.main.async {
                    self.isSignedIn = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorText = "Google Sign-In failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct LoginView: View {
    @State private var currentNonce: String?
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
    @AppStorage("profileId") var profileId: String?
    @State var showAlert: Bool = false
    @State var errorText: String = ""
    @State var isSignedIn = false
    @StateObject private var googleSignInManager = GoogleSignInManager()
    
    init() {
        if let token = accessToken, !token.isEmpty {
            print("is signed in")
            isSignedIn = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomColors.background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Sign In")
                        .font(.custom(AppConfig.fontName, size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(CustomColors.textColor)
                        .multilineTextAlignment(.center)
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            currentNonce = handleOnRequest(request: request)
                        },
                        onCompletion: { result in
                            handleOnCompletion(result: result, currentNonce: currentNonce)
                        }
                    )
                    .frame(width: 280, height: 45)
                    
                    Button(action: {
                        // Implement sign in with Google
                        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                            googleSignInManager.signIn(withPresenting: rootViewController)
                        }
                    }) {
                        HStack{
                            Image("Google").imageScale(.small)
                            Text("Sign in with Google")
                                .font(.custom("Helvetica-Neue", size: 18))
                                .foregroundColor(.black)
                        }
                        
                    }
                    .frame(width: 280, height: 45)
                    .background(.white)
                    .cornerRadius(8)
                    
                    NavigationLink(destination: AppView(), isActive: $googleSignInManager.isSignedIn) {
                        EmptyView()
                    }
                    
//                    NavigationLink(destination: AppView()) {
//                        Text("Skip Login")
//                            .font(.custom(AppConfig.fontName, size: 16))
//                            .fontWeight(.bold)
//                            .foregroundColor(CustomColors.textColor)
//                            .multilineTextAlignment(.center)
//                    }
//                    .padding()
                }
                .padding()
            }
        }
        .tint(Color(CustomColors.tan2))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(googleSignInManager.errorText ?? "Unknown error"),
                dismissButton: .cancel() {
                    showAlert = false
                }
            )
        }
        .onReceive(googleSignInManager.$errorText) { errorText in
            if let errorText = errorText {
                self.errorText = errorText
                showAlert = true
            }
        }
    }
    
    // Existing Apple sign-in helper functions
    func handleOnRequest(request: ASAuthorizationAppleIDRequest) -> String {
        print("handling request")
        let nonce = Auth().randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = Auth().sha256(nonce)
        return nonce
    }
    
    func handleOnCompletion(result: Result<ASAuthorization, Error>, currentNonce: String?) {
        let logger = Logger(subsystem: "LoginView.handleOnCompletion", category: "network")
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    errorText = "Invalid state: A login callback was received, but no login request was sent."
                    showAlert = true
                    logger.error("\(errorText, privacy: .public)")
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    errorText = "Unable to fetch identity token"
                    showAlert = true
                    logger.error("\(errorText, privacy: .public)")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    errorText = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                    showAlert = true
                    logger.error("\(errorText)")
                    return
                }
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName
                print(email ?? "email missing")
                print(fullName?.givenName ?? "given name missing", fullName?.familyName ?? "family name missing")
                Task {
                    do {
                        try await Database().signInWithSupabase(idToken: idTokenString, nonce: nonce)
                    } catch {
                        errorText = "Authorization failed at supabase sign in: \(error.localizedDescription)"
                        showAlert = true
                        logger.error("\(errorText, privacy: .public)")
                    }
                }
            }
        case .failure(let error):
            errorText = "Authorization failed: \(error.localizedDescription)"
            showAlert = true
            logger.error("\(errorText, privacy: .public)")
        }
    }
}

#Preview {
    LoginView()
}

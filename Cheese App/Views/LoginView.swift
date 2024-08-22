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


struct LoginView: View {
    @State private var currentNonce: String?
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("userId") var userId: String?
    @AppStorage("profileId") var profileId: String?
    
    @State var isSignedIn = false
    init(){
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
                        .font(.custom("IowanOldStyle-Roman", size: 48))
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
                    .padding()
                    
                    NavigationLink(destination: AppView(), isActive: $isSignedIn) {
                        EmptyView()
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
        .tint(Color(CustomColors.tan2))

    }
    
    func signInWithSupabase(idToken: String, nonce: String) {
        
        Task {
            do {
                let session = try await Database().supabase.auth.signInWithIdToken(
                    credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
                accessToken = session.accessToken
                //                if (session.user.email != email) {
                //                    var userAttributes = UserAttributes()
                //                    userAttributes.email = email
                //                    do {
                //                        try await Database().supabase.auth.update(user: userAttributes)
                //
                //                    } catch {
                //                        print(error)
                //                    }
                //
                //                }
                userId = session.user.id.uuidString
                if(userId != nil){
                    var profile = await Database().getUserProfile(userId: userId!)
                    if(profile == nil){
                        profile = await Database().createUserProfile(userId: userId!)
                    }
                    profileId = profile?.id
                }
                isSignedIn = true
            } catch {
                print(error)
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
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName
                print(email ?? "email missing")
                print(fullName!.givenName ??  "given name missing", fullName!.familyName ?? "family name missing")
                signInWithSupabase(idToken: idTokenString, nonce: nonce)
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
    
    
    
}





#Preview {
    LoginView()
}

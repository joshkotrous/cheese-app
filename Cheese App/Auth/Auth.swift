//
//  Auth.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/18/24.
//

import Foundation
import Supabase
import CryptoKit
import AuthenticationServices

struct AuthResult {
    let idToken: String
    let nonce: String
}

class Auth {
    private var currentNonce: String?
    private var completionHandler: ((Result<AuthResult, Error>) -> Void)?
    private var nonce: String?
    let client = Database().supabase
    
    init(){
        nonce = randomNonceString()
    }
    func startSignInWithAppleFlow() {
        guard let topVC = UIApplication.getTopViewController() else {
            return
        }
        
        
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce!)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.presentationContextProvider = topVC
      authorizationController.performRequests()

    }
    
    
    
    func signInWithApple(idToken: String, nonce: String) async throws {
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
    }
    
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }



    
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    
    
    func handleSignInWithAppleCompletion(credential: ASAuthorizationAppleIDCredential) {

        
    }

        
}

//extension Auth: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return ASPresentationAnchor(frame: .zero)
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            guard let nonce = currentNonce, let completion = completionHandler else {
//                fatalError("Invalid state: A login callback was received, but no login request was sent.")
//            }
//            guard let appleIDToken = appleIDCredential.identityToken else {
//                print("Unable to fetch identity token")
//                return
//            }
//            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                return
//            }
//            let authResult = AuthResult(idToken: idTokenString, nonce: nonce)
//        }
//        
//        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//            // Handle error.
//            print("Sign in with Apple errored: \(error)")
//        }
//        
//    }
//    
//    
//}


extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? =  UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }

}
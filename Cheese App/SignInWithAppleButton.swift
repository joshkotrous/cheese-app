import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
    var onRequest: () -> Void
    var onCompletion: (ASAuthorizationAppleIDCredential) -> Void

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(context.coordinator, action: #selector(context.coordinator.didTapButton), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onRequest: onRequest, onCompletion: onCompletion)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        var onRequest: () -> Void
        var onCompletion: (ASAuthorizationAppleIDCredential) -> Void

        init(onRequest: @escaping () -> Void, onCompletion: @escaping (ASAuthorizationAppleIDCredential) -> Void) {
            self.onRequest = onRequest
            self.onCompletion = onCompletion
        }

        @objc func didTapButton() {
            onRequest()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                onCompletion(credential)
            }
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Handle error
            print("Sign in with Apple errored: \(error)")
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return UIApplication.shared.windows.first { $0.isKeyWindow }!
        }
    }
}

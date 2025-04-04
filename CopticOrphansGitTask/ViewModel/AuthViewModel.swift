//
//  AuthViewModel.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 03/04/2025.
//

import FirebaseAuth
import FirebaseCore
import Alamofire
import GoogleSignIn
import FBSDKLoginKit
import Firebase

class AuthViewModel {
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, self.getAuthErrorMessage(error))
            } else {
                completion(true, nil)
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, self.getAuthErrorMessage(error))
            } else {
                completion(true, nil)
            }
        }
    }
    
    func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard let user = result?.user, error == nil else {
                completion(false, error?.localizedDescription ?? "Google Sign-In failed")
                return
            }
            guard let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                completion(true, nil)
            }
        }
    }
    
    func loginWithFacebook(from viewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: viewController) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            guard let tokenString = AccessToken.current?.tokenString else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                completion(true, nil)
            }
        }
    }
    
    private func getAuthErrorMessage(_ error: Error) -> String {
        let err = error as NSError
        switch err.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password. Please try again."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email address."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email is already in use."
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Please check your connection."
        default:
            return "Authentication failed. Try again."
        }
    }
}

//
//  AuthVC.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 03/04/2025.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthVC: UIViewController {
    
    private let viewModel = AuthViewModel()
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let registerButton = UIButton()
    private let googleLoginButton = UIButton()
    private let facebookLoginButton = UIButton()
    private let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .green
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        googleLoginButton.setTitle("Login with Google", for: .normal)
        googleLoginButton.backgroundColor = .red
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        
        facebookLoginButton.setTitle("Login with Facebook", for: .normal)
        facebookLoginButton.backgroundColor = .blue
        facebookLoginButton.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButton, googleLoginButton, facebookLoginButton, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showError("Please enter email and password")
            return
        }
        
        viewModel.login(email: email, password: password) { success, error in
            if success {
                self.navigateToHome()
            } else {
                self.showError(error ?? "")
                return
            }
        }
    }
    
    @objc private func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showError("Please enter email and password")
            return
        }
        
        viewModel.register(email: email, password: password) { success, error in
            if success {
                self.navigateToHome()
            } else {
                self.showError(error ?? "")
                return
            }
        }
    }
    
    @objc private func handleGoogleLogin() {
        
        viewModel.loginWithGoogle(presenting: self) { success, error in
            if success {
                self.navigateToHome()
            } else {
                self.showError(error ?? "Google Sign-In failed")
                return
            }
        }
    }
    
    @objc private func handleFacebookLogin() {
        
        viewModel.loginWithFacebook(from: self) { success, error in
            if success {
                self.navigateToHome()
                return
            } else {
                self.showError(error ?? "Facebook Sign-In failed")
            }
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func navigateToHome() {
        let homeVC = GitHubVC()
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

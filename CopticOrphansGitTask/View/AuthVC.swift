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
    
    // UI Elements
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let emailTextField = CustomTextField(placeholder: "Email", icon: "envelope.fill")
    private let passwordTextField = CustomTextField(placeholder: "Password", icon: "lock.fill", isSecure: true)
    private let loginButton = CustomButton(title: "Login", backgroundColor: UIColor.systemBlue)
    private let registerButton = CustomButton(title: "Register", backgroundColor: UIColor.systemGreen)
    private let googleLoginButton = SocialButton(title: " Sign in with Google", iconName: "g.circle.fill", backgroundColor: UIColor.systemRed)
    private let facebookLoginButton = SocialButton(title: " Sign in with Facebook", iconName: "f.circle.fill", backgroundColor: UIColor.systemBlue)
    private let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure container
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Logo
        logoImageView.image = UIImage(named: "app_logo") // Replace with your actual logo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Error Label
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        // StackView for form elements
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButton, googleLoginButton, facebookLoginButton, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Button Actions
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        facebookLoginButton.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
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

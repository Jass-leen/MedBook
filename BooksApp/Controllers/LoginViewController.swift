//
//  LoginViewController.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    private func navigateToHome() {
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        viewModel.login(email: email, password: password) {[weak self] result in
            switch result{
            case .success(let isSuccess):
                print("Signup success: \(isSuccess)")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                print("islogged in",isLoggedIn)
                
                self?.navigateToHome()
            case .failure(let error):
                print("Signup failed with error: \(error)")
                // Handle error
                
            }
        }
    }
    
}

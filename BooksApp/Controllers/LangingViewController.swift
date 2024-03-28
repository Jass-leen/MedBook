//
//  LangingViewController.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import UIKit

class LangingViewController: UIViewController {
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.1, green: 0.5, blue: 0.9, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        // Stack View
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        // Signup Button
        signupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Login Button
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add buttons to stack view
        stackView.addArrangedSubview(signupButton)
        stackView.addArrangedSubview(loginButton)
        
        // Add stack view to main view
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        return button
    }
    
    @objc private func signupButtonTapped() {
        // Navigate to SignupViewController
        let signupVC = SignupViewController()
        
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        // Navigate to LoginViewController
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

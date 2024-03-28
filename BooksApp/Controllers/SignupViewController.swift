//
//  SignupViewController.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import UIKit

class SignupViewController: UIViewController {
    

    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    let errorLabel = UILabel()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let countryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = SignupViewModel()
    private var countries: [String] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupPicker()
        fetchCountries()
    }
    
    private func setupViews() {
        // Stack view for text fields and picker
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        // Email text field
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(emailTextField)
        
        // Password text field
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(passwordTextField)
        
        // Error label
        
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        stackView.addArrangedSubview(errorLabel)
        
        // Picker view
        countryPicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.addArrangedSubview(countryPicker)
        
        // Signup button
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Main stack view
        let mainStackView = UIStackView(arrangedSubviews: [stackView, signupButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    
    private func setupPicker() {
        countryPicker.delegate = self
        countryPicker.dataSource = self
    }
    
    private func fetchCountries() {
        viewModel.fetchCountries { countries in
            if let countries = countries {
                self.countries = countries
                DispatchQueue.main.async {
                    self.countryPicker.reloadAllComponents()
                }        } else {
                    print("Failed to fetch countries")
                    // Handle error condition
                }
        }
    }
    
    private func validateFields() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            displayError("Email cannot be empty.")
            return false
        }
        
        guard isValidEmail(email) else {
            displayError("Invalid email format.")
            return false
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayError("Password cannot be empty.")
            return false
        }
        
        let (isValidPassword,msg) = isValidPassword(password)
        if !isValidPassword{
            displayError(msg)
            return false
        }
        
        return true
    }
    
    private func displayError(_ message: String) {
        errorLabel.text = message
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for basic email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: emailRegex, options: []) else {
            return false
        }
        
        // Get the range of the email string
        let range = NSRange(location: 0, length: email.utf16.count)
        
        // Use the regular expression object to match the email string
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    
    private func isValidPassword(_ password: String) -> (Bool,String) {
        // Check if password length is at least 8 characters
        guard password.count >= 8 else {
            return (false,"password length shoould be atleast 8 characters")
        }
        
        // Check if password contains at least one uppercase letter
        guard password.rangeOfCharacter(from: .uppercaseLetters) != nil else {
            return (false,"passwoord should have atleast one uppercase letter")
        }
        
        // Check if password contains at least one lowercase letter
        guard password.rangeOfCharacter(from: .lowercaseLetters) != nil else {
            return (false,"passwoord should have atleast one lowercase letter")
        }
        
        // Check if password contains at least one digit
        guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
            return (false,"passwoord should have atleast one digit")
        }
        
        // Check if password contains at least one special character
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?")
        guard password.rangeOfCharacter(from: specialCharacterSet) != nil else {
            return (false,"passwoord should have atleast one special character")
        }
        
        return (true,"")
    }
    
    
    
    @objc private func signupButtonTapped() {
        if validateFields() {
            // Proceed with signup
            let countryIndex = countryPicker.selectedRow(inComponent: 0)
            let selectedCountry = countries[countryIndex]
            viewModel.signup(email: emailTextField.text!, password: passwordTextField.text!, country: selectedCountry){[weak self] result in
                switch result {
                case .success(let isSuccess):
                    print("Signup success: \(isSuccess)")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Signup failed with error: \(error)")
                    // Handle error
                }
                
            }
            
        }
    }
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
}

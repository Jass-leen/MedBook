//
//  HomeViewController.swift
//  BooksApp
//
//  Created by Jasleen on 27/03/24.
//

import UIKit

class HomeViewController: UIViewController {
    var currentPage = 0 // Initial page number
    var isLoadingData = false
    
    let sortingOptions = ["Title", "Average", "Views"]
    var selectedSortingOption = "Title" // Default sorting option
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to MedBook"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    private let searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white // Set background color
        textField.textColor = .black // Set text color
        textField.font = UIFont.systemFont(ofSize: 16) // Set font
        textField.translatesAutoresizingMaskIntoConstraints = false // Enable auto layout
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModel = HomeViewModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupUI()
    }
    
  
    private func setupUI() {
        view.backgroundColor = .white
        
        
        view.addSubview(headingLabel)
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        // Add bookmark button
        view.addSubview(bookmarkButton)
        NSLayoutConstraint.activate([
            bookmarkButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            bookmarkButton.leadingAnchor.constraint(equalTo: headingLabel.trailingAnchor, constant: 10),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Add logout button
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: 10),
            
        ])
        
        
        // Add search bar
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])
        // Set up segmented control
        for (index, option) in sortingOptions.enumerated() {
            segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0 // Select the default sorting option
        
        // Add segmented control to the view
        view.addSubview(segmentedControl)
        
        // Add constraints
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Add table view
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Configure table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Get the selected sorting option
        let selectedIndex = sender.selectedSegmentIndex
        selectedSortingOption = sortingOptions[selectedIndex]
        
        // Sort the table view based on the selected option
        sortTableView()
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] (_) in
            self?.clearUserLoginStatus()
            self?.navigateToLogin()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    @objc private func bookmarkButtonTapped() {
        // Handle logout action here
        // For example, clear user's login status and navigate to the login screen
        present(BookmarkViewController(), animated: true)
    }
    
    func sortTableView() {
        switch selectedSortingOption {
        case "Title":
            viewModel.searchResults.sort { $0.title ?? "" < $1.title ?? "" }
        case "Average Rating":
            viewModel.searchResults.sort  {(left, right) -> Bool in
                let epsilon = 0.000001
                let absDiff = abs((left.averageRating ?? 0) - (right.averageRating ?? 0))
                if absDiff < epsilon {
                    return (left.averageRating ?? 0) < (right.averageRating ?? 0)
                } else {
                    return (left.averageRating ?? 0) - (right.averageRating ?? 0) < 0
                }
            }
        case "Views":
            viewModel.searchResults.sort { $0.ratingsCount ?? 0 > $1.ratingsCount ?? 0 }
        default:
            break
        }
        
        tableView.reloadData()
    }
    private func clearUserLoginStatus() {
        // Clear user's login status from UserDefaults or Keychain
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    func loadMoreData() {
        // Prevent multiple API requests
        guard let searchText = searchBar.text, !searchText.isEmpty, searchText.count>3 else {
            return
        }
        isLoadingData = true
        
        // Increment current page
        currentPage += 1
        
        // Call API to fetch next page of data using the updated page or offset value
        viewModel.searchBooks(query: searchText, offset: currentPage,isLoading: true) { result in
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    // Reload table view with search results
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error searching books: \(error.localizedDescription)")
            }
        }
        
    }
    
  
    private func navigateToLogin() {
        // Navigate back to the login screen
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? SceneDelegate else {
            // Unable to get the scene delegate
            return
        }
        
        // Instantiate the landing view controller
        let landingVC = LangingViewController()
        let navigationController = UINavigationController(rootViewController: landingVC)
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
        
    }
    fileprivate func swipeUploadedFlagAction(book: Book) {
        
        viewModel.saveBooks(book: book){ result in
            switch result {
            case .success(let success):
                print("successfully bookmarked")
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
        let book = viewModel.searchResults[indexPath.row]
        
        
        HomeViewModel.fetchBookCoverImage(coverID: book.coverID ){ image in
            DispatchQueue.main.async {
                if let image = image {
                    cell.bookCoverImageView.image = image
                } else {
                    cell.bookCoverImageView.image = UIImage(named: "placeholder_image")
                }
            }
        }
        cell.configure(with: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last cell is being displayed
        if indexPath.row == viewModel.searchResults.count - 1 && !isLoadingData {
            loadMoreData()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var book = viewModel.searchResults[(indexPath as NSIndexPath).row] as Book
        
        let uploadedAction = UIContextualAction(style: .normal, title: "BookMark", handler: {[weak self]
            (action, sourceView, completionHandler) in
            self?.viewModel.searchResults[(indexPath as NSIndexPath).row].isBookMarked = true
            self?.swipeUploadedFlagAction(book: book)
            completionHandler(true)
        }
                                                
        )
        
        uploadedAction.backgroundColor = .green
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        return swipeConfiguration
        
    }
}


extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return true
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Call API to search for books
        currentPage = 0
        isLoadingData = false
        viewModel.searchBooks(query: updatedText, offset: 0) {[weak self] result in
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    // Reload table view with search results
                    self?.sortTableView()
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error searching books: \(error.localizedDescription)")
            }
        }
        return true
    }
    
    
}




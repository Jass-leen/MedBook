//
//  BookmarkViewController.swift
//  BooksApp
//
//  Created by Jasleen on 29/03/24.
//

import UIKit

class BookmarkViewController: UIViewController {
    let headingLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Bookmarks"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        var bookmarkedBooks: [Book] = []
    var viewModel = BookmarkViewModel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            loadBookmarkedBooks()
        }
        
        private func setupUI() {
            view.backgroundColor = .white
            view.addSubview(headingLabel)
            view.addSubview(tableView)
            
            // Layout constraints for heading label
            NSLayoutConstraint.activate([
                headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            
            // Layout constraints for table view
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            // Set delegates
            tableView.delegate = self
            tableView.dataSource = self
            
            // Register cell
            tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookCell")
        }
        
        private func loadBookmarkedBooks() {
            bookmarkedBooks = viewModel.getAllBookmarks()
            tableView.reloadData()
            
        }
    fileprivate func swipeUploadedFlagAction(book: Book) {
      
            viewModel.deleteBook(book:book){[weak self] result in
                switch result {
                case .success(let books):
                    self?.bookmarkedBooks = books
                    print("successfully bookmarked")
                    self?.tableView.reloadData()
                case .failure(let failure):
                    print(failure)
                }
            }
      
      }
    }

    extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bookmarkedBooks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
            let book = bookmarkedBooks[indexPath.row]
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
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            var book = bookmarkedBooks[(indexPath as NSIndexPath).row] as Book
            let deleteAction = UIContextualAction(style: .destructive, title: "Unbookmark") { [weak self] (_, _, completionHandler) in

                      self?.swipeUploadedFlagAction(book: book)

                  completionHandler(true)
              }
              
              return UISwipeActionsConfiguration(actions: [deleteAction])

               
           }
        
       
    }

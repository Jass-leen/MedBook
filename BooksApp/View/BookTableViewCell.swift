//
//  BookTableViewCell.swift
//  BooksApp
//
//  Created by Jasleen on 28/03/24.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    static let identifier = "BookTableViewCell"
     let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.addSubview(bookCoverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(viewsLabel)
        
        NSLayoutConstraint.activate([
            // Book cover image view constraints
            bookCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookCoverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookCoverImageView.widthAnchor.constraint(equalToConstant: 60),
            bookCoverImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Author label constraints
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Rating label constraints
            ratingLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Views label constraints
            viewsLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            viewsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = "Author: " + (book.author?[0] ?? "") 
        ratingLabel.text = "⭐️" + String(book.averageRating ?? 0)
        viewsLabel.text = "👁" + String(book.ratingsCount ?? 0)
    }
}


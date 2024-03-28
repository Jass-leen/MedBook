//
//  BookModel.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import Foundation
import Foundation

struct Book: Codable {
    let title: String?
    let author: [String]?
    let averageRating: Double?
    let ratingsCount: Int?
    let coverID: Int?
    var isBookMarked = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case author = "author_name"
        case averageRating = "ratings_average"
        case ratingsCount = "ratings_count"
        case coverID = "cover_i"
    }
    init(title: String?, author: [String]?, averageRating: Double?, ratingsCount: Int?, coverID: Int?, isBookMarked: Bool = false) {
        self.title = title
        self.author = author
        self.averageRating = averageRating
        self.ratingsCount = ratingsCount
        self.coverID = coverID
        self.isBookMarked = isBookMarked
    }
    
}
struct Books: Codable {
    let docs: [Book]
    
    enum CodingKeys: String, CodingKey {
        case docs
    }
}

//
//  HomeViewModel.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import Foundation
import UIKit
class HomeViewModel {
    var searchResults: [Book] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // MARK: Functions
    
    func searchBooks(query: String,offset:Int,isLoading:Bool = false, completion: @escaping (Result<[Book], Error>) -> Void) {
        
        guard query.count >= 3 else {
            // Return empty array if query length is less than 3 characters
            completion(.failure(NSError(domain: "HomeViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "too short"]) as! Error))
            return
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "openlibrary.org"
        components.path = "/search.json"
        
        components.queryItems = [
            URLQueryItem(name: "title", value: query),
            URLQueryItem(name: "offset", value: String(offset*10)),
            URLQueryItem(name: "limit", value: String(10))
        ]
        
        
        guard let url = URL(string: components.string ?? "") else {
            let error = NSError(domain: "HomeViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        // Perform API request
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    let error = NSError(domain: "HomeViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Books.self, from: data)
                let books = response.docs
                if isLoading{
                    self.searchResults.append(contentsOf: books)
                }else{
                    self.searchResults = books
                }
                completion(.success(books))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    static func fetchBookCoverImage(coverID: Int?, completion: @escaping (UIImage?) -> Void) {
        guard let coverID = coverID else {return}
        let urlString = "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching book cover image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to create image from data")
                completion(nil)
            }
        }
        
        task.resume()
    }
    func saveBooks(book:Book, completion: @escaping (Result<Bool, Error>) -> Void) {
        let newItem = BooksCd(context: context)
        newItem.title = book.title
        newItem.author = book.author?[0] ?? ""
        newItem.ratingsCount = Double(book.ratingsCount ?? 0)
        newItem.coverID = Int64(book.coverID ?? 0)
        newItem.averageRating = book.averageRating ?? 0
        
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}

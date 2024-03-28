//
//  BookmarksViewModel.swift
//  BooksApp
//
//  Created by Jasleen on 29/03/24.
//

import Foundation
import CoreData
import UIKit

class BookmarkViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllBookmarks() -> [Book] {
        let fetchRequest: NSFetchRequest<BooksCd> = BooksCd.fetchRequest()
        
        do {
            let books = try context.fetch(fetchRequest)
            var booksToSend : [Book] = []
            books.forEach({ book in
                booksToSend.append(Book(title: book.title, author: [book.author ?? ""], averageRating: book.averageRating, ratingsCount: Int(book.ratingsCount), coverID: Int(book.coverID)))
            })
            return booksToSend
        } catch {
            print("Error fetching books: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func deleteBook(book: Book, completion: @escaping (Result<[Book], Error>) -> Void) {
        // Create fetch request to find the book to delete
        let fetchRequest: NSFetchRequest<BooksCd> = BooksCd.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", book.title ?? "")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let bookToDelete = results.first else {
                let error = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Book not found"])
                completion(.failure(error))
                return
            }

            context.delete(bookToDelete)
            
            try context.save()
            
            completion(.success((getAllBookmarks())))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}

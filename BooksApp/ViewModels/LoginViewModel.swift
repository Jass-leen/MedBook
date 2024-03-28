//
//  LoginViewModel.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import Foundation
import UIKit
import CoreData
class LoginViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
               
               do {
                   let matches = try context.fetch(fetchRequest)
                   if !matches.isEmpty {
                       // Login successful if matches found
                       completion(.success(true))
                   } else {
                       // No match found, login failed
                       completion(.success(false))
                   }
               } catch {
                   // Error occurred while fetching data, login failed
                   print("Error fetching data: \(error.localizedDescription)")
                   completion(.failure(error))
               }
           }
        
}

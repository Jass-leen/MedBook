//
//  SignupViewModel.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import Foundation
import SwiftyJSON
class SignupViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func signup(email: String, password: String, country: String, completion: @escaping (Result<Bool, Error>) -> Void) {

        let newItem = Users(context: context)
        newItem.email = email
        newItem.password = password
        
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    func fetchCountries(completion: @escaping ([String]?) -> Void) {
 
           let url = URL(string: "https://api.first.org/data/v1/countries")!
           
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   print("Error fetching countries: \(error?.localizedDescription ?? "Unknown error")")
                   completion(nil)
                   return
               }
               
               do {
                   let jsondata = JSON(data)
 
                   debugPrint(data)
                   let countries = try JSONDecoder().decode(Countries.self, from: jsondata.rawData())

                   let countryNames = countries.data.compactMap { $0.value.country }
                   completion(countryNames)
               } catch {
                   print("Error decoding JSON: \(error.localizedDescription)")
                   completion(nil)
               }
           }.resume()
       }
}

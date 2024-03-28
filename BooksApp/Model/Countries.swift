//
//  Countries.swift
//  BooksApp
//
//  Created by Jasleen on 26/03/24.
//

import Foundation
struct Countries: Codable {
    let data: [String: Place]

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Datum
struct Place: Codable {
    let country: String
    let region: Region
}

enum Region: String, Codable {
    case africa = "Africa"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case centralAmerica = "Central America"
}

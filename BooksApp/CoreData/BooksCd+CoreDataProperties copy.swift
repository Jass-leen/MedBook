//
//  BooksCd+CoreDataProperties.swift
//  
//
//  Created by Jasleen on 28/03/24.
//
//

import Foundation
import CoreData


extension BooksCd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BooksCd> {
        return NSFetchRequest<BooksCd>(entityName: "BooksCd")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var averageRating: Double
    @NSManaged public var ratingsCount: Double
    @NSManaged public var coverID: Int64

}

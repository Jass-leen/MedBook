//
//  Users+CoreDataProperties.swift
//  
//
//  Created by Jasleen on 27/03/24.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?

}

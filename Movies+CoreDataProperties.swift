//
//  Movies+CoreDataProperties.swift
//  Log
//
//  Created by Taras Shukhman on 24/06/2021.
//
//

import Foundation
import CoreData


extension Movies {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var genre: [String]
    @NSManaged public var image: String
    @NSManaged public var rating: Float
    @NSManaged public var releaseYear: Int16
    @NSManaged public var title: String

}

extension Movies : Identifiable {

}

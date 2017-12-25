//
//  Album+CoreDataProperties.swift
//  JSONtoCoreData
//
//  Created by anoopm on 24/12/17.
//  Copyright © 2017 anoopm. All rights reserved.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var image: String?
    @NSManaged public var thumbnailImage: String?
    @NSManaged public var artist: String?

}

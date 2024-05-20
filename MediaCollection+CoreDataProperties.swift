//
//  MediaCollection+CoreDataProperties.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 14/05/24.
//
//

import Foundation
import CoreData


extension MediaCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaCollection> {
        return NSFetchRequest<MediaCollection>(entityName: "MediaCollection")
    }

    @NSManaged public var collectionId: UUID?
    @NSManaged public var mediaItems: NSObject?
    @NSManaged public var name: String?

}

extension MediaCollection : Identifiable {

}

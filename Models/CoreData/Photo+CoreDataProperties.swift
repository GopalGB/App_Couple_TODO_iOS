//
//  Photo+CoreDataProperties.swift
//  TogetherList
//

import Foundation
import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var caption: String?
    @NSManaged public var takenDate: Date?
    @NSManaged public var addedBy: UUID?
    @NSManaged public var activity: Activity?

}
//
//  Activity+CoreDataProperties.swift
//  TogetherList
//

import Foundation
import CoreData

extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var activityDescription: String?
    @NSManaged public var category: String?
    @NSManaged public var priority: String?
    @NSManaged public var status: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var completedDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var createdBy: UUID?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Activity {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
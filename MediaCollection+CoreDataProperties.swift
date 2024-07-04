

import Foundation
import CoreData

extension MediaCollection {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaCollection> {
        return NSFetchRequest<MediaCollection>(entityName: "MediaCollection")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var mediaItemsData: Data?
    @NSManaged public var date: Date

    var mediaItems: [UUID] {
            get {
                guard let data = mediaItemsData else { return [] }
                let unarchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
                unarchiver?.requiresSecureCoding = true
                let nsUUIDs = unarchiver?.decodeObject(of: [NSArray.self, NSUUID.self], forKey: NSKeyedArchiveRootObjectKey) as? [NSUUID]
                return nsUUIDs?.map { $0 as UUID } ?? []
            }
            set {
                let nsUUIDs = newValue.map { $0 as NSUUID }
                mediaItemsData = try? NSKeyedArchiver.archivedData(withRootObject: nsUUIDs, requiringSecureCoding: true)
            }
        }
}


import Foundation
import Photos
import CoreData
import SwiftUI

class DataController {
    
    static let shared = DataController() // Singleton
    
    let container: NSPersistentContainer
    
    
    
    private init() {
        //        container = NSPersistentContainer(name: "DBmainModel")
        //        container.loadPersistentStores { desc, error in
        //            if let error = error {
        //                fatalError("Failed to load the data \(error.localizedDescription)")
        //            }
        //        }
        
        container = NSPersistentContainer(name: "DBmainModel")
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.LinSaver.group")!.appendingPathComponent("DBmainModel.sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Data saved")
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    func deleteById(id: UUID) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<DBmain> = DBmain.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
                removeMediaFromAllCollections(mediaId: id)
            }
            do {
                try save()
                print("Deleted object with ID: \(id)")
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print("Error deleting object with ID \(id): \(error.localizedDescription)")
        }
    }
    
    func addPaths(id: UUID, date: Date, displayImg: String, sourceFile: String, saveToPhotos: Bool, link: String, completion: @escaping (Error?) -> Void) {
        let context = container.viewContext
        let dbMain = DBmain(context: context)
        do {
            dbMain.id = id
            dbMain.date = date
            dbMain.displayImg = displayImg
            dbMain.sourceFile = sourceFile
            dbMain.link = link
            try save()
            if saveToPhotos {
                if displayImg == sourceFile {
                    saveImageToPhotos(url: URL(string: sourceFile)!) { error in
                        if let error = error {
                            print("Error saving image to photo library: \(error)")
                            completion(error)
                        } else {
                            print("Image saved to photo library successfully.")
                            completion(nil)
                        }
                    }
                } else {
                    saveVideoToPhotos(url: URL(string: sourceFile)!) { error in
                        if let error = error {
                            print("Error saving video to photo library: \(error.localizedDescription)")
                            completion(error)
                        } else {
                            print("Video saved to photo library successfully.")
                            completion(nil)
                        }
                    }
                }
            } else {
                completion(nil)
            }
        } catch {
            print(error.localizedDescription)
            completion(error)
            deleteById(id: id)
            
        }
    }


func saveImageToPhotos(url: URL, completion: @escaping (Error?) -> Void) {
    guard let image = UIImage(contentsOfFile: url.path) else {
        completion(NSError(domain: "DataManagerViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from file"]))
        return
    }
    PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAsset(from: image)
    }) { success, error in
        if let error = error {
            print("Error saving image to photo library: \(error)")
            completion(error)
        } else {
            print("Image saved to photo library successfully.")
            completion(nil)
        }
    }
}

func saveVideoToPhotos(url: URL, completion: @escaping (Error?) -> Void) {
    PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
    }) { success, error in
        if let error = error {
            print("Error saving video to photo library: \(error.localizedDescription)")
            completion(error)
        } else {
            print("Video saved to photo library successfully.")
            completion(nil)
        }
    }
}

func fetchDBmain(by id: UUID) -> DBmain? {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<DBmain> = DBmain.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    do {
        return try context.fetch(fetchRequest).first
    } catch {
        print("Failed to fetch DBmain with id \(id): \(error.localizedDescription)")
        return nil
    }
}

//collections

func addCollection(name: String) {
    let context = container.viewContext
    let collection = MediaCollection(context: context)
    collection.id = UUID()
    collection.name = name
    collection.mediaItems = []
    collection.date = Date()
    
    do {
        try save()
    } catch {
        print(error.localizedDescription)
    }
}

func addMediaToCollection(mediaId: UUID, collectionId: UUID) {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", collectionId as CVarArg)
    
    do {
        let collections = try context.fetch(fetchRequest)
        if let collection = collections.first {
            collection.mediaItems.append(mediaId)
            try save()
        }
    } catch {
        print("Error adding media to collection: \(error.localizedDescription)")
    }
}

func removeMediaFromCollection(mediaId: UUID, collectionId: UUID) {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", collectionId as CVarArg)
    
    do {
        let collections = try context.fetch(fetchRequest)
        if let collection = collections.first {
            collection.mediaItems.removeAll(where: { $0 == mediaId })
            try save()
        }
    } catch {
        print("Error removing media from collection: \(error.localizedDescription)")
    }
}

func fetchCollections() -> [MediaCollection] {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
    
    do {
        return try context.fetch(fetchRequest)
    } catch {
        print("Error fetching collections: \(error.localizedDescription)")
        return []
    }
}

func removeMediaFromAllCollections(mediaId: UUID) {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
    
    do {
        let collections = try context.fetch(fetchRequest)
        for collection in collections {
            collection.mediaItems.removeAll { $0 == mediaId }
        }
        try save()
    } catch {
        print("Error removing media from all collections: \(error.localizedDescription)")
    }
}
    
    func addSubscription() {
        let context = container.viewContext
        let localSubscription = LocalSubscription(context: context)
        
        
        localSubscription.id = UUID()
        localSubscription.startDate = Date()
        localSubscription.endDate = Calendar.current.date(byAdding: .day, value: 5, to: localSubscription.startDate!)
        
        do {
            try save()
            scheduleTrialEndingNotification(for: localSubscription)
        } catch {
            // Handle the error appropriately
            print("Error saving context: \(error)")
        }
        
        
    }
    func scheduleTrialEndingNotification(for subscription: LocalSubscription) {
        guard let endDate = subscription.endDate else { return }
        let notifyDate = Calendar.current.date(byAdding: .day, value: 0, to: endDate)!
        
        let content = UNMutableNotificationContent()
        content.title = "Trial Ending Soon"
        content.body = "Your trial period will end in 2 days. Don't forget to subscribe!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notifyDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: subscription.id!.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}

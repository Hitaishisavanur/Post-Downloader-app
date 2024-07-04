import Foundation
import Photos
import CoreData
import SwiftUI
import FirebaseCrashlytics

class DataController {
    
    static let shared = DataController() // Singleton
    
    @Published var isSubscribed: Bool = false
    let container: NSPersistentContainer
    let userDefaults: UserDefaults
    @State var subscriptionActive: Bool = false
    
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
        userDefaults = UserDefaults(suiteName: "group.com.LinSaver.group")!
       isSubscribed = userDefaults.bool(forKey: "subscriptionActive")
    }
    
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
               
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
                
            } catch {
                Crashlytics.crashlytics().log(error.localizedDescription)
            }
        } catch {
            Crashlytics.crashlytics().log(error.localizedDescription)
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
                            
                            completion(error)
                        } else {
                           
                            completion(nil)
                        }
                    }
                } else {
                    saveVideoToPhotos(url: URL(string: sourceFile)!) { error in
                        if let error = error {
                           
                            completion(error)
                        } else {
                          
                            completion(nil)
                        }
                    }
                }
            } else {
                completion(nil)
            }
            incrementDownloadCount()
        } catch {
            
            completion(error)
            deleteById(id: id)
            
        }
    }

    private func incrementDownloadCount() {
        let currentCount = userDefaults.integer(forKey: "recordCount")
        if !isSubscribed{
            userDefaults.set(currentCount + 1, forKey: "recordCount")
        }
    }
        
        func getRecordCount() -> Int {
            return userDefaults.integer(forKey: "recordCount")
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
           
            completion(error)
        } else {
            
            completion(nil)
        }
    }
}

func saveVideoToPhotos(url: URL, completion: @escaping (Error?) -> Void) {
    PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
    }) { success, error in
        if let error = error {
      
            completion(error)
        } else {
           
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
        Crashlytics.crashlytics().log(error.localizedDescription)
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
        Crashlytics.crashlytics().log(error.localizedDescription)
    }
}

func addMediaToCollection(mediaId: UUID, collectionId: UUID) {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", collectionId as CVarArg)
    
    do {
        let collections = try context.fetch(fetchRequest)
        if let collection = collections.first {
            if !collection.mediaItems.contains(mediaId) {
                            collection.mediaItems.append(mediaId)
                            try save()
                        } else {
                            Crashlytics.crashlytics().log("error adding to mediaCollection even after having mediaId/file saved in device")
                        }
        }
    } catch {
        Crashlytics.crashlytics().log(error.localizedDescription)
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
        Crashlytics.crashlytics().log(error.localizedDescription)
    }
}

func fetchCollections() -> [MediaCollection] {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
    
    do {
        return try context.fetch(fetchRequest)
    } catch {
       
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
        Crashlytics.crashlytics().log(error.localizedDescription)
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
            Crashlytics.crashlytics().log(error.localizedDescription)
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
                Crashlytics.crashlytics().log(error.localizedDescription)
            } else {
               
            }
        }
    }
}



import SwiftUI
import CoreData

class CollectionsViewModel: ObservableObject {
    
    @Published var collections: [MediaCollection] = []
    let dataController = DataController.shared
    @Published var selectedMediaItem: MediaItem?
    @Published var selectedCollection: MediaCollection?
    @Published var cId : UUID = UUID()
    @Published var selectedCollectionforEdit: MediaCollection?
    @Published var searchText: String = ""
    @Published var dataModels: [DBmain] = []
    
    func fetchCollections() {
        collections = dataController.fetchCollections()
    }
    
    func createCollection(name: String) {
        dataController.addCollection(name: name)
        fetchCollections()
    }
    
    func fetchDBmain(by id: UUID) -> DBmain? {
            
            let dbMains = dataController.fetchDBmain(by: id)
            
            return dbMains
        }
    
    func getLastThreeDisplayImages(for collection: MediaCollection) -> [UIImage]? {
        let mediaItems = collection.mediaItems
        print(mediaItems)
        var images: [UIImage] = []
        
        for id in mediaItems {
            print(id)
            if let dbMain = fetchDBmain(by: id){
                print(dbMain)
                if let displayImgPath = dbMain.displayImg{
                    print(displayImgPath)
                    if let image = loadImage(from: displayImgPath) {
                        
                        images.append(image)
                    }
                }
            }
        }
        print(images)
        return images

    }
        
        func getMediaItems(id: UUID) -> MediaItem {
            var mediaItem = MediaItem(id: UUID(), displayImg: "", sourceFile: "", date: Date(), link: "")
            if let dbMain = fetchDBmain(by: id) {
                mediaItem.id = dbMain.id ?? UUID()
                mediaItem.displayImg = dbMain.displayImg ?? ""
                mediaItem.sourceFile = dbMain.sourceFile ?? ""
                mediaItem.date = dbMain.date ?? Date()
                mediaItem.link = dbMain.link ?? ""
            }
            
            return mediaItem
        }
        func loadImage(from path: String?) -> UIImage? {
            
            
            guard let imagePath = path, let imageUrl = URL(string: imagePath) else {
                return nil
            }
            
            do {
                
                let imageData = try Data(contentsOf: imageUrl)
                
                return UIImage(data: imageData)
            } catch {
                print("Error loading image: \(error.localizedDescription)")
                return nil
            }
        }
        
    var filteredCollections: [MediaCollection] {
           if searchText.isEmpty {
               return collections
           } else {
               return collections.filter { collection in
                   collection.name.localizedCaseInsensitiveContains(searchText)
               }
           }
       }
    
    func deleteCollectionbyId(id: UUID) {
        let context = dataController.container.viewContext
        let fetchRequest: NSFetchRequest<MediaCollection> = MediaCollection.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
                do{
                    try dataController.save()
                }catch{
                    print(error.localizedDescription)
                }
                fetchCollections()
                print("Deleted object with ID: \(id)")
            }
           
        } catch {
            print("Error deleting object with ID \(id): \(error.localizedDescription)")
        }
        
        
    }
    
    func editCollection(name: String, cId: UUID){
        if let collection = filteredCollections.first(where: { $0.id == cId }) {
                    collection.name = name
            do{
                try dataController.save()
            }catch{
                print(error.localizedDescription)
            }
                    fetchCollections()
        }
    }
    
    func fetchFiles() {
        let context = dataController.container.viewContext
        let request: NSFetchRequest<DBmain> = DBmain.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DBmain.date, ascending: false)]
        
        do {
            dataModels = try context.fetch(request)
        } catch {
            print("Error fetching data models: \(error.localizedDescription)")
        }
    }
    
    func observeChanges() {
        let context = dataController.container.viewContext
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    @objc private func contextObjectsDidChange(_ notification: Notification) {
        fetchFiles()
    }
    
    
    
    func loadImagebyPath(from path: String?) -> UIImage? {
        
        
        guard let imagePath = path, let imageUrl = URL(string: imagePath) else {
            return nil
        }
        
        do {
            print(imageUrl)
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func moveToCollection(mediaItemId: UUID, collectionId: UUID){
        dataController.addMediaToCollection(mediaId: mediaItemId, collectionId: collectionId)
    }
}

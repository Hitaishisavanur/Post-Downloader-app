

import SwiftUI
import CoreData
import Photos

class CollectionsViewModel: ObservableObject {
    
    @Published var collections: [MediaCollection] = []
    let dataController = DataController.shared
    @Published var selectedMediaItem: MediaItem?
    @Published var selectedCollection: MediaCollection?
    @Published var cId : UUID = UUID()
    @Published var selectedCollectionforEdit: MediaCollection?
    @Published var searchText: String = ""
    @Published var dataModels: [DBmain] = []
    @Published var isSubscribed: Bool = false
    @Published var buyPro = false
    private let userViewModel = UserViewModel.shared
    @Published var exceeds = false
    let crashlyticsManager = CrashlyticsManager.shared
    
    
    init(){
        isSubscribed = userViewModel.subscriptionActive
        
    }
    
    
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
       
        var images: [UIImage] = []
        
        for id in mediaItems {
           
            if let dbMain = fetchDBmain(by: id){
               
                if let displayImgPath = dbMain.displayImg{
                  
                    if let image = loadImage(from: displayImgPath) {
                        
                        images.append(image)
                    }
                }
            }
        }
      
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
                crashlyticsManager.addLog(message: "failed to load image in collectionviewmodel")
                return nil
            }
            
            do {
                
                let imageData = try Data(contentsOf: imageUrl)
                
                return UIImage(data: imageData)
            } catch {
                crashlyticsManager.addLog(message: error.localizedDescription)
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
                    crashlyticsManager.addLog(message: error.localizedDescription)
                }
                fetchCollections()
            }
           
        } catch {
            crashlyticsManager.addLog(message: error.localizedDescription)
        }
        
        
    }
    
    func editCollection(name: String, cId: UUID){
        if let collection = filteredCollections.first(where: { $0.id == cId }) {
                    collection.name = name
            do{
                try dataController.save()
            }catch{
                crashlyticsManager.addLog(message: error.localizedDescription)
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
            crashlyticsManager.addLog(message: error.localizedDescription)
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
            crashlyticsManager.addLog(message: "failed to load image by path in collectionviewmodel")
            return nil
        }
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
        } catch {
            crashlyticsManager.addLog(message: error.localizedDescription)
            return nil
        }
    }
    
    func moveToCollection(mediaItemId: UUID, collectionId: UUID){
        dataController.addMediaToCollection(mediaId: mediaItemId, collectionId: collectionId)
    }
    func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
           let status = PHPhotoLibrary.authorizationStatus()
           switch status {
           case .authorized, .limited:
               completion(true)
           case .denied, .restricted:
               completion(false)
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                   completion(newStatus == .authorized)
               }
           @unknown default:
               completion(false)
           }
       }
}

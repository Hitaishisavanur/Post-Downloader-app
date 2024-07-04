

import Foundation
import Photos
import UIKit

class VideoPlayerViewModel: ObservableObject{
    private let dataController = DataController.shared
    @Published var errorSavetoPhotosMessage = ""
    @Published var showErrorAlert: Bool = false
    @Published var isloading = false
    let crashyliticsManager = CrashlyticsManager.shared
    
    func saveToPhotos(mediaItem: MediaItem){
        let sourceFile = mediaItem.sourceFile
        if(mediaItem.displayImg == mediaItem.sourceFile){
            dataController.saveImageToPhotos(url: URL(string: sourceFile)!){error in
                DispatchQueue.main.async {
                    if let error = error {
                        if error.localizedDescription == "The operation couldn’t be completed. (PHPhotosErrorDomain error 3311.)"{
                            self.errorSavetoPhotosMessage = "Permission denied to access photo library. Please enable it in device settings.\n Go to Settings > LinSaver > Photos > select \"Add Photos Only\""
                            
                            self.showErrorAlert = true
                        }else{
                            self.errorSavetoPhotosMessage = "Error saving image to photo library: \(error.localizedDescription)"
                            self.showErrorAlert = true
                        }
                        
                        
                    } else {
                        // Image saved successfully
                        
                    }
                }
            }
        }else{
            
                dataController.saveVideoToPhotos(url: URL(string: sourceFile)!){error in
                 DispatchQueue.main.async {
                    if let error = error {
                        // Handle error
                        if error.localizedDescription == "The operation couldn’t be completed. (PHPhotosErrorDomain error 3311.)"{
                            self.errorSavetoPhotosMessage = "Permission denied to access photo library. Please enable it in device settings.\n Go to Settings > LinSaver > Photos > select \"Add Photos Only\""
                           
                            self.showErrorAlert = true
                        }else{
                            self.errorSavetoPhotosMessage = "Error saving video to photo library: \(error.localizedDescription)"
                            self.showErrorAlert = true
                        }
                        
                    } else {
                        // Image saved successfully
                      
                    }
               }
            }
        }
    }
    
    func fileDelete(mediaItem : MediaItem){
        dataController.removeMediaFromAllCollections(mediaId: mediaItem.id)
        dataController.deleteById(id: mediaItem.id)
    }
    
    func fileRemove(mediaItem: MediaItem, collectionId: UUID){
        dataController.removeMediaFromCollection(mediaId: mediaItem.id, collectionId: collectionId)
    }
    
    func loadImage(from path: String?) -> UIImage? {
        
        
        guard let imagePath = path, let imageUrl = URL(string: imagePath) else {
            crashyliticsManager.addLog(message: "failed to load image in videoPlayerView")
            return nil
        }
        
        do {
           
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
        } catch {
            crashyliticsManager.addLog(message: error.localizedDescription)
            return nil
        }
    }
    
}

//
//  VideoPlayerViewModel.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 16/05/24.
//

import Foundation
import Photos
import UIKit

class VideoPlayerViewModel: ObservableObject{
    private let dataController = DataController.shared
    
    
    func saveToPhotos(mediaItem: MediaItem){
        let sourceFile = mediaItem.sourceFile
        if(mediaItem.displayImg == mediaItem.sourceFile){
            dataController.saveImageToPhotos(url: URL(string: sourceFile)!){error in
                if let error = error {
                    // Handle error
                    print("Error saving image to photo library: \(error.localizedDescription)")
                    
                } else {
                    // Image saved successfully
                    print("Image saved to photo library successfully.")
                }
            }
        }else{
            dataController.saveVideoToPhotos(url: URL(string: sourceFile)!){error in
                if let error = error {
                    // Handle error
                    print("Error saving video to photo library: \(error.localizedDescription)")
                    
                } else {
                    // Image saved successfully
                    print("Video saved to photo library successfully.")
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
    
}

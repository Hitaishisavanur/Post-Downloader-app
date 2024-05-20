import Foundation
import UIKit
import Photos
import SwiftUI

class DataManagerViewModel {
    let dataController = DataController.shared
    
    func getDownloadsDirectory() -> URL {
        let fileManager = FileManager.default
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let downloadDirectory = path[0].appendingPathComponent("Downloads")
        
        // Check if the directory exists
        if !fileManager.fileExists(atPath: downloadDirectory.path) {
            // Directory does not exist, create it
            do {
                try fileManager.createDirectory(at: downloadDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating download directory: \(error.localizedDescription)")
            }
        }
        
        return downloadDirectory
    }
    
    func getFileName(fileType: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let currentDateTime = formatter.string(from: Date())
        return "file_\(currentDateTime).\(fileType)"
    }
    
    func downloadFile(url: URL, fileName: String, completion: @escaping (URL?) -> Void) {
        URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location, error == nil else { return }
            do {
                let documentsDirectory = self.getDownloadsDirectory()
                let destinationURL = documentsDirectory.appendingPathComponent(fileName)
                
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                
                try FileManager.default.moveItem(at: location, to: destinationURL)
                print("File saved: \(destinationURL)")
                completion(destinationURL)
            } catch {
                print("Error saving file:", error)
                completion(nil)
            }
        }.resume()
    }
    
    func deleteFiles(_ urls: [URL]) {
        let fileManager = FileManager.default
        for url in urls {
            do {
                try fileManager.removeItem(at: url)
                print("Deleted file at path: \(url.path)")
            } catch {
                print("Error deleting file at path \(url.path): \(error.localizedDescription)")
            }
        }
    }
    
    func writeDownloadsToFolder(displayURLs: URL, sourceURLs: URL, saveToPhotos: Bool ,link: String) {
        let date = Date()
        let id = UUID()
        let displayImg = displayURLs.absoluteString
        let sourceFilePath = sourceURLs.absoluteString
        let saveToPhotos = saveToPhotos
        let link = link
        
        dataController.addPaths(id: id, date: date, displayImg: displayImg, sourceFile: sourceFilePath, saveToPhotos: saveToPhotos, link: link)
    }
  
}

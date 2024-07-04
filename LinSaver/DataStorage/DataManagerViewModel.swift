import Foundation
import UIKit
import Photos
import SwiftUI

class DataManagerViewModel {
    let dataController = DataController.shared
    let crashlyticsManager = CrashlyticsManager.shared
    func getDownloadsDirectory() -> URL? {

        let fileManager = FileManager.default
           guard let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.LinSaver.group") else {
               crashlyticsManager.addLog(message: "error getting container from group.com.LinSaver.group")
               return nil
           }
           
           let downloadDirectory = containerURL.appendingPathComponent("Downloads")
           
           // Check if the directory exists
           if !fileManager.fileExists(atPath: downloadDirectory.path) {
               // Directory does not exist, create it
               do {
                   try fileManager.createDirectory(at: downloadDirectory, withIntermediateDirectories: true, attributes: nil)
               } catch {
                   crashlyticsManager.addLog(message: error.localizedDescription)
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
    
    func downloadFile(url: URL, fileName: String, completion: @escaping (Result<URL, Error>) -> Void) {
           URLSession.shared.downloadTask(with: url) { location, response, error in
               guard let location = location, error == nil else {
                   completion(.failure(error ?? NSError(domain: "Download Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                   return
               }
               do {
                   if let documentsDirectory = self.getDownloadsDirectory() {
                       let destinationURL = documentsDirectory.appendingPathComponent(fileName)
                       
                       if FileManager.default.fileExists(atPath: destinationURL.path) {
                           try FileManager.default.removeItem(at: destinationURL)
                       }
                       
                       try FileManager.default.moveItem(at: location, to: destinationURL)
                       
                       completion(.success(destinationURL))
                   } else {
                       completion(.failure(NSError(domain: "Download Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get downloads directory"])))
                   }
               } catch {
                   
                   completion(.failure(error))
               }
           }.resume()
       }
       
    
    func deleteFiles(_ urls: [URL]) {
        let fileManager = FileManager.default
        for url in urls {
            do {
                try fileManager.removeItem(at: url)
                
            } catch {
                crashlyticsManager.addLog(message: error.localizedDescription)
            }
        }
    }
    
    func writeDownloadsToFolder(displayURLs: URL, sourceURLs: URL, saveToPhotos: Bool, link: String, completion: @escaping (Error?) -> Void) {
           let date = Date()
           let id = UUID()
           let displayImg = displayURLs.absoluteString
           let sourceFilePath = sourceURLs.absoluteString
           
           dataController.addPaths(id: id, date: date, displayImg: displayImg, sourceFile: sourceFilePath, saveToPhotos: saveToPhotos, link: link) { error in
               if let error = error {
                   completion(error)
               } else {
                   completion(nil)
               }
           }
       }
  
}

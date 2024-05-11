//
//  DownloadCardViewModel.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import SwiftUI

class DownloadViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var downloadItem = DownloadItem(link: "", saveToPhotos: false, fileType: .image, folderPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    
    func pasteButtonTapped() {
        if let text = UIPasteboard.general.string {
            self.text = text    }
    }
    
    func downloadButtonTapped() {
        // Handle downloading
       var download = getDownloadsDirectory()
        writeDownloadsToFolder(download)
        print(download)
        
    }
    
    func getDownloadsDirectory()-> URL{
        let fileManager = FileManager.default
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            var downloadDirectory = path[0].appendingPathComponent("Downloads")
            
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
    
    func writeDownloadsToFolder(_ downloadsFolderPath: URL){
        let str="hello"
        var newFile = downloadsFolderPath.appendingPathComponent("messages\(Date()).txt)")
        do{
            try str.write(to: newFile, atomically: true, encoding: .utf8)
        }catch{
            print(error.localizedDescription)
        }
        print(newFile)
    }
    
    
}


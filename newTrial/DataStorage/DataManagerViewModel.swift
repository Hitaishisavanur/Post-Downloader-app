//
//  DataManager.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import Foundation

class DataManagerViewModel: ObservableObject{
    
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
    
    func getFileName(fileType: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            let currentDateTime = formatter.string(from: Date())
            return "file_\(currentDateTime).\(fileType)"
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

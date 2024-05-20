//
//  DownloadCardViewModel.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import SwiftUI
import SwiftSoup

class DownloadViewModel: ObservableObject {
    @Published var text: String = ""
    @EnvironmentObject var saveViewModel: SettingsViewModel

     var viewModel = DataManagerViewModel()
    
    func pasteButtonTapped() {
        if let text = UIPasteboard.general.string {
            self.text = text
        }
    }
    
    func downloadButtonTapped(saveToPhotos:Bool) {
        downloadHTML(text: text, saveToPhotos: saveToPhotos)
    }
    
    func downloadHTML(text: String, saveToPhotos: Bool) {
        let group = DispatchGroup()
        guard let url = URL(string: text) else { return }
        
        var sourceURL: URL?
        var displayImageURL: URL?
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let htmlString = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parse(htmlString)
                    
                    if let section = try doc.select("section.mb-3").first() {
                        if let videoSources = try? section.select("video.share-native-video__node").attr("data-sources"), !videoSources.isEmpty {
                            
                            let videoURLs = videoSources.replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "\\\"", with: "\"")
                            let dataSources = try JSONSerialization.jsonObject(with: Data(videoURLs.utf8), options: []) as? [[String: Any]]
                            
                            if let thirdVideoURL = dataSources?.last?["src"] as? String {
                                group.enter()
                                if let videoURL = URL(string: thirdVideoURL) {
                                    let fileName = self.viewModel.getFileName(fileType: "mp4")
                                    self.viewModel.downloadFile(url: videoURL, fileName: fileName) { destinationURL in
                                        if let destinationURL = destinationURL {
                                            sourceURL = destinationURL
                                            
                                        } else {
                                            print("Error downloading source file.")
                                        }
                                        group.leave()
                                    }
                                }
                            }
                            
                            if let videoCoverURL = try? section.select("video.share-native-video__node").attr("data-poster-url"), !videoCoverURL.isEmpty {
                                group.enter()
                                if let url = URL(string: videoCoverURL) {
                                    let fileName = self.viewModel.getFileName(fileType: "jpeg")
                                    self.viewModel.downloadFile(url: url, fileName: fileName) { destinationURL in
                                        if let destinationURL = destinationURL {
                                            displayImageURL = destinationURL
                                            print("image\(destinationURL)")
                                        } else {
                                            print("Error downloading display image.")
                                        }
                                        group.leave()
                                    }
                                }
                            }
                        } else if let ul = try? section.select("ul.feed-images-content").first() {
                            try? ul.select("li").forEach { li in
                                if let imageURL = try? li.select("img").first()?.attr("data-delayed-url") {
                                    group.enter()
                                    if let url = URL(string: imageURL) {
                                        let fileName = self.viewModel.getFileName(fileType: "jpeg")
                                        self.viewModel.downloadFile(url: url, fileName: fileName) { destinationURL in
                                            if let destinationURL = destinationURL {
                                                displayImageURL = destinationURL
                                                sourceURL = destinationURL
                                            } else {
                                                print("Error downloading display image.")
                                            }
                                            group.leave()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        if let displayImageURL = displayImageURL, let sourceURL = sourceURL {                            self.viewModel.writeDownloadsToFolder(displayURLs: displayImageURL, sourceURLs: sourceURL, saveToPhotos: saveToPhotos, link: text)
                           
                        } else {
                            print("Error getting file destinations.")
                        }
                    }
                } catch let error {
                    print("Error parsing HTML: \(error)")
                }
            }
        }.resume()
        
       
    }
}

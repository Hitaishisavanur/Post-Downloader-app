

import SwiftUI
import SwiftSoup
import Photos

class DownloadViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String?
    @Published var errorMessageExt: String = ""
    @Published var isDownloading = false
    @Published var isDownloadingAndSaving = false
    @Published var downloadCount: Int
    private let dataController = DataController.shared
    var viewModel = DataManagerViewModel()
    @Published var urls: String? = nil
    
    
  
    
    
    init(){
        self.downloadCount = dataController.getRecordCount()
    }

    func pasteButtonTapped() {
        if let text = UIPasteboard.general.string {
            self.text = text
        }
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

    func downloadButtonTapped(saveToPhotos: Bool) {
        
        downloadHTML(text: text, saveToPhotos: saveToPhotos)
    }

    func downloadHTML(text: String, saveToPhotos: Bool) {
        let group = DispatchGroup()
        
        guard let url = URL(string: text) else {
            showError("Invalid URL")
            return
        }

        var sourceURL: URL?
        var displayImageURL: URL?

        URLSession.shared.dataTask(with: url) { data, response, error in
            if(saveToPhotos){
                self.isDownloadingAndSaving = true
            }else{
                self.isDownloading = true
            }
            guard let data = data, error == nil else {
                self.isDownloading = false
                self.isDownloadingAndSaving = false
                self.showError("Failed to download HTML: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

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
                                    self.viewModel.downloadFile(url: videoURL, fileName: fileName) { result in
                                        switch result {
                                        case .success(let destinationURL):
                                            sourceURL = destinationURL
                                        case .failure(let error):
                                            self.isDownloading = false
                                            self.isDownloadingAndSaving = false
                                            self.showError("Error downloading video: \(error.localizedDescription)")
                                        }
                                        group.leave()
                                    }
                                }
                            }

                            if let videoCoverURL = try? section.select("video.share-native-video__node").attr("data-poster-url"), !videoCoverURL.isEmpty {
                                group.enter()
                                if let url = URL(string: videoCoverURL) {
                                    let fileName = self.viewModel.getFileName(fileType: "jpeg")
                                    self.viewModel.downloadFile(url: url, fileName: fileName) { result in
                                        switch result {
                                        case .success(let destinationURL):
                                            displayImageURL = destinationURL
                                        case .failure(let error):
                                            self.isDownloading = false
                                            self.isDownloadingAndSaving = false
                                            self.showError("Error downloading image: \(error.localizedDescription)")
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
                                        self.viewModel.downloadFile(url: url, fileName: fileName) { result in
                                            switch result {
                                            case .success(let destinationURL):
                                                displayImageURL = destinationURL
                                                sourceURL = destinationURL
                                            case .failure(let error):
                                                self.isDownloading = false
                                                self.isDownloadingAndSaving = false
                                                self.showError("Error downloading image: \(error.localizedDescription)")
                                            }
                                            group.leave()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    group.notify(queue: .main) {
                        if let displayImageURL = displayImageURL, let sourceURL = sourceURL {
                            self.viewModel.writeDownloadsToFolder(displayURLs: displayImageURL, sourceURLs: sourceURL, saveToPhotos: saveToPhotos, link: text) { error in
                                if let error = error {
                                    self.isDownloading = false
                                    self.isDownloadingAndSaving = false
                                    self.showError("Error writing downloads to folder: \(error.localizedDescription)")
                                }else{
                                    self.isDownloading = false
                                    self.isDownloadingAndSaving = false
                                    if(self.urls == nil){
                                        
                                    }else{
                                        
                                    }
                                }
                            }
                        } else {
                            self.isDownloading = false
                            self.isDownloadingAndSaving = false
                            self.showError("Error downloading, please check url.\n OR \n Unsupported format.\n If its a bug, kindly contact us")
                        }
                    }
                } catch let error {
                    self.isDownloading = false
                    self.isDownloadingAndSaving = false
                    self.showError("Error parsing HTML: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

     func showError(_ message: String) {
         
         if(urls == nil){
             DispatchQueue.main.async {
                 self.errorMessage = message
                 self.showErrorAlert = true
             }
         }else{
             errorMessageExt = message
         }
    }
}

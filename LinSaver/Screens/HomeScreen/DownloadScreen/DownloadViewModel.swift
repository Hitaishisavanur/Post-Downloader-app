

import SwiftUI
import SwiftSoup

class DownloadViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String? = nil
    @EnvironmentObject var saveViewModel: SettingsViewModel

    var viewModel = DataManagerViewModel()

    func pasteButtonTapped() {
        if let text = UIPasteboard.general.string {
            self.text = text
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
            guard let data = data, error == nil else {
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
                                    self.showError("Error writing downloads to folder: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            self.showError("Error downloading, please check url.\n OR \n Unsupported format.\n If its a bug, kindly contact us")
                        }
                    }
                } catch let error {
                    self.showError("Error parsing HTML: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

     func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showErrorAlert = true
        }
    }
}

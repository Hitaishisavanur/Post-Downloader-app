import Foundation
import SwiftUI
import Photos
import UIKit
import CoreData

class HomeScreenViewModel: ObservableObject {
    @Published var buyPremium: Bool = false
    @Published var downloadCount: Int
    @Published var isShowingDownloader = false
    @Published var dataModels: [DBmain] = []
    @Published var selectedMediaItem: MediaItem?
    @Published var exceeds: Bool = false
    @Published var buyPro: Bool = false
    @Published var isSubscribed: Bool = false
    private let userViewModel = UserViewModel.shared
    private let dataController = DataController.shared
    @Published var isloading = false
    let crashlyticsManager = CrashlyticsManager.shared
    
    init() {
        
      downloadCount = dataController.getRecordCount()
        self.fetchFiles()
       self.observeChanges()
        isSubscribed = userViewModel.subscriptionActive
        if !isSubscribed{
            if(downloadCount > 10){
                exceeds = true
            }
        }
          
        
    }
    
    
    func buyPremiumAction() {
        buyPremium.toggle()
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
    
    
    
    func loadImage(from path: String?) -> UIImage? {
        
        
        guard let imagePath = path, let imageUrl = URL(string: imagePath) else {
            crashlyticsManager.addLog(message: "failed to load image in HomeScreenviewModel")
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

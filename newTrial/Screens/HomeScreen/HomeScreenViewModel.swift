import Foundation
import UIKit
import CoreData

class HomeScreenViewModel: ObservableObject {
    @Published var buyPremium: Bool = false
    @Published var openMedia: Bool = false
    @Published var isShowingCardView = false
    @Published var dataModels: [DBmain] = []
    @Published var selectedMediaItem: MediaItem?
    private let dataController = DataController.shared
    
    init() {
        fetchFiles()
        observeChanges()
        
    }
    
    func toggleCardView() {
        isShowingCardView.toggle()
    }
    
    func buyPremiumAction() {
        buyPremium.toggle()
    }
    
    private func fetchFiles() {
        let context = dataController.container.viewContext
        let request: NSFetchRequest<DBmain> = DBmain.fetchRequest()
        do {
            dataModels = try context.fetch(request)
        } catch {
            print("Error fetching data models: \(error.localizedDescription)")
        }
    }
    
    private func observeChanges() {
        let context = dataController.container.viewContext
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    @objc private func contextObjectsDidChange(_ notification: Notification) {
        fetchFiles()
    }
    
    
    
    func loadImage(from path: String?) -> UIImage? {
        
        
        guard let imagePath = path, let imageUrl = URL(string: imagePath) else {
            return nil
        }
        
        do {
            print(imageUrl)
            let imageData = try Data(contentsOf: imageUrl)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }
}

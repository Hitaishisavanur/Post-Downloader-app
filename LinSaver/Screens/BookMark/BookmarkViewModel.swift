
import SwiftUI
import CoreData

class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [DBbookmark] = []
    @Published var searchText: String = ""
    @Published var selectedBookmark: DBbookmark?
    @Published var adShown: String = ""
    private let dataController = DataController.shared
    @Published var exceeds = false
    @Published var isSubscribed: Bool = false
    @Published var buyPro = false
    private let userViewModel = UserViewModel.shared
    let crashlyticsManager = CrashlyticsManager.shared
    
    init() {
        fetchBookmarks()
        isSubscribed = userViewModel.subscriptionActive
//        if !isSubscribed{
//            if(bookmarks.count > 15){
//                exceeds = true
//            }
//        }
    }
    
    func fetchBookmarks() {
        let request: NSFetchRequest<DBbookmark> = DBbookmark.fetchRequest()
        do {
            bookmarks = try dataController.container.viewContext.fetch(request)
        } catch {
            crashlyticsManager.addLog(message: error.localizedDescription)
        }
    }
    
    func addBookmark(name: String, link: String) {
        let newBookmark = DBbookmark(context: dataController.container.viewContext)
        newBookmark.bookmarkId = UUID()
        newBookmark.date = Date()
        newBookmark.name = name
        newBookmark.link = link
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try dataController.save()
            fetchBookmarks() // Refresh the list
        } catch {
            crashlyticsManager.addLog(message: error.localizedDescription)
        }
    }
    
    var filteredBookmarks: [DBbookmark] {
           if searchText.isEmpty {
               return bookmarks
           } else {
               return bookmarks.filter { bookmark in
                   bookmark.name?.localizedCaseInsensitiveContains(searchText) ?? false
               }
           }
       }
    
    func fetchDBbookmarkbyId (by id: UUID) -> DBbookmark? {
        let context = dataController.container.viewContext
           let fetchRequest: NSFetchRequest<DBbookmark> = DBbookmark.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "bookmarkId == %@", id as CVarArg)
           
           do {
               return try context.fetch(fetchRequest).first
           } catch {
               crashlyticsManager.addLog(message: error.localizedDescription)
               return nil
           }
       }
    func deleteBookmarkbyId(id: UUID) {
        let context = dataController.container.viewContext
        let fetchRequest: NSFetchRequest<DBbookmark> = DBbookmark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookmarkId == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
                saveContext()
            }
           
        } catch {
            crashlyticsManager.addLog(message: error.localizedDescription)
        }
        
        
    }
    
    func editBookmark(name: String, bId: UUID){
        if let bookmark = filteredBookmarks.first(where: { $0.bookmarkId == bId }) {
                    bookmark.name = name
                   
                    saveContext()
                    fetchBookmarks()
                }
    }


    
}


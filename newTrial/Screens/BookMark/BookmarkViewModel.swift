//
//  BookmarkViewModel.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 17/05/24.
//

import SwiftUI
import CoreData

class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [DBbookmark] = []
    @Published var searchText: String = ""
    @Published var selectedBookmark: DBbookmark?
    private let dataController = DataController.shared
    
    
    init() {
        fetchBookmarks()
    }
    
    func fetchBookmarks() {
        let request: NSFetchRequest<DBbookmark> = DBbookmark.fetchRequest()
        do {
            bookmarks = try dataController.container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch bookmarks: \(error.localizedDescription)")
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
            print("Failed to save context: \(error.localizedDescription)")
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
               print("Failed to fetch DBbookmark with id \(id): \(error.localizedDescription)")
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
                print("Deleted object with ID: \(id)")
            }
           
        } catch {
            print("Error deleting object with ID \(id): \(error.localizedDescription)")
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


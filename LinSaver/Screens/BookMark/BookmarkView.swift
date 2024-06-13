import SwiftUI


struct BookmarkView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = BookmarkViewModel()
    @State private var showingAddBookmarkSheet = false
    @State private var showingEditBookmarkSheet = false
    @State private var isSelected = false
    @State private var showAlert = false
    @State private var showAlertforMultiple = false
    @State private var isSelectionMode = false
    @State private var deletebookmark: DBbookmark?
    @State private var selectedBookmarks: Set<UUID> = []
    
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.filteredBookmarks.isEmpty {
                    Text("No bookmarks created")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.filteredBookmarks, id: \.bookmarkId) { bookmark in
                        if !isSelectionMode{
                            Menu{
                                
                                Button(action: {
                                    viewModel.selectedBookmark = bookmark
                                    
                                    showingEditBookmarkSheet.toggle()
                                    
                                    
                                }) {
                                    Label("Edit Name", systemImage: "pencil")
                                    
                                }
                                
                                
                                Button(action: {
                                    
                                    if bookmark.link != ""{
                                        let url = URL(string: bookmark.link ?? "")
                                        UIApplication.shared.open(url!)}
                                    
                                }, label: {
                                    Label("Open in Browser", systemImage: "")}
                                )
                                
                                
                                Button(action: {
                                    
                                    UIPasteboard.general.string = bookmark.link
                                }) {
                                    Label("Copy link", systemImage: "link")
                                }
                                Button(action: {
                                    if bookmark.bookmarkId != nil{
                                        
                                        deletebookmark = bookmark
                                        showAlert = true
                                    }
                                    
                                    
                                }) {
                                    
                                    Label("Delete", systemImage: "trash")
                                    
                                }
                                
                            } label:{
                                
                                
                                HStack{
                                    HStack{
                                        VStack(alignment: .leading) {
                                            if colorScheme == .light{
                                                Text(bookmark.name ?? "No Name")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                            }else{
                                                Text(bookmark.name ?? "No Name")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }
                                                
                                            
                                            Text(bookmark.date ?? Date(), style: .date)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text(bookmark.link ?? "No Link")
                                                .font(.subheadline)
                                                .lineLimit(1)
                                                .foregroundColor(.blue)
                                        }
                                        Spacer()
                                    }
                                    
                                    
                                }
                                
                            }
                        }else{
                            Button(action: {
                                if isSelectionMode {
                                    toggleSelection(for: bookmark.bookmarkId ?? UUID())
                                } else {
                                    viewModel.selectedBookmark = bookmark
                                    showingEditBookmarkSheet.toggle()
                                }
                            }) {
                                HStack{
                                    
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(bookmark.name ?? "No Name")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text(bookmark.date ?? Date(), style: .date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(bookmark.link ?? "No Link")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    
                                    Spacer()
                                }
                            }.opacity(selectedBookmarks.contains(bookmark.bookmarkId ?? UUID()) ? 0.8 : 1.0)
                                    .background(selectedBookmarks.contains(bookmark.bookmarkId ?? UUID()) ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                                    .padding(.vertical, 8)
                            }
                        }
                         
                    }
                }
            }
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Bookmark"),
                    message: Text("Are you sure, You want to delete this bookmark?"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        viewModel.deleteBookmarkbyId(id: deletebookmark!.bookmarkId!)
                        
                        },
                        
                        
                    
                    secondaryButton: .cancel(){
                        
                    }
                )
            }
            
            .navigationTitle("Bookmarks")
            .navigationBarItems(
                leading: HStack {
                    if isSelectionMode {
                        
                        Button("Delete") {
                            showAlertforMultiple = true
                            
                        }.tint(.red)
                            
                    }
                }.alert(isPresented: $showAlertforMultiple) {
                    Alert(
                        title: Text("Delete Bookmarks"),
                        message: Text("Selected bookmarks will be deleted."),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteSelectedBookmarks()
                            
                            selectedBookmarks.removeAll()
                            isSelectionMode = false
                            
                        },
                        secondaryButton: .cancel(){
                            
                            selectedBookmarks.removeAll()
                            isSelectionMode = false
                        }
                    )
                },
                trailing:HStack{
                    Button(action: {
                        isSelectionMode.toggle()
                        if !isSelectionMode {
                            selectedBookmarks.removeAll()
                        }
                    }) {
                        Text(isSelectionMode ? "Cancel" : "Select")
                    }
                    if !isSelectionMode{
                        Button(action: {
                            
                            showingAddBookmarkSheet = true
                        }) {
                            Image(systemName: "plus")
                                
                                
                        }
                    }
                }
                
            )
            
        
        }
        .sheet(isPresented: $showingEditBookmarkSheet) {
            if let selectedbookmarkId = viewModel.selectedBookmark?.bookmarkId{
                EditBookmarkSheetView(viewModel: viewModel, bId: selectedbookmarkId)
            }
        }
        
        .sheet(isPresented: $showingAddBookmarkSheet) {
            AddBookmarkSheetView(viewModel: viewModel)
                
        }
        
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by name")
        
                
    }
    
    private func toggleSelection(for bookmarkId: UUID) {
        if selectedBookmarks.contains(bookmarkId) {
            selectedBookmarks.remove(bookmarkId)
        } else {
            selectedBookmarks.insert(bookmarkId)
        }
    }
    
    private func deleteSelectedBookmarks() {
        for bookmarkId in selectedBookmarks {
            viewModel.deleteBookmarkbyId(id: bookmarkId)
        }
        selectedBookmarks.removeAll()
    }
    
   
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}


import SwiftUI


struct BookmarkView: View {
    @StateObject private var viewModel = BookmarkViewModel()
    @State private var showingAddBookmarkSheet = false
    @State private var showingEditBookmarkSheet = false
    @State private var isSelected = false
    
    
    
    
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
                        Menu{
                            Button(action: {
                                viewModel.selectedBookmark = bookmark
                                
                                    showingEditBookmarkSheet.toggle()
                                
                            
                            }) {
                                Label("Edit", systemImage: "pencil")
                                
                            }
                            
                            
                            Button(action: {
                                
                                if bookmark.link != ""{
                                    let url = URL(string: bookmark.link ?? "")
                                    UIApplication.shared.open(url!)}
                                
                            }, label: {
                                Label("Open in Linkedin", systemImage: "")}
                            )
                            
                            
                            Button(action: {
                                
                                UIPasteboard.general.string = bookmark.link
                            }) {
                                Label("Copy link", systemImage: "link")
                            }
                            Button(action: {
                                if bookmark.bookmarkId != nil{
                                    viewModel.deleteBookmarkbyId(id: bookmark.bookmarkId!)
                                }
                                
                                
                            }) {
                                
                                Label("Delete", systemImage: "trash")
                                
                            }.foregroundStyle(Color.red)} label:{
                                
                                
                                HStack{
                                    HStack{
                                        VStack(alignment: .leading) {
                                            Text(bookmark.name ?? "No Name")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
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
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        showingAddBookmarkSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                
                
            }.sheet(isPresented: $showingEditBookmarkSheet) {
                if let selectedbookmarkId = viewModel.selectedBookmark?.bookmarkId{
                    EditBookmarkSheetView(viewModel: viewModel, bId: selectedbookmarkId)
                }
            }
            .sheet(isPresented: $showingAddBookmarkSheet) {
                AddBookmarkSheetView(viewModel: viewModel)
            }
            
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by name")
        }
    }
    
    
}

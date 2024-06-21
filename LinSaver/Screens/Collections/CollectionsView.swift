import SwiftUI

struct CollectionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: CollectionsViewModel
    @State private var showingAddCollectionAlert:Bool = false
    @State private var isEditCollection: Bool = false
    @State private var selectedCollectionfordelete: MediaCollection?
    @State var showingAlbum:Bool = false
    @State var showAlert:Bool = false
    @State private var displayImages: [UUID: [UIImage]] = [:]
    private let userViewModel = UserViewModel.shared
    @State var exceeds = false
    
    var body: some View {
        NavigationView {
            ZStack{
                if colorScheme != .light{
                  
                    Color.white.opacity(0.15)
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150) ,spacing: 20)],spacing: 20) {
                        ForEach(viewModel.filteredCollections) { collection in
                            let images = displayImages[collection.id] ?? []
                            let indexs = images.count
                            
                            VStack {
                                HStack(spacing: 1) {
                                    VStack {
                                        if indexs > 0 {
                                            Image(uiImage: images[indexs - 1])
                                                .resizable()
                                                .frame(height: 100)
                                                .clipped()
                                            
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(height: 100)
                                        }
                                    }
                                    
                                    
                                    VStack(spacing: 1) {
                                        if indexs > 1 {
                                            Image(uiImage: images[indexs - 2])
                                                .resizable()
                                                .frame(height: 49)
                                                .clipped()
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(height: 50)
                                        }
                                        
                                        if indexs > 2 {
                                            Image(uiImage: images[indexs - 3])
                                                .resizable()
                                                .frame(height: 49)
                                                .clipped()
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(height: 49)
                                        }
                                    }
                                    
                                }.cornerRadius(15)
//                                    .padding(.top,10)
//                                    .padding(.horizontal,10)
                                
                                
                                
                                
                                Text(collection.name)
                                    .font(.subheadline)
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    viewModel.selectedCollection = collection
                                    showingAlbum = true
                                }
                            )
                            .contextMenu {
                                Button(action: {
                                    viewModel.selectedCollectionforEdit = collection
                                    isEditCollection = true
                                }) {
                                    Label("Edit Name", systemImage: "pencil")
                                }
                                
                                Button(action: {
                                    selectedCollectionfordelete = collection
                                    if let cIds = selectedCollectionfordelete {
                                        showAlert = true
                                    }
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                                .foregroundStyle(Color.red)
                            }
                        }
                    }.padding(10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Collection"),
                    message: Text("Are you sure, You want to delete \(selectedCollectionfordelete!.name)?"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        viewModel.deleteCollectionbyId(id: selectedCollectionfordelete!.id)
                        
                        },
                        
                        
                    
                    secondaryButton: .cancel(){
                        
                    }
                )
            }
            .fullScreenCover(isPresented: $showingAlbum, content: {
                if let selectedCollection = viewModel.selectedCollection {
                    CollectionAlbumView(collection: selectedCollection, viewModel: viewModel)
                        .onDisappear {
                            refreshDisplayImages()
                        }
                }
            })
            .sheet(isPresented: $showingAddCollectionAlert) {
                AddCollectionView(viewModel: viewModel)
                    .onDisappear {
                        refreshDisplayImages()
                    }
            }
            .sheet(isPresented: $isEditCollection) {
                if let collectionIds = viewModel.selectedCollectionforEdit?.id {
                    EditCollectionNameView(viewModel: viewModel, cId: collectionIds)
                        .onDisappear {
                            refreshDisplayImages()
                        }
                }
            }
            .onAppear {
                viewModel.fetchCollections()
                refreshDisplayImages()
                if !viewModel.isSubscribed{
                    if(viewModel.collections.count > 1){
                        exceeds = true
                    }else{
                        exceeds = false
                    }
                }
            }
            .navigationTitle("Collections")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by name")
            .toolbar {
                Button {
                    if((viewModel.collections.count < 3 )||(userViewModel.subscriptionActive)){
                        showingAddCollectionAlert = true
                    }else{
                        viewModel.buyPro = true
                    }
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }.premiumBadge(isPresented: $exceeds , remainingText: "Free Collections: \(viewModel.collections.count)/3")
           .exceedAlert(isPresented: $viewModel.buyPro)
    }

    private func refreshDisplayImages() {
        var updatedDisplayImages: [UUID: [UIImage]] = [:]
        for collection in viewModel.filteredCollections {
            let images = viewModel.getLastThreeDisplayImages(for: collection) ?? []
            updatedDisplayImages[collection.id] = images
        }
        displayImages = updatedDisplayImages
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView(viewModel: CollectionsViewModel())
    }
}

//
//  CollectionAlbumView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 14/05/24.
//

import SwiftUI

struct CollectionAlbumView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var collection: MediaCollection
    @ObservedObject var viewModel : CollectionsViewModel
    @State var openCollectionFile = false
    @State var isShowingShareSheet: Bool = false
    @State var isShowingCollections: Bool = false
    var optionalViewModel = VideoPlayerViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                if collection.mediaItems.isEmpty {
                    Text("No files found in this collection")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(collection.mediaItems, id: \.self) { mediaItem in
                                Button(action: {
                                    viewModel.selectedMediaItem = viewModel.getMediaItems(id: mediaItem)
                                    viewModel.cId = collection.id
                                    openCollectionFile.toggle()
                                    
                                    
                                })
                                {  let newmediaItem = viewModel.getMediaItems(id: mediaItem)
                                    if let displayImg = viewModel.loadImage(from: newmediaItem.displayImg){
                                        Image(uiImage: displayImg)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                        //.frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                            .padding(5)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray)
                                        //.frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                            .padding(5)
                                    }
                                    
                                }.contextMenu{
                                    
                                    Button(action: {
                                        isShowingShareSheet.toggle()
                                    }) {
                                        Label("Share via", systemImage: "square.and.arrow.up")
                                    }
                                    
                                    
                                    Button(action: {
                                        let customMediaItem = viewModel.getMediaItems(id: mediaItem)
                                        optionalViewModel.saveToPhotos(mediaItem: customMediaItem)
                                    }) {
                                        Label("Save to Photos", systemImage: "square.and.arrow.down")
                                        
                                    }
                                    
                                    Button(action: {
                                        
                                    isShowingCollections = true
                                        
                                    }, label: {Text("Move to Collection")
                                    })
                                   
                                    
                                    Button(action: {
                                        
                                        let customMediaItem = viewModel.getMediaItems(id: mediaItem)
                                        optionalViewModel.fileRemove(mediaItem: customMediaItem, collectionId: collection.id)
                                        
                                        
                                    }) {
                                        
                                            Label("Remove", systemImage: "trash")
                                        
                                    }.foregroundStyle(Color.red)
                                    
                                    
                                    
                                    
                                    
                               
                                }.sheet(isPresented: $isShowingShareSheet) {
                                    let customMediaItem = viewModel.getMediaItems(id: mediaItem)
                                    if let url = URL(string: customMediaItem.sourceFile ) {
                                        ShareSheet(items: [url])
                                    }
                                }
                                .sheet(isPresented: $isShowingCollections) {
                                    ChooseCollectionView(viewModel: ChooseCollectionViewModel(), mediaItemId: mediaItem)
                                }
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
            }.navigationTitle("\(collection.name)")
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width:17.5,height: 25)
                            .padding(5)
                    })
                .fullScreenCover(isPresented: $openCollectionFile) {
                    if let selectedMediaItem = viewModel.selectedMediaItem {
                        VideoPlayerView(mediaItem: selectedMediaItem, inCollection: true, collectionId: viewModel.cId, viewModel: VideoPlayerViewModel())
                    } else {
                        EmptyView()
                    }
                }
                
        }
        
    }
}
    #Preview {
        CollectionAlbumView(collection: MediaCollection(), viewModel: CollectionsViewModel())
    }
    
    

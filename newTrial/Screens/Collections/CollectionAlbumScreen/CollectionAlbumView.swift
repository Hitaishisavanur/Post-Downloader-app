//
//  CollectionAlbumView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 14/05/24.
//

import SwiftUI

struct CollectionAlbumView: View {
    let collection: MediaCollection
    var viewModel = CollectionsViewModel()
    @State var openCollectionFile = false
    
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
                                    
                                }.fullScreenCover(isPresented: $openCollectionFile) {
                                    if let selectedMediaItem = viewModel.selectedMediaItem {
                                        VideoPlayerView(mediaItem: selectedMediaItem, inCollection: true, collectionId: viewModel.cId)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
            }.navigationTitle("\(collection.name)")

        }
        
    }
}
    #Preview {
        CollectionAlbumView(collection: MediaCollection())
    }
    
    

//
//  VIdeoPlayerView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 13/05/24.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let mediaItem: MediaItem
    var inCollection: Bool
    var collectionId : UUID?
    @State private var isShowingShareSheet = false
    @State private var isShowingCollections = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: VideoPlayerViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: mediaItem.sourceFile) {
                    if url.pathExtension == "mp4" {
                        VideoPlayer(player: AVPlayer(url: url))
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } placeholder: {
                            ProgressView()
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            }
            
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width:17.5,height: 25)
                        .padding(5)
                },
                trailing: Menu {
                    Button(action: {
                        isShowingShareSheet.toggle()
                    }) {
                        Label("Share via", systemImage: "square.and.arrow.up")
                    }
                    Button(action: {
                        viewModel.saveToPhotos(mediaItem: mediaItem)
                    }) {
                        Label("Save to Photos", systemImage: "square.and.arrow.down")
                        
                    }
                    
                    Button(action: {
                        if(!inCollection){
                            viewModel.fileDelete(mediaItem: mediaItem)
                        }else{
                            viewModel.fileRemove(mediaItem: mediaItem, collectionId: collectionId!)
                            
                        }
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        if(!inCollection){
                            Label("Delete", systemImage: "trash")
                        }else{
                            Label("Remove", systemImage: "trash")
                        }
                    }.foregroundStyle(Color.red)
                    
                    Button(action: {
                        
                    isShowingCollections.toggle()
                        
                    }, label: {Text("Move to Collection")
                    })
                    
                    
                    Button(action: {
                        
                        if mediaItem.link != ""{
                            let url = URL(string: mediaItem.link)
                            UIApplication.shared.open(url!)
                        }
                    }, label: {Text("Open in Linkedin")
                    })
                    
                    
                    Button(action: {
                        
                        UIPasteboard.general.string = mediaItem.link
                    }) {
                        Label("Copy link", systemImage: "link")
                    }
                }
                
                label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 25,height:25)
                        .padding(5)
                }
            )
            .sheet(isPresented: $isShowingCollections) {
                ChooseCollectionView(viewModel: ChooseCollectionViewModel(), mediaItemId: mediaItem.id)
            }
            .sheet(isPresented: $isShowingShareSheet) {
                if let url = URL(string: mediaItem.sourceFile) {
                    ShareSheet(items: [url])
                }
            }
        }
    }
    
}


struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let mediaItem = MediaItem(id: UUID(), displayImg: "imageURL", sourceFile: "videoURL", date: Date(), link: "link")
        NavigationView {
            VideoPlayerView(mediaItem: mediaItem, inCollection: true, viewModel: VideoPlayerViewModel())
                .navigationTitle("Video Player")
        }
    }
}

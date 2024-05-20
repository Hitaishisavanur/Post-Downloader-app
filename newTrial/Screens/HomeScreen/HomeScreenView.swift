//
//  HomeScreenView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 15/04/24.
//

import SwiftUI
import AVKit

struct HomeScreenView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DBmain.date, ascending: false)],
        animation: .default)
    private var dataModels: FetchedResults<DBmain>
    @ObservedObject var viewModel: HomeScreenViewModel
    @State var isShowingShareSheet: Bool = false
    @State var isShowingCollections: Bool = false
    
    var optionalViewModel = VideoPlayerViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        Button(action: {
                            viewModel.toggleCardView()
                        }) {
                            Text("Save New Post")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .padding(7)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .sheet(isPresented: $viewModel.isShowingCardView) {
                            DownloadCardView(viewModel: DownloadViewModel())
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    if dataModels.isEmpty {
                        Text("Your Saved Posts Appear here.\nNo Posts Saved yet.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                                ForEach(dataModels) { dataModel in
                                    Button(action: {
                                        viewModel.selectedMediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                        viewModel.openMedia = true
                                    })
                                    {
                                        if let displayImg = viewModel.loadImage(from: dataModel.displayImg) {
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
                                            let mediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                            optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                        }) {
                                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                                            
                                        }
                                        
                                        Button(action: {
                                            isShowingShareSheet.toggle()
                                        }) {
                                            Label("Share via", systemImage: "square.and.arrow.up")
                                        }
                                        
                                        Button(action: {
                                            
                                        isShowingCollections = true
                                            
                                        }, label: {Text("Move to Collection")
                                        })
                                        
                                        Button(action: {
                                            
                                            let mediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                            optionalViewModel.fileDelete(mediaItem: mediaItem)
                                            
                                            
                                        }) {
                                            
                                                Label("Delete", systemImage: "trash")
                                            
                                        }.foregroundStyle(Color.red)
                                        
                                        
                                        
                                   
                                    }.sheet(isPresented: $isShowingShareSheet) {
                                        if let url = URL(string: dataModel.sourceFile ?? "") {
                                            ShareSheet(items: [url])
                                        }
                                    }
                                    .sheet(isPresented: $isShowingCollections) {
                                        ChooseCollectionView(viewModel: ChooseCollectionViewModel(), mediaItemId: dataModel.id!)
                                    }
                                }
                                
                            }
                            
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Downloader")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.buyPremiumAction()
                        }) {
                            Text("Ads-Free")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.primary, lineWidth: 2)
                                        .padding(.trailing, 2)
                                )
                        }
                        .fullScreenCover(isPresented: $viewModel.buyPremium, content:{BuyProView(buyPremium: $viewModel.buyPremium,viewModel: BuyProViewModel())})
                    }
                }
            }
        }.fullScreenCover(isPresented: $viewModel.openMedia) {
            if let selectedMediaItem = viewModel.selectedMediaItem {
                VideoPlayerView(mediaItem: selectedMediaItem, inCollection: false, viewModel: VideoPlayerViewModel())
            } else {
                EmptyView()
            }
        }
        
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView( viewModel: HomeScreenViewModel())
    }
}



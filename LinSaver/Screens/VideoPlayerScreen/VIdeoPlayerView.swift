import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let mediaItem: MediaItem
    var inCollection: Bool
    var collectionId: UUID?
    @State private var isShowingShareSheet = false
    @State private var isShowingCollections = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: VideoPlayerViewModel
    @State private var  showRemoveAlert: Bool = false
    @State var  showDeleteAlert: Bool = false
    @StateObject private var interstetialAdManager = InterstitialAdsManager()
    @State private var isAdPresented: Bool = false
    
    @State private var saveReward: Bool = false
    @State private var shareReward: Bool = false
    
    @StateObject private var rewardedAdManager = RewardedAdManager()
        @State private var showRewardedAd = false
        @State private var rewardAlert = false
    @StateObject var userViewModel = UserViewModel()

   
    @State private var player: AVPlayer?
    
   
    
    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: mediaItem.sourceFile) {
                    if url.pathExtension == "mp4" {
                        VideoPlayer(player: player)
                            .onAppear {
                                let newPlayer = AVPlayer(url: url)
                                player = newPlayer
                                newPlayer.play()
                            }
                            .onDisappear {
                                player?.pause()
                            }
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        VStack{
                            Spacer()
                            if let image = viewModel.loadImage(from: mediaItem.displayImg) {
                                ZoomableImageViewControllerRepresentable(image: image)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            Spacer()
                        }
                        
                    }
                }
            }
            
            
              
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack{
                        Image(systemName: "chevron.left")
                            
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                },
                trailing: Menu {
                    Button(action: {
//                        isShowingShareSheet.toggle()
                        if rewardedAdManager.adLoaded {
                            shareReward = true
                                           showRewardedAd = true
                                       } else {
                                           print("Ad not ready yet")
                                       }
                    }) {
                        if(userViewModel.subscriptionActive){
                            Label("Share via", systemImage: "square.and.arrow.up")
                               
                        }else{
                            Label("Share via - pro", systemImage: "square.and.arrow.up")
                                
                        }
                    }
                    Button(action: {
//                        viewModel.saveToPhotos(mediaItem: mediaItem)
//                        if viewModel.errorSavetoPhotosMessage != ""{
//
//                        }
                        if rewardedAdManager.adLoaded {
                            saveReward = true
                                           showRewardedAd = true
                                       } else {
                                           print("Ad not ready yet")
                                       }
                    }) {
                        if(userViewModel.subscriptionActive){
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }else{
                           Label("Save to Photos - pro", systemImage: "square.and.arrow.down")
                           
                                
                        }
                    }
                    
                    Button(action: {
                        if inCollection {
                            showRemoveAlert = true
                        } else {
                            showDeleteAlert = true
                        }
                       
                        
                       
                    }) {
                        if(!inCollection) {
                            Label("Delete", systemImage: "trash")
                        } else {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                    Button(action: {
                        isShowingCollections.toggle()
                        
                        
                    }, label: {
                        Text("Move to Collection")
                    })
                    
                    Button(action: {
                        if mediaItem.link != "" {
                            let url = URL(string: mediaItem.link)
                            UIApplication.shared.open(url!)
                        }
                    }, label: {
                        Text("Open in Browser")
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
                       
                }
            )
            
            .alert(isPresented: $viewModel.showErrorAlert) {
                            Alert(
                                title: Text("Error"),
                                message: Text(viewModel.errorSavetoPhotosMessage),
                                dismissButton: .default(Text("OK")){
                                    viewModel.errorSavetoPhotosMessage = ""
                                    viewModel.showErrorAlert = false
                                }
                            )
                        }
            
            .sheet(isPresented: $isShowingCollections) {
                ChooseCollectionView(viewModel: ChooseCollectionViewModel(), mediaItemId: mediaItem.id)
                    .onDisappear{
                        
                        if interstetialAdManager.interstitialAdLoaded {
                            
                            if interstetialAdManager.interstitialAdLoaded  {
                                    self.isAdPresented = true
                                } else {
                                    print("Ad not ready")
                                }
                        
                        }
                                
                    }
            }
            .fullScreenCover(isPresented: self.$isAdPresented) {
                InterstitialAdView(adManager: interstetialAdManager)
                    .onAppear {
                        interstetialAdManager.onAdDismissed = {
                            self.isAdPresented = false
                            
                        }
                    }
            }
            .background(
                        NavigationLink(
                            destination: RewardedAdViewControllerRepresentable(adManager: rewardedAdManager)
                                .onDisappear {
                                    showRewardedAd = false
                                },
                            isActive: $showRewardedAd,
                            label: {
                                EmptyView()
                            }
                        )
                    )
            
                    .onChange(of: rewardedAdManager.userDidEarnReward) { didEarnReward in
                        if didEarnReward {
                            if (saveReward){
                                viewModel.saveToPhotos(mediaItem: mediaItem)
                                if viewModel.errorSavetoPhotosMessage != ""{
                                    
                                }
                            }
                            if(shareReward){
                                isShowingShareSheet.toggle()
                            }
                            saveReward = false
                            shareReward = false
                            rewardAlert = true
                            rewardedAdManager.userDidEarnReward = false // Reset the reward state
                        }
                    }
                    .alert(isPresented: $rewardAlert) {
                                Alert(title: Text("Congratulations!"), message: Text("Saved to Photos Successfully"), dismissButton: .default(Text("OK")))
                            }
            
            .sheet(isPresented: $isShowingShareSheet) {
                if let url = URL(string: mediaItem.sourceFile) {
                    ShareSheet(items: [url])
                }
            }
            .alert(isPresented: $showRemoveAlert){
                Alert(
                    title: Text("Remove From Collection"),
                    message: Text("Are you sure you want to remove this item?"),
                    primaryButton: .destructive(Text("Remove")) {
                        if let collectionId = collectionId {
                            viewModel.fileRemove(mediaItem: mediaItem, collectionId: collectionId)
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        
        .alert(isPresented: $showDeleteAlert) {
            
            Alert(
                title: Text("Delete Item"),
                message: Text("Are you sure you want to delete this item?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.fileDelete(mediaItem: mediaItem)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
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

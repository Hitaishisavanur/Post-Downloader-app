import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let mediaItem: MediaItem
    var inCollection: Bool
    var collectionId: UUID?
    @State private var isShowingShareSheet = false
    @State private var isShowingCollections = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: VideoPlayerViewModel
    @State private var  showRemoveAlert: Bool = false
    @State var  showDeleteAlert: Bool = false
    @StateObject private var interstetialAdManager = InterstitialAdsManager()
    @State private var isAdPresented: Bool = false
    @State var showInfo = false
    
    @State private var saveReward: Bool = false
    @State private var shareReward: Bool = false
    
    @StateObject private var rewardedAdManager = RewardedAdManager()
    @State private var showRewardedAd = false
    @State private var rewardAlert = false
    private let userViewModel = UserViewModel.shared
    @State var showCustomAlert = false
    @State var noInternetAlert = false
    @State var watchAds = false
    
    @State private var player: AVPlayer?
    @State var showCustomShareAlert = false
    
    
    
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
                            VStack{
                                if let image = viewModel.loadImage(from: mediaItem.displayImg) {
                                    ZoomableImageViewControllerRepresentable(image: image)
                                    
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                            
                            Spacer()
                            VStack{
                                HStack{
                                    VStack{
                                        Image(systemName: "hand.draw")
                                            .foregroundStyle(.blue)
                                    }
                                        .padding(.trailing,10)
                                    VStack{
                                        Text("Pinch and Drag to zoom")
                                            
                                            .italic()
                                            .foregroundStyle(.blue)
                                    }
                                    
                            }.padding()
                            }.onTapGesture{
                                showInfo = true
                            }
                        }
                        
                    }
                }
            }
            .alert("Info", isPresented: $showInfo,
                   actions: {
                Button("Ok"){
                    showInfo = false
                }
            },
                   message: {Text("Pinch and drag to zoom the image")})
            
            
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
                        
                        
                        if userViewModel.subscriptionActive{
                            isShowingShareSheet.toggle()
                        }else{
                            saveReward = false
                            shareReward = true
                            showCustomShareAlert = true
                        }
                        
                    }) {
                        if(userViewModel.subscriptionActive){
                            Label("Share via", systemImage: "square.and.arrow.up")
                            
                        }else{
                            Label("Share via - pro", systemImage: "square.and.arrow.up")
                            
                        }
                    }
                    Button(action: {
                        
                        if (userViewModel.subscriptionActive){
                            viewModel.saveToPhotos(mediaItem: mediaItem)
                            
                            
                        }else{
                            shareReward = false
                            saveReward = true
                            showCustomAlert = true
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
            
            
            
            .sheet(isPresented: $isShowingCollections) {
                ChooseCollectionView(viewModel: ChooseCollectionViewModel(), mediaItemId: mediaItem.id)
                    .onDisappear{
                        
                        if interstetialAdManager.interstitialAdLoaded && !userViewModel.subscriptionActive {
                            
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
        
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK") {
                viewModel.errorSavetoPhotosMessage = ""
                viewModel.showErrorAlert = false
            }
        } message: {
            Text(viewModel.errorSavetoPhotosMessage)
        }
        .alert("Error", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel){showDeleteAlert = false}
            Button("Delete Item", role: .destructive) {
                viewModel.fileDelete(mediaItem: mediaItem)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this item?")
        }
        
        .customAlert(isPresented: $showCustomAlert, text: "save"){ didWatchAds in
            watchAds = didWatchAds
            if watchAds{
                
                if rewardedAdManager.adLoaded {
                    
                    showRewardedAd = true
                } else {
                    noInternetAlert = true
                }
            }else{
                saveReward = false
                shareReward = false
                
            }
                
        }
        .customAlert(isPresented: $showCustomShareAlert, text: "share"){ didWatchAds in
            watchAds = didWatchAds
            if watchAds{
                
                if rewardedAdManager.adLoaded {
                    
                    showRewardedAd = true
                } else {
                    noInternetAlert = true
                }
            }else{
                saveReward = false
                shareReward = false
                
            }
                
        }
        .alert(isPresented: $noInternetAlert) {
            
            Alert(
                title: Text("Failed to load Ad"),
                message: Text("Unable to load ad, please check your internet connection and try again after sometimes"),
                dismissButton: .destructive(Text("Done")) {
                    saveReward = false
                    shareReward = false
                    noInternetAlert = false
                }
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

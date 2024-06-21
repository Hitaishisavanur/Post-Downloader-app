

import SwiftUI

struct CollectionAlbumView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var collection: MediaCollection
    @ObservedObject var viewModel : CollectionsViewModel
    @State var openCollectionFile = false
    @State var isShowingShareSheet: Bool = false
    @State var isSelecting = false
    @State var isAddingFiles = false
    @State var showAlertforMultiple = false
    @State var showAlert = false
    @State var customdeleteMediaItem: MediaItem?
    @State var saveMediaItem: MediaItem?
    @State var selectedItems = Set<UUID>()
    @ObservedObject var optionalViewModel = VideoPlayerViewModel()
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    private let userViewModel = UserViewModel.shared
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    @State private var saveReward: Bool = false
    
    @StateObject private var rewardedAdManager = RewardedAdManager()
        @State private var showRewardedAd = false
        @State private var rewardAlert = false
    
    @State var showCustomAlert = false
    @State var noInternetAlert = false
    @State var watchAds = false
    
    @StateObject private var adManager = InterstitialAdsManager()
    @State private var isAdPresented: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                if collection.mediaItems.isEmpty {
                    Text("No files found in this collection")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns,spacing: 10) {
                            ForEach(collection.mediaItems, id: \.self) { mediaItem in
                                let dataModel = viewModel.getMediaItems(id: mediaItem)
                                Button(action: {
                                    
                                    if isSelecting {
                                        toggleSelection(for: dataModel.id)
                                    } else {
                                        viewModel.selectedMediaItem = dataModel
                                        viewModel.cId = collection.id
                                        openCollectionFile.toggle()
                                    }
                                    
                                })
                                {
                                    ZStack{
                                        if let displayImg = viewModel.loadImage(from: dataModel.displayImg) {
                                            if dataModel.displayImg != dataModel.sourceFile {
                                                Image(uiImage: displayImg)
                                                    .resizable()
                                                
                                                    .aspectRatio(1.0,contentMode: .fill)
                                                    .cornerRadius(10)
                                                
                                                Image(systemName: "play.circle")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 75 , height: 75, alignment: .center)
                                                    .foregroundColor(.white)
                                                    .opacity(0.8)
                                                    .cornerRadius(10)
                                                
                                            }else{
                                                Image(uiImage: displayImg)
                                                    .resizable()
                                                
                                                    .aspectRatio(1.0,contentMode: .fill)
                                                    .cornerRadius(10)
                                                
                                            }
                                            
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                            //.frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                            
                                        }
                                        if selectedItems.contains(dataModel.id ) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                                .font(.largeTitle)
                                                .padding()
                                        }
                                    }
                                    
                                    
                                }.contextMenu{
                                    
                                    if !isSelecting{
                                        if (userViewModel.subscriptionActive){
                                            Button(action: {
                                                saveMediaItem = viewModel.getMediaItems(id: mediaItem)
                                                
                                                optionalViewModel.saveToPhotos(mediaItem: saveMediaItem!)
                                                
                                                
                                            }) {
                                                
                                                Label("Save to Photos", systemImage: "square.and.arrow.down")
                                                
                                                
                                            }
                                            
                                            
                                        }else{
                                            Button(action: {
                                                saveMediaItem = viewModel.getMediaItems(id: mediaItem)
                                                checkPhotosPermission()
//                                                saveReward = true
//                                                showCustomAlert = true
                                            })
                                            {
                                                Label("Save to Photos - pro", systemImage: "square.and.arrow.down")
                                            }
                                        }
                                        Button(action: {
                                            
                                            customdeleteMediaItem = viewModel.getMediaItems(id: mediaItem)
                                            if customdeleteMediaItem != nil {
                                                showAlert = true
                                            }
                                            
                                        }) {
                                            
                                            Label("Remove", systemImage: "trash")
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        .padding(10)
                        Spacer()
                    }
                }
            }
            .alert("Error", isPresented: $optionalViewModel.showErrorAlert) {
               Button("OK") {
                   optionalViewModel.errorSavetoPhotosMessage = ""
                   optionalViewModel.showErrorAlert = false
               }
           } message: {
               Text(optionalViewModel.errorSavetoPhotosMessage)
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
                    selectedItems.removeAll()
                    isSelecting = false
                    
                }
                    
            }.alert(isPresented: $noInternetAlert) {
                
                Alert(
                    title: Text("Failed to load Ad"),
                    message: Text("Unable to load ad, please check your internet connection and try again after sometimes"),
                    dismissButton: .destructive(Text("Done")) {
                        saveReward = false
                        
                        noInternetAlert = false
                    }
                )
            }
            
            .navigationTitle("\(collection.name)")
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
                    if (isSelecting){
                        selectedItems.forEach { id in
                            let mediaItem = viewModel.getMediaItems(id: id)
                            optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                            
                        }
                        selectedItems.removeAll()
                        isSelecting = false
                    }else{
                        if(saveMediaItem?.sourceFile != ""){
                            optionalViewModel.saveToPhotos(mediaItem: saveMediaItem!)
                        }
                    }
                    saveReward = false
                    rewardAlert = true
                    rewardedAdManager.userDidEarnReward = false // Reset the reward state
                }
            }
            .navigationBarItems(
                
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack{
                            Image(systemName: "chevron.left")
                            
                                .foregroundColor(.blue)
                            if !isSelecting{
                                Text("Collections")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                    },
                trailing: HStack {
                    if isSelecting {
                        if(selectedItems.count == 0){
                           
                                if (userViewModel.subscriptionActive){
                                    Button(action: {
                                        
                                        
                                        selectedItems.forEach { id in
                                            let mediaItem = viewModel.getMediaItems(id: id)
                                            optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                            
                                        }
                                        selectedItems.removeAll()
                                        isSelecting = false
                                        
                                    }) {
                                        Text("Save to Photos")
                                        
                                        
                                    }.disabled(true)
                                    
                                    
                                }else{
                                    Button(action: {
                                        checkPhotosPermission()
                                        //                                saveReward = true
                                        //                                showCustomAlert = true
                                    })
                                    {
                                        Text("Save to Photos - pro")
                                    }.disabled(true)
                                }
                                
                                Button("Remove"){
                                    showAlertforMultiple = true
                                        
                                }.disabled(true)
                                
                            
                        }else{
                            if (userViewModel.subscriptionActive){
                                Button(action: {
                                    
                                    
                                    selectedItems.forEach { id in
                                        let mediaItem = viewModel.getMediaItems(id: id)
                                        optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                        
                                    }
                                    selectedItems.removeAll()
                                    isSelecting = false
                                    
                                }) {
                                    Text("Save to Photos")
                                    
                                    
                                }
                                
                                
                            }else{
                                Button(action: {
                                    checkPhotosPermission()
                                    //                                saveReward = true
                                    //                                showCustomAlert = true
                                })
                                {
                                    Text("Save to Photos - pro")
                                }
                            }
                            
                            Button("Remove") {
                                showAlertforMultiple = true
                            }
                            .foregroundColor(.red)
                                             
                        }
                        
                        Spacer()
                        Button("Cancel") {
                            selectedItems.removeAll()
                            isSelecting = false
                        }.alert(isPresented: $showAlertforMultiple) {
                            Alert(
                                title: Text("Remove From Collection"),
                                message: Text("Selected files will be removed from this collection, it will still be present in Home Screen and other collections"),
                                primaryButton: .destructive(Text("Remove")) {
                                    selectedItems.forEach { id in
                                        let mediaItem = viewModel.getMediaItems(id: id)
                                        optionalViewModel.fileRemove(mediaItem: mediaItem, collectionId: collection.id)
                                        
                                    }
                                    selectedItems.removeAll()
                                    isSelecting = false
                                    
                                },
                                secondaryButton: .cancel(){
                                    
                                    selectedItems.removeAll()
                                    isSelecting = false
                                }
                            )
                        }
                    } else {
                        Button("Select") {
                            isSelecting = true
                        }
                        Button(action: {
                            isAddingFiles = true
                        }) {
                            Image(systemName: "plus")
                            
                        }
                    }
                }
            )
            
            .sheet(isPresented: $isAddingFiles){
                let cId = collection.id
                SelectImagesView(viewModel: CollectionsViewModel(),  cId: cId)
                    .onDisappear{
                        viewModel.fetchCollections()
                        if !userViewModel.subscriptionActive {
                            if adManager.interstitialAdLoaded {
                                isAdPresented = true
                            }
                        } else {
                            print("Ad not ready")
                        }
                    }
                
            }
            .fullScreenCover(isPresented: $isAdPresented) {
                if adManager.interstitialAdLoaded {
                    InterstitialAdView(adManager: adManager)
                        .onAppear {
                            adManager.onAdDismissed = {
                                isAdPresented = false
                            }
                        }
                }
            }
            .fullScreenCover(isPresented: $openCollectionFile) {
                if let selectedMediaItem = viewModel.selectedMediaItem {
                    VideoPlayerView(mediaItem: selectedMediaItem, inCollection: true, collectionId: viewModel.cId, viewModel: VideoPlayerViewModel())
                        .onDisappear{
                            viewModel.fetchCollections()
                        }
                } else {
                    EmptyView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Remove From Collection"),
                    message: Text("Are you sure, You want to remove this item?"),
                    primaryButton: .destructive(Text("Remove")) {
                        optionalViewModel.fileRemove(mediaItem: customdeleteMediaItem!, collectionId: collection.id)
                        
                        viewModel.fetchCollections()
                        
                        
                    },
                    
                    
                    secondaryButton: .cancel(){
                        
                    }
                )
            }
        }
        
        
    }
    func checkPhotosPermission(){
        viewModel.checkPhotoLibraryAuthorization { authorized in
            if authorized {
                // If permission is granted, save to photos
                
                saveReward = true
                showCustomAlert = true
            } else {
                // If permission is denied, show alert and set toggle to false
                
                optionalViewModel.errorSavetoPhotosMessage = "Permission denied to access photo library. Please enable it in device settings.\n Go to Settings > LinSaver > Photos > select \"Add Photos Only\""
                optionalViewModel.showErrorAlert = true
                isSelecting = false
                selectedItems.removeAll()
            }
        }
    }
    
   private func toggleSelection(for id: UUID?) {
        guard let id = id else { return }
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }
}



#Preview {
    CollectionAlbumView(collection: MediaCollection(), viewModel: CollectionsViewModel())
}



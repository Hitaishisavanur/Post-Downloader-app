

import SwiftUI
import AVKit

struct HomeScreenView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @State private var showPremiumAd: Bool = false
    @ObservedObject var viewModel: HomeScreenViewModel
    @State private var selectedItems: Set<UUID> = []
    @State private var isSelectionMode: Bool = false
    @State private var showAlertforMultiple: Bool = false
    @State private var showAlert: Bool = false
    private let userViewModel = UserViewModel.shared
  
    @StateObject private var rewardedAdManager = RewardedAdManager()
    @State private var showRewardedAd = false
    @State private var rewardAlert = false
    
    @State private var saveReward: Bool = false
    @State var showProgressView = false
    @State var showCustomAlert = false
    @State var noInternetAlert = false
    @State var watchAds = false
    
    @State private var deletemediaItem: MediaItem?
    @State private var savemediaItem: MediaItem?
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
   
    
    let gridItemLayout = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    @State var openMedia: Bool = false
    
    @ObservedObject var optionalViewModel = VideoPlayerViewModel()
    
    
    var body: some View {
       
        NavigationView {
                        ZStack {
                            

                VStack {
                    
                    VStack {
                        Button(action: {
                            if(viewModel.downloadCount < 15) || (userViewModel.subscriptionActive){
                               viewModel.isShowingDownloader = true
                            }else{
                                viewModel.buyPro = true
                            }
                        }) {
                            Text("Save New Post")
                            
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .padding(7)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.accent)
                        .padding()
                        .sheet(isPresented: $viewModel.isShowingDownloader) {
                            DownloadCardView(viewModel: DownloadViewModel())
                                .onDisappear{
                                    if(!userViewModel.subscriptionActive)&&(interstetialAdsManager.interstitialAdLoaded){
                                        interstetialAdsManager.displayInterstitialAd()
                                    }
                                  
                                }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    
                    Spacer()
                    
                    if viewModel.dataModels.isEmpty {
                        Text("Your Saved Posts Appear here.\nNo Posts Saved yet.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.bottom,30)
                    } else {
                        ZStack{
                            
                            
                            if colorScheme == .light{
                                Color.clear
                                Color.black.opacity(0.05)
                            }else{
                                Color.white.opacity(0.15)
                            }
                            
                            
                            ScrollView {
                                
                                LazyVGrid(columns:gridItemLayout, spacing: 10) {
                                    ForEach(viewModel.dataModels) { dataModel in
                                        Button(action: {
                                            if isSelectionMode {
                                                let mediaItemSelected = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                toggleSelection(for: mediaItemSelected)
                                            } else {
                                                viewModel.selectedMediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                openMedia = true
                                            }
                                            //                                        viewModel.selectedMediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                            //                                        viewModel.openMedia = true
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
                                                if selectedItems.contains(dataModel.id ?? UUID()) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.blue)
                                                        .font(.largeTitle)
                                                        .padding()
                                                }
                                            }
                                            
                                        }.contextMenu{
                                            if !isSelectionMode{
                                                if (userViewModel.subscriptionActive){
                                                    Button(action: {
                                                        savemediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                        
                                                        optionalViewModel.saveToPhotos(mediaItem: savemediaItem!)
                                                        
                                                        
                                                        
                                                    }) {
                                                        
                                                        Label("Save to Photos", systemImage: "square.and.arrow.down")
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                }else{
                                                    Button(action: {
                                                        savemediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                        if(savemediaItem?.displayImg != ""){checkPhotosPermission()}
                                                        
                                                    })
                                                    {
                                                        Label("Save to Photos - pro", systemImage: "square.and.arrow.down")
                                                    }
                                                }
                                                
                                                
                                                
                                            }
                                            Button(action: {
                                                deletemediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                if deletemediaItem?.sourceFile != ""{
                                                    showAlert = true
                                                }
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                                
                                            }
                                            
                                        }
                                    }
                                }.padding(10)
                                Spacer()
                            }
                            
                        }
                    }
                }
               
                .loadingOverlay(isPresented: $viewModel.isloading, loadingText: "Loading...")
                .navigationTitle(Text("LinSaver"))
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
                        if(isSelectionMode){
                            selectedItems.forEach { id in
                                if let dataModel = viewModel.dataModels.first(where: { $0.id == id }) {
                                    let mediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                    optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                }
                            }
                            isSelectionMode = false
                            selectedItems.removeAll()
                        }else{
                            if(savemediaItem?.sourceFile != ""){
                                optionalViewModel.saveToPhotos(mediaItem: savemediaItem!)
                            }
                        }
                        saveReward = false
                        rewardAlert = true
                        rewardedAdManager.userDidEarnReward = false // Reset the reward state
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if isSelectionMode {
                            Button("Cancel") {
                                isSelectionMode = false
                                selectedItems.removeAll()
                            }
                        } else {
                            Button("Select") {
                                isSelectionMode = true
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        if isSelectionMode {
                            if(selectedItems.count == 0){
                                HStack {
                                    
                                    if (userViewModel.subscriptionActive){
                                        Button(action: {
                                            
                                            selectedItems.forEach { id in
                                                if let dataModel = viewModel.dataModels.first(where: { $0.id == id }) {
                                                    let mediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                    optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                                }
                                            }
                                            isSelectionMode = false
                                            selectedItems.removeAll()
                                            
                                        }) {
                                            
                                            Text("Save to Photos")
                                            
                                            
                                        }
                                        
                                        
                                    }else{
                                        Button(action: {
                                            checkPhotosPermission()
                                            //                                    saveReward = true
                                            //                                    showCustomAlert = true
                                        })
                                        {
                                            Text("Save to Photos - pro")
                                        }
                                    }
                                    
                                    
                                    Button(action: {
                                        showAlertforMultiple = true
                                    }) {
                                        Text("Delete")
                                            .tint(.red)
                                    }
                                }.disabled(true)
                            }else{
                                HStack {
                                    
                                    if (userViewModel.subscriptionActive){
                                        Button(action: {
                                            
                                            selectedItems.forEach { id in
                                                if let dataModel = viewModel.dataModels.first(where: { $0.id == id }) {
                                                    let mediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                    optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                                }
                                            }
                                            isSelectionMode = false
                                            selectedItems.removeAll()
                                            
                                        }) {
                                            
                                            Text("Save to Photos")
                                            
                                            
                                        }
                                        
                                        
                                    }else{
                                        Button(action: {
                                            checkPhotosPermission()
                                            //                                    saveReward = true
                                            //                                    showCustomAlert = true
                                        })
                                        {
                                            Text("Save to Photos - pro")
                                        }
                                        
                                    }
                                    
                                    Button(action: {
                                        showAlertforMultiple = true
                                    }) {
                                        Text("Delete")
                                            .tint(.red)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                    .alert(isPresented: $showAlertforMultiple) {
                        Alert(
                            title: Text("Delete Items"),
                            message: Text("Selected files will be removed from all collections and deleted."),
                            primaryButton: .destructive(Text("Delete")) {
                                selectedItems.forEach { id in
                                    if let dataModel = viewModel.dataModels.first(where: { $0.id == id }) {
                                        let mediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                        optionalViewModel.fileDelete(mediaItem: mediaItem)
                                    }
                                }
                                isSelectionMode = false
                                selectedItems.removeAll()
                                
                            },
                            secondaryButton: .cancel(){
                                isSelectionMode = false
                                selectedItems.removeAll()
                            }
                        )
                    }
                    
                }
                
            }.navigationViewStyle(.stack)
            
            .alert(isPresented: $rewardAlert) {
                Alert(title: Text("Congratulations!"), message: Text("Saved to Photos Successfully"), dismissButton: .default(Text("OK")))
            }
            
            .fullScreenCover(isPresented: $openMedia) {
                if let selectedMediaItem = viewModel.selectedMediaItem {
                    VideoPlayerView(mediaItem: selectedMediaItem, inCollection: false, viewModel: VideoPlayerViewModel())
                } else {
                    EmptyView()
                }
            }.onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                  
                    viewModel.observeChanges()
                    viewContext.refreshAllObjects()
                }
            }
            .alert("Error", isPresented: $optionalViewModel.showErrorAlert) {
                Button("OK", role: .cancel) {
                    optionalViewModel.errorSavetoPhotosMessage = ""
                    optionalViewModel.showErrorAlert = false
                }
            } message: {
                Text(optionalViewModel.errorSavetoPhotosMessage)
            }
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Items"),
                    message: Text("Are you sure, You want to delete this item?"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        optionalViewModel.fileDelete(mediaItem: deletemediaItem!)
                        
                    },
                    
                    
                    
                    secondaryButton: .cancel(){
                        
                    }
                )
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
                    isSelectionMode = false
                }
                
            } 
           
            .onFirstAppear {
                
                checkSubscriptionStatus()
               
            }
            
            .sheet(isPresented: $showPremiumAd){
                PremiumAdPopup()
                    .onDisappear{
                       viewModel.isloading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            viewModel.isloading = false
                            
                                               }
                    }
                
                
            }
            .alert("Failed to load Ad", isPresented: $noInternetAlert, actions: {
                Button(
                    action: {
                    saveReward = false
                        noInternetAlert = false
                    }, label: {
                        Text("Done")
                    })}, message: {
                        Text("Unable to load ad, please check your internet connection and try again after sometimes")
                    })

                    .premiumBadge(isPresented: $viewModel.exceeds, remainingText: "Free Downloads: \(viewModel.downloadCount)/15")
                    .exceedAlert(isPresented: $viewModel.buyPro)
    }
    
      func checkSubscriptionStatus() {
                // Fetch the customer info to update the subscription status
                userViewModel.refreshCustomerInfo()
          viewModel.isloading = userViewModel.subscriptionActive
                // Set the showPremiumAd state based on the subscription status
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showPremiumAd = !userViewModel.subscriptionActive
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
                isSelectionMode = false
                selectedItems.removeAll()
            }
        }
    }
    
    func toggleSelection(for dataModel: MediaItem) {
        if dataModel.sourceFile != "" {
            let id = dataModel.id
            if selectedItems.contains(id) {
                selectedItems.remove(id)
            } else {
                selectedItems.insert(id)
            }
        }
    }
        
    
    
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView( viewModel: HomeScreenViewModel() )
    }
}



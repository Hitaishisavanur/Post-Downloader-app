

import SwiftUI
import AVKit

struct HomeScreenView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: HomeScreenViewModel
    @State private var selectedItems: Set<UUID> = []
    @State private var isSelectionMode: Bool = false
    @State private var showAlertforMultiple: Bool = false
    @State private var showAlert: Bool = false
    
    
    @StateObject private var rewardedAdManager = RewardedAdManager()
        @State private var showRewardedAd = false
        @State private var rewardAlert = false
    
    @State private var deletemediaItem: MediaItem?
    @State private var savemediaItem: MediaItem?
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    
    let gridItemLayout = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ]
    
    
    
    @StateObject var optionalViewModel = VideoPlayerViewModel()
    
    
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
                                .onDisappear{
                                    if interstetialAdsManager.interstitialAdLoaded{
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
                                                viewModel.openMedia = true
                                            }
                                            //                                        viewModel.selectedMediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                            //                                        viewModel.openMedia = true
                                        })
                                        {
                                            ZStack{
                                                if let displayImg = viewModel.loadImage(from: dataModel.displayImg) {
                                                    //                                                Image(uiImage: displayImg)
                                                    //                                                    .resizable()
                                                    //                                                    .aspectRatio(contentMode: .fill)
                                                    //                                                    .cornerRadius(10)
                                                    //                                                    .padding(5)
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
                                                Button(action: {
                                                    
                                                    savemediaItem = MediaItem(id:dataModel.id ?? UUID(),displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
                                                    
                                                    showRewardedAd = true
//                                                    optionalViewModel.saveToPhotos(mediaItem: mediaItem)
                                                }) {
                                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
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
                                    }
                                }.padding(10)
                                Spacer()
                            }
                        }
                    }
                }
                .alert(isPresented: $optionalViewModel.showErrorAlert) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text(optionalViewModel.errorSavetoPhotosMessage),
                                    dismissButton: .default(Text("OK")){
                                        optionalViewModel.errorSavetoPhotosMessage = ""
                                        optionalViewModel.showErrorAlert = false
                                    }
                                )
                            }
                .navigationTitle("Downloader")
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
                            HStack {
                                Button(action: {
                                    showRewardedAd = true
//                                    selectedItems.forEach { id in
//                                        if let dataModel = viewModel.dataModels.first(where: { $0.id == id }) {
//                                            let mediaItem = MediaItem(id: dataModel.id ?? UUID(), displayImg: dataModel.displayImg ?? "", sourceFile: dataModel.sourceFile ?? "", date: dataModel.date ?? Date(), link: dataModel.link ?? "")
//                                            optionalViewModel.saveToPhotos(mediaItem: mediaItem)
//                                        }
//                                    }
//                                    isSelectionMode = false
//                                    selectedItems.removeAll()
                                }) {
                                    Text("Save to Photos")
                                }
                                
                                Button(action: {
                                    showAlertforMultiple = true
                                }) {
                                    Text("Delete")
                                        .tint(.red)
                                } .alert(isPresented: $showAlertforMultiple) {
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
                        }
                    }
                }
            }
        }
        .alert(isPresented: $rewardAlert) {
                    Alert(title: Text("Congratulations!"), message: Text("Saved to Photos Successfully"), dismissButton: .default(Text("OK")))
                }
       
        .fullScreenCover(isPresented: $viewModel.openMedia) {
            if let selectedMediaItem = viewModel.selectedMediaItem {
                VideoPlayerView(mediaItem: selectedMediaItem, inCollection: false, viewModel: VideoPlayerViewModel())
            } else {
                EmptyView()
            }
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Hello world")
                viewModel.observeChanges()
                viewContext.refreshAllObjects()
            }
        }
        .onAppear {
            
            viewModel.observeChanges()
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



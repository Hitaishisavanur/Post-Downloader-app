import SwiftUI

struct ChooseCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChooseCollectionViewModel
    var mediaItemId: UUID
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    
    @State private var selectedCollections = Set<UUID>()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.collections, id: \.id, selection: $selectedCollections) { collection in
                    HStack {
                        Text(collection.name)
                        Spacer()
                        if selectedCollections.contains(collection.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedCollections.contains(collection.id) {
                            selectedCollections.remove(collection.id)
                        } else {
                            selectedCollections.insert(collection.id)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle("Choose Collection", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    for collectionId in selectedCollections {
                        viewModel.moveToCollection(mediaItemId: mediaItemId, collectionId: collectionId)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            viewModel.fetchCollections()
        }.onDisappear(){
            
           // showInterstetialAds()
        }
    }
    func showInterstetialAds() {
        if (interstetialAdsManager.interstitialAdLoaded){
            let result = interstetialAdsManager.displayInterstitialAd()
            print(result)
            //showingAddBookmarkSheet = true
        }
    }
    
    
}

struct ChooseCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCollectionView(
            viewModel: ChooseCollectionViewModel(), mediaItemId: UUID()
        )
    }
}

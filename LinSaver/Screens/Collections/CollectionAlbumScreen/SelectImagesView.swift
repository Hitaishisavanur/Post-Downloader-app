

import SwiftUI

struct SelectImagesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CollectionsViewModel
    @State var selectedItems: Set<UUID> = []
    @State var cId : UUID
    let gridItemLayout = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ]
    @StateObject private var adManager = InterstitialAdsManager()
      @State private var isAdPresented: Bool = false
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView{
                    LazyVGrid(columns: gridItemLayout, spacing: 10){
                        ForEach(viewModel.dataModels, id: \.id) { mediaItem in
                            Button(action: {
                                toggleSelection(for: mediaItem.id)
                            }) {
                                ZStack {
                                    if let displayImg = viewModel.loadImage(from: mediaItem.displayImg) {
                                        if mediaItem.displayImg != mediaItem.sourceFile {
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
                                    
                                    if selectedItems.contains(mediaItem.id!) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .font(.title)
                                            .padding(5)
                                    }
                                }
                            }
                        }
                    }.padding(10)
                }
            }
            .navigationTitle("Select Images")
            .navigationBarItems(leading: Button("Cancel") {
                selectedItems.removeAll()
                presentationMode.wrappedValue.dismiss()
            },trailing: Button("Add"){
                selectedItems.forEach{ id in
                    viewModel.moveToCollection(mediaItemId: id, collectionId: cId)
                    selectedItems.removeAll()
                    presentationMode.wrappedValue.dismiss()
                    
                }
            })
        }.navigationViewStyle(.stack)
        .onAppear {
            viewModel.fetchFiles()
            viewModel.observeChanges()
           
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

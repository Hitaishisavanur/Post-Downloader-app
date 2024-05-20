//
//  CollectionsView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import SwiftUI

struct CollectionsView: View {
    
    @ObservedObject var viewModel : CollectionsViewModel
    @State private var showingAddCollectionAlert = false
    @State private var selectedCollectionfordelete: MediaCollection?
    
    
    @State var showingAlbum = false
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        NavigationView{
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    
                    ForEach(viewModel.filteredCollections) { collection in
                        let displayImages = viewModel.getLastThreeDisplayImages(for: collection)
                        let indexs = displayImages?.count ?? 0
                        
                        
                        //                        Button(action: {
                        //                            viewModel.selectedCollection = collection
                        //                            showingAlbum.toggle()
                        //                        })
                        //                        {
                        VStack{
                            HStack (spacing:1 ){
                                VStack {
                                    if displayImages?.count ?? 0 > 0 {
                                        Image(uiImage: displayImages![indexs - 1])
                                            .resizable()
                                        //                                               .aspectRatio(contentMode: .fit)
                                            .frame(height:100)
                                            .clipped()
                                        
                                            .padding(5)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(height: 100)
                                        
                                    }
                                }
                                .padding(0)
                                
                                VStack(spacing: 1) {
                                    HStack{
                                        
                                        if displayImages?.count ?? 0 > 1 {
                                            Image(uiImage: displayImages![indexs - 2])
                                                .resizable()
                                                .frame(height: 49)
                                                .clipped()
                                            
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(height: 50)
                                            
                                        }
                                        
                                    }
                                    HStack{
                                        
                                        
                                        if displayImages?.count ?? 0 > 2 {
                                            Image(uiImage: displayImages![indexs - 3])
                                                .resizable()
                                            //                                                        .aspectRatio(contentMode: .fit)
                                                .frame(height: 49)
                                                .clipped()
                                            
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(height: 49)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                .padding(0)
                            }
                            .cornerRadius(15)
                            .padding(10)
                            
                            Text(collection.name)
                                .font(.subheadline)
                            
                            
                            
                        }.simultaneousGesture(
                            TapGesture().onEnded {
                                
                                viewModel.selectedCollection = collection
                                showingAlbum = true
                            }
                        )
                        
                        .contextMenu{
                            
                            Button(action: {
                                //viewModel.saveToPhotos(mediaItem: mediaItem)
                            }) {
                                Label("Edit Name", systemImage: "pencil.fill")
                                
                            }
                            
                            Button(action: {
                                selectedCollectionfordelete = collection
                                if let cIds = selectedCollectionfordelete{
                                    print(cIds)
                                    viewModel.deleteCollectionbyId(id: cIds.id)
                                }
                                
                            }) {
                                
                                Label("Delete", systemImage: "trash")
                                
                            }.foregroundStyle(Color.red)
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            .fullScreenCover(isPresented: $showingAlbum, content: {
                CollectionAlbumView(collection: viewModel.selectedCollection!, viewModel: CollectionsViewModel())
            })
            .sheet(isPresented: $showingAddCollectionAlert) {
                AddCollectionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchCollections()
            }
            
            .navigationTitle("Collections")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by name")
            .toolbar{
                Button{
                    showingAddCollectionAlert = true
                }
            label:{Image(systemName: "plus")}
                    .font(.title2)
                
            }
        }
    }
}

#Preview {
    CollectionsView(viewModel: CollectionsViewModel())
}

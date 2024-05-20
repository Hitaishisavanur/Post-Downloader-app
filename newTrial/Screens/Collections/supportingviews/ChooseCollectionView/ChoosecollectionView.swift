//
//  ChoosecollectionView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 16/05/24.
//
import SwiftUI

struct ChooseCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChooseCollectionViewModel
    var mediaItemId: UUID
    
     

    var body: some View {
        NavigationView {
            VStack{
                List(viewModel.collections, id: \.id) { collection in
                    Button(action: {
                        
                        viewModel.moveToCollection(mediaItemId: mediaItemId, collectionId: collection.id)
                        presentationMode.wrappedValue.dismiss()
                        // Handle the selection action here, e.g., call a method in the parent view model
                    }) {
                        VStack{
                            Text(collection.name) // Replace with your collection name property
                        }
                    }
                }
            }
            .navigationBarTitle("Choose Collection", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        
        }.onAppear{
            viewModel.fetchCollections()
        }
    }
}

// Replace this struct with your actual collection model


struct ChooseCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCollectionView(
            viewModel: ChooseCollectionViewModel(), mediaItemId: UUID()
        )
    }
}

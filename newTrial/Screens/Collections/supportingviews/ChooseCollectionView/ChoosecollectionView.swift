//
//  ChoosecollectionView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 16/05/24.
//
import SwiftUI

struct ChooseCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCollection: UUID?
    var mediaItemId: UUID
    
    let collections: [Collection] // Replace with your collection model

    var body: some View {
        NavigationView {
            List(collections, id: \.id) { collection in
                Button(action: {
                    selectedCollection = collection.id
                    presentationMode.wrappedValue.dismiss()
                    // Handle the selection action here, e.g., call a method in the parent view model
                }) {
                    Text(collection.name) // Replace with your collection name property
                }
            }
            .navigationBarTitle("Choose Collection", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Replace this struct with your actual collection model
struct Collection {
    var id: UUID
    var name: String
}

struct ChooseCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCollectionView(
            collections: [
                Collection(id: UUID(), name: "Collection 1"),
                Collection(id: UUID(), name: "Collection 2")
            ]
        )
    }
}

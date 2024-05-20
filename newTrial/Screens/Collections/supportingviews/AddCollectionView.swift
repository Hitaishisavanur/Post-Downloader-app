//
//  AddCollectionView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 14/05/24.
//

import SwiftUI

struct AddCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var collectionName: String = ""
    @ObservedObject var viewModel: CollectionsViewModel
    
    var body: some View {
        
        Form {
            VStack {
                Text("Enter Collection Name")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .padding(.top, 30)
            }.listRowSeparator(.hidden)
            VStack {
                Section {
                    TextField("Enter name here ", text: $collectionName)
                        .padding(8)
                        
                    }
                }
            

//                VStack {
//                    Section {
//                        Button(action: {
//                            viewModel.pasteButtonTapped()
//                        }) {
//                            Text("Paste")
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//                }
            
            .padding(7)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 1)
            )

            VStack {
                Button(action: {
                    viewModel.createCollection(name: collectionName)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Create New Collection")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                
            }.padding(.top,30)
                .padding(.bottom,30)
        }
        .padding(.top, 30)
        
    }
}
#Preview {
    AddCollectionView(viewModel: CollectionsViewModel())
}

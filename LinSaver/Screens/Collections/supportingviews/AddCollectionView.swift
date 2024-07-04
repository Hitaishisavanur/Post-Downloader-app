

import SwiftUI

struct AddCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var collectionName: String = ""
    @ObservedObject var viewModel: CollectionsViewModel
    
    var body: some View {
        NavigationView{
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
                
                .padding(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                
                VStack {
                    Button(action: {
                        if !collectionName.isEmpty {
                            viewModel.createCollection(name: collectionName)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Create New Collection")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                    }
                    .tint(.accent)
                    .buttonStyle(.borderedProminent)
                    
                    
                }.padding(.top,30)
                    .padding(.bottom,30)
            }
            
            .navigationTitle("Add Collection")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }
        }.navigationViewStyle(.stack)
    }
}
#Preview {
    AddCollectionView(viewModel: CollectionsViewModel())
}

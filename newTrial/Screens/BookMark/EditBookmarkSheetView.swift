//
//  EditBookmarkSheetView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 18/05/24.
//


import SwiftUI

struct EditBookmarkSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BookmarkViewModel
    @State var name = ""
    @FocusState private var focuseds: Bool
    
    var bId: UUID
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bookmark Details")) {
                    TextField("Name", text: $name)
                        .focused($focuseds)
                }.onAppear{
                    focuseds = true
                }
            }
            .navigationTitle("Edit Bookmark")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") {
                        if !name.isEmpty  {
                            viewModel.editBookmark(name: name, bId: bId)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }.onAppear{
            let dbBookmark = viewModel.fetchDBbookmarkbyId(by: bId)
           
            
            
        }
    }
}

struct EditBookmarkSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditBookmarkSheetView(viewModel: BookmarkViewModel(), bId: UUID())
    }
}

//
//  AddBookmarkSheetView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 17/05/24.
//

import SwiftUI

struct AddBookmarkSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BookmarkViewModel
    @State private var name: String = ""
    @State private var link: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bookmark Details")) {
                    TextField("Name", text: $name)
                    TextField("Link", text: $link)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Bookmark")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !name.isEmpty && !link.isEmpty {
                            viewModel.addBookmark(name: name, link: link)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct AddBookmarkSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddBookmarkSheetView(viewModel: BookmarkViewModel())
    }
}

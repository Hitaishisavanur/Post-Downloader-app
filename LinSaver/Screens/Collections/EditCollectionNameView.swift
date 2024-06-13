

import SwiftUI

struct EditCollectionNameView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CollectionsViewModel
    @State var name = ""
    @FocusState private var focuseds: Bool
    
    var cId: UUID
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Collection Details")) {
                    TextField("Name", text: $name)
                        .focused($focuseds)
                }.onAppear{
                    focuseds = true
                }
            }
            .navigationTitle("Edit Collection")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") {
                        if !name.isEmpty  {
                            viewModel.editCollection(name: name, cId: cId)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

//struct EditBookmarkSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBookmarkSheetView(viewModel: BookmarkViewModel(), bId: UUID())
//    }
//}

//#Preview {
//    EditCollectionNameView()
//}

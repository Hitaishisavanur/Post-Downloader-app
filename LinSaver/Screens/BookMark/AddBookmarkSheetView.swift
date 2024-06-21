

import SwiftUI

struct AddBookmarkSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BookmarkViewModel
    @State private var name: String = ""
    @State private var link: String = ""
    @State var showError = false
    @EnvironmentObject var interstetialAdsManager: InterstitialAdsManager
    private let userViewModel = UserViewModel.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bookmark Details")) {
                    TextField("Name", text: $name)
                    
                    HStack{
                        VStack{
                        TextField("Link", text: $link)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                    }
                        VStack {
                            Section {
                                Button(action: {
                                    if let text = UIPasteboard.general.string {
                                        self.link = text
                                    }
                                }) {
                                    Text("Paste")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
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
                        if !name.isEmpty && !link.isEmpty && link.contains(".linkedin."){
                            viewModel.addBookmark(name: name, link: link)
                            presentationMode.wrappedValue.dismiss()
                        }
                        else{
                            showError = true
                        }
                    }
                }
            }
        }.alert(isPresented: $showError){
            Alert(title: Text("ERROR"), message: Text("Please provide valid input"), dismissButton: .default(Text("OK")){
                showError = false
            })
        }.onDisappear(){
            if(!userViewModel.subscriptionActive)&&(interstetialAdsManager.interstitialAdLoaded){
                showInterstetialAds()
            }
        }
    }
    func showInterstetialAds() {
        
       interstetialAdsManager.displayInterstitialAd()
        //showingAddBookmarkSheet = true
    }
    

}

struct AddBookmarkSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddBookmarkSheetView(viewModel: BookmarkViewModel())
    }
}

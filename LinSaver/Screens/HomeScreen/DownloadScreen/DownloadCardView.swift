
import SwiftUI
import GoogleMobileAds

struct DownloadCardView: View {
    
    @ObservedObject var viewModel: DownloadViewModel
    @EnvironmentObject var saveViewModel: SettingsViewModel
    

    
    @State var url: String?
    

    var body: some View {
        NavigationView{
            Form {
                VStack {
                    Text("Paste Test Link")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .padding(.top, 0)
                }.listRowSeparator(.hidden)
                HStack {
                    VStack {
                        Section {
                            //TextField("test link...", text: $viewModel.text)
                            
                            TextField("test link...", text: $viewModel.text)
                                .padding(8)
                            
                            
                        }
                    }
                    
                    VStack {
                        Section {
                            Button(action: {
                                viewModel.pasteButtonTapped()
                            }) {
                                Text("Paste")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .padding(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                
                VStack {
                    Button(action: {
                        if viewModel.text != "" && viewModel.text.contains(".linkedin."){
                            viewModel.downloadButtonTapped(saveToPhotos: saveViewModel.settings.saveToPhotos)
                            if url != nil{
                                
                                url = nil
                                
                            }
                            
                        }else{
                            viewModel.showError("Invalid Url")
                        }
                    }) {
                        Text("Download")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    VStack {
                        
                        Toggle("Save to Camera Roll", isOn: $saveViewModel.settings.saveToPhotos)
                            .onChange(of: saveViewModel.settings.saveToPhotos) { newValue in
                                if !newValue {
                                    // Don't show alert when turning off
                                    return
                                }
                                saveViewModel.checkPhotoLibraryAuthorization { authorized in
                                    if authorized {
                                        // If permission is granted, save to photos
                                        saveViewModel.saveToPhotosChanged(true)
                                    } else {
                                        // If permission is denied, show alert and set toggle to false
                                        saveViewModel.saveToPhotosChanged(false)
                                        viewModel.showError("Permission denied to access photo library. Please enable it in Settings.")
                                    }
                                }
                            }
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1)
                                    .overlay(
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color.red)
                                                            .frame(width: 24, height: 24)
                                                        Image(systemName: "crown.fill")
                                                            .resizable()
                                                            .frame(width: 16, height: 16)
                                                            .foregroundColor(.white)
                                                    }
                                                    .offset(x: -5, y: -20),
                                                    alignment: .topTrailing
                                                )
                            )
                            
                    }
                    .padding(.top, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 0)
            
            .onAppear(){
                if url != nil{
                    viewModel.text = url ?? ""
                }
                
            }
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}

struct DownloadCardView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadCardView(viewModel: DownloadViewModel()).environmentObject(SettingsViewModel())
    }
}

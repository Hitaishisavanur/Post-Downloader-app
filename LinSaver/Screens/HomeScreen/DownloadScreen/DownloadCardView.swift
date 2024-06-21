
import SwiftUI
import GoogleMobileAds

struct DownloadCardView: View {
    
    @ObservedObject var viewModel: DownloadViewModel
    @Environment(\.presentationMode) var presentationMode
    var userDefaults = UserDefaults(suiteName: "group.com.LinSaver.group")!
    @State var subscriptionActive: Bool = false
   
    
    
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
                    if !subscriptionActive{
                        if(viewModel.downloadCount < 15 && viewModel.downloadCount >= 0) {
                            
                            
                            Button(action:{
                                
                                
                                if viewModel.text != "" && viewModel.text.contains(".linkedin."){
                                    viewModel.downloadButtonTapped(saveToPhotos: false)
                                    if url != nil{
                                        
                                        url = nil
                                        
                                    }
                                    
                                }else{
                                    viewModel.showError("Invalid Url")
                                }
                                
                            }) {
                                Text("Download (\(15 - viewModel.downloadCount) left)")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.bottom,20)
                            
                            
                            
                            Button(action:{
                                
                                
                                if viewModel.text != "" && viewModel.text.contains(".linkedin."){
                                    viewModel.showError("This is Pro-Only Feature. Please Purchase premium version to enjoy this feature")
                                    if url != nil{
                                        
                                        url = nil
                                        
                                    }
                                    
                                }else{
                                    viewModel.showError("Invalid Url")
                                }
                                
                            }) {
                                Text("Download & Save to Photos")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                                   // .background(.green)
                            }
                            .tint(.green)
                            .buttonStyle(.borderedProminent)
                            
                           

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
                            
                          
                            
                        }else{
                            
                            // exceeded 2 buttons
                            
                            
                            
                            
                            Button(action:{
                                print("exceeeded")
                                
                                
                                if url != nil{
                                    
                                    url = nil
                                    
                                }
                                
                                
                                
                            }) {
                                Text("Download (0 left)")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.bottom, 20)
                            
                            
                            
                            Button(action:{
                                
                                
                                if viewModel.text != "" && viewModel.text.contains(".linkedin."){
                                    viewModel.showError("This is Pro-Only Feature. Please Purchase premium version to enjoy this feature")
                                    if url != nil{
                                        
                                        url = nil
                                        
                                    }
                                    
                                }else{
                                    viewModel.showError("Invalid Url")
                                }
                                
                            }) {
                                Text("Download & Save to Photos")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                            }
                            .tint(.green)
                            .buttonStyle(.borderedProminent)
                            
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
                            
                        
                            
                        }
                        
                    }else{
                        
                        //subscribed 2 buttons
                        
                        
                        Button(action:{
                            
                            
                            if viewModel.text != "" && viewModel.text.contains(".linkedin."){
                                viewModel.downloadButtonTapped(saveToPhotos: false)
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
                        .padding(.bottom, 20)
                        Button(action:{
                            
                            
                            if viewModel.text != "" && viewModel.text.contains(".linkedin."){
                               viewModel.checkPhotoLibraryAuthorization { authorized in
                                    if authorized {
                                        // If permission is granted, save to photos
                                        viewModel.downloadButtonTapped(saveToPhotos: true)
                                    } else {
                                        // If permission is denied, show alert and set toggle to false
                                        
                                        viewModel.showError("Permission denied to access photo library. Please enable it in device settings.\n Go to Settings > LinSaver > Photos > select \"Add Photos Only\"")
                                    }
                                }
                               
                                if url != nil{
                                    
                                    url = nil
                                    
                                }
                                
                            }else{
                                viewModel.showError("Invalid Url")
                            }
                            
                        }) {
                            Text("Download & Save to Photos")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(.green)
                        .buttonStyle(.borderedProminent)
                    }
                    
                    
                    
     
                    
                    if(viewModel.errorMessageExt != ""){
                        VStack{
                            Text(viewModel.errorMessageExt)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 0)
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing){
                    if(url == nil){
                        Button("Cancel"){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            
            .onAppear(){
               subscriptionActive = userDefaults.bool(forKey: "subscriptionActive")
                if url != nil{
                    viewModel.text = url ?? ""
                    viewModel.urls = url
                }
                
            }
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred." ), dismissButton: .default(Text("OK")))
                        }
            
        }
        
        .loadingOverlay(isPresented: $viewModel.isDownloading, loadingText: "Downloading, please wait...")
        .loadingOverlay(isPresented: $viewModel.isDownloadingAndSaving, loadingText: "Downloading and Saving to Photos, please wait...")
        
    }
    
}

struct DownloadCardView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadCardView(viewModel: DownloadViewModel())
    }
}

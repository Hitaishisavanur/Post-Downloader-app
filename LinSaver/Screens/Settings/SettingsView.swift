

import SwiftUI


struct SettingsView: View{
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Try Ad-free Subscription")
                        .onTapGesture(perform: viewModel.tryAdFreeSubscription)
                    
                    Text("Restore Purchase")
                        .onTapGesture(perform: viewModel.restorePurchase)
                    
                    Text("About Subscription")
                        .onTapGesture(perform: viewModel.aboutSubscription)
                    
                    Text("Manage Subscription")
                        .onTapGesture(perform: viewModel.manageSubscription)
                    
                    Toggle("Save to Camera Roll", isOn: $viewModel.settings.saveToPhotos)
                                            .onChange(of: viewModel.settings.saveToPhotos) { newValue in
                                                if !newValue {
                                                    // Don't show alert when turning off
                                                    return
                                                }
                                                viewModel.checkPhotoLibraryAuthorization { authorized in
                                                    if authorized {
                                                        // If permission is granted, save to photos
                                                        viewModel.saveToPhotosChanged(true)
                                                    } else {
                                                        // If permission is denied, show alert and set toggle to false
                                                        viewModel.saveToPhotosChanged(false)
                                                        viewModel.showError = true
                                                    }
                                                }
                                            }
                }
                
                Section {
                    Text("Share App")
                        .onTapGesture(perform: viewModel.shareApp)
                    
                    Text("Rate on the App Store")
                        .onTapGesture(perform: viewModel.rateApp)
                }
                
                Section {
                    Text("FAQ")
                        .onTapGesture(perform: viewModel.showFAQ)
                    
                    Text("Contact Us")
                        .onTapGesture(perform: viewModel.contactUs)
                    
                    Text("Send Feedback")
                        .onTapGesture(perform: viewModel.sendFeedback)
                }
                
                Section {
                    Text("Privacy Policy")
                        .onTapGesture(perform: viewModel.showPrivacyPolicy)
                    
                    Text("Terms of Use")
                        .onTapGesture(perform: viewModel.showTermsOfUse)
                }
                
                Section {
                    Text("About")
                        .onTapGesture(perform: viewModel.showAbout)
                }
            }
            .alert(isPresented: $viewModel.showError){
                Alert(title: Text("ERROR"), message: Text("permission not granted"), dismissButton: .default( Text("OK")))
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $viewModel.subscriptionPageShowing){
                PremiumAdPopup()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


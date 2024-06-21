

import SwiftUI


struct SettingsView: View{
    @StateObject var viewModel = SettingsViewModel()
    
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
                Alert(title: Text(viewModel.errorText), message: Text(viewModel.errorMessage), dismissButton: .default( Text("OK")))
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $viewModel.subscriptionPageShowing){
                PremiumAdPopup()
            }
            .sheet(isPresented: $viewModel.showAboutSubscription){
               AboutSubscriptionView()
            }
            
        }.alert(isPresented: $viewModel.showAboutAlert) {
            Alert(title: Text("About"), message: Text(viewModel.aboutMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $viewModel.isShowingShareSheet) {
            if viewModel.shareAppUrl != "" {
                if let url = URL(string: viewModel.shareAppUrl){
                    let image = UIImage(named:"ShareImage")
                    let text = "Download the LinSaver app to download and manage the images and videos from your favourite social media."
                    ShareSheet(items: [image, url, text])
                }
            }
        }.loadingOverlay(isPresented: $viewModel.isPurchasing, loadingText: "Restoring Purchases, Please wait")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


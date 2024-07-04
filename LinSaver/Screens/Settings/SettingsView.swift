

import SwiftUI


struct SettingsView: View{
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack{
                        VStack{
                            Text("Try Ad-free Subscription")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.tryAdFreeSubscription)
                    
                   
                    HStack{
                        VStack{
                            Text("Restore Purchase")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.restorePurchase)
                    
                    
                    HStack{
                        VStack{
                            Text("About Subscription")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.aboutSubscription)
                    
                
                    HStack{
                        VStack{
                            Text("Manage Subscription")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.manageSubscription)
                    

                    
                }
                
                Section {
                   
                    HStack{
                        VStack{
                            Text("Share App")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.shareApp)
                    
                    
                    HStack{
                        VStack{
                            Text("Rate on the App Store")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.rateApp)
                }
                
                Section {
                    
                    HStack{
                        VStack{
                            Text("FAQ")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.showFAQ)
                    
                    
                    HStack{
                        VStack{
                            Text("Contact Us")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.contactUs)
                    
                   
                    HStack{
                        VStack{
                            Text("Send Feedback")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.sendFeedback)
                }
                
                Section {
                    
                    HStack{
                        VStack{
                            Text("Privacy Policy")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.showPrivacyPolicy)
                    
                    
                    HStack{
                        VStack{
                            Text("Terms of Use")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
                        .onTapGesture(perform: viewModel.showTermsOfUse)
                }
                
                Section {
                    
                    HStack{
                        VStack{
                            Text("About")
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "chevron.forward")
                        }
                    }
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
            
        }.navigationViewStyle(.stack)
        .alert(isPresented: $viewModel.showAboutAlert) {
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


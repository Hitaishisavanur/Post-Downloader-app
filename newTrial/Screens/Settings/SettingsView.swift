//
//  SettingsView.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 15/04/24.
//

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
                    
                    Toggle("Save to Camera Roll", isOn: $viewModel.settings.saveToPhotos) .onChange(of: viewModel.settings.saveToPhotos) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "saveToPhotos")
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
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


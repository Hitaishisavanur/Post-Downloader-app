//
//  SettingsViewModel.swift
//  newTrial
//
//  Created by Hitaishi Savanur on 08/05/24.
//

import Foundation
 
class SettingsViewModel: ObservableObject {
    @Published var settings: SettingsModel
        
    init() {
            self.settings = SettingsModel(saveToPhotos: UserDefaults.standard.bool(forKey: "saveToPhotos"))
        }
        
   func saveToPhotosChanged(_ newValue: Bool){
            settings.saveToPhotos = newValue
            UserDefaults.standard.set(newValue, forKey: "saveToPhotos")
    }
        
    
    func tryAdFreeSubscription() {
        print("Try Ad-free Subscription")
    }
    
    func restorePurchase() {
        print("Restore Purchase")
    }
    
    func aboutSubscription() {
        print("About Subscription")
    }
    
    func manageSubscription() {
        print("Manage Subscription")
    }
    
    func shareApp() {
        print("Share App")
    }
    
    func rateApp() {
        print("Rate on the App Store")
    }
    
    func showFAQ() {
        print("FAQ")
    }
    
    func contactUs() {
        print("Contact Us")
    }
    
    func sendFeedback() {
        print("Send Feedback")
    }
    
    func showPrivacyPolicy() {
        print("Privacy Policy")
    }
    
    func showTermsOfUse() {
        print("Terms of Use")
    }
    
    func showAbout() {
        print("About")
    }
}





import Foundation
import Photos
import SwiftUI
import RevenueCat
 
class SettingsViewModel: ObservableObject {
    
    @Environment(\.openURL) var openURL
    
    @Published var showError = false
    @Published var showAboutSubscription = false
    @Published var isShowingShareSheet = false
    @Published var shareAppUrl = ""
    @Published var aboutMessage = ""
    @Published var errorMessage = ""
    @Published var errorText = ""
    @Published var showAboutAlert = false
    @Published var subscriptionPageShowing = false
   @Published var isPurchasing = false
        
   

        
    
    func tryAdFreeSubscription() {
        subscriptionPageShowing = true
    }
    
    func restorePurchase() {
        isPurchasing = true
        Purchases.shared.restorePurchases { customerInfo, error in
                    if let error = error {
                       
                        self.showError(message: "Error restoring purchases: \(error.localizedDescription)", title: "ERROR")
                    } else {
                        
                        if let activeSubscriptions = customerInfo?.activeSubscriptions, !activeSubscriptions.isEmpty{
                            self.showError(message: "Purchases restored successfully!", title: "Hurray!!")
                        }else{
                            self.showError(message: "No Active Subscription Found! Make sure you logged in to app store with the same apple id you used to purchase the subscription.", title: "ERROR")
                        }
                        
                    }
                }
    }
    
    func aboutSubscription() {
        showAboutSubscription = true
        
    }
    
    func manageSubscription() {
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
               openURL(url)
    }
    
    func shareApp() {
        shareAppUrl =  "https://apps.apple.com/app/id6503945356"
        
        isShowingShareSheet = true
    }
    
    func rateApp() {
        guard let url = URL(string: "https://apps.apple.com/app/id6503945356?action=write-review") else { return }
               openURL(url)
    }
    
    func showFAQ() {
        guard let url = URL(string: "https://hitugo.wordpress.com/2024/06/18/faq/") else { return }
        openURL(url)
    }
    
    func contactUs() {
        if let url = URL(string: "mailto:techiehitaishi@gmail.com?subject=LinSaver%20-%20Customer%20Service") {
                    openURL(url)
                }
    }
    
    func sendFeedback() {
        if let url = URL(string: "mailto:techiehitaishi@gmail.com?subject=LinSaver%20-%20Customer%20Feedback") {
                    openURL(url)
                }

    }
    
    func showPrivacyPolicy() {
        guard let url = URL(string: "https://hitugo.wordpress.com/2024/06/18/privacy-policy/") else { return }
        openURL(url)
    }
    
    func showTermsOfUse() {
        guard let url = URL(string: "https://hitugo.wordpress.com/2024/06/18/terms-of-use/") else { return }
               openURL(url)
                
    }
    
    func showAbout() {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "App"
               let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
               let aboutMessage = "\(appName) - Version \(appVersion)"
               
               // Update the published properties
               self.aboutMessage = aboutMessage
               self.showAboutAlert = true
               
            
    }
    

       
    func showError(message: String,title: String) {
        isPurchasing = false
           errorMessage = message
        errorText = title
           if errorMessage != ""{
               showError = true
           }
       }
}





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
        print("Try Ad-free Subscription")
    }
    
    func restorePurchase() {
        print("Restore Purchase")
        isPurchasing = true
        Purchases.shared.restorePurchases { customerInfo, error in
                    if let error = error {
                       
                        print("Error restoring purchases: \(error.localizedDescription)")
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
        print("About Subscription")
        showAboutSubscription = true
        
    }
    
    func manageSubscription() {
        print("Manage Subscription")
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
               openURL(url)
    }
    
    func shareApp() {
        print("Share App")
        shareAppUrl =  "https://apps.apple.com/app/id6503945356"
        
        isShowingShareSheet = true
    }
    
    func rateApp() {
        print("Rate on the App Store")
        guard let url = URL(string: "https://apps.apple.com/app/id6503945356?action=write-review") else { return }
               openURL(url)
    }
    
    func showFAQ() {
        print("FAQ")
        guard let url = URL(string: "https://hitugo.wordpress.com/2024/06/18/faq/") else { return }
        openURL(url)
    }
    
    func contactUs() {
        print("Contact Us")
        if let url = URL(string: "mailto:techiehitaishi@gmail.com?subject=LinSaver%20-%20Customer%20Service") {
                    openURL(url)
                }
    }
    
    func sendFeedback() {
        print("Send Feedback")
        if let url = URL(string: "mailto:techiehitaishi@gmail.com?subject=LinSaver%20-%20Customer%20Feedback") {
                    openURL(url)
                }

    }
    
    func showPrivacyPolicy() {
        print("Privacy Policy")
        guard let url = URL(string: "https://hitugo.wordpress.com/2024/06/18/privacy-policy/") else { return }
        openURL(url)
    }
    
    func showTermsOfUse() {
        print("Terms of Use")
        guard let url = URL(string: "https://hitugo.wordpress.com/2024/06/18/terms-of-use/") else { return }
               openURL(url)
                
    }
    
    func showAbout() {
        print("About")
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "App"
               let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
               let aboutMessage = "\(appName) - Version \(appVersion)"
               
               // Update the published properties
               self.aboutMessage = aboutMessage
               self.showAboutAlert = true
               
               print("About: \(aboutMessage)")
            
    }
    
//    func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
//           let status = PHPhotoLibrary.authorizationStatus()
//           switch status {
//           case .authorized, .limited:
//               completion(true)
//           case .denied, .restricted:
//               completion(false)
//           case .notDetermined:
//               PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
//                   completion(newStatus == .authorized)
//               }
//           @unknown default:
//               completion(false)
//           }
//       }
       
    func showError(message: String,title: String) {
        isPurchasing = false
           errorMessage = message
        errorText = title
           if errorMessage != ""{
               showError = true
           }
       }
}



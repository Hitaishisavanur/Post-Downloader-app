

import Foundation
import Photos
 
class SettingsViewModel: ObservableObject {
    @Published var settings: SettingsModel
    @Published var showError = false
    @Published var subscriptionPageShowing = false
        
    init() {
            self.settings = SettingsModel(saveToPhotos: UserDefaults.standard.bool(forKey: "saveToPhotos"))
        }
        
   func saveToPhotosChanged(_ newValue: Bool){
            settings.saveToPhotos = newValue
            UserDefaults.standard.set(newValue, forKey: "saveToPhotos")
    }
        
    
    func tryAdFreeSubscription() {
        subscriptionPageShowing = true
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
    
    func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
           let status = PHPhotoLibrary.authorizationStatus()
           switch status {
           case .authorized, .limited:
               completion(true)
           case .denied, .restricted:
               completion(false)
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                   completion(newStatus == .authorized)
               }
           @unknown default:
               completion(false)
           }
       }
       
       func showError(message: String) {
           print("Error: \(message)")
       }
}



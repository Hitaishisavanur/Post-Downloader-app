//
//  UserViewModel.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 07/06/24.


import Foundation
import RevenueCat
import SwiftUI

/* Static shared model for UserView */
class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    
    private let dataController = DataController.shared
    private let Purchased = PurchasesDelegateHandler.shared
    private let userDefaults = UserDefaults(suiteName: "group.com.LinSaver.group")!
    @Published var subscriptionActive: Bool = false {
           didSet {
               userDefaults.set(subscriptionActive, forKey: "subscriptionActive")
           }
       }
    /* The latest CustomerInfo from RevenueCat. Updated by PurchasesDelegate whenever the Purchases SDK updates the cache */
    @Published var customerInfo: CustomerInfo? {
        didSet {
           subscriptionActive = customerInfo?.entitlements["pro"]?.isActive == true
        }
    }
    
    /* The latest offerings - fetched from MagicWeatherApp.swift on app launch */
    @Published var offerings: Offerings? = nil
    
    /* Set from the didSet method of customerInfo above, based on the entitlement set in Constants.swift */
    
    
    
    
    init() {
        PurchasesDelegateHandler.shared // Ensure the delegate is initialized
        fetchCustomerInfo()
    }
    
    func fetchCustomerInfo() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let customerInfo = customerInfo {
                DispatchQueue.main.async {
                    self.customerInfo = customerInfo
                }
            }
        }
    }
    func refreshCustomerInfo() {
           Purchases.shared.getCustomerInfo { (customerInfo, error) in
               if let customerInfo = customerInfo {
                   DispatchQueue.main.async {
                       self.customerInfo = customerInfo
                   }
               }
           }
       }
    func restorePurchases(){
        Purchases.shared.restorePurchases { customerInfo, error in
                    if let error = error {
                       // self.settingsViewModel.showError(message: "Error restoring purchases: \(error.localizedDescription)")
                    } else {
                        if let activeSubscriptions = customerInfo?.activeSubscriptions, !activeSubscriptions.isEmpty{
                     //       self.settingsViewModel.showError(message: "Purchases restored successfully!")
                        }else{
                       //     self.settingsViewModel.showError(message: "No Active Subscription Found! Make sure you logged in to app store with the same apple id you used to purchase the subscription.")
                        }
                        
                    }
                }
    }
    
    
    
    
    /*
     How to login and identify your users with the Purchases SDK.
     
     These functions mimic displaying a login dialog, identifying the user, then logging out later.
     
     Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
     */
    
    func addSubscription(){
        dataController.addSubscription()
    }
    
}

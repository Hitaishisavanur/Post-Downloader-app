//
//  UserViewModel.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 07/06/24.
//

import Foundation
import RevenueCat
import SwiftUI

/* Static shared model for UserView */
class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    private let dataController = DataController.shared
    private let Purchased = PurchasesDelegateHandler.shared
    
    /* The latest CustomerInfo from RevenueCat. Updated by PurchasesDelegate whenever the Purchases SDK updates the cache */
    @Published var customerInfo: CustomerInfo? {
        didSet {
            subscriptionActive = customerInfo?.entitlements["pro"]?.isActive == true
        }
    }
    
    /* The latest offerings - fetched from MagicWeatherApp.swift on app launch */
    @Published var offerings: Offerings? = nil
    
    /* Set from the didSet method of customerInfo above, based on the entitlement set in Constants.swift */
    @Published var subscriptionActive: Bool = false
    
    /*
     How to login and identify your users with the Purchases SDK.
     
     These functions mimic displaying a login dialog, identifying the user, then logging out later.
     
     Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
     */
    
    func addSubscription(){
        dataController.addSubscription()
    }
    
}

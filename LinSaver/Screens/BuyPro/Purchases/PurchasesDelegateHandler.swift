//
//  PurchasesDelegateHandler.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 07/06/24.
//

import Foundation
import RevenueCat

/*
 The class we'll use to publish CustomerInfo data to our app.
 */

class PurchasesDelegateHandler: NSObject, ObservableObject {

    static let shared = PurchasesDelegateHandler()

}

extension PurchasesDelegateHandler: PurchasesDelegate {
    
    /**
     Whenever the `shared` instance of Purchases updates the CustomerInfo cache, this method will be called.
    
     - Note: CustomerInfo is not pushed to each Purchases client, it has to be fetched.
     This delegate method is only called when the SDK updates its cache after an app launch, purchase, restore, or fetch.
     You still need to call `Purchases.shared.customerInfo` to fetch CustomerInfo regularly.
     */
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        
        /// - Update our published customerInfo object
        DispatchQueue.main.async {
                  UserViewModel.shared.customerInfo = customerInfo
              }
        UserViewModel.shared.refreshCustomerInfo() 
    }

    /**
     - Note: this can be tested by opening a link like:
     itms-services://?action=purchaseIntent&bundleId=<BUNDLE_ID>&productIdentifier=<SKPRODUCT_ID>
     */
    func purchases(_ purchases: Purchases,
                   readyForPromotedProduct product: StoreProduct,
                   purchase startPurchase: @escaping StartPurchaseBlock) {
        startPurchase { (transaction, info, error, cancelled) in
            if let info = info, error == nil, !cancelled {
                DispatchQueue.main.async {
                    UserViewModel.shared.customerInfo = info
                }
            }
        }
    }

}
